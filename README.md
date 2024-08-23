# Déploiement d'une Web API .Net et de l'infrastructure (Terraform) via Github Actions

[![infrastructure state deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-state.yml/badge.svg)](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-state.yml)
[![infrastructure deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-cd.yml/badge.svg)](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-cd.yml)
[![webapp deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/dotnet-webapp-deploy.yml/badge.svg)](https://github.com/guillaume-heron/asset-net-app/actions/workflows/dotnet-webapp-deploy.yml)


## Introduction

Le but de ce repository est de servir de "template" dans le processus de <code>Build & Deploy</code> d'une Web API en utilisant <b>Terraform</b> et les <b>Github Actions</b> pour le déploiement de notre infrastructure et de nos services.

Pour notre exemple, nous allons déployer une Web API .Net dans Azure sur une App Service en tant que container.

Toutes les étapes nécessaires sont décrites ci-dessous, et le code mis à disposition dans le repository.

<br/>

<em>PS : Ce repository est en "work in progress" ; chaque aspect (infrastructure, pipelines de ci/cd, application) va évoluer pour proposer une solution globale représentative de réels projets.</em>

## Prérequis

### Compte Azure

Si vous n'avez pas déjà de compte Azure et d'un abonnement valide, je vous invite à en créer un directement depuis le portail Azure : https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account<br/>

Cette étape est obligatoire pour la suite.

### Azure CLI

La première étape est de vérifier que vous avez bien la CLI d'Azure d'installée :
https://learn.microsoft.com/en-us/cli/azure/

Une fois cela effectué, vous pouvez vous connecter à votre subscription.

- Connexion au compte azure : 

    ```bash
    az login --tenant "<TENANT_ID>"
    ```

- Si vous avez plusieurs abonnements Azure, listez-les et sélectionnez celui que vous souhaitez utiliser :
    ```bash
    az account list --output table
    az account set --subscription "<SUBSCRIPTION_ID>"
    ```

<br/>

### Authentification à Azure depuis les Github Actions

https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect

#### Création du Service Principal

En premier lieu, il est nécessaire de créer un Service Principal qui aura seul les permissions pour déployer notre infrastructure (ressources dans Azure). De cette façon, on évite de donner des accès avec privilèges aux membres de notre équipe.

Création du SPN  : 
```bash
az ad sp create-for-rbac \
    --name "<SERVICE_PRINCIPAL_NAME>" \
    --role "Owner" \ 
    --scopes "/subscriptions/<SUBSCRIPTION_ID>"
```

Cela va créer une App Registration en plus du Service Principal, que vous pouvez retrouver sur le portail Azure sous <code>App Registrations</code>.

Une fois le SPN créé, le résultat de la création affiche dans le terminal les informations de ce dernier sous la forme :

```bash
{
  "appId": "***",
  "displayName": "{you_spn_name}",
  "password": "***",
  "tenant": "***"
}
```

Gardez de côté les informations pour l'étape suivante.<br/>
Afin que les Github Actions puissent utiliser le Service Principal pour s'authentifier à Azure, il est nécessaire d'enregistrer les données de connexions en tant que secrets.

<br/>

#### Mise en place des secrets dans Github

Sur Github, naviguer dans votre repo puis dans : 
<code>Settings > Security > Secrets and variables > Actions</code>

Sous l'onglet <code>Secrets</code>, cliquer sur <code>New repository secret</code> puis saisir :

| Name                  | Secret                                                                   |
|---------------------- | ------------------------------------------------------------------------ |
| AZURE_CLIENT_ID       | La valeur présente dans le champ <code>appId</code> ci dessus            |
| AZURE_CLIENT_SECRET   | La valeur présente dans le champ <code>password</code> ci dessus         |
| AZURE_SUBSCRIPTION_ID | L'Id de votre Subscription (disponible sur le portail Azure)             |
| AZURE_TENANT_ID       | L'Id de votre Tenant Azure (valeur présente dans le champ <code>tenant</code> ci dessus et sur votre portail Azure)  |

<br/>

### Backend Terraform

#### Création du Resource Group de gestion des tfstates

Terraform a besoin de stocker l'état de notre infrastructure et sa configuration (https://developer.hashicorp.com/terraform/language/state).<br/>

Pour cela, nous allons créer un Groupe de Ressources spécifique dans Azure avec un Compte de Stockage, dans lequel notre configuration sera stockée.

#### Méthod n°1 : Création manuelle

Ouvir un terminal et saisir les informations suivantes avec vos valeurs :
```bash
RESOURCE_GROUP_NAME="{your_rg_name}"
STORAGE_ACCOUNT_NAME="{your_storage_account_name}"
CONTAINER_NAME="tfstates"
REGION="{region}"
```

Exécuter ensuite les commandes suivantes :

- Création du groupe de ressources :
    ```bash
    az group create \
        --name $RESOURCE_GROUP_NAME \
        --location $REGION
    ```

- Création du compte de stockage :
    ```bash
    az storage account create \ 
        --resource-group $RESOURCE_GROUP_NAME \
        --name $STORAGE_ACCOUNT_NAME \
        --sku Standard_LRS \
        --encryption-services blob
    ```

- Récupération de la clé d'accès pour la création du container :
    ```bash
    az storage account keys list \
        --resource-group $RESOURCE_GROUP_NAME \
        --account-name $STORAGE_ACCOUNT_NAME
    ```


- Création du container qui hébergera les fichiers tfstates :
    ```bash
    az storage container create \
        --name $CONTAINER_NAME \
        --account-name $STORAGE_ACCOUNT_NAME \
        --account-key "{key}"
    ```
<br/>

#### Méthod n°2 : via Github Actions (recommandé)

Afin d'éviter au maximum de donner des privilèges ou permissions trop élevés aux utilisateurs, et comme nous avons précédemment configuré un Service Principal pour se connecter à Azure depuis nos Github Actions, nous pouvons de la même manière créer une Github action pour créer les ressources nécessaires pour la gestion du state Terraform.

Le workflow associé est décrit dans le fichier <code>.github/workflows/terraform-state.yml</code>.

<br/>

## Mise en place de l'infrastructure

En cours de rédaction...
<br/>

## Description de notre API 

En cours de rédaction...
<br/>

## Développement local

```bash
docker build -t my-web-api .
```

```bash
docker run --rm -it -p 8000:80 -e ASPNETCORE_HTTP_PORTS=80 my-web-api
```
