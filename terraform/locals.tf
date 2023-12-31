locals {
    env = var.environment
}

locals {
    env_noblank = var.environment_noblank
}

locals {
    env_dot = var.environment_dot
}

locals {
  main_subnet_cidr_block = var.environment == "local" ? "10.0.0.0/24" : "10.0.1.0/24"
}

locals {
  alt_subnet_cidr_block = var.environment == "local" ? "10.0.2.0/24" : "10.0.3.0/24"
}

locals {
  default_tags = {
    Name = "${local.env_noblank}"
  }
}