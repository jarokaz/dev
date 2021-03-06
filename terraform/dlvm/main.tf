locals {
    startup_script = "${path.module}/assets/startup-script.sh"
}

data "google_compute_image" "dlvm_image" {
    family  = var.image_family
    project = "deeplearning-platform-release"
}

data "template_file" "startup_script" {
    template = file(local.startup_script)

    vars = {
        gpu_type = var.gpu_type
    }
}

resource "google_compute_instance" "dlvm" {
    name             = var.name
    machine_type     = var.machine_type
    zone             = var.zone

    tags             = ["ssh-traffic"]

    guest_accelerator = [ {
      count = var.gpu_count
      type = var.gpu_type
    } ]

    network_interface {
        network = var.network
        subnetwork = var.subnetwork
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

    metadata = {
        install-nvidia-driver = "True"
    }    

    metadata_startup_script = data.template_file.startup_script.rendered

}

