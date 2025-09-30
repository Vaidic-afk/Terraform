data "azuread_domains" "aad" {
    only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad.domains.*.domain_name
  users = csvdecode(file("users.csv"))
}

resource "azuread_user" "users" {
    for_each = { for user in local.users : user.first_name => user}
    display_name = "${each.value.first_name} ${each.value.last_name}"

    user_principal_name = format("%s%s@%s", 
    lower(substr(each.value.first_name,0,2)),
    lower(each.value.last_name),
    local.domain_name[0]
    )

    mail_nickname = format("%s%s",
    lower(substr(each.value.first_name,0,2)),
    lower(each.value.last_name)
    )
    
    password = format("%s@%s%s",
    lower(each.value.first_name),
    lower(each.value.job_title),
    length(each.value.last_name)
    )

    force_password_change = true

    department = each.value.department

    job_title = each.value.job_title
}
output "domain" {
  value = local.domain_name
}

output "users" {
  value = [ for user in local.users : "${user.first_name} ${user.last_name}" ]
}