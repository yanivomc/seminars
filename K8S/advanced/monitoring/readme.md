# Lest start by installing Promethous:
The below procedure will install Prometheous , Grafana & AlertManager along with NodeExporter.



1. Install helm 
~~~
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
~~~
2. Add Promethous Repo:
~~~
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
~~~
3. Install Prometheous using our custom Value file
######Dont forget to download prometheus-values.yaml from this repo
~~~
helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-values.yaml
~~~
4. Check SVC 
~~~
ubuntu@ip-172-31-6-140:~$ kubectl get svc | grep LoadBalancer
prometheus-grafana                        LoadBalancer   100.64.222.amazonaws.com   80:32171/TCP       63m
prometheus-kube-prometheus-alertmanager   LoadBalancer   100.68.186.amazonaws.com   9093:31184/TCP     63m
prometheus-kube-prometheus-prometheus     LoadBalancer   100.71.57.amazonaws.com   9090:31877/TCP     63m
~~~

5. Browse Grafana:
USER: admin Password: prom-operator
5. Prometheous




https://github.com/ContainerSolutions/k8s-deployment-strategies
