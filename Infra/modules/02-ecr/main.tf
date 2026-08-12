resource "aws_ecr_repository" "this" {
    name = "ai-app" 
    
    image_scanning_configuration {
        scan_on_push = true 
    }
}