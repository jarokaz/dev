module "vpc" {
    source        = "terraform-google-modules/network/google"
    network_name  = "${var.name_prefix}-vpc"
    project_id    = module.project-services.project_id
    routing_mode  = "GLOBAL"

    subnets = [
        {
            subnet_name   = "${var.name_prefix}-subnet"
            subnet_ip     = var.subnet_ip_range
            subnet_region = var.region
        }
    ]

    firewall_rules = [
        {
            name        = "allow-ssh-ingres"
            description = "Allow ssh ingres"
            direction   = "INGRESS"
            allow = [
                {
                    protocol = "tcp"
                    ports    = ["22"]
                }
            ]
        }
    ]
}