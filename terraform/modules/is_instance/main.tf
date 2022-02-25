data "ibm_is_image" "ubuntu" {
  name = "ibm-ubuntu-20-04-minimal-amd64-2"
}

resource "ibm_is_instance" "is_instance" {
  name    = var.name
  image   = data.ibm_is_image.ubuntu.id
  profile = "bx2-16x64"

  resource_group = var.resource_group

  primary_network_interface {
    subnet            = var.subnet_id
    security_groups   = [var.security_group_id]
    allow_ip_spoofing = false
  }

  vpc  = var.vpc_id
  zone = var.zone
  keys = [var.ssh_key_id]

  timeouts {
    # From experience, this sometimes takes longer than 30m, which is the
    # default.
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

resource "ibm_is_floating_ip" "fip" {
  name              = var.name
  target            = ibm_is_instance.is_instance.primary_network_interface[0].id
  resource_group    = var.resource_group
}
