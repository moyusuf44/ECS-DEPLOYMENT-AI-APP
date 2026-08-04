terraform {
    backend "s3" {
        bucket         = ""
        key            = ""
        region         = var.region_id
        dynamodb_table = "terraform-aiapp-state-lock"
        encrypt        = true 
    }
}