# 🚀 Projet CI/CD & Infrastructure pour API Mobile

## 1. Présentation du projet

Ce dépôt met en place un pipeline CI/CD complet et une infrastructure as code pour déployer une API REST destinée à une application mobile.  
Il couvre : provisionnement, configuration des serveurs, déploiement automatisé, monitoring, sauvegardes, rollback et gestion de versions.

**Stack technique :**  
- Node.js + Express  
- Terraform (infra GCP)  
- Ansible (config des VM)  
- GitHub Actions (CI/CD)  
- Prometheus (+ Grafana)  
- GitFlow  
- Snapshots GCP & script rollback  
- SemVer + tags automatiques  

---

## 2. GitFlow

| Branche       | Rôle                                         |
|---------------|----------------------------------------------|
| `main`        | Production stable                            |
| `develop`     | Intégration & staging                        |
| `feature/*`   | Nouvelles fonctionnalités                    |
| `release/*`   | Préparation d’une version                    |
| `hotfix/*`    | Corrections urgentes en production           |

**Commandes clés :**
```bash
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop

git checkout develop
git checkout -b feature/ma-fonctionnalite
git push -u origin feature/ma-fonctionnalite
```

📸 *Exemple de vue des branches Git :*  
![Branches Git](./captures/branches_git.png)

---

## 3. Infrastructure as Code

📁 Dossier : `terraform/`  
**À venir** :  
- VPC + règles firewall (ports 22, 3000)  
- Instance Compute Engine  
- Backend distant pour l'état (`bucket GCS`)

---

## 4. Configuration serveur (Ansible)

📁 Dossier : `ansible/`  
Playbook `deploy.yml` :
- Installation Node.js, Git
- Déploiement API
- Installation Prometheus

---

## 5. Pipeline CI/CD (GitHub Actions)

📁 Fichier : `.github/workflows/deploy.yml`

### Étapes réalisées
1. `checkout`
2. Setup SSH
3. Ajout known_hosts
4. `ssh` vers VM & exécution de `release.sh`

📸 *Exécution du pipeline :*  
![CI/CD pipeline](./captures/pipeline_execution.png)

### À compléter
- Lint / Tests
- Build / Packaging
- Déploiement staging
- Snapshots automatiques
- Rollback auto

---

## 6. Versionnement & Release

📄 `release.sh` effectue :
- Clonage du dépôt
- Tag `release-YYYYMMDDHHMMSS`
- Changelog automatique
- Déploiement via Ansible

📸 *Tag Git créé automatiquement :*  
![Tag Git](./captures/git_tag_release.png)

---

## 7. Monitoring & Logs

🖥️ Prometheus installé sur la VM  
- Métriques exposées sur `/metrics`  
- Fichier de config : `/etc/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'api-node'
    static_configs:
      - targets: ['localhost:3000']
```

📸 *Interface Prometheus :*  
![Prometheus metrics](./captures/prometheus_metrics.png)

### À venir
- Dashboard Grafana
- Alerte en cas d’échec

---

## 8. Sauvegardes & Rollback

### Snapshots
📁 Dossier `snapshots/` prévu  
Commande GCP :
```bash
gcloud compute disks snapshot api-disk --snapshot-names snapshot-$(date +%Y%m%d%H%M%S)
```

### Rollback
📁 Script : `rollback/rollback.sh`
```bash
#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi
TAG=$1
cd ~/api
pkill -f index.js || true
git fetch --all --tags
git checkout $TAG
nohup node index.js > api.log 2>&1 &
sleep 5
curl -s http://localhost:3000/ | grep -q "API de test déployée avec succès" \
  && echo "✅ Rollback vers $TAG réussi" \
  || (echo "⚠️ Rollback échoué"; exit 1)
```

📸 *Résultat d’un rollback réussi :*  
![Rollback](./captures/rollback_success.png)

---

## 9. Gestion des secrets

🔐 GitHub Secrets utilisés :
- `SSH_PRIVATE_KEY`
- `SSH_USER`, `SSH_HOST`

Autres :
- `.env` pour les variables sensibles
- Inventaire Ansible séparé pour staging / production

---

## 10. Procédures

### 🔁 Déploiement
```bash
# Dev → Release
git checkout -b release/1.0.0
git merge develop
git checkout main
git merge release/1.0.0
```

### 🔙 Rollback
```bash
ssh amaur@34.38.9.249 'bash ~/rollback/rollback.sh release-20250610140652'
```

### ✅ Validation
- API : `curl http://<ip>:3000`
- Logs : `tail -f ~/api/api.log`
- GCP VM : `gcloud compute instances list`

---

## ✅ Statut d'avancement

| État                     | Statut |
|--------------------------|--------|
| CI/CD pipeline (prod)    | ✅     |
| GitFlow                  | ✅     |
| Monitoring Prometheus    | ✅     |
| Script rollback          | ✅     |
| Tests automatisés        | 🚧     |
| Terraform infrastructure | 🚧     |
| Snapshots automatisés    | 🚧     |
| Dashboard Grafana        | 🚧     |

---

> 📝 Pense à exécuter tous les scripts depuis la VM et à stocker les captures dans le dossier `captures/`.  
> Pour les points manquants, tu peux ajouter des TODO ou simuler certains éléments si besoin (ex: captures, scripts vides, etc.).

