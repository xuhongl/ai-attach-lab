# 10-minute Quick start: Troubleshoot distributed app using application insights 

 

## Objective of the lab: 

This lab is about learning how to diagnose and troubleshoot distributed application in AKS without modifying the code of the application. The sample application consists of multiple microservices that call into each other at runtime. Application Insights is helping to visualize the dependencies and supports distributed tracing at runtime. 

Learn about Application Insights [here](https://www.youtube.com/watch?v=pqZF8LjBh68) and about Codeless Attach [here](https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/blob/master/README.md).

## Prerequisites 

* An AKS cluster with Azure CLI and kubectl configured to connect to your cluster. This can be achieved following [this guide]( 
https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).

* An Application Insights resource set up following [this guide](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-new-resource). You can as well create one as described in the first steps of the lab below.

# Enable Codeless Attach for your cluster 

0. First, we will prepare our session. Open a shell, log in with Azure CLI and set it to your target subscription (use `az account show` and/or `az account set` if needed). Then initialize a few variables:

   ```sh
   NAME=aiattachlab # must conform to the following pattern: '^[a-zA-Z0-9]*$'
   GROUP=$NAME-rg
   LOCATION=westeurope
   CLUSTER_NAME=$NAME-cluster
   AI_NAME=$NAME-ai
   TARGET_NAMESPACE=default
   ```

1. To use Application Insights (AI), we first need to create an AI instance. We will do so using the Azure CLI and at the same time will save its instrumentation key in a variable (`AI_KEY`). The instrumentation key will be needed in subsequent steps: 
 
   ```sh
   az extension add -n application-insights
   AI_KEY=$(az monitor app-insights component create -g $GROUP -a $AI_NAME -l $LOCATION --query instrumentationKey -o tsv)
   ```

   In the following steps, we will set up Codeless Attach with the AI_KEY we just saved, so that all telemetry data will go to our newly created Application Insights instance. 

1. Codeless Attach is available at [github](https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach). Yet we only need two files from its latest release. We can get those using wget: 
   ```sh
   wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/init.sh 
   
   wget https://github.com/microsoft/Application-Insights-K8s-Codeless-Attach/releases/download/Beta3/helm-v0.8.4.tgz 
   ```

   The `init.sh` script we just downloaded will install a few resources in your cluster in a new namespace `aks-webhook-ns`. Most importantly, a so-called [Mutating admission webhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#mutatingadmissionwebhook), which will inject Application Insights into the configuration of pods that are subsequently deployed to your cluster. Let's execute the script: 
 
   ```sh
   . init.sh
   ```
   
   The second thing we downloaded is a [Helm chart](https://helm.sh/docs/topics/charts/) to install the "local-forwarder" into the namespace that will contain your application. In our lab, we will simply use the default namespace. : 
   
   ```sh 
   helm upgrade local-forwarder ./helm-v0.8.4.tgz -f values.yaml --install --set namespaces={} --set namespaces[0].target=$TARGET_NAMESPACE --set namespaces[0].iKey=$AI_KEY 
   ```
   
   The local forwarder acts as a proxy, to which the instrumented containers in your namespace will send their telemetry data, upon which the local forwarder will forward it to your Application Insights instance in the cloud.

   Now your cluster is connected to Application Insights. All eligible workloads (.NET Core, Java, Node) that will be deployed into our target namespace, will automatically be instrumented by a mutating webhook that will change each deployment into the target namespace mainly in three ways: 
   * Mount a volume into the pods containing the Application Insights agents for .NET, Java and Node JS. 
   * Set some environment variables that make the runtime load the Application Insights agents as additional dependencies. 
   * Set the Application Insights instrumentation key. 

# Deploy app into aks cluster and generate traffic 

Let’s see it in action.

1. Clone our sample app’s helm chart:

   ```sh
   git clone https://github.com/cadullms/ai-attach-lab 
   cd ai-attach-lab
   ```
1. Deploy the app: 

   ```sh
   helm upgrade labapp ./helm/labapp --install 
   ```

1. Wait until we have an external IP to navigate to:

   ```sh
   kubectl get svc labapp-app 
   ```
   Repeat until you see output similar to this:

   ```sh
   $ kubectl get svc labapp-app
   NAME         TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
   labapp-app   LoadBalancer   10.0.31.108   40.114.170.105   80:30007/TCP   22d
   ```
   Copy the external IP and navigate to it using a web browser:

   ![The app in a browser](/media/app.png)
   
1. Click the "Home" and "Privacy" links in it a few times. 
 
>TODO: Exec into the container to see the env vars and the volume

>TODO: Troubleshoot an exception

# Analyze Results in Application Insights 

1. Navigate to https://portal.azure.com 

1. Navigate to your application insights resource 

1. Click “Application Map” and you should see something similar to this:

![Application Map](/media/app-map.png)

 

 

 
 

  

 