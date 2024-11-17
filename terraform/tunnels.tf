resource "random_password" "tunnel_secret1" {
  length = 64
}

# This requires CLOUDFLARE_API_TOKEN with `Cloudflare Tunnel:Edit` permissions
resource "cloudflare_zero_trust_tunnel_cloudflared" "opi1_ssh" {
  account_id = "3f9c9fe20610d6d6726cd35148e3e588"
  name       = "opi1_ssh"
  secret     = base64encode(random_password.tunnel_secret1.result)
}

output "opi1_ssh_cloudflare_tunnel_credential" {
  value = cloudflare_zero_trust_tunnel_cloudflared.opi1_ssh.tunnel_token
  sensitive = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "opi1_ssh" {
  account_id = "3f9c9fe20610d6d6726cd35148e3e588"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.opi1_ssh.id

  config {
    ingress_rule {
      hostname = "${cloudflare_record.opi1_ssh_tunnel.hostname}"
      service = "ssh://localhost:22"
    }
    ingress_rule {
     service  = "http_status:404"
   }
  }
}

resource "cloudflare_record" "opi1_ssh_tunnel" {
  zone_id = var.site_zone_id
  type    = "CNAME"
  name    = "opi1"
  content = cloudflare_zero_trust_tunnel_cloudflared.opi1_ssh.cname
  proxied = true
}
