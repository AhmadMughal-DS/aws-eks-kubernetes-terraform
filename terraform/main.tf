locals {
  name_prefix = var.project_name
}

module "eks" {
  source                 = "./modules/eks"
  name_prefix            = local.name_prefix
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  cluster_version        = var.cluster_version
  node_instance_types    = var.node_instance_types
  node_desired_size      = var.node_desired_size
  node_min_size          = var.node_min_size
  node_max_size          = var.node_max_size
  endpoint_public_access = var.endpoint_public_access
}
