#!/bin/bash

set -e  # Stoppe le script si une commande échoue

echo "=== Début du script de release ==="

# Étape 1 : Génération d'un tag Git (utilise la date pour l'unicité)
VERSION=$(date +%Y%m%d%H%M%S)
echo "Tagging la version : release-$VERSION"
git tag -a "release-$VERSION" -m "Release $VERSION"
git push origin "release-$VERSION"

# Étape 2 : Génération d’un changelog rapide avec les 5 derniers commits
echo "Génération du changelog..."
git log -5 --oneline > CHANGELOG.md
git add CHANGELOG.md
git commit -m "Mise à jour du changelog pour release-$VERSION"
git push

# Étape 3 : Test local de l'API (si elle tourne déjà)
echo "Vérification de l'API locale..."
if curl -s http://localhost:3000/ | grep -q "API de test déployée avec succès"; then
  echo "✅ L'API répond correctement"
else
  echo "❌ L'API ne répond pas comme prévu (ou pas en cours d'exécution)"
fi

# Étape 4 : Lancement du playbook Ansible
echo "Lancement du déploiement avec Ansible..."
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

echo "=== Release terminée avec succès ==="
