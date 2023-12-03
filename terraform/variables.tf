variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default = [
    {
      userarn  = "arn:aws:iam::922619342246:user/chillipharm"
      username = "circleci"
      groups   = ["system:masters"]
    }
  ]
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}


variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
