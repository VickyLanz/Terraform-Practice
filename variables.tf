variable "project_id" {
    type = string
    description = "(optional) describe your variable"
}

variable "region" {
    type = string
    description = "(optional) describe your variable"
}

variable "zone" {
    type = string
    description = "(optional) describe your variable"
}

variable "cluster_name" {
    type = string
}

variable "zones" {
    type = list(string)
    description = "(optional) describe your variable"
}

variable "network" {
    type = string
    description = "(optional) describe your variable"
}

variable "subnetwork" {
    type = string
    description = "subnetwork name"
}
variable "ip_range_pods_name" {
    type = string
    description = "pod subnet range"
}

variable "ip_range_services_name" {
     type = string
    description = "service subnet range"
}