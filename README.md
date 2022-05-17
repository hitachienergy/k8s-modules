# k8s-modules

Terraform modules for AKS and EKS which can be used alongside Epiphany.

## Usage

### Introduction

AKS and EKS modules use existing resources created by Epiphany e.g. resource groups, subnets etc. First step is to create infrastructure with Epiphany.Then, taking advantage of possibility to deploy custom Terraform scripts with Epiphany - AKS or EKS can be installed. Finally, after obtaining kubeconfig from Kubernetess service, it is possible to deploy Epiphany apps on top of that cluster.

### 1. Creating Epiphany cluster infrastructure

Follow documentation from [Epiphany](https://github.com/epiphany-platform/epiphany) in order to create infrastructure.
Prefereable way at this point is to create Epiphany cluster without ansible provisioning, which means applying with `--skip-config` flag set - see `epicli apply -h` to learn more. Note that usage of AKS/EKS assumes that your infrastructure will not include kubernetes machines - Epiphany do not support managing both services withing one cluster.

Basic configuration example:

  ```yaml
  kind: epiphany-cluster
  title: Epiphany cluster Config
  name: default
  provider: azure
  specification:
    name: your-cluster-name
    admin_user:
      name: operations # <----- make sure os-user is correct
      key_path: /tmp/shared/vms_rsa # <----- use generated key file
    cloud:
      k8s_as_cloud_service: true # <----- make sure that flag is set, as it indicates usage of a managed Kubernetes service
    components:
      repository:
        count: 1
      kubernetes_master:
        count: 0
      kubernetes_node:
        count: 0
      logging:
        count: 0
      monitoring:
        count: 0
      kafka:
        count: 0
      postgresql:
        count: 1
      load_balancer:
        count: 0
      rabbitmq:
        count: 0
  ---
```

Please ensure that you supply correct user for your cloud provider:

```yaml
Azure:
    redhat: ec2-user
    ubuntu: operations
AWS:
    redhat: ec2-user
    ubuntu: ubuntu
```

### 2. Re-using Terraform modules for AKS/EKS

In order to deploy AKS or EKS alongside existing Epiphany cluster, copy content of the directory: `aks` or `eks`, according to the provider used in your cluster. These terraform templates have to be copied inside your build directory, under terrafrom path: `/shared/build/clustername/terraform/`.
See [How to additional custom terrafrom templates](https://github.com/epiphany-platform/epiphany/blob/develop/docs/home/howto/CLUSTER.md#how-to-additional-custom-terraform-templates) to learn more.

### 3. Deploying AKS/EKS alongside Epiphany cluster

Before applying the configuration, parameters related to the AKS/EKS needs to be a provided.
Both `aks` and `eks` directories contain:

- `variables.tf` - describes inputs for AKS/EKS
- `terraform.tfvars` - template configuration file used to provide input variables

In both cases (AKS/EKS) there are mandatory parameters that needs to be provided. For values which are going to be reused from existing Epiphany
cluster, you can find them via cloud provider dashboard or by inspecting terrafrom state file in your cluster - `/shared/build/clustername/terraform/terraform.tfstate`.

**AKS:**

- `rsa_pub_path`

*Note:* Parameters that have default values set in `variables.tf` are automatically fetched from existing infrastructure. However, it doesn't prevent you from applying these values manually.

**EKS:**

- `name`
- `vpc_id`
- `region`
- `private_route_table_id`
- `ec2_ssh_key`

*Note:* EKS requires 2 subnets from differect AZs. If `subnet_ids` are not provided, EKS will create 2 new subnets in existing VPC.

When all required parameters are in place, you can deploy AKS/EKS with `epicli`.

*Note:* If you plan to deploy some Epiphany apps in AKS/EKS cluster, make sure that flag `--skip-config` is set. During Epiphany Ansible provisioning, `kubeconfig` from AKS/EKS lets Epiphany to connect and configure your cluster.

### 4. Getting `kubeconfig` from deployed AKS/EKS

In order to fetch kubeconfig from Terraform output variable to a file, you can use command:

```shell
terraform -chdir=/shared/build/clustername/terraform/ output kubeconfig | grep -v EOT > kubeconfig`
```

With kubeconfig set in your environment you can now connect and operate on your cluster.

*Note:* Connectivity to EKS with kubeconfig from command line requires AWS cli tool. See [EKS userguide](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html) to learn more.

### 5. Applying Epiphany on top of AKS/EKS

1. Put `kubeconfig` in Epiphany cluster build directory - `/shared/build/clustername/kubeconfig`
2. Specify kubeconfig file - `export KUBECONFIG=/shared/build/clustername/kubeconfig`
3. Re-apply Epiphany with `epicli` - use flag `--no-infra` since infrastructure is already provisioned
