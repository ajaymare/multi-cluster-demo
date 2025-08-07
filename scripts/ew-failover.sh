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

# Check Status of Details deployment on cluster
echo "Checking status of details deployments in $CONTEXT..."
kubectl --context="$CONTEXT" get deployment/details-v1 -n bookinfo || {
  echo "Details deployment not found in context $CONTEXT. Exiting..."
  exit 1
}
echo "✅ details deployment found in context $CONTEXT."
echo "Performing eastwest Failover in context: $CONTEXT"
kubectl --context="$CONTEXT" scale deploy details-v1 -n bookinfo --replicas=0 || {
  echo "❌ Failed to scale down Gateway deployment in context $CONTEXT."
  exit 1
}
echo "✅ Details deployment scaled down to 0 replicas in context $CONTEXT."
sleep 60
echo "Scaling up Details deployment in context: $CONTEXT"
# Scale up the Gateway deployment to 1 replica
kubectl --context="$CONTEXT" scale deploy details-v1 -n bookinfo --replicas=1 || {
  echo "❌ Failed to scale up Gateway deployment in context $CONTEXT."
  exit 1
}
sleep 10
echo "✅ Details deployment scaled up to 1 replica in context $CONTEXT."
echo "Checking status of Details deployments in $CONTEXT..."
kubectl --context="$CONTEXT" get deployment/details-v1 -n bookinfo || {
  echo "❌ Details deployment not found in context $CONTEXT after failover."
  exit 1
}
echo "✅ Details deployment found in context $CONTEXT after failover."
echo "East West Failover test completed successfully in context: $CONTEXT"
echo "--------------------------------------------------------------------"