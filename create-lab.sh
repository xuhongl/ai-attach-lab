NAME=aiattachlab # must conform to the following pattern: '^[a-zA-Z0-9]*$'
GROUP=$NAME-rg
LOCATION=westeurope
CLUSTER_NAME=$NAME-cluster
# ACR_NAME=${NAME}acr
AI_NAME=$NAME-ai
TARGET_NAMESPACE=default

az group create -n $GROUP -l $LOCATION
# az acr create -n $ACR_NAME -g $GROUP --sku Basic
# az acr build -t labapp-api:v1 -r $ACR_NAME src/api
# az acr build -t labapp-app:v1 -r $ACR_NAME src/app
docker image build -t docker.io/cadull/ai-attach-lab-api:latest src/api
docker image push docker.io/cadull/ai-attach-lab-api:latest
docker image build -t docker.io/cadull/ai-attach-lab-app:latest src/app
docker image push docker.io/cadull/ai-attach-lab-app:latest
az aks create -n $CLUSTER_NAME -g $GROUP --generate-ssh-keys
# az aks update -n $CLUSTER_NAME -g $GROUP --attach-acr $ACR_NAME
az aks get-credentials -n $CLUSTER_NAME -g $GROUP

