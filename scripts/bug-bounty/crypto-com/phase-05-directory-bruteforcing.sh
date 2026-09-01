PHASE 5: DIRECTORY BRUTE FORCING

echo -e "\n=== DIRECTORY BRUTE FORCING ==="

# Install gobuster if missing
apt-get install -y gobuster

echo "[*] Brute-forcing critical endpoints..."

# Target 1: Exchange (Extreme Tier)
echo -e "\n[*] exchange.crypto.com"
gobuster dir -u https://exchange.crypto.com -w /usr/share/seclists/Discovery/Web-Content/common.txt \
    -o gobuster_exchange.txt -t 50 -x php,json,asp,aspx,jsp,html,xml

# Target 2: Developer API (might have GraphQL)
echo -e "\n[*] developer-api.crypto.com"
gobuster dir -u https://developer-api.crypto.com -w /usr/share/seclists/Discovery/Web-Content/common.txt \
    -o gobuster_devapi.txt -t 50 -x graphql,gql,json

# Target 3: Web portal
echo -e "\n[*] web.crypto.com"
gobuster dir -u https://web.crypto.com -w /usr/share/seclists/Discovery/Web-Content/common.txt \
    -o gobuster_web.txt -t53 50

# Target 4: NFT endpoint (GraphQL mentioned)
echo -e "\n[*] crypto.com/nft"
gobuster dir -u https://crypto.com/nft -w /usr/share/seclists/Discovery/Web-Content/GraphQL.txt \
    -o gobuster_nft.txt -t 50

echo "[*] Checking for interesting findings..."
grep -E "(admin|api|graphql|backup|config|test|dev|staging)" gobuster_*.txt | head -20