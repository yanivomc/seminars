#!/usr/bin/env bash

set -e

if [[ $# == 0 ]]; then
  echo "Usage: $0 SERVICEACCOUNT [kubectl options]" >&2
  echo "" >&2
  echo "This script creates a kubeconfig to access the apiserver with the specified serviceaccount and outputs it to stdout." >&2

  exit 1
fi

function _kubectl() {
  kubectl $@ $kubectl_options
}

serviceaccount="$1"
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
cluster="development"
server="https://$(_kubectl get nodes  --selector '!node-role.kubernetes.io/node' --output jsonpath="{.items[?(@.status.addresses[-1].type)].status.addresses[1].address}")"
# token
ca_crt_data="$(_kubectl get secret "$secret" -o "jsonpath={.data.ca\.crt}" | openssl enc -d -base64 -A)"
namespace="$(_kubectl get secret "$secret" -o "jsonpath={.data.namespace}" | openssl enc -d -base64 -A)"
token="$(_kubectl get secret "$secret" -o "jsonpath={.data.token}" | openssl enc -d -base64 -A)"


export KUBECONFIG="$(mktemp)"

kubectl config set-credentials "$serviceaccount" --token="$token" >/dev/null
ca_crt="$(mktemp)"; echo "$ca_crt_data" > $ca_crt
#kubectl config --kubeconfig=kube-jb set-cluster "$cluster" --certificate-authority="$ca_crt" --embed-certs >/dev/null

kubectl config set-cluster "$cluster" --server="$server" --certificate-authority="$ca_crt" --embed-certs >/dev/null
kubectl config set-context "$cluster" --cluster="$cluster" --namespace="$namespace" --user="$serviceaccount" >/dev/null
kubectl config use-context "$cluster" >/dev/null

cat "$KUBECONFIG"
# vim: ft=sh :