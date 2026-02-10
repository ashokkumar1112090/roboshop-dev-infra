/* resource "aws_security_group_rule" "frontend_frontend_alb" {
  type = "ingress"
  security_group_id = module.sg[9].sg_id   #FE SG  Id
  source_security_group_id = module.sg[11].sg_id  #FE ALB SG ID
  #cidr_ipv4         = aws_vpc.main.cidr_block  #if we give cidr we have to give ip add so
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
} */

#backend alb accepting traffic from bastion
resource "aws_security_group_rule" "backend_alb_bastion" {
  type = "ingress"
  security_group_id = local.backend_alb_sg_id   #it should posseses
  source_security_group_id = local.bastion_sg_id  # incoming from
  #cidr_ipv4         = aws_vpc.main.cidr_block  #if we give cidr we have to give ip add so
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
}


#bastion accepting from laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type = "ingress"
  security_group_id = local.bastion_sg_id   #it should posseses

  #source_security_group_id = local.bastion_sg_id  #my laptop not source of aws so
  cidr_blocks = ["0.0.0.0/0"] #if we give cidr we have to give ip add so
                                                 #previous not hard code but here to check we use hard code with my ip add
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
}


# mongodb accepting traffic from bastion
resource "aws_security_group_rule" "mongodb_bastion" {
  type = "ingress"
  security_group_id = local.mongodb_sg_id   #it should posseses
  source_security_group_id = local.bastion_sg_id  # incoming from
  #cidr_ipv4         = aws_vpc.main.cidr_block  #if we give cidr we have to give ip add so
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
}
