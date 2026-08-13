resource "aws_secretsmanager_secret" "openai_api_key" {
  name = "ai-app/openai-api-key"
}