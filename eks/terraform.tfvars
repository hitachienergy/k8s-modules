name                                        = null
vpc_id                                      = null  # from Epiphany infrastructure
subnet_ids                                  = null
region                                      = null  # from Epiphany infrastructure
private_route_table_id                      = null  # from Epiphany infrastructure
disk_size                                   = 32
autoscaler_scale_down_utilization_threshold = 0.65
ec2_ssh_key                                 = null  # from Epiphany infrastructure
ami_type                                    = "AL2_x86_64"

worker_groups = [
  {
    name                 = null,
    instance_type        = "t2.small",
    asg_desired_capacity = 1,
    asg_min_size         = 1,
    asg_max_size         = 1,
  }
]
