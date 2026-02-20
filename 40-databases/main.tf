resource "aws_instance" "mongodb" {
  ami = local.ami_id
  vpc_security_group_ids = [local.mongodb_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency
  subnet_id = local.database_subnet_id
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-mongodb"  #robo-dev-mongodb
    }
  )
}

resource "terraform_data" "mongodb" {        #null resource called as terr data
  triggers_replace = [                     #we cant run this in local(pc) bcz private subnet
                                           #use bastion and configure terr in that server and run this file 
    aws_instance.mongodb.id
  ]

 connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.mongodb.private_ip
    }

 #terr copy this file to mongodb server
 #connection need but already took by above cmds
  provisioner "file" {                      #prov file means copy to another server 
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      }

   provisioner "remote-exec" {         #from bastion it will execute plbok in mong ser
    inline = [
        "chmod +x /tmp/bootstrap.sh",   #execution access
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh mongodb dev "
    ]
  }
}



resource "aws_instance" "redis" {
  ami = local.ami_id
  vpc_security_group_ids = [local.redis_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency
  subnet_id = local.database_subnet_id
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-redis"  #robo-dev-redis
    }
  )
}

resource "terraform_data" "redis" {        #null resource called as terr data
  triggers_replace = [                     #we cant run this in local(pc) bcz private subnet
                                           #use bastion and configure terr in that server and run this file 
    aws_instance.redis.id
  ]

 connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.redis.private_ip
    }

 #terr copy this file to mongodb server
 #connection need but already took by above cmds
  provisioner "file" {                      #prov file means copy to another server 
        source      = "bootstarp.sh"
        destination = "/tmp/bootstarp.sh"
      }

   provisioner "remote-exec" {         #from bastion it will execute plbok in mong ser
    inline = [
        "set -x",
        "chmod +x /tmp/bootstarp.sh",   #execution access
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstarp.sh redis dev"
    ]
  }
}


resource "aws_instance" "mysql" {
  ami = local.ami_id
  vpc_security_group_ids = [local.mysql_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency
  subnet_id = local.database_subnet_id
  iam_instance_profile = aws_iam_instance_profile.mysql.name  #get access by next resource
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-mysql"  #robo-dev-redis
    }
  )
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParametreRead"  #created role in IAM in aws manually
                             #we create role using terr but takes time try next time
}

resource "terraform_data" "mysql" {        #null resource called as terr data
  triggers_replace = [                     #we cant run this in local(pc) bcz private subnet
                                           #use bastion and configure terr in that server and run this file 
    aws_instance.mysql.id
  ]

 connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.mysql.private_ip
    }

 #terr copy this file to mongodb server
 #connection need but already took by above cmds
  provisioner "file" {                      #prov file means copy to another server 
        source      = "bootstarp.sh"
        destination = "/tmp/bootstarp.sh"
      }

   provisioner "remote-exec" {         #from bastion it will execute plbok in mong ser
    inline = [
        "chmod +x /tmp/bootstarp.sh",   #execution access
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstarp.sh mysql dev"
    ]
  }
}


resource "aws_instance" "rabbitmq" {
  ami = local.ami_id
  vpc_security_group_ids = [local.rabbitmq_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency
  subnet_id = local.database_subnet_id
  tags = merge (
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-rabbitmq"  #robo-dev-redis
    }
  )
}

resource "terraform_data" "rabbitmq" {        #null resource called as terr data
  triggers_replace = [                     #we cant run this in local(pc) bcz private subnet
                                           #use bastion and configure terr in that server and run this file 
    aws_instance.rabbitmq.id
  ]

 connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.rabbitmq.private_ip
    }

 #terr copy this file to mongodb server
 #connection need but already took by above cmds
  provisioner "file" {                      #prov file means copy to another server 
        source      = "bootstarp.sh"
        destination = "/tmp/bootstarp.sh"
      }

   provisioner "remote-exec" {         #from bastion it will execute plbok in mong ser
    inline = [
        "chmod +x /tmp/bootstarp.sh",   #execution access
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstarp.sh rabbitmq dev"
    ]
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}"  
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true #if data r53 records exists with this name
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}" #mongodb-dev.ashokking.sbs
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true #if data r53 records exists with this name
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.domain_name}"  
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true #if data r53 records exists with this name
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.domain_name}"  
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true #if data r53 records exists with this name
}