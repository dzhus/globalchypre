# Use Cloudflare for now (for CNAME flattening)

variable "new_site_zone_id" {
  default = "e08c9e60d738ce4c21b3301212d5f9f1"
}

resource "cloudflare_record" "mx_new" {
  zone_id  = var.new_site_zone_id
  type     = "MX"
  name     = var.new_site
  content  = "mx.yandex.net"
  priority = "10"
}

resource "cloudflare_record" "spf_new" {
  zone_id=var.new_site_zone_id
  type  = "TXT"
  name  = var.new_site
  content = "v=spf1 redirect=_spf.yandex.net"
}

resource "cloudflare_record" "yandex_new" {
  zone_id=var.new_site_zone_id
  type  = "TXT"
  name  = var.new_site
  content = "yandex-verification: 783f4152e3fc517c"
}

resource "cloudflare_record" "cname_new" {
  zone_id = var.new_site_zone_id
  type    = "CNAME"
  name    = var.new_site
  content = "${var.new_site}.s3-website.eu-west-2.amazonaws.com"
  proxied = true
}
