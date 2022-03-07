#!/usr/bin/env bash

set -e
sudo snap install jq >&2
sudo snap install yq >&2
cat .kube/config | yq -o json > /tmp/config.json
jsonfile=/tmp/config.json

echo "script start" >&2

function _kubectl() {
  kubectl $@ $kubectl_options
}

serviceaccount="default"
kubectl_options="${@:2}"

if ! secret="$(_kubectl get serviceaccount "$serviceaccount" -o 'jsonpath={.secrets[0].name}' 2>/dev/null)"; then
  echo "serviceaccounts \"$serviceaccount\" not found." >&2
  exit 2
fi

if [[ -z "$secret" ]]; then
  echo "serviceaccounts \"$serviceaccount\" doesn't have a serviceaccount token." >&2
  exit 2
fi

# context
context="$(_kubectl config current-context)"
# cluster
#cluster="development"
cluster="$(_kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.cluster}")"

server="https://$(_kubectl get nodes  --selector '!node-role.kubernetes.io/node' --output jsonpath="{.items[?(@.status.addresses[-1].type)].status.addresses[1].address}")"
# token
ca_crt_data="$(_kubectl get secret "$secret" -o "jsonpath={.data.ca\.crt}" | openssl enc -d -base64 -A)"
namespace="$(_kubectl get secret "$secret" -o "jsonpath={.data.namespace}" | openssl enc -d -base64 -A)"
token="$(_kubectl get secret "$secret" -o "jsonpath={.data.token}" | openssl enc -d -base64 -A)"
clientkeydata="$(mktemp)"; cat $jsonfile | jq ".users[0].user.\"client-key-data\""  | tr -d '"' | base64 --decode > $clientkeydata
clientcertificate="$(mktemp)"; cat $jsonfile | jq ".users[0].user.\"client-certificate-data\"" | tr -d '"' | base64 --decode > $clientcertificate

export KUBECONFIG="$(mktemp)"

#kubectl config set-credentials developer --client-certificate="$ca_crt" --token="$token" >/dev/null
ca_crt="$(mktemp)"; echo "$ca_crt_data" > $ca_crt
#kubectl config --kubeconfig=kube-jb set-cluster "$cluster" --certificate-authority="$ca_crt" --embed-certs >/dev/null

kubectl config set-cluster development --server="$server" --insecure-skip-tls-verify  >/dev/null
kubectl config set-credentials "developer" --client-certificate="$clientcertificate" --client-key="$clientkeydata" --embed-certs=true >/dev/null

kubectl config set-context dev-jb --cluster=development --namespace=default --user=developer >/dev/null
kubectl config use-context dev-jb >/dev/null
printf "\n\n ******  COPY FROM HERE EXCLUDE THIS LINE ******\n\n" >&2
cat "$KUBECONFIG"
printf "\n\n******  END COPY EXCLUDE THIS LINE ******\n\n" >&2
echo "Create a ~/.kube/config-jb in your local machine and paste the above into it"
echo "Once pasted run: export KUBECONFIG=~/.kube/config-jb && kubectl config use-context dev-jb"
# vim: ft=sh :