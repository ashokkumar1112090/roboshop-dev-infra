data "aws_ssm_parameter" "vpc-id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}