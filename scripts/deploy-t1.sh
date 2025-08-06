#!/bin/bash

# Define your kubeconfig contexts
CONTEXT="azure-centralus"

# Path to the manifest
MANIFEST="t1/t1-config.yaml"

# Deploy T1 configuration to cluster
echo "Checking tier1 namespace in context: $CONTEXT"
kubectl --context="$CONTEXT" get namespace tier1 || {
echo "Namespace 'tier1' does not exist in context $CONTEXT. Creating it..."
kubectl --context="$CONTEXT" apply -f t1/namespace.yaml
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
kubectl --context="$CONTEXT" apply -f t1/install-gw-t1.yaml -n tier1
sleep 5  # Wait for deployment to start
echo "Configuring Tier1 Gateway workspace in Cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "t1/t1-ws-config.yaml" 
sleep 10  # Wait for workspace configuration to apply
echo "Configuring Tier1 Gatewaty in Cluster: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "t1/t1-gw-config.yaml"
