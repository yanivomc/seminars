You can use the following commands to set a hostname on each server. After executing the following commands on each server, re-login to the servers so that the servers will get a new Hostname. 

sudo hostnamectl set-hostname "master"
sudo hostnamectl set-hostname "node1"
sudo hostnamectl set-hostname "node2"
# Follow the steps mentioned below to bring up the working Kubernets cluster

Get the Docker gpg key (Execute the following command on All the Nodes):

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
Add the Docker repository(Execute the following command on All the Nodes):

sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
  stable"


Get the Kubernetes gpg key(Execute the following command on All the Nodes):

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
Add the Kubernetes repository(Execute the following command on All the Nodes):

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
Install Docker, kubelet, kubeadm, and kubectl   (Execute the following command on All the Nodes):

sudo apt-get install -y docker-ce kubelet kubeadm kubectl

Hold them at the current version(Execute the following command on All the Nodes):

sudo apt-mark hold docker-ce kubelet kubeadm kubectl
# Add the iptables rule to sysctl.conf (Execute the following command on All the Nodes):

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
# Enable iptables immediately(Execute the following command on All the Nodes:

sudo sysctl -p

# sudo vim /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}

sudo systemctl restart docker
 - wait
# Only on master 

Create file: 

# vim kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.23.5
networking:
  serviceSubnet: "10.96.0.0/16"
  podSubnet: "10.244.0.0/24"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd



sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --config kubeadm-config.yaml


# Set up local kubeconfig(Execute the following command only on the Master node):

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# You must deploy a Container Network Interface (CNI) based Pod network add-on so that your Pods can communicate with each other. Cluster DNS (CoreDNS) will not start up before a network is installed.

Take care that your Pod network must not overlap with any of the host networks: you are likely to see problems if there is any overlap. (If you find a collision between your network plugin's preferred Pod network and some of your host networks, you should think of a suitable CIDR block to use instead, then use that during kubeadm init with --pod-network-cidr and as a replacement in your network plugin's YAML).

By default, kubeadm sets up your cluster to use and enforce use of RBAC (role based access control). Make sure that your Pod network plugin supports RBAC, and so do any manifests that you use to deploy it.

If you want to use IPv6--either dual-stack, or single-stack IPv6 only networking--for your cluster, make sure that your Pod network plugin supports IPv6. IPv6 support was added to CNI in v0.6.0.


# Install Flannel:
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


Make sure all pods are running: 
kubectl get pods  --all-namespaces -o wide -w


Control plane node isolation
By default, your cluster will not schedule Pods on the control-plane node for security reasons. If you want to be able to schedule Pods on the control-plane node, for example for a single-machine Kubernetes cluster for development, run:

kubectl taint nodes --all node-role.kubernetes.io/master-

This will remove the node-role.kubernetes.io/master taint from any nodes that have it, including the control-plane node, meaning that the scheduler will then be able to schedule Pods everywhere.

# Joining your nodes
The nodes are where your workloads (containers and Pods, etc) run. To add new nodes to your cluster do the following for each machine:

- SSH to the machine

- Become root (e.g. sudo su -)

- Install a runtime if needed (docker)

# Run the command that was output by kubeadm init. For example:

kubeadm join --token <token> <control-plane-host>:6443 --discovery-token-ca-cert-hash sha256:<hash>
# If you do not have the token, you can get it by running the following command on the control-plane node:

kubeadm token list
The output is similar to this:

TOKEN                    TTL  EXPIRES              USAGES           DESCRIPTION            EXTRA GROUPS
8ewj1p.9r9hcjoqgajrj4gi  23h  2018-06-12T02:51:28Z authentication,  The default bootstrap  system:
                                                   signing          token generated by     bootstrappers:
                                                                    'kubeadm init'.        kubeadm:
                                                                                           default-node-token
By default, tokens expire after 24 hours. If you are joining a node to the cluster after the current token has expired, you can create a new token by running the following command on the control-plane node:

kubeadm token create --print-join-command --v=5
The output is similar to this:

29:55.476977   13941 token.go:122] [token] validating mixed arguments
I0419 07:29:55.477118   13941 token.go:131] [token] getting Clientsets from kubeconfig file
I0419 07:29:55.477184   13941 cmdutil.go:81] Using kubeconfig file: /etc/kubernetes/admin.conf
I0419 07:29:55.483504   13941 token.go:246] [token] loading configurations
I0419 07:29:55.483845   13941 interface.go:432] Looking for default routes with IPv4 addresses
I0419 07:29:55.483867   13941 interface.go:437] Default route transits interface "ens5"
I0419 07:29:55.484076   13941 interface.go:209] Interface ens5 is up
I0419 07:29:55.484144   13941 interface.go:257] Interface "ens5" has 2 addresses :[172.31.51.90/20 fe80::43a:1ff:fe08:8c73/64].
I0419 07:29:55.484189   13941 interface.go:224] Checking addr  172.31.51.90/20.
I0419 07:29:55.484216   13941 interface.go:231] IP found 172.31.51.90
I0419 07:29:55.484246   13941 interface.go:263] Found valid IPv4 address 172.31.51.90 for interface "ens5".
I0419 07:29:55.484259   13941 interface.go:443] Found active IP 172.31.51.90
I0419 07:29:55.484360   13941 kubelet.go:217] the value of KubeletConfiguration.cgroupDriver is empty; setting it to "systemd"
I0419 07:29:55.491120   13941 token.go:253] [token] creating token

## kubeadm join 172.31.51.90:6443 --token it0eh8.5s2qb4ygydwiwmbq --discovery-token-ca-cert-hash sha256:fcacfec1456f12494938670adef2283791c2889b7d54f481ee6682c18f481aa3

# Run the joing command
Note: To specify an IPv6 tuple for <control-plane-host>:<control-plane-port>, IPv6 address must be enclosed in square brackets, for example: [fd00::101]:2073.
The output should look something like:

[preflight] Running pre-flight checks

... (log output of join workflow) ...

Node join complete:
* Certificate signing request sent to control-plane and response
  received.
* Kubelet informed of new secure connection details.

Run 'kubectl get nodes' on control-plane to see this machine join.
A few seconds later, you should notice this node in the output from kubectl get nodes when run on the control-plane node.

Note: As the cluster nodes are usually initialized sequentially, the CoreDNS Pods are likely to all run on the first control-plane node. To provide higher availability, please rebalance the CoreDNS Pods with kubectl -n kube-system rollout restart deployment coredns after at least one new node is joined.

# In case of a failure 
run kubeadm reset on the worker node and check logs /var/logs/syslog
Dont forget to make sure communications and CNI are installed on Master node

# (Optional) Controlling your cluster from machines other than the control-plane node
In order to get a kubectl on some other computer (e.g. laptop) to talk to your cluster, you need to copy the administrator kubeconfig file from your control-plane node to your workstation like this:

scp root@<control-plane-host>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get nodes

# Want to use kube
# Maintenance:
Removing a node: 
kubectl drain <node name> --delete-emptydir-data --force --ignore-daemonsets

The above will Drain all running pods on our Node

Before we remove the NODE completetly we should run 
kubeadm reset

The reset process does not reset or clean up iptables rules or IPVS tables. If you wish to reset iptables, you must do so manually:

iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
If you want to reset the IPVS tables, you must run the following command:

ipvsadm -C
Now remove the node:

kubectl delete node <node name>
If you wish to start over, run kubeadm init or kubeadm join with the appropriate arguments.

Clean up the control plane
You can use kubeadm reset on the control plane host to trigger a best-effort clean up.


## Lets deploy a test applicaion:
kubectl apply -f https://raw.githubusercontent.com/yanivomc/seminars/K8S/K8S/advanced/kubeadm/testapplication.yaml

Now expose it as TYPE NODEPORT
kubectl expose <deployment name> --type NodePort --port 8080

Browse it: 
http://<REMOTE PUBLIC IP>:<NODEPORT>


