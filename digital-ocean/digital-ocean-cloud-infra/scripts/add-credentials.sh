security add-generic-password \
  -a "$USER" \
  -s "digitalocean-s3-access-key" \
  -w "XXXXXXXXXYYYYYYYYXXXXXXXXXXXXXX"

security add-generic-password \
  -a "$USER" \
  -s "digitalocean-s3-secret-key" \
  -w "XXXXXXZXCFAGFSFAHSXXXXXXXXXX"

security add-generic-password \
  -a "$USER" \
  -s "github-token"
  -w "XXXXXXJSHJBDHJBSHJDBSXXXXXXXXXXXX"

security add-generic-password \
  -a "$USER" \
  -s "digitalocean-api-token"
  -w "do.XXXXXXJSHJBDHJBSHJDBSXXXXXXXXXXXX"

security add-generic-password \
  -a "$USER" \
  -s "grafana-admin-password"
  -w "XXXXXXJSHJBDHJBSHJDBSXXXXXXXXXXXX"