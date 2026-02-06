#open source module
# module "catalogue" {
#   source = "terraform-aws-modules/security-group/aws"
#   name        = "${local.common_name_suffix}-catalogue"
#   use_name_prefix = false
#   description = "Security group for catalogue with custom ports open within VPC, and egress all traffic "
#   vpc_id      = data.aws_ssm_parameter.vpc-id.value   #ssm parameter store key-value pair 
# }

module "sg" {
  count = length(var.sg_names)
  source = "git::https://github.com/ashokkumar1112090/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_name = var.sg_names[count.index]
  sg_description = "created for ${var.sg_names[count.index]}"
  vpc_id = local.vpc_id

}


#Frontend accepting traffic from frontend alb
/* resource "aws_security_group_rule" "frontend_frontend_alb" {
  type = "ingress"
  security_group_id = module.sg[9].sg_id   #FE SG  Id
  source_security_group_id = module.sg[11].sg_id  #FE ALB SG ID
  #cidr_ipv4         = aws_vpc.main.cidr_block  #if we give cidr we have to give ip add so
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80

} */