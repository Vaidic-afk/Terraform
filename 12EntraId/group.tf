resource "azuread_group" "edu_dep" {
    display_name = "Education Department"
    security_enabled = true
}

resource "azuread_group_member" "department" {
  for_each = { for user in azuread_user.users : user.mail_nickname => user if user.department == "Education" }
  group_object_id = azuread_group.edu_dep.id
  member_object_id = each.value.id
}

resource "azuread_group" "managers" {
    display_name = "Managers"
    security_enabled = true
}

resource "azuread_group_member" "manager" {
  for_each = { for user in azuread_user.users : user.mail_nickname => user if user.job_title == "Manager" }
  group_object_id = azuread_group.managers.id
  member_object_id = each.value.id
}

resource "azuread_group" "engineers" {
    display_name = "Engineers"
    security_enabled = true
}

resource "azuread_group_member" "engineer" {
  for_each = { for user in azuread_user.users : user.mail_nickname => user if user.job_title == "Engineer" }
  group_object_id = azuread_group.engineers.id
  member_object_id = each.value.id
}

resource "azuread_group" "clients" {
    display_name = "Customers"
    security_enabled = true
}

resource "azuread_group_member" "client" {
  for_each = { for user in azuread_user.users : user.mail_nickname => user if user.job_title == "Customer"}
  group_object_id = azuread_group.clients.id
  member_object_id = each.value.id
}