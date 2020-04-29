provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

resource "rancher2_cloud_credential" "secret" {
  name        = "vcenter"
  description = "Default Cloud credential for on-prem vsphere env"
  vsphere_credential_config {
    vcenter      = var.vcenter
    vcenter_port = var.vcenter_port
    username     = var.username
    password     = var.password
  }
}
