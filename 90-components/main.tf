/* module "components" {
    source = "../../terraform-roboshop-component"
    component = var.component
    rule_priority = var.rule_priority
}
 */
module "components" {
    for_each = var.components  #map so use for loop
    source = "git::https://github.com/ashokkumar1112090/terraform-roboshop-component.git?ref=main"
    component = each.key
    rule_priority = each.value.rule_priority
}