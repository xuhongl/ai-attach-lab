NAME=aiattachlab$RANDOM # must conform to the following pattern: '^[a-zA-Z0-9]*$'
GROUP=$NAME-rg
LOCATION=westeurope
CLUSTER_NAME=$NAME-cluster
ACR_NAME=${NAME}acr
AI_NAME=$NAME-ai
TARGET_NAMESPACE=default

az group create -n $GROUP -l $LOCATION
AI_KEY=$(az monitor app-insights component create -g $GROUP -a $AI_NAME -l $LOCATION --query instrumentationKey -o tsv)
az acr create -n $ACR_NAME -g $GROUP --sku Basic
az acr build -t labapp-api:v1 -r aiattachlabacr src/api
az acr build -t labapp-app:v1 -r aiattachlabacr src/app
az aks create -n $CLUSTER_NAME -g $GROUP --generate-ssh-keys
az aks update -n $CLUSTER_NAME -g $GROUP --attach-acr $ACR_NAME

wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/init.sh
wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/helm-v0.8.4.tgz
. init.sh
helm install $NAME ./helm-v0.8.4.tgz -f values.yaml --set namespaces={} --set namespaces[0].target=$TARGET_NAMESPACE --set namespaces[0].iKey=$AI_KEY