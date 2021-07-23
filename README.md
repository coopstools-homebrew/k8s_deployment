# k8s_deployment
The deployment scripts for k8s

## Deploying ingress controller
This step is only needed if the cluster does not have ingress pre-installed. For example, digital ocean installs ingress as a push button operation after the creatin of the cluster.

- Add credentials to k8s_deployment/.kube (folder is in .gitignore and will need to be generated localy). Just needs a file called `config`

- Run the helm command to add Ingress
```
docker run -it --rm -v $(pwd)/.kube:/root/.kube -v $(pwd)/helm_scripts:/config  dtzar/helm-kubectl bash ingress.sh
```

- Run the `kubectl apply -f ingress.yaml`... and wait

- Once an address has been assigned (spam `kubectl get ingress users-ingress` until one appears), create an `A` entry in domain provider pointing to ingress address

## Deployments

### Kubectl (prod deployment only)
This approach can be seen in the .github/workflows/main.yaml. Here we call each of the yamls in `old_deply` using the kubectl commands.

### Helm (dev environments)
This approach can be seen in .github/workflows/dev.yaml. Here, we create a deployment, using helm, based upon a naming scheme:
`helm update --install <new_env_name> ./dev_env`
The `<new_env_name>` is used to define the namespace of the full deployment, as well as the url path prefix that will be used in routing traffic.

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

### TODO
As a part of deploying to individual namespaces, I will need to update the config yaml after it is downloaded with the currently desired namespace.

## Personal notes
- To exec into a running container, try `kubectl exec --kubeconfig ./.kube/config --stdin --tty users-api-7754f84869-kmt7l -- /bin/bash`
- When creating services, use the default type of `ClusterIP` unless I either need to explicitly create a public IP address for the service, `LoadBalancer`, or I am referencing an external resource (look it up). The problem with `LoadBalancer` is that many cloud providers will charge you per load balancer deployed.
