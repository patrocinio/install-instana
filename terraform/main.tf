provider "ibm" {
  region = "${var.CLOUD_REGION}"
}

# https://cloud.ibm.com/docs/vpc?topic=solution-tutorials-vpc-public-app-private-backend

# Documentation: https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-vpc-gen2-resources

data "ibm_is_images" "ds_images" {
}

module "instana_base" {
  source = "./modules/instana_base"

  RESOURCE_PREFIX = var.RESOURCE_PREFIX
  SSH_PUBLIC_KEY  = var.SSH_PUBLIC_KEY
  zone            = var.zone
}


module "is_instance" {
  source = "./modules/is_instance"

  name                 = "${var.RESOURCE_PREFIX}-nfs"
  resource_group       = module.instana_base.resource_group_id
  subnet_id            = module.instana_base.subnet_id
  security_group_id    = module.instana_base.security_group_id
  vpc_id               = module.instana_base.vpc_id
  ssh_key_id           = module.instana_base.ssh_key_id
  zone                 = var.zone
}

