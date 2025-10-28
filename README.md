# k8s-home-lab

A Kubernetes home lab project, built from the ground up.

* To learn how container orchestration works.
* To transform abstract concepts of Kubernetes into a tangible, working environment that I control.
* To gain confidence in how components such as PODS, API server, Etcd, Kube-controller-manager, and Deployment fit together.
* To build a sandbox where I can experiment, break things, fix them, and learn deeply, without risking critical systems.
* To obtain Certified Kubernetes Application Developer (CKAD) 

## Cluster setup with kubeadm
I chose to bootstrap the cluster using kubeadm because I wanted to know exactly what was happening under the hood. 
I was not satisfied with using a managed service that abstracts everything away. 

* I wanted to understand the roles of the control plane & worker node.
* I wanted to see how etcd, API server, scheduler, and kubelet all tie together.
* I wanted to be comfortable with troubleshooting, debugging pod failures, and other maintenance tasks.

## Storage & NFS setup
In a home lab, you don’t have cloud-native block storage, so I included an NFS.

* To handle persistent volumes
* Deploy stateful workloads.
* Understand persistent volume & persistent volume claim lifecycles.
  
## Ingress NGINX Controller
Entry point to the cluster, responsible for exposing applications externally.

* Acts as an ingress controller to route external traffic to internal services.  
* Uses cert-manager with an HTTP challenge that automatically issues and manages TLS certificates.    
* The entire path from the client through Cloudflare to the ingress controller is fully encrypted.

## Observability
Running workloads is only part of the equation; understanding what is happening is just as important.

* I integrated metrics and logging to monitor the actual behavior of the cluster, rather than simply assuming it is functioning properly. 
* I collected metrics for both nodes and pods to track resource usage and identify potential issues early on. 
* By aggregating logs from applications and the cluster, I created a single point for troubleshooting.

