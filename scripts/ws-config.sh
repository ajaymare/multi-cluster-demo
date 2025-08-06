#!/bin/bash

# Define your kubeconfig contexts
CONTEXT="azure-centralus"

# Path to the manifest
MANIFEST="infra/ws-config.yaml"

# Deploy bookinfo App to each cluster
echo "Deploying TSB Configuration: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "infra/ws-config.yaml"
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
kubectl --context="$CONTEXT" apply -f "app/gw-config.yaml"
