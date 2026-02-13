data "aws_ami" "joindevops" {
    owners           = ["973714476881"]
    most_recent      = true
    
    filter {
        name   = "name"
        values = ["Redhat-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}



data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.environment}/catalogue_sg_id"
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
  
}
