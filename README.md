# 10-minute Quick start: Trace apps using Application Insights without code change

See [this lab](https://azure.github.io/kube-labs/5-aks-appinsights.html) at our [Kube Labs github page](https://azure.github.io/kube-labs/).


AKS distributed tracing docs:
https://docs.microsoft.com/en-us/azure/azure-monitor/app/distributed-tracing


How can I create this web app+ API from scratch????

https://docs.microsoft.com/en-us/aspnet/web-api/overview/getting-started-with-aspnet-web-api/build-a-single-page-application-spa-with-aspnet-web-api-and-angularjs 


Or this?
https://azure.github.io/kube-labs/5-aks-appinsights.html#_1-enable-codeless-attach-for-your-cluster
https://github.com/cadullms/ai-attach-lab

(note that mssql needs to be changed

)




Then the next step is adding AI to the code
https://docs.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core#enable-application-insights-server-side-telemetry-no-visual-studio


docker build -f src/api/Dockerfile . -t xxxuhong.azurecr.io/cluster1/api

docker push xxxuhong.azurecr.io/cluster1/api 


docker build -f Dockerfile . -t xxxuhong.azurecr.io/cluster1/app

helm upgrade labapp ./helm/labapp --install ![image](https://user-images.githubusercontent.com/16740771/171024324-3d4bdbb5-8c00-4cfa-a307-0bb209ec9ed1.png)
