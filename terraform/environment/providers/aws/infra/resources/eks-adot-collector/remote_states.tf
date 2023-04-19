# ==========================================================================
#  Resources: EKS / remote_states.tf (Remote Terraform References)
# --------------------------------------------------------------------------
#  Description
# --------------------------------------------------------------------------
#    - DynamoDB
#    - S3 Bucket
#    - Region
# ==========================================================================

# --------------------------------------------------------------------------
#  Use Existing Core Terraform Remote State
# --------------------------------------------------------------------------
data "terraform_remote_state" "core_state" {
  backend   = "s3"
  workspace = local.env

  config = {
    bucket = "devopscorner-adot-remote-state"
    key    = "core/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "eks_state" {
  backend   = "s3"
  workspace = local.env

  config = {
    bucket = "devopscorner-adot-remote-state"
    key    = "resources/eks/terraform.tfstate"
    region = var.aws_region
  }
}