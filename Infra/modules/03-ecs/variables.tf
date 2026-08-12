variable "cpu" {
    type = string
}

variable "memory" {
    type = string
}

variable "image_id" {
    type = string
}

variable "desired_count" {
    type = string
}

variable "cluster_name" {
    type = string 
}

variable "subnets" {
    type = list(string)
}

variable "security_groups" {
    type = string
}

variable "target_group_arn" {
    type = string
}

variable "vpc_id" {
    type = string 
}

variable "subnet_ids" {
    type = list(string)
}