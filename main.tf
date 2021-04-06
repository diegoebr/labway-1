/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
}

locals {
  instance_name       = "${var.team}-${var.instance_name}"
  instance_name_mysql = "${var.team}-${var.instance_name_mysql}"
}
########################## MYSQL #####################################################
module "gce-container" {
  source = "git@github.com:terraform-google-modules/terraform-google-container-vm.git"

  container = {
    image = var.image

    env = [
      {
        name  = "MYSQL_ROOT_PASSWORD"
        value = var.mysql_password_root
      },
      {
        name  = "MYSQL_DATABASE"
        value = "wordpress"
      },
      {
        name  = "MYSQL_USER"
        value = "wordpress"
      },
      {
        name  = "MYSQL_PASSWORD"
        value = var.mysql_password
      },
    ]

    # Declare volumes to be mounted
    # This is similar to how Docker volumes are mounted
    volumeMounts = [
      {
        mountPath = "/var/lib/mysql"
        name      = "data-disk-0"
        readOnly  = false
      },
    ]
  }

  # Declare the volumes
  volumes = [
    {
      name = "data-disk-0"

      gcePersistentDisk = {
        pdName = "data-disk-0"
        fsType = "ext4"
      }
    },
  ]

  restart_policy = "OnFailure"
}


resource "google_compute_disk" "pd" {
  project = var.project_id
  name    = "${local.instance_name_mysql}-data-disk"
  type    = "pd-ssd"
  zone    = var.zone
  size    = 10
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = local.instance_name_mysql
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  attached_disk {
    source      = google_compute_disk.pd.self_link
    device_name = "data-disk-0"
    mode        = "READ_WRITE"
  }

  network_interface {
    subnetwork_project = var.subnetwork_project
    subnetwork         = var.subnetwork
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    ssh-keys                  = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  tags = ["all-ingress"]


}


############################## WORDPRESS ####################################
/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

##################################### WORDPRESS ##############################################################
module "gce-container-wp" {
  source = "git@github.com:terraform-google-modules/terraform-google-container-vm.git"

  container = {
    image     = "wordpress:latest"
    http_port = "80"

    env = [
      {
        name  = "WORDPRESS_DB_HOST"
        value = "${google_compute_instance.vm.network_interface.0.network_ip}:${var.image_port}"
      },
      {
        name  = "WORDPRESS_DB_USER"
        value = "wordpress"
      },
      {
        name  = "WORDPRESS_DB_PASSWORD"
        value = var.mysql_password
      },
      {
        name  = "WORDPRESS_DB_NAME"
        value = "wordpress"
      },
    ]
  }

  restart_policy = "OnFailure"
}


resource "google_compute_instance" "wp" {
  project      = var.project_id
  name         = local.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container-wp.source_image
    }
  }

  network_interface {
    subnetwork_project = var.subnetwork_project
    subnetwork         = var.subnetwork
  }
  #merge(var.additional_metadata, map("gce-container-declaration", module.gce-container.metadata_value))
  metadata = {
    gce-container-declaration = module.gce-container-wp.metadata_value
    ssh-keys                  = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  labels = {
    container-vm = module.gce-container-wp.vm_container_label
  }

  tags = ["all-ingress"]

}

