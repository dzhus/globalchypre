# Ansible playbooks to manage my servers

Install required roles

```
ansible-galaxy install -r requirements.yml
```

Run as

```
ansible-playbook -u dzhus -b --ask-become-pass main.yml
```

## Notes

### Non-managed configuration

- [ ] Syncthing configuration (`~dzhus/.config/syncthing/config.xml`)

### Syncthing permissions

Syncthing preserves file permissions, so .torrent files synced to
Transmission watch directory must be readable by Transmission user
(it's probably safe to make them `a+r`).
