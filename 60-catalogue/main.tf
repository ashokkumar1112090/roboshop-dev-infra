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
        destination = "/tmp/catalogue.shh"
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