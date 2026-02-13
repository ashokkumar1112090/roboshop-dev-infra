locals {
    ami_id = data.aws_ami.joindevops.id
    common_name_suffix = "${var.project_name}-${var.environment}"
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    private_subnet_ids= split("," , data.aws_ssm_parameter.private_subnet_ids.value)[0]
    common_tags = {
    project = var.project_name
    environment = var.environment
    terraform = "true"
     }
}
  