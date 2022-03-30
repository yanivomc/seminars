# Lest start by installing Promethous:
The below procedure will install Prometheous , Grafana & AlertManager along with NodeExporter.



1. Install helm and metricserver
~~~
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
~~~
To check if Metric server is already installed run:
~~~
kubectl get deployments/metrics-server -n kube-system
~~~
install it using the following if missing:
~~~
kubectl apply -f https://raw.githubusercontent.com/yanivomc/seminars/K8S/K8S/advanced/hpa/metricserver/components.yaml
~~~
VERIFY:
~~~
kubectl api-resources | grep metrics
(expected results)
nodes  metrics.k8s.io/v1beta1  false   NodeMetrics
pods  metrics.k8s.io/v1beta1 true PodMetrics

~~~
2. Add Promethous Repo:
~~~
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
~~~
3. Install Prometheous using our custom Value file

~~~
helm upgrade  prometheus prometheus-community/kube-prometheus-stack --values https://raw.githubusercontent.com/yanivomc/seminars/K8S/K8S/advanced/monitoring/prometheus-values.yaml
~~~
4. Check SVC 
~~~
ubuntu@ip-172-31-6-140:~$ kubectl get svc | grep LoadBalancer
prometheus-grafana                        LoadBalancer   100.64.222.amazonaws.com   80:32171/TCP       63m
prometheus-kube-prometheus-alertmanager   LoadBalancer   100.68.186.amazonaws.com   9093:31184/TCP     63m
prometheus-kube-prometheus-prometheus     LoadBalancer   100.71.57.amazonaws.com   9090:31877/TCP     63m
~~~

5. Browse Grafana:
~~~
export ALBHOST="http://"$(kubectl  get svc prometheus-grafana --output jsonpath='{.status.loadBalancer.ingress[:1].hostname}'):80/dashboards && echo $ALBHOST
~~~
USER: admin Password: prom-operator
5. Browse Prometheous:
~~~
export ALBHOST="http://"$(kubectl  get svc prometheus-kube-prometheus-prometheus --output jsonpath='{.status.loadBalancer.ingress[:1].hostname}'):9090 && echo $ALBHOST
~~~




https://github.com/ContainerSolutions/k8s-deployment-strategies
