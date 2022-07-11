FROM mcr.microsoft.com/azure-functions/dotnet:3.0.14492-appservice

ENV AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=oapila;AccountKey=4Nl4l2uVHbVtqSTBmq3RwAEqK1veZRuvx96ZvCQSiVKyMYoyJ7EF8BjrQYP5ZmuL7/DSwIkFEe5o+AStDRXURw==;EndpointSuffix=core.windows.net
ENV AZURE_FUNCTIONS_ENVIRONMENT Development
ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true
ENV FUNCTIONS_V2_COMPATIBILITY_MODE=true

COPY ./bin/release/netcoreapp3.1/publish/ /home/site/wwwroot