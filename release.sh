#!/bin/bash

set -e

echo "=== Début du script de release ==="

# Étape 0 : Cloner proprement
cd ~
if [ -d api ]; then
  echo "Répertoire 'api' déjà présent, suppression..."
  rm -rf api
fi

echo "Clonage du dépôt Git..."
git clone git@github.com:AmauryRDV/Project_CI-CD.git api
cd api

# Étape 1 : Tag Git
VERSION=$(date +%Y%m%d%H%M%S)
echo "Tagging version : release-$VERSION"
git tag -a "release-$VERSION" -m "Release $VERSION"
git push origin "release-$VERSION"

# Étape 2 : Changelog
echo "Génération du changelog..."
git log -5 --oneline > CHANGELOG.md
if ! git diff --quiet CHANGELOG.md; then
  git add CHANGELOG.md
  git commit -m "Mise à jour du changelog pour release-$VERSION"
  git push
else
  echo "Aucun changement à commit dans le changelog."
fi

# Étape 3 : Test de l’API
echo "Vérification de l'API locale..."
if curl -s http://localhost:3000/ | grep -q "API de test déployée avec succès"; then
  echo "✅ L'API répond correctement"
else
  echo "⚠️ L'API ne répond pas comme prévu ou n'est pas lancée"
fi

# Étape 4 : Déploiement Ansible
echo "Lancement du déploiement avec Ansible..."
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

echo "=== Release terminée avec succès ==="
