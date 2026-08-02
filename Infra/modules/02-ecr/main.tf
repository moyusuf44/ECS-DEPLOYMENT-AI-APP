resource "aws_ecr_repository" "this" {
    name = ai-app-repo 
    
    image_scanning_configuration {
        scan_on_push = true 
    }
}