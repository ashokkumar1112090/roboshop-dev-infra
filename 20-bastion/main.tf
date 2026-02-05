resource "aws_instance" "bastion" {
  ami           = local.ami_id
  vpc_security_group_ids = [local.bastion_sg_id] # we get key by google for arguments then for this ec2-instance....use below sg id
  instance_type = "t3.micro"     # in vpc line first create sg then next line inst type this is auto dependency

  tags = merge (
    local.common_tags,
    {
      name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}

/* resource "aws_security_group" "allow-all" {
  name   = "allow-all"
  egress {
    from_port        = 0   #from port 0 to port  0 means all ports allowed
    to_port          = 0
    protocol         = "-1"   #all protocols
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    from_port        = 0   #from port 0 to port  0 means all ports allowed
    to_port          = 0
    protocol         = "-1"   #all protocols
    cidr_blocks      = ["0.0.0.0/0"] #internet

  }
  tags = {    #sec grp tags dont confuse with before resource tages
    Name = "allow-all"
}
} */   #sg-given in sg.tf files as bastion  #this is taken from ec2.tf ..terraform..ec2