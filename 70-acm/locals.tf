locals {
   common_name_suffix = "${var.project_name}-${var.environment}"

   common_tags = {
    project = var.project_name
    environment = var.environment
    terraform = "true"
     }
}