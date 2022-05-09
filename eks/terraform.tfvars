name                                        = "cicharka-emod-rg"      # resource group name
vpc_id                                      = "vpc-0a307dd209c0810f1" # should be provided the one from epi cluster
subnet_ids                                  = null
region                                      = "eu-west-2"   # from epi
private_route_table_id                      = "rtb-077293d21698b5d56"   # from epi
disk_size                                   = 32
autoscaler_scale_down_utilization_threshold = 0.65
ec2_ssh_key                                 = "ubuntu-d5691968-e2f9-4b6c-9df9-7ae5f05ee8bd"   # from epi
ami_type                                    = "AL2_x86_64"

worker_groups = [
  {
    name                 = "cich-wg",
    instance_type        = "t2.small",
    asg_desired_capacity = 1,
    asg_min_size         = 1,
    asg_max_size         = 1,
  }
]
