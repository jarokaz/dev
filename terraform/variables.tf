
variable "project_id" {
    description = "The GCP project ID"
    type        = string
}

variable "region" {
    description = "The region for  clusters"
    type        = string
}

variable "zones" {
    description = "The zones for clusters"
    type        = list
}

variable "name_prefix" {
    description = "The prefix for the resources"
    type        = string
}

variable "DLVM_image" {
    description = "The DLVM image"
    type        = string
}

variable "machine_type" {
    description = "DLVM machine type"
    type        = string
    default     = "n1-standard-8"
}

variable "gpu_type" {
    description = "DLVM GPU type"
    type        = string
    default     = "nvidia-tesla-t4"
}

variable "gpu_count" {
    description = "DLVM GPU count"
    default     = 2
}

variable "subnet_ip_range" {
    description = "The IP address range for the environment's subnet"
    default     = "10.128.0.0/14"
}

