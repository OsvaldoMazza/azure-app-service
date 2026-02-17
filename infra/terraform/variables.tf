variable "base_name" {
  description = "Base name for all resources"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.base_name))
    error_message = "base_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "location" {
  description = "Region for the resources"
  type        = string
  default     = "canadacentral"
}

variable "plan_sku_name" {
  description = "App Service plan SKU (F1 for Free, B1 Basic, S1 Standard, etc.)"
  type        = string
  default     = "B1"
}