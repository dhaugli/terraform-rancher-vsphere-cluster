data "rancher2_cloud_credential" "cloud_cred" {
  name = var.cloud_cred
}

provider "rancher2" {

  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

resource "rancher2_node_template" "workernode8gb" {
  name                = "master-4-8gb"
  description         = "Master Node Template (spec: 4-8GB)"
  cloud_credential_id = data.rancher2_cloud_credential.cloud_cred.id
  engine_install_url  = "https://releases.rancher.com/install-docker/19.03.sh"

  vsphere_config {
    datacenter = var.datacenter
    pool       = var.pool
    datastore  = var.datastore850
    folder     = var.folder

    boot2docker_url = ""
    creation_type   = "template"
    clone_from      = var.template
    cpu_count       = "4"
    memory_size     = "8192"
    disk_size       = "51200"
    network         = [var.network]
    cfgparam        = ["disk.enableUUID=TRUE"]
    ssh_user        = var.ssh_username
    ssh_password    = var.ssh_password
  }
}
