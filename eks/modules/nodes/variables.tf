variable "name" {
  description = "Prefix for resource names and tags"
  type        = string
}

variable "worker_groups" {
  description = "Worker groups definition list"
  type        = list(object({
    name                 = string
    instance_type        = string
    asg_desired_capacity = number
    asg_min_size         = number
    asg_max_size         = number
  }))
}

variable "subnet_ids" {
  description = "Subnet ids to join to"
  type = list(string)
}

variable "disk_size" {
  description = "Disk size"
  type        = number
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
}

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group"
  type        = string
}
