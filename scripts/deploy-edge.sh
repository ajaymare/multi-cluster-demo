#!/bin/bash

# Load variables from .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi
# Define your kubeconfig contexts
CONTEXT=$CENTRALUS

# Deploy Edge Gateway to cluster
echo "Checking tier1 namespace in context: $CONTEXT"
kubectl --context="$CONTEXT" get namespace tier1 || {
echo "Namespace 'tier1' does not exist in context $CONTEXT. Creating it..."
kubectl --context="$CONTEXT" apply -f edge-gateway/namespace.yaml
sleep 5  # Wait for namespace creation
kubectl --context="$CONTEXT" get namespace tier1 || {   
echo "❌ Failed to create namespace 'tier1' in context $CONTEXT."
exit 1
  }
echo "✅ Namespace 'tier1' created successfully."
echo "Namespace 'tier1' created."
} 
echo "Checking TLS secret in context: $CONTEXT"
kubectl --context="$CONTEXT" get secret bookinfo-cert -n tier1 || {
echo "❌ TLS secret 'bookinfo-cert' does not exist in context $CONTEXT. Creating it..."
kubectl --context="$CONTEXT" apply -f app/tls-secret.yaml -n tier1
sleep 5  # Wait for secret creation
kubectl --context="$CONTEXT" get secret bookinfo-cert -n tier1 || {
echo "❌ Failed to create TLS secret 'bookinfo-cert' in context $CONTEXT."
exit 1
  }
echo "✅ TLS secret 'bookinfo-cert' created successfully."
} 
echo "Deploying T1 Gatway on Cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f edge-gateway/install-edge-gw.yaml -n tier1
sleep 5  # Wait for deployment to start
echo "Configuring Tier1 Gateway workspace in Cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "edge-gateway/ws-config.yaml" 
sleep 10  # Wait for workspace configuration to apply
echo "Configuring Tier1 Gatewaty in Cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "edge-gateway/edge-gw-config.yaml"
