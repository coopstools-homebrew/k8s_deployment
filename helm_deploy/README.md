# A helm chart for deploying dev environments to k8s

This chart can be deployed by running the following command form the parent directory:
```
helm update --install <dev-env-name> ./dev_env
```

## templates

### namespace.yaml
A basic namespace which will contain the entire deployment. The name given to the namespace is derived from the command above and is just <dev-env-name>

### deployment.yaml
A generic deployment template used (currently) by all deployed images. All deployments are done in the above namespace.

### service.yaml
A generic service template used by each of the deployments from above. These are used as load balancer, and used to let the ingress controller know where to direct traffic.

### ingress.yaml
A simple nginx ingress four routing both by path and environment/namespace.

### ns_ctrl_role.yaml
This template sets up the permissions needed for the namespace api to be able to access k8s. The `ClusterRole` contained in here is why the helm command above uses `update --install`, instead of just `install`. The `ClusterRole` exists outside of namespaces and is not deleted when the namespace is cleared out. If helm was run with `install`, there would be an error thrown saying `Error: cannot re-use a name that is still in use`. (unfortunately, the error fails to state what name is already in use)
