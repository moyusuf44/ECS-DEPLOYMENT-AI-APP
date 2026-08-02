output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
    value = module.vpc.public_subnets
}

output "ecs_security_group" {
    value = aws_security_group.this.id
}