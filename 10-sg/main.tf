module "catalogue" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.common_name_suffix}-catalogue"
  use_name_prefix = false
  description = "Security group for catalogue with custom ports open within VPC, and egress all traffic "
  vpc_id      = data.aws_ssm_parameter.vpc-id.value   #ssm parameter store key-value pair

  
}