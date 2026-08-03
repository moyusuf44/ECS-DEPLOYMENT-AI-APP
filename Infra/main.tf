module "vpc" {
    source = "./modules/01-vpc"
 
}

module "ecs" {
    source = "./modules/03-ecs"

    vpc_id  = module.vpc.vpc_id
    subnets = module.vpc.public_subnets
    
    security_groups = module.vpc.ecs_security_group_id    
    
    
    cpu           = var.cpu
    memory        = var.memory
    image_id      = var.image_id
    desired_count = var.desired_count
    cluster_name  = var.cluster_name
}

module "alb" {
    source = "./modules/04-alb"

    health_check    = var.health_check_path    

    subnets         = module.vpc.public_subnets
    vpc_id          = module.vpc.vpc_id
    certificate_arn = module.acm.certificate_arn
}

module "acm" {
    source "./modules/05-acm"

    domain_name = var.domain_name
    subdomain   = var.subdomain
    zone_id     = var.zone_id
}