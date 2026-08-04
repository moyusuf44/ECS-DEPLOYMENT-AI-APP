resource "aws_dynamodb_table" "terraform-aiapp-state-lock" {
    name         = "terraform-aiapp-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}