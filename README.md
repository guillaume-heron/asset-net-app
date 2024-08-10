# asset-net-app

## Infra

### Prérequis

#### Connexion à la CLI Azure

Connexion au compte azure : <code> az login </code>
<br/>
Liste des abonnements : <code>az account list --output table</code>
<br/>
Sélection d'un abonnement : <code>az account set "{subscriptionId}"</code>

#### Création du Resource Group de gestion des tfstates

Création du SPN  : 
<br/>
<code>az ad sp create-for-rbac --role="contributor" --scopes="/subscriptions/{subscriptionId}" --name="{spn_name}"</code>

Initialisation des variables pour la création du RG 
- <code>RESOURCE_GROUP_NAME="{rg_name}"</code>
- <code>STORAGE_ACCOUNT_NAME="{storage_account_name}"</code>
- <code>CONTAINER_NAME="{container_name}"</code>
- <code>REGION="{region}"</code>

Création du groupe de ressources :
<br/>
<code>az group create --name $RESOURCE_GROUP_NAME --location $REGION</code>

Création du compte de stockage :
<br/>
<code>az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob</code>

Récupération de la clé d'accès pour la création du container :
<br/>
<code>az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME</code>

Création du container qui hébergera les fichiers tfstates :
<br/>
<code>az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key "{key}"</code>

## Conteneurisation

<code>docker build -t my-web-api .</code>

<code>docker run --rm -it -p 8000:80 -e ASPNETCORE_HTTP_PORTS=80 my-web-api</code>