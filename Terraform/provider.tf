# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

#Create VPC

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

#Create IG

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

#Create Public Subnet1

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Main"
  }
}

#Create Public Subnet 2

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
}

#create Route Table for subnet 1

resource "aws_route_table" "my_vpc_us_east_1a_public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
        Name = "Public Subnet1 Route Table"
    }
}

#Create association for route subnet 1
resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.my_vpc_us_east_1a_public.id
}

#create Route Table for subnet 2

resource "aws_route_table" "my_vpc_us_east_1b_public" {
    vpc_id = aws_vpc.main.id

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
      
      Name ="Public Subnet2 Route Table."
    }
  
}

#create association for route subnet 2

resource "aws_route_table_association" "my_vpc_us_east_1b_public" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.my_vpc_us_east_1b_public.id
  
}

#create EKS cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.name}-${var.cluster_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version = null

  vpc_config {
    security_group_ids = [aws_security_group.TerraformEC2_Security.id]
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  
  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created 
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}


# Create AWS EKS Node Group - Public
resource "aws_eks_node_group" "eks_ng_public" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_group_name = "${local.name}-eks-ng-public"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [aws_subnet.subnet1.id , aws_subnet.subnet2.id]
  
  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t2.micro"]
  
  
  remote_access {
    ec2_ssh_key = "srevm-key"
  }

  scaling_config {
    desired_size = 1
    min_size     = 1    
    max_size     = 2
  }

  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1    
  }

  # Ensure that IAM Role permissions are created.

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ] 

  tags = {
    Name = "Public-Node-Group"
  }
}