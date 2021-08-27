output "resource_group_id" {
  value = ibm_resource_group.group.id
}

output "subnet_id" {
    value = ibm_is_subnet.subnet.id
}

output "security_group_id" {
    value = ibm_is_security_group.security_group.id
}

output "ssh_key_id" {
    value = ibm_is_ssh_key.ssh-key.id
}

output "vpc_id" {
    value = ibm_is_vpc.vpc.id
}



