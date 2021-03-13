
locals {
    startup_script = "${path.module}/assets/startup-script.sh"
    network        = var.network_name != "" var.net
    subnetwork     = var.subnetwork_name
}

data "template_file" "startup_script" {
    template = file(local.startup_script)

    vars = {
        gpu_type = var.gpu_type
    }
}

data "google_compute_image" "dlvm_image" {
    family  = var.image_family
    project = "deeplearning-platform-release"
}


resource "google_compute_instance" "container_vm" {
    name             = var.name
    machine_type     = var.machine_type
    zone             = var.zone

    tags             = ["ssh-traffic"]

    guest_accelerator = [ {
      count = var.gpu_count
      type = var.gpu_type
    } ]

    network_interface {
        network = local.network
        subnetwork = local.subnetwork
        access_config {}
    }

    boot_disk {
        initialize_params {
          image = data.google_compute_image.dlvm_image.self_link
          size  = var.boot_disk_size
        }
    }

    service_account {
        email = var.service_account
        scopes = var.scopes
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "TERMINATE"
    }

    metadata_startup_script = data.template_file.startup_script.rendered

}

