#!/usr/bin/env bash
# Notifie IndexNow (Bing, Yandex, Seznam…) de toutes les URL du sitemap.
# À lancer après chaque déploiement, une fois le fichier de clé en ligne.
set -euo pipefail
cd "$(dirname "$0")"

HOST="crea-bains.fr"
KEY="771c203a7985dfcf7a15fcd6e829a2e0"

URLS=$(grep -oE '<loc>[^<]+</loc>' sitemap.xml | sed -E 's#</?loc>##g; s#.*#"&"#' | paste -sd, -)

curl -sS -o /dev/null -w 'IndexNow : HTTP %{http_code}\n' \
  -X POST "https://api.indexnow.org/indexnow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"host\":\"$HOST\",\"key\":\"$KEY\",\"keyLocation\":\"https://$HOST/$KEY.txt\",\"urlList\":[$URLS]}"
