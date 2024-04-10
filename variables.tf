variable "namespace" {
  description = "Namespace to deploy the node initializer."
  type        = string
  default     = "default"
}

# https://cloud.google.com/looker/docs/reference/param-view-timezone-values
variable "timezone" {
  description = "Timezone to be used in the GKE nodes."
  type        = string
  default     = "Europe/Berlin"
}

variable "gke_timezone_label" {
  description = "Labels to be applied to the GKE nodes."
  type        = string
  default     = "default-init"
}
