# Asset .Net Web API with infrastructure (terrafom)

![infrastructure deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-cd.yml/badge.svg)
![webapp deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/dotnet-webapp-deploy.yml/badge.svg)
![infrastructure state deployment](https://github.com/guillaume-heron/asset-net-app/actions/workflows/terraform-state.yml/badge.svg)


## Infra

### Prérequis

#### Connexion à la CLI Azure

La première étapt est de vérifier que vous avez bien la CLI d'Azure d'installée.<br/>
Une fois cela effectué, vous pouvez vous connecter à votre subscription.

Connexion au compte azure : 

```bash
az login --tenant <TENANT_ID>
```

Si vous avez plusieurs abonnements Azure, listez-les et sélectionnez celui que vous souhaitez utiliser :
```bash
az account list --output table
az account set --subscription "<SUBSCRIPTION_ID>"
```

<br/>

### Création du Service Principal

En premier lieu, il est nécessaire de créer un Service Principal qui aura seul les permissions pour déployer notre infrastructure. De cette façon, on s'affranchit de donner des accès avec privilèges aux membres de notre équipe.

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

### Mise en place des secrets dans Github

Sur Github, naviguer dans votre repo puis dans : 
<code>Settings > Security > Secrets and variables > Actions</code>

Sous l'onglet <code>Secrets</code>, cliquer sur <code>New repository secret</code> puis saisir :

| Name                  | Secret                                                        |
|---------------------- | ------------------------------------------------------------- |
| AZURE_CLIENT_ID       | La valeur contenue dans le champ "appId" ci dessus            |
| AZURE_CLIENT_SECRET   | La valeur contenue dans le champ "password" ci dessus         |
| AZURE_SUBSCRIPTION_ID | L'Id de votre Subscription (disponible sur le portail Azure)  |
| AZURE_TENANT_ID       | L'Id de votre Tenant Azure (disponible sur le portail Azure)  |

<br/>

### Création du Resource Group de gestion des tfstates

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
    az group create --name $RESOURCE_GROUP_NAME --location $REGION
    ```

- Création du compte de stockage :
    ```bash
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
    ```

- Récupération de la clé d'accès pour la création du container :
    ```bash
    az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME
    ```


- Création du container qui hébergera les fichiers tfstates :
    ```bash
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key "{key}"
    ```
<br/>

#### Méthod n°2 : via Github Actions

Afin d'éviter au maximum de donner des privilèges ou permissions trop élevés aux utilisateurs, et que nous avons précédemment configurer un Service Principal pour se connecter à Azure depuis nos Github Actions, nous pouvons de la même manière créer une Github action pour créer les ressources nécessaires pour la gestion du state Terraform.

Le workflow associé est décrit dans le fichier <code>terraform-state.yml</code>.

<br/>

## Conteneurisation

```bash
docker build -t my-web-api .
```

```bash
docker run --rm -it -p 8000:80 -e ASPNETCORE_HTTP_PORTS=80 my-web-api
```
