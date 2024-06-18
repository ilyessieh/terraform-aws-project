# Store state file in S3 bucket
terraform {
  backend "s3" {
    bucket                  = "ilyessiehexam-wordpress-3tier-state-files"
    region                  = "eu-west-3"
    key                     = "wordpress-3tier/terraform.tfstate"
    shared_credentials_files = ["~/.aws/credentials"]
  }
}