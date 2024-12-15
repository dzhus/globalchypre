# Use Cloudflare for now (for CNAME flattening)

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

resource "cloudflare_record" "dkim_cname1" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = "protonmail._domainkey.${var.site}"
  content = "protonmail.domainkey.dliipls7c3aersicqovyzvwsix3bfuj2eu57cnnsdiun6rh6blmma.domains.proton.ch."
  proxied = false
}

resource "cloudflare_record" "dkim_cname2" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = "protonmail2._domainkey.${var.site}"
  content = "protonmail2.domainkey.dliipls7c3aersicqovyzvwsix3bfuj2eu57cnnsdiun6rh6blmma.domains.proton.ch."
  proxied = false
}

resource "cloudflare_record" "dkim_cname3" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = "protonmail3._domainkey.${var.site}"
  content = "protonmail3.domainkey.dliipls7c3aersicqovyzvwsix3bfuj2eu57cnnsdiun6rh6blmma.domains.proton.ch."
  proxied = false
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
