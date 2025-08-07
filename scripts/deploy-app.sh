#!/bin/bash

# Define your kubeconfig contexts
CONTEXTS=($(kubectl config get-contexts -o name))

# Deploy bookinfo App to each cluster
for CONTEXT in "${CONTEXTS[@]}"; do
  echo "Checking bookinfo namespace in context: $CONTEXT"
  kubectl --context="$CONTEXT" get namespace bookinfo || {
    echo "Namespace 'bookinfo' does not exist in context $CONTEXT. Creating it..."
    kubectl --context="$CONTEXT"  apply -f app/namespace.yaml
    sleep 5  # Wait for namespace creation
    kubectl --context="$CONTEXT" get namespace bookinfo || {
      echo "❌ Failed to create namespace 'bookinfo' in context $CONTEXT."
      exit 1
    }
    echo "✅ Namespace 'bookinfo' created successfully."
    echo "Namespace 'bookinfo' created."
  }
  echo "Deploying application to cluster: $CONTEXT"
  kubectl --context="$CONTEXT" apply -f app/bookinfo-service.yaml -n bookinfo
  kubectl --context="$CONTEXT" apply -f app-gateway/install-app-gw.yaml -n bookinfo
  # Check deployment status
  sleep 5  # Wait for deployment to start
  echo "Checking status of Bookinfo deployments in $CONTEXT..."
  kubectl --context="$CONTEXT" get deployment -n bookinfo
  echo "--------------------------------------------------------"
  echo "Checking status of Bookinfo pods in $CONTEXT..."
  kubectl --context="$CONTEXT" get pods -n bookinfo
  echo "--------------------------------------------------------"
  echo "Checking status of Gateway deployments in $CONTEXT..."
  kubectl --context="$CONTEXT" get deployment/bookinfo-gw -n bookinfo
  echo "--------------------------------------------------------"
done


# Deploy bookinfo App to each cluster
echo "Configuring TSB Workspace and Groups: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "app-gateway/ws-config.yaml"
sleep 5  # Wait for deployment to start
echo "Checking TLS secret in context: $CONTEXT"
kubectl --context="$CONTEXT" get secret bookinfo-cert -n bookinfo || {
  echo "❌ TLS secret 'bookinfo-cert' does not exist in context $CONTEXT. Creating it..."
  kubectl --context="$CONTEXT" apply -f app/tls-secret.yaml -n bookinfo
  sleep 5  # Wait for secret creation
  kubectl --context="$CONTEXT" get secret bookinfo-cert -n bookinfo || {
    echo "❌ Failed to create TLS secret 'bookinfo-cert' in context $CONTEXT."
    exit 1
   }
  echo "✅ TLS secret 'bookinfo-cert' created successfully."
}
echo "Configuring Gateway for bookinfo in context: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "app-gateway/app-gw-config.yaml"


# Load variables from .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi
# Define your kubeconfig contexts
CONTEXT=$CENTRALUS

# Deploy Sleep service to verify traffic to service
echo "Checking sleep namespace in context: $CONTEXT"
kubectl --context="$CONTEXT" get namespace sleep || {
echo "Namespace 'sleep' does not exist in context $CONTEXT. Creating it..."
kubectl --context="$CONTEXT" apply -f app/namespace.yaml
sleep 5  # Wait for namespace creation
kubectl --context="$CONTEXT" get namespace sleep || {   
echo "❌ Failed to create namespace 'sleep' in context $CONTEXT."
exit 1
  }
echo "✅ Namespace 'sleep' created successfully."
echo "Namespace 'slepp' created."
} 
# Deploy the sleep application
echo "Deploying sleep Application in cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f app/sleep.yaml -n sleep
# Check deployment status
sleep 5  # Wait for deployment to start
echo "Checking status of sleep deployments in $CONTEXT..."
kubectl --context="$CONTEXT" get deployment/sleep -n sleep
echo "--------------------------------------------------------"
echo "Sleep deployment completed in context $CONTEXT."

echo "All deployments completed across all contexts."
echo "Deployment script finished successfully."
