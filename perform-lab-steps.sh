NAME=aiattachlab # must conform to the following pattern: '^[a-zA-Z0-9]*$'
GROUP=$NAME-rg
LOCATION=westeurope
CLUSTER_NAME=$NAME-cluster
ACR_NAME=${NAME}acr
AI_NAME=$NAME-ai
TARGET_NAMESPACE=default

az extension add -n application-insights
AI_KEY=$(az monitor app-insights component create -g $GROUP -a $AI_NAME -l $LOCATION --query instrumentationKey -o tsv)
wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/init.sh
wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/helm-v0.8.4.tgz
. init.sh
helm upgrade local-forwarder ./helm-v0.8.4.tgz -f values.yaml --install --set namespaces={} --set namespaces[0].target=$TARGET_NAMESPACE --set namespaces[0].iKey=$AI_KEY
helm upgrade labapp ./helm/labapp --install --set registry=${ACR_NAME}.azurecr.io