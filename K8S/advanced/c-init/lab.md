# LAB C-INIT
In the following lab we will implment many of what we have learned up until now.

##### We will use:
- Volume
- C-INIT
- ConfigMap
- SERVICE type ClusterIp
- Ingress
- LoadBalancer as a proxy to ingress


---

# LAB SCENARIO 
We would like to create a CDN like service that will download on INIT of every POD start a GIT CLONE command to a shared EmptyDir folder.

Once the init container finish it's task we should start an NGINX image that will mount it's DEFAULT www folder to the shared EmptyDir folder (where the git clone content is).

The git repo will be stored in a ConfigMap,
this way if we would like to change the Git repo we will be able to do this in a centralize location and restart our pod.

Once created,
we will move forward and create our ingress rule that will point to our SVC.

The ingress Controller will be type LoadBalancer.

### LAB STEPS
1. Create a ConfigMap with the k/v source=https://...
2. Create a Pod or a deployment Spec 
2.1 In the init phase use image alpine/git:latest
2.2 Create an EMPTYDIR volume and mount it as /cdn
2.3 Run git clone $env? (the Env will be extracted from our config map) to the /cdn MOUNTER volume
3. In the application container run the following
3.1 Image nginx:latest
3.2 mount our EmptyDir to  /usr/share/nginx/html
4. Create a svc type CLUSTERIP where endpoint is our Pod
5. Create an ingress Rule to direct traffic on port 80 to our SVC
6. LET'S SEE IT WORK in the browser!




# GOOD LUCK!