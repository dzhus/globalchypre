terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "random_password" "tunnel_secret" {
  length = 64
}

# This requires CLOUDFLARE_API_TOKEN (NOT the account-owned one, but
# from https://dash.cloudflare.com/profile/api-tokens) with
# `Cloudflare Tunnel:Edit` and `Zone DNS:Edit` permissions
resource "cloudflare_zero_trust_tunnel_cloudflared" "ssh" {
  account_id = var.account_id
  name       = var.tunnel_name
  secret     = base64encode(random_password.tunnel_secret.result)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "ssh" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.ssh.id

  config {
    ingress_rule {
      hostname = "${cloudflare_record.ssh_tunnel.hostname}"
      service = "ssh://localhost:22"
    }
    ingress_rule {
     service  = "http_status:404"
   }
  }
}

resource "cloudflare_record" "ssh_tunnel" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = var.record_name
  content = cloudflare_zero_trust_tunnel_cloudflared.ssh.cname
  proxied = true
}
