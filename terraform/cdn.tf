# Use Cloudflare for now (for CNAME flattening)

# resource "aws_route53_zone" "site" {
#   name = "${var.site}"
# }

# resource "aws_route53_record" "mx" {
#   zone_id = "${aws_route53_zone.site.zone_id}"
#   name = "${aws_route53_zone.site.name}"
#   type = "MX"
#   # Syntax for MX records took me a good 10 minutes to figure out
#   records = ["10 mx.yandex.net."]
#   ttl = "86400"
# }

# resource "aws_route53_record" "txt" {
#   zone_id = "${aws_route53_zone.site.zone_id}"
#   name = "${aws_route53_zone.site.name}"
#   type = "TXT"
#   records = ["v=spf1 ip4:94.250.255.234 include:_spf.yandex.net ~all"]
#   ttl = "86400"
# }

# resource "aws_route53_record" "a" {
#   zone_id = "${aws_route53_zone.site.zone_id}"
#   name = "${aws_route53_zone.site.name}"
#   type = "A"
#   records = ["95.31.27.234"]
#   ttl = "86400"
# }

variable "site_zone_id" {
  default = "6459a193d396cb3efaa25ebbcf1b41e6"
}

resource "cloudflare_record" "mx" {
  zone_id  = var.site_zone_id
  type     = "MX"
  name     = var.site
  content  = "mail.protonmail.ch"
  priority = "10"
}

resource "cloudflare_record" "mx2" {
  zone_id  = var.site_zone_id
  type     = "MX"
  name     = var.site
  content  = "mailsec.protonmail.ch"
  priority = "20"
}

resource "cloudflare_record" "spf" {
  zone_id=var.site_zone_id
  type  = "TXT"
  name  = var.site
  content = "v=spf1 include:_spf.protonmail.ch ~all"
}

resource "cloudflare_record" "google" {
  zone_id=var.site_zone_id
  type  = "TXT"
  name  = var.site
  content = "google-site-verification=rIbMUrGpzR_1z0ENLgQ4DqlS8ky0_umYbLxfl0Bi9vA"
}

resource "cloudflare_record" "yandex" {
  zone_id=var.site_zone_id
  type  = "TXT"
  name  = var.site
  content = "yandex-verification: f2121f360f0c70fc"
}

resource "cloudflare_record" "proton" {
  zone_id=var.site_zone_id
  type  = "TXT"
  name  = var.site
  content = "protonmail-verification=7d61974cd5924b214746355e6e27cf24608f3712"
}

resource "cloudflare_record" "cname" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = var.site
  content = "${var.site}.s3-website.eu-west-2.amazonaws.com"
  proxied = true
}

resource "cloudflare_page_rule" "all" {
  zone_id = var.site_zone_id
  target  = "${var.site}/*"

  actions {
    cache_level       = "cache_everything"
    browser_cache_ttl = "3600"
    edge_cache_ttl    = "604800"
  }
}
