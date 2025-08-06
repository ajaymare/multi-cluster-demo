#!/bin/bash

# Define your kubeconfig contexts
CONTEXT="azure-centralus"

# Deploy bookinfo App to each cluster
echo "Checking status of Gateway deployments in $CONTEXT..."
kubectl --context="$CONTEXT" get deployment/bookinfo-gw -n bookinfo || {
  echo "Gateway deployment not found in context $CONTEXT. Deploying Gateway..."
  kubectl --context="$CONTEXT" apply -f app-gateway/install-app-gw.yaml -n bookinfo
  sleep 5  # Wait for deployment to start
  echo "Gateway deployment initiated in context $CONTEXT."
} || {
  echo "❌ Failed to deploy Gateway in context $CONTEXT."
  exit 1
}
echo "✅ Gateway deployment found in context $CONTEXT."
echo "Performing App Failover in context: $CONTEXT"
kubectl --context="$CONTEXT" scale deploy bookinfo-gw -n bookinfo --replicas=0 || {
  echo "❌ Failed to scale down Gateway deployment in context $CONTEXT."
  exit 1
}
echo "✅ Gateway deployment scaled down to 0 replicas in context $CONTEXT."
sleep 30
echo "Scaling up Gateway deployment in context: $CONTEXT"
# Scale up the Gateway deployment to 1 replica
kubectl --context="$CONTEXT" scale deploy bookinfo-gw -n bookinfo --replicas=1 || {
  echo "❌ Failed to scale up Gateway deployment in context $CONTEXT."
  exit 1
}
sleep 5
echo "✅ Gateway deployment scaled up to 1 replica in context $CONTEXT."
echo "Checking status of Gateway deployments in $CONTEXT..."
kubectl --context="$CONTEXT" get deployment/bookinfo-gw -n bookinfo || {
  echo "❌ Gateway deployment not found in context $CONTEXT after failover."
  exit 1
}
echo "✅ Gateway deployment found in context $CONTEXT after failover."
echo "App Failover test completed successfully in context: $CONTEXT"
echo "--------------------------------------------------------------------"
echo "App Failover script executed successfully in context: $CONTEXT"
echo "--------------------------------------------------------------------"
