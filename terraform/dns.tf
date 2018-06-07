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

provider "cloudflare" {}

resource "cloudflare_record" "mx" {
  domain = "${var.site}"
  type = "MX"
  name = "${var.site}"
  value = "mx.yandex.net"
  priority = "10"
}

resource "cloudflare_record" "txt" {
  domain = "${var.site}"
  type = "TXT"
  name = "${var.site}"
  value = "v=spf1 ip4:94.250.255.234 include:_spf.yandex.net ~all"
}

resource "cloudflare_record" "cname" {
  domain = "${var.site}"
  type = "CNAME"
  name = "${var.site}"
  value = "${var.site}.s3-website.eu-west-2.amazonaws.com"
  proxied = true
}