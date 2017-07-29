# Non-managed configuration

- [ ] Zabbix items and USERS (lives inside `zabbix-postgres` container)

- [ ] Syncthing configuration (`~dzhus/.config/syncthing/config.xml`)

# Syncthing permissions

Syncthing preserves file permissions, so .torrent files synced to
Transmission watch directory must be readable by Transmission user
(it's probably safe to make them `a+r`).
