module "opi2_ssh" {
  source = "./modules/tunnel"

  account_id = "3f9c9fe20610d6d6726cd35148e3e588"
  site_zone_id = var.site_zone_id
  tunnel_name = "opi2_ssh"
  record_name = "opi2"
}

output "opi2_ssh_cloudflare_tunnel_credential" {
  value = module.opi2_ssh.ssh_cloudflare_tunnel_credential
  sensitive = true
}
