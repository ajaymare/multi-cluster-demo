#!/bin/bash

# Define your kubeconfig contexts
CONTEXTS=("azure-centralus" "azure-eastus")

# Deploy Gateway to each cluster
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
  echo "Deploying East West Gateway to cluster: $CONTEXT"
  kubectl --context="$CONTEXT" apply -f east-west/install-ew-gw.yaml -n bookinfo
  # Check deployment status
  sleep 5  # Wait for deployment to start
  echo "Checking status of East West Gateway deployments in $CONTEXT..."
  kubectl --context="$CONTEXT" get deployment/eastwest-gateway -n bookinfo
  echo "--------------------------------------------------------"
done
echo "East West Gateway deployment completed across all contexts."

# Define your kubeconfig contexts
CONTEXT="azure-centralus"

# Deploy East West Gateway configuration
echo "Configuring East West Gateway for bookinfo in context: $CONTEXT"
kubectl --context="$CONTEXT" apply -f "east-west/ws-ew-config.yaml"
echo "East West Gateway configuration applied successfully in context: $CONTEXT"