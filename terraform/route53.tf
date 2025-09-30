# ==============================
# Route 53 Hosted Zone
# ==============================
resource "aws_route53_zone" "dr_zone" {
  name    = var.domain_name  # e.g., vraj.online
  comment = "DR Multi-Region Public Hosted Zone"
}

# ==============================
# Health Check for Primary ALB
# ==============================
resource "aws_route53_health_check" "primary_health" {
  fqdn              = aws_lb.web_alb.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  request_interval  = 30
  failure_threshold = 3
}

# ==============================
# Primary Region Web ALB DNS Record
# ==============================
resource "aws_route53_record" "primary_web" {
  zone_id = aws_route53_zone.dr_zone.zone_id
  name    = var.web_record_name  # e.g., www.vraj.online
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary_health.id

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "Primary-Region"
}

# ==============================
# Health Check for Secondary ALB
# ==============================
resource "aws_route53_health_check" "secondary_health" {
  fqdn              = aws_lb.web_alb_secondary.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  request_interval  = 30
  failure_threshold = 3
}

# ==============================
# Secondary Region Web ALB DNS Record (Failover)
# ==============================
resource "aws_route53_record" "secondary_web" {
  zone_id = aws_route53_zone.dr_zone.zone_id
  name    = var.web_record_name
  type    = "A"

  alias {
    name                   = aws_lb.web_alb_secondary.dns_name
    zone_id                = aws_lb.web_alb_secondary.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.secondary_health.id

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "Secondary-Region"
}
