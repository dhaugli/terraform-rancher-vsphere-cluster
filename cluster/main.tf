data "rancher2_cloud_credential" "cloud_cred" {
  name = "vcenter"
}

data "rancher2_node_template" "node8gb" {
  name = "master-4-8gb"
}

provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

resource "rancher2_cluster" "rkecluster" {
  name        = "david"
  description = "default cluster"

  rke_config {
    network {
      plugin = "canal"
    }

    services {
      etcd {
        snapshot  = true
        retention = ""
      }
    }
    ssh_agent_auth = true


    cloud_provider {
      name = "vsphere"
      vsphere_cloud_provider {
        global {
          insecure_flag = true
        }
        virtual_center {
          datacenters = var.datacenters
          name        = var.vcenter_ip
          user        = var.vcenter_username
          password    = var.vcenter_password
          port        = "443"

        }
        workspace {
          datacenter        = var.datacenter
          server            = var.vcenter_ip
          folder            = var.workspace_folder
          default_datastore = var.default_datastore
          resourcepool_path = var.resourcepool_path
        }

        disk {
          scsi_controller_type = "pvscsi"
        }
        network {
          public_network = var.public_network
        }
      }
    }

  }

  enable_cluster_monitoring = true

  cluster_monitoring_input {
      #depends_on = kubernetes_storage_class.storageclass_default - To be tested when storage class is complete.
    answers = {
      "exporter-kubelets.https"                   = true
      "exporter-node.enabled"                     = true
      "exporter-node.ports.metrics.port"          = 9796
      "exporter-node.resources.limits.cpu"        = "200m"
      "exporter-node.resources.limits.memory"     = "200Mi"
      "grafana.persistence.enabled"               = false
      "grafana.persistence.size"                  = "1Gi"
      "grafana.persistence.storageClass"          = "default"
      "operator.resources.limits.memory"          = "500Mi"
      "prometheus.persistence.enabled"            = "false"
      "prometheus.persistence.size"               = "1Gi"
      "prometheus.persistence.storageClass"       = "default"
      "prometheus.persistent.useReleaseName"      = "true"
      "prometheus.resources.core.limits.cpu"      = "1000m",
      "prometheus.resources.core.limits.memory"   = "1500Mi"
      "prometheus.resources.core.requests.cpu"    = "750m"
      "prometheus.resources.core.requests.memory" = "750Mi"
      "prometheus.retention"                      = "24h"
    }
  }

}

resource "rancher2_node_pool" "bignodepool" {
  cluster_id       = rancher2_cluster.rkecluster.id
  name             = "node"
  hostname_prefix  = "node-"
  node_template_id = data.rancher2_node_template.node8gb.id
  quantity         = 2
  control_plane    = true
  etcd             = true
  worker           = true
}


##### ----- For development ----- #####
/*
resource "kubernetes_storage_class" "storageclass_default" {
  depends_on = rancher2_cluster.rkecluster
  metadata {
    name = "terraform-example"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Retain"
  parameters = {
    type = "pd-standard"
  }
  mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}

