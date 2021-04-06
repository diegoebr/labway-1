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

variable "project_id" {
  description = "The project ID to deploy resource into"
  type        = string
  default     = "infra-automation-brlm"
}

variable "subnetwork_project" {
  description = "The project ID where the desired subnetwork is provisioned"
  type        = string
  default     = "TF_VAR_subnetwork_project"
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
  type        = string
  default     = "TF_VAR_subnetwork"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  type        = string
  default     = "wp"
}

variable "mysql_password" {
  description = "The desired name to assign to the deployed instance"
  type        = string
  default     = "TF_VAR_mysql_password"
}

variable "mysql_password_root" {
  description = "The desired name to assign to the deployed instance"
  type        = string
  default     = "TF_VAR_mysql_password_root"
}

variable "instance_name_mysql" {
  description = "The desired name to assign to the deployed instance"
  type        = string
  default     = "mysql"
}

variable "team" {
  description = "The desired name to assign to the deployed instance"
  type        = string
  default     = "TF_VAR_team"
}

variable "image" {
  description = "The Docker image to deploy to GCE instances"
  type        = string
  default     = "mysql"
}

variable "image_port" {
  description = "The port the image exposes for HTTP requests"
  type        = number
  default     = "3306"
}

variable "restart_policy" {
  description = "The desired Docker restart policy for the deployed image"
  type        = string
  default     = "OnFailure"
}

variable "machine_type" {
  description = "The GCP machine type to deploy"
  type        = string
  default     = "e2-standard-2"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
  type        = string
  default     = "us-central1-a"
}

variable "additional_metadata" {
  type        = map(string)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "gce_ssh_user" {
  description = "User for ssh"
  type        = string
  default     = "dbrasileiro"
}

variable "gce_ssh_pub_key_file" {
  description = "path for ida_rsa.pub"
  type        = string
  default     = "/home/diego/.ssh/id_rsa.pub"
}
