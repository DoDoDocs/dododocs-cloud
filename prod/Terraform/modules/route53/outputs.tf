output "route53_record" {
  value = aws_route53_record.infra_record.fqdn
}