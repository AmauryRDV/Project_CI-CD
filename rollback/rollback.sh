#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi

TAG=$1

cd ~/api

echo "Arrêt de l'API (si en cours)..."
pkill -f index.js || true

echo "Retour au tag $TAG"
git fetch --all --tags
git checkout $TAG

echo "Relance de l'API..."
nohup node index.js > api.log 2>&1 &

sleep 5
echo "Vérification de l'état de l'API..."
curl -s http://localhost:3000/ | grep -q "API de test déployée avec succès" \
  && echo "✅ Rollback vers $TAG réussi" \
  || (echo "⚠️ Rollback échoué"; exit 1)
