variable "environment" {
  description = "The environment for the subnet (e.g., local, ci)"
  type        = string
  default     = "local"
}

variable "environment_noblank" {
  description = "The environment for the subnet (e.g., local, ci)"
  type        = string
  default     = "local"
}

variable "manually_created_zone_id" {
  description = "This is a route 53 zone id that was manually created to preserve NS records"
  type        = string
  default     = "Z0759889102IHV71WC0NI"
}