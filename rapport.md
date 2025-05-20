# Rapport sur le projet CI/CD

Ce projet a pour objectif de mettre en place un pipeline d’intégration et de déploiement continu (CI/CD) pour une API développée en Node.js. L’objectif principal était d’automatiser entièrement le processus, de la création de l’infrastructure au déploiement de l’application, afin d’assurer une meilleure qualité, rapidité et répétabilité des déploiements.

## Choix du provider cloud

Google Cloud Platform (GCP) a été choisi comme fournisseur cloud. Ce choix s’appuie sur plusieurs facteurs :  
- La qualité et la maturité des services proposés, notamment en matière de gestion d’infrastructure via Terraform.  
- Une offre gratuite généreuse, permettant de réaliser des tests sans coûts initiaux.  
- Une bonne intégration avec les outils DevOps modernes.  

Ces éléments facilitent la gestion et la scalabilité de l’infrastructure dans un cadre professionnel.

## Gestion de l’infrastructure avec Terraform

Terraform a été retenu pour la gestion de l’infrastructure en tant que code (IaC).  
Les principaux avantages sont :  
- **Déclaration claire et lisible** : Terraform utilise un langage déclaratif qui permet de décrire l’état souhaité de l’infrastructure, ce qui facilite la maintenance et la revue de code.  
- **Portabilité** : La même configuration peut être adaptée à plusieurs fournisseurs cloud ou environnements.  
- **Gestion de l’état** : Terraform suit l’état actuel de l’infrastructure pour appliquer uniquement les changements nécessaires, minimisant ainsi les risques d’erreurs.  
- **Automatisation complète** : Permet de provisionner automatiquement les ressources, évitant les configurations manuelles sujettes aux erreurs.

## Automatisation du déploiement avec Ansible

Ansible a été choisi pour orchestrer le déploiement de l’API sur la machine virtuelle provisionnée. Ses atouts majeurs incluent :  
- **Simplicité et lisibilité** : Le langage YAML utilisé par Ansible est accessible et permet de décrire clairement les étapes de configuration et déploiement.  
- **Agentless** : Ansible ne nécessite pas d’agents installés sur les machines cibles, ce qui simplifie la gestion.  
- **Idempotence** : Les playbooks Ansible peuvent être relancés sans risque de casser la configuration, ce qui est un grand avantage pour la fiabilité des déploiements.  
- **Extensibilité** : Ansible offre de nombreux modules pour gérer tout type de ressource, ce qui permet d’intégrer facilement de nouvelles étapes dans le pipeline.

## Script de release automatisé

Le script `release.sh` automatise plusieurs étapes critiques :  
- Création d’un tag Git unique basé sur la date, assurant un suivi clair des versions déployées.  
- Génération automatique d’un changelog des derniers commits, améliorant la traçabilité des modifications.  
- Vérification de la disponibilité locale de l’API avant déploiement, ce qui prévient les erreurs de mise en production.  
- Exécution du playbook Ansible pour déployer la nouvelle version.  

Cette automatisation réduit considérablement le risque d’erreur humaine et accélère le cycle de livraison.

## Intégration avec GitHub Actions

GitHub Actions a été utilisé pour automatiser les tests et validations à chaque push ou pull request sur le dossier API. Parmi ses avantages :  
- **Intégration native avec GitHub** : Pas besoin d’installer des outils tiers, ce qui simplifie la mise en place.  
- **Flexibilité** : Permet de définir précisément les conditions de déclenchement et les étapes à exécuter.  
- **Évolutivité** : Possibilité d’ajouter facilement d’autres jobs, comme le déploiement ou des tests plus poussés.  
- **Gestion sécurisée des secrets** : GitHub Actions offre un système sécurisé pour gérer les clés et tokens nécessaires aux déploiements.  

Cette étape permet d’avoir un feedback rapide sur la qualité du code avant d’aller en production.

## Difficultés rencontrées et solutions apportées

- **Gestion des fichiers volumineux** : Les fichiers liés à Terraform, notamment certains providers, sont trop volumineux pour GitHub. La solution a été d’exclure le dossier `.terraform` du contrôle de version via `.gitignore`.  
- **Sécurité des secrets** : Pour éviter d’exposer des clés sensibles dans le dépôt, elles sont désormais gérées via les secrets GitHub, ce qui garantit leur confidentialité.  
- **Synchronisation des commits et tags** : La gestion correcte des tags et commits a nécessité l’utilisation de commandes Git précises et l’adoption d’un workflow strict pour éviter les conflits.

## Organisation du dépôt

Le dépôt est structuré en plusieurs dossiers distincts pour une meilleure clarté et maintenance :  
- `api` : Contient le code source de l’API Node.js.  
- `ansible` : Inclut les playbooks pour la configuration et le déploiement.  
- `infra` : Regroupe les fichiers Terraform décrivant l’infrastructure cloud.  
- À la racine, des scripts et fichiers de configuration (comme `release.sh` et les workflows GitHub Actions) orchestrent le processus global.

## Conclusion

Ce projet met en œuvre une chaîne d’automatisation robuste et complète pour le développement, le test et le déploiement d’une API. Le choix des technologies (Terraform, Ansible, GitHub Actions) repose sur leur maturité, leur popularité et leur capacité à s’intégrer harmonieusement. Ces outils assurent une meilleure qualité de déploiement, une traçabilité claire, et une grande flexibilité pour évoluer vers des scénarios plus complexes ou des environnements de production.

Cette base constitue un socle solide pour toute stratégie DevOps efficace, facilitant la collaboration, la répétabilité et la rapidité des livraisons.
