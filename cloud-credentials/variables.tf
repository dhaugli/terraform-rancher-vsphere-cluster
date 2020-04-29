variable "api_url" {
}

variable "access_key" {
}

variable "secret_key" {
}

variable "vcenter" {
  type = string
}

variable "vcenter_port" {
  description = "Port of the vmware vsphere/vcenter environment"
  default     = "443"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}
