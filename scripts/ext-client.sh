
# Define colors using ANSI escape codes
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

URL="https://bookinfo.tetrate.io"

while true; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    #dns_lookup=$(dig +short $URL)
    response=$(curl $URL/productpage -sS -I -k --resolve "bookinfo.tetrate.io:443:128.203.211.38")
    response_code=$(echo "$response" | awk 'NR==1 {print $2}')
    location_header=$(echo "$response" | awk '/^location:/ {match($0, /location:\s*(eastus|centralus)/); if(RSTART != 0) {print substr($0, RSTART+length("location:"), RLENGTH)}}')

    echo $location_header
    # Print timestamp, DNS lookup result, response code, and location header with color
    echo "Timestamp: ${YELLOW}$timestamp"${NC}
    #echo "DNS Lookup\n ${RED}$dns_lookup"${NC}
    echo "Response Code: ${RED}$response_code${NC}"
    
    if echo "$location_header" | grep -q "eastus"; then
        echo "Location Header: ${GREEN}$location_header${NC}"
    elif echo "$location_header" | grep -q "centralus"; then
        echo "Location Header: ${BLUE}$location_header${NC}"
    else
        echo "Location Header not found"
    fi

    sleep 2  # Sleep for 10 seconds before the next iteration
done