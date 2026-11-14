#!/usr/bin/env bash
# After a PR merges to main: sync checkout and rebuild loa-pandaria:local.
# Does NOT restart world — run Johnt countdown + compose recreate separately.
set -euo pipefail
ROOT=/opt/loa
SRC="$ROOT/LoA-Pandaria-Playerbots"
cd "$SRC"
git fetch origin
git checkout main
git reset --hard origin/main
cd "$ROOT"
sudo docker build -t loa-pandaria:local -f docker/Dockerfile .
echo "Image rebuilt. Announce countdown, then:"
echo "  cd /opt/loa && sudo docker compose up -d --force-recreate --no-deps worldserver"
