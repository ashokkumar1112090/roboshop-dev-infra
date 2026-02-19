#create ec2 inst
resource "aws_instance" "catalogue" {
  ami = local.ami_id
  vpc_security_group_ids = [local.catalogue_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency
  subnet_id = local.private_subnet_id
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-catalogue"  #robo-dev-catalogue
    }
  )
}

#connect to inst using remote-exec provisioner through terr data

resource "terraform_data" "catalogue" {        #null resource called as terr data
  triggers_replace = [                     #we cant run this in local(pc) bcz private subnet
                                           #use bastion and configure terr in that server and run this file 
    aws_instance.catalogue.id            #whenever it shows cat.id ittriggers to connect
  ]                                        

connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.catalogue.private_ip
    }

#terr copy this file to mongodb server
 #connection need but already took by above cmds
  provisioner "file" {                      #prov file means copy to another server 
        source      = "catalogue.sh"
        destination = "/tmp/catalogue.sh"
      }

   provisioner "remote-exec" {         #from bastion it will execute plbok in mong ser
    inline = [
        "chmod +x /tmp/catalogue.sh",   #execution access
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state      = "stopped"  #Change to "running" to start it back up
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.common_name_suffix}-catalogue-ami" 
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-catalogue-ami" 
    }
  )
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name_suffix}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance
    health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}

resource "aws_launch_template" "catalogue" {
  name = "${local.common_name_suffix}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"

  vpc_security_group_ids = [local.catalogue_sg_id]

  # when we run terraform apply again, a new version will be created with new AMI ID
  update_default_version = true

 # tags attached to the instance
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }

  # tags attached to the volume created by instance
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }

  # tags attached to the launch template
  tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
  )

}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name_suffix}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"  #lb will do health check
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version  #2nd runing ami changes so take latest
  }
  vpc_zone_identifier       = local.private_subnet_ids  #available zones 
  target_group_arns = [aws_lb_target_group.catalogue.arn]   #where to launch target group

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 # atleast 50% of the instances should be up and running
    }
    triggers = ["launch_template"]
  }
  
  dynamic "tag" {  # we will get the iterator with name as tag
    for_each = merge(    
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "15m"  #if didnt launched in 15 mins it will shows timeout
  }

}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name  #to give which asg 
  name                   = "${local.common_name_suffix}-catalogue"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"] #host path
    }
  }
}


#to delete ec2 inst that created to take ami
resource "terraform_data" "catalogue_local" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  depends_on = [aws_autoscaling_policy.catalogue]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}