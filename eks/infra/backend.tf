terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "DevOpsLab_dlsrks1218"
    workspaces {
      name = "EKS_INFRA"
    }
  }
}
