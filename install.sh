#!/bin/bash
# This will install k8s kind and ARGO CD

# Validate all cli tools are installed - PLEASE ADD CLI REQUIRED
declare -a CLI=("kubectl" "argo" "kind")
export REGISTRY_IP=192.168.86.73 # Change to the IP where NEXUS is installed
export REGISTRY_HOSTNAME=registry.emei # change to the name of the host name
export CLUSTER_NAME=toga # change to the name of your cluster

function init_process {
    validate_command $CLI 
    case_script $@
}

function validate_command {
    echo "checking CLI requirments"
    declare -a cli_missing=()
    for cli in "${CLI[@]}"
    do 
        command -v "$cli" >/dev/null 2>&1 || { echo >&2 ; cli_missing+=($cli); }                
    done
    # Check if array object count is bigger then 0 and if so exit
    len=${#cli_missing[@]}
    if [ $len \> 0 ]; then 
    echo "The following CLI are missing in your system. Please install them: ${cli_missing[@]} - Aborting"
    exit 44
    fi


}

function create_cluster {

               echo "Creating kind cluster $1"
               # Check if kind exists
               command -v kind >/dev/null 2>&1 || { echo >&2 "I require kind but it's not installed. Please use install-kind flag. Aborting."; exit 1; }
               # Create KIND CLUSTER
               #Check if CLUSTER exists
               check_cluster $CLUSTER_NAME

               # Check if kubectl works
               echo -e "\nListing K8S NODES\n"
               kubectl get nodes 2>&1 || { echo >&2 "Unable to run kubectl - Aborting."; exit 1; }
               install_argocd
           }

function install_argocd {
    echo -e "\nInstalling ARGOCD\n"
    kubectl apply -f ./k8s/packages/argocd/argocd.yaml 2>&1 || { echo >&2 "Failed to install ARGOCD - Aborting."; exit 1; }
    
    # Getting ARGOCD NODEPORT
    ARGOPORT=$(kubectl get svc/argocd-server -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
    echo -e "\n\nARGOCD URL\nhttp://localhost:$ARGOPORT"
    expose_port $ARGOPORT
    #open http://localhost:$ARGOPORT
}


function check_cluster {
    kind get kubeconfig-path --name=$CLUSTER_NAME
    if kubectl get nodes > /dev/null 2>&1 ; then
        echo "Cluster already created - switching context"
        return 0
    else
        kind create cluster --name $CLUSTER_NAME --wait 4m --config kind_values.yaml  2>&1 || { echo >&2 "Kind Cluster creation failed - Aborting."; exit 1; }
        echo "Configuring KUBECONFIG"
        export KUBECONFIG="$(kind get kubeconfig-path --name=$CLUSTER_NAME)" 2>&1 || { echo >&2 "Configuring KUBECONFIG FAILED. Please run it manualy - Aborting."; exit 1; }
        return 0
    fi

}
function expose_port {
    #Check if container forward already exposed
if docker container inspect kind-proxy-$1 > /dev/null 2>&1 ; then
    echo port already exposed - Opening browser
else
    for port in $1
do                
    node_port=$1

    docker run --rm -d --name porxy-$CLUSTER_NAME-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link $CLUSTER_NAME-worker:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:${node_port}
done
fi
}



function delete_cluster {
    echo "checking CLI requirments"
    for cli in "$@"
    do 
        command -v $cli >/dev/null 2>&1 || { echo >&2 "I require $1 but it's not installed. Please install it first. Aborting."; exit 1; }                
    done

    
}

# STARTING CASE
function case_script {
case "$1" in
        install-kind)
            echo installing kind
            ;;
         
        create-cluster)
            echo creating new cluster named $2
            CLUSTER_NAME=$2
            create_cluster $CLUSTER_NAME
            ;;
         
        delete-cluster)
            echo deleting cluster named $2
            CLUSTER_NAME=$2
            delete_cluster $CLUSTER_NAME
            ;;
        restart)
            stop
            start
            ;;
        condrestart)
            if test "x`pidof anacron`" != x; then
                stop
                start
            fi
            ;;
         
        *)
            echo $"Usage: $0 {install-kind|create-cluster [NAME]|restart|condrestart|status}"
            exit 1
 
esac
}



init_process $@


