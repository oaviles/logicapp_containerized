# PoC: Logic App deployed on Kubernetes

### Steps to deploy this PoC
1. GitHub account and repository.
2. Azure subscription.
3. A Service Principal with Contributor role at subscription scope. This is the identity that will be used to access the Azure resources from GitHub Action.
    + If you don't have a Service Principal, create one by following [these steps](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure).
4. Deploy Azure Kubernetes Service, your can reuse this project and run GitHub Action called ["Depoy AKS Env"](https://github.com/oaviles/hello_iac/actions/workflows/tf-deploy-aks.yml). You can also depoy this PoC on:
    + EKS: ["Deploy EKS Env"](https://github.com/oaviles/hello_iac/actions/workflows/tf-deploy-eks.yml)
    + GKE: ["Deploy GKE Env"](https://github.com/oaviles/hello_iac/actions/workflows/tf-deploy-gke.yml)
5. Create an Azure Storage Account and get Connection String.
```sh
az storage account create --name <account-name> --resource-group storage-resource-group --location eastus --sku Standard_LRS --kind StorageV2
az storage account show-connection-string --name <account-name> --resource-group storage-resource-group
```
6. Encode your "Azure Storage Account Connection String" o Create a Secret in Kubernetes called "storage-cs" and key "csc" with your "Azure Storage Account Connection String" .
```sh
echo '<<your_azure-storage-account_connectionstring>>' | based64
```
```sh
kubectl create secret generic storage-cs --dry-run=client -o yaml --from-literal=scs='<<your_azure-storage-account_connectionstring>>'
```
7. Update YAML files called ["logicapp-pod.yaml"](https://github.com/oaviles/logicapp_containerized/blob/master/yaml-file/logicapp-pod.yaml) with your encoded "Azure Storage Account Connection String" in line 8.
8. Create Secrets refered in Gihub Actions called ["build-push-image.yml"](https://github.com/oaviles/logicapp_containerized/blob/master/.github/workflows/build-push-image.yml)
9. Build a Push Image to Container Registry (ACR), reuse GitHub Workflow called ["build-push-image.yml"](https://github.com/oaviles/logicapp_containerized/blob/master/.github/workflows/build-push-image.yml) 
    + Optional, you can deploy the image to Docker Hub. You can reuse this Github Workflow to do it. ["build-push-image-dockerhub.yml"](https://github.com/oaviles/logicapp_containerized/actions/workflows/build-push-image-dockerhub.yml)
10. Deploy Logic App on Kubernetes using YAML file called ["logicapp-pod.yaml"](https://github.com/oaviles/logicapp_containerized/blob/master/yaml-file/logicapp-pod.yaml)
11. Validate deployment, get ip address assignet to deployment and check if logic app is deployed. 
```sh
kubectl get service -n logicapp
curl -I <<your_ip-address>>
```
12. Open Postmand and fetch logic app URL using callback URL
    + Fetch master key from your Azure Blob Storage in container name "azure-webjobs-secrets" and file name "host.json", this key will help in fetching callback URL, Image reference.
    ![](https://microsoft.github.io/AzureTipsAndTricks/files/95hostjson.png)
    + http://<<your_ip-address>>:80/runtime/webhooks/workflow/api/management/workflows/oapistaless/triggers/manual/listCallbackUrl?api-version=2020-05-01-preview&code=<<your_logicapp-master-key>>
    ![](https://microsoft.github.io/AzureTipsAndTricks/files/95postmanresults.png)
    
13. Copy and Paste in your Bowser value from postman results (line 2). This this an example of url value:
    + http://localhost:80/api/{your logic app workflow name}/triggers/manual/invoke?api-version=2020-05-01-preview&sp={value for sp}&sv={value for sv}&sig={value for sig}
    + http://<<your_ip-address>>:80/api/oapistaless/triggers/manual/invoke?api-version=2020-05-01-preview&sp={value for sp}&sv={value for sv}&sig={value for sig} 
14. A random number will be displayed in your browser.
15. Test and Enjoy PoC

You can learn more about Logic Apps here:
+ [What is Azure Logic Apps?](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) 
+ [Microsoft Learn: Build automated workflows to integrate data and apps with Azure Logic Apps](https://docs.microsoft.com/en-us/learn/paths/build-workflows-with-logic-apps/)
+ [New hosting options for Azure Logic Apps](https://azure.microsoft.com/en-us/updates/logic-apps-updated-with-new-hosting-options-improved-performance-and-developer-workflows/)

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
