# k8s_deployment
The deployment scripts for k8s

## Deploying ingress controller
- Add credentials to k8s_deployment/.kube (folder is in .gitignore and will need to be generated localy). Just needs a file called `config`

- Run the helm command to add Ingress
```
docker run -it --rm -v $(pwd)/.kube:/root/.kube -v $(pwd)/helm_scripts:/config  dtzar/helm-kubectl bash ingress.sh
```

- Run the `kubectl apply -f ingress.yaml`... and wait

- Once an address has been assigned (spam `kubectl get ingress users-ingress` until one appears), create an `A` entry in domain provider pointing to ingress address

## Retrieving DigitalOcean creds via api
- Retrieve api token from digital ocean https://cloud.digitalocean.com/account/api/tokens?i=670d0c and export to `DO_TOKEN`
- Retrieve cluster id (of the form `47b7f645-6c74-4d11-8f51-0422e041f885`) and export to K8S_CLUSTER_ID
```
curl -H "Authorization: Bearer $DO_TOKEN" https://api.digitalocean.com/v2/kubernetes/clusters
```
- Generate kube config
```
curl -H "Authorization: Bearer $DO_TOKEN" https://api.digitalocean.com/v2/kubernetes/clusters/$K8S_CLUSTER_ID/kubeconfig
```
