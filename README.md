# PoC: Logic App deployed on Kubernetes (AKS)

### Steps to deploy this PoC
- GitHub account and repository.
- Azure subscription.
- A Service Principal with Contributor role at subscription scope. This is the identity that will be used to access the Azure resources from GitHub Action. If you don't have a Service Principal, create one by following [these steps](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure).
- Deploy Azure Kubernetes Service, your can reuse this project and run GitHub Action called ["Depoy AKS Env"](https://github.com/oaviles/hello_cloud-native/blob/master/.github/workflows/deploy-poc-env.yml)
- Create an Azure Storage Account and get Connection String.
- Encode your "Azure Storage Account Connection String" o Create a Secret in Kubernetes called "storage-cs" and key "csc" with your "Azure Storage Account Connection String" .
```sh
echo '<<your_azure-storage-account_connectionstring>>' | based64
```
```sh
kubectl create secret generic storage-cs --dry-run=client -o yaml --from-literal=scs='<<your_azure-storage-account_connectionstring>>'
```
- Update YAML files called ["logicapp-pod.yaml"](https://github.com/oaviles/logicapp_containerized/blob/master/yaml-file/logicapp-pod.yaml) with your encoded "Azure Storage Account Connection String" in line 8.
- Create Secrets refered in Gihub ACtions called ["build-push-image.yml"](https://github.com/oaviles/logicapp_containerized/blob/master/.github/workflows/build-push-image.yml)
- Deploy Logic App on Kubernetes(AKS) using YAML file called ["logicapp-pod.yaml"](https://github.com/oaviles/logicapp_containerized/blob/master/yaml-file/logicapp-pod.yaml)
- Test and Enjoy PoC
