
# Define colors using ANSI escape codes
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

URL="https://bookinfo.tetrate.io"

# Load variables from .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi
# Define your kubeconfig contexts

CONTEXT=$CENTRALUS

while true; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    response=$(kubectl --context="$CONTEXT" exec deployment/sleep -n sleep -c sleep -- curl -s -H "X-B3-Sampled: 1" http://productpage.bookinfo:9080/productpage | grep -i details -A 8)
    echo ${GREEN}"$response"
    # Print timestamp, DNS lookup result, response code, and location header with color
    echo "Timestamp: ${YELLOW}$timestamp"${NC}

    sleep 2  # Sleep for 10 seconds before the next iteration
done