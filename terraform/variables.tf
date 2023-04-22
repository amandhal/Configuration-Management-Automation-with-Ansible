# ECR Repo Names
variable "ecr_repo_names" {
  default = ["web", "mysql"]
  type    = list(string)
}
