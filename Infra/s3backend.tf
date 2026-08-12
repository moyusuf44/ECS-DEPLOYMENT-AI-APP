terraform {
    backend "s3" {
        bucket         = "moyusufs-aiapp-terraform-state"
        key            = "ai-app/terraform.tfstate"
        region         = "eu-north-1"
        dynamodb_table = "terraform-aiapp-state-lock"
        encrypt        = true 
    }
}