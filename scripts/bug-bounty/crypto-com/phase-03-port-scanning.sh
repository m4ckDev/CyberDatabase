PHASE 3: PORT SCANNING & SERVICE DISCOVERY

echo -e "\n=== PORT SCANNING ==="

# Create targeted scan list
cat > targets.txt << 'EOF'
web.crypto.com
exchange.crypto.com
api.crypto.com
developer.crypto.com
developer-api.crypto.com
developer-platform-api.crypto.com
travel.crypto.com
tickets.crypto.com
tax.crypto.com
js.crypto.com
experiences.crypto.com
app.mona.co
EOF

echo "[*] Running nmap scans..."
# Quick scan for top ports
nmap -sV -sC -T4 -iL targets.txt -oA nmap_quick --max-retries 1 --min-rate 100

echo "[*] Full port scan on critical targets..."
# Full scan on exchange (Extreme tier)
nmap -p- -T4 -sV -sC exchange.crypto.com -oA nmap_exchange_full

echo "[*] Scanning for specific services..."
# Check for GraphQL (mentioned in scope)
nmap -p 3000,4000,8080,9000 -sV --script graphql-* developer.crypto.com developer-api.crypto.com -oA nmap_graphql

# Check results
echo -e "\n[*] Scan Summary:"
echo "Quick scan: nmap_quick.nmap"
echo "Exchange full: nmap_exchange_full.nmap"
echo "GraphQL: nmap_graphql.nmap"

grep -h "open " *.nmap 2>/dev/null | sort -u