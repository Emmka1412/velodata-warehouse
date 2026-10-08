#!/usr/bin/env bash
# Exécute chaque test de tests/ : un test réussit s'il renvoie 0 ligne.
set -uo pipefail
PSQL=(docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -tAq')
failed=0
for f in tests/*.sql; do
  n=$( { echo "SELECT COUNT(*) FROM ("; grep -v '^--' "$f" | sed 's/;[[:space:]]*$//'; echo ") t;"; } | "${PSQL[@]}" ) \
    || { echo "💥 $(basename "$f") : erreur SQL"; failed=1; continue; }
  if [ "$n" -eq 0 ]; then echo "✅ $(basename "$f")"
  else echo "❌ $(basename "$f") : $n ligne(s) en anomalie"; failed=1; fi
done
exit $failed
