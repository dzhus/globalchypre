output "ssh_cloudflare_tunnel_credential" {
  value = cloudflare_zero_trust_tunnel_cloudflared.ssh.tunnel_token
  sensitive = true
}
