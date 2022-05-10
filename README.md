# k8s-modules

Terraform modules for AKS and EKS which can be used alongside Epiphany.

## Usage

AKS and EKS modules use existing resources created by Epiphany e.g. resource groups, subnets etc. Therefore first step is to create infrastructure with Epiphany, and then taking advantage of possibility to deploy custom Terraform scripts, AKS or EKS can be installed.

### 1. Creating Epiphany cluster infrastructure

Follow documentation from [Epiphany](https://github.com/epiphany-platform/epiphany) in order to create infrastructure.
Prefereable way at this point is to create Epiphany cluster without ansible provisioning, which means applying with `--skip-config` flag set - see `epicli apply -h` to learn more.

### 2. Re-using Terraform modules for AKS/EKS

In order to deploy AKS or EKS alongside existing Epiphany cluster, copy content of the directory: `aks` or `eks`, according to the provider used in your cluster. These terraform templates have to be copied inside your build directory, under terrafrom path: `/shared/build/clustername/terraform/`.
See [How to additional custom terrafrom templates](https://github.com/epiphany-platform/epiphany/blob/develop/docs/home/howto/CLUSTER.md#how-to-additional-custom-terraform-templates) to learn more.

### 3. Deploying AKS/EKS alongside Epiphany cluster

Before applying the configuration, parameters related to the AKS/EKS needs to be a provided.
Both `aks` and `eks` directories contain:

- `variables.tf` - describes inputs for AKS/EKS
- `terraform.tfvars` - template configuration file with defaults

In both cases (AKS/EKS) there are mandatory parameters that needs to be provided.

**AKS:**

- `rsa_pub_path`

**EKS:**

- `name`
- `vpc_id`
- `region`
- `private_route_table_id`
- `ec2_ssh_key`

EKS requires 2 subnets from differect AZs. If `subnet_ids` are not provided, EKS will create 2 new subnets in existing VPC.

When all required parameters are in place, you can deploy AKS/EKS. NOTEHEREABOUT using --skip-config again

### 4. Setting `kubeconfig` from deployed AKS/EKS in cluster

`terraform -chdir=/workspaces/epiphany/emod/build/emod/terraform/ output kubeconfig | grep -v EOT > kubeconfig`
1. Getting kubeconfig
2. Setting env variable
3. Trying connectivity
4. Installing aws cli for EKS

### 5. Applying Epiphany on top of AKS/EKS

Info about apps?