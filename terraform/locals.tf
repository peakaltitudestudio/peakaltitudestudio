locals {
    env = var.environment
}

locals {
  main_subnet_cidr_block = var.environment == "local" ? "172.31.0.0/24" : "172.31.2.0/24"
}

locals {
  alt_subnet_cidr_block = var.environment == "local" ? "172.31.1.0/24" : "172.31.3.0/24"
}