resource "aws_ssm_parameter" "sg_id" {
 count = length(var.sg_names)
  name  = "/${var.project_name}/${var.environment}/${var.sg_names[count.index]}/sg_id"
  type  = "String"                   #robos/dev/catalog/sg_id
  value = module.sg[count.index].sg_id
}