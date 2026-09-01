PHASE 2: SUBDOMAIN ENUMERATION

echo -e "\n=== SUBDOMAIN ENUMERATION ==="

# Install subdomain tools if missing
apt-get install -y subfinder assetfinder amass dnsutils

# Primary subdomain discovery
echo "[*] Running subfinder..."
subfinder -d crypto.com -o subdomains_subfinder.txt -all

echo "[*] Running assetfinder..."
assetfinder --subs-only crypto.com | tee -a subdomains_assetfinder.txt

echo "[*] Running amass..."
amass enum -d crypto.com -o subdomains_amass.txt

# Combine and deduplicate
cat subdomains_*.txt | sort -u > all_subdomains.txt
echo "[+] Found $(wc -l < all_subdomains.txt) unique subdomains"

# Filter for in-scope subdomains
grep -E '(crypto\.com|mona\.co)$' all_subdomains.txt | \
    grep -vE '(out-of-scope|test|dev|stage|beta)' > inscope_subdomains.txt

echo "[+] In-scope subdomains:"
cat inscope_subdomains.txt

# Check for wildcard scope coverage
echo -e "\n[*] Checking *.crypto.com wildcard..."
while read sub; do
    if [[ $sub == *".crypto.com" ]]; then
        echo "✓ $sub (within *.crypto.com)"
    fi
done < inscope_subdomains.txt | head -20