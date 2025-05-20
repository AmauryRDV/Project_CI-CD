variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "public_key_path" {
  type    = string
  default = "id_ed25519.pub"
}
