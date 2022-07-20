#Input variables

#Environment 

variable "environment" {
  description = "Environment Company"
  type = string
  default="prod"
}

variable "business_divsion" {
    description ="Business Unit"
    type = string
    default = "hr"
}

variable "cluster_name" {
  description = "name of cluster"
  type = string
  default = "eks-prod"
}