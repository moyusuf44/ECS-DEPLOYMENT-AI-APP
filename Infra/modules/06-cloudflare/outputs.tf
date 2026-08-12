output "validation_record_fqdns" {
    description = "ACM validation DNS record fqdns created in cloudflare"
    value       = [
        for record in cloudflare_dns_record.acm_validation :
        record.name
    ]
}