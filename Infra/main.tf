module "vpc" {
    source = "./modules/01-vpc"
 
}

module "ecr" {
  source = "./modules/02-ecr"

}

module "ecs" {
    source = "./modules/03-ecs"

    vpc_id                = module.vpc.vpc_id
    subnets               = module.vpc.public_subnets
    target_group_arn      = module.alb.target_group   
    security_groups       = [module.vpc.ecs_security_group]    
    subnet_ids            = module.vpc.public_subnets
    alb_security_group_id = module.alb.alb_security_group_id

    cpu           = var.cpu
    memory        = var.memory
    image_id      = var.image_id
    desired_count = var.desired_count
    cluster_name  = var.cluster_name
}

module "alb" {
    source = "./modules/04-alb"

    health_check_path = var.health_check_path    
    
    subnets               = module.vpc.public_subnets
    vpc_id                = module.vpc.vpc_id
    certificate_arn       = module.acm.certificate_arn
}

module "acm" {
    source = "./modules/05-acm"

    domain_name = var.domain_name
    subdomain   = var.subdomain
    zone_id     = var.zone_id
}

module "cloudflare" {
    source = "./modules/06-cloudflare"

    domain_validation_options = module.acm.domain_validation_options
    alb_dns_name              = module.alb.alb_dns_name

    zone_name = var.zone_name
    zone_id   = var.zone_id
}

resource "aws_acm_certificate_validation" "this" {
    certificate_arn = module.acm.certificate_arn

    validation_record_fqdns = module.cloudflare.validation_record_fqdns

    depends_on = [
        module.cloudflare
    ] 
}