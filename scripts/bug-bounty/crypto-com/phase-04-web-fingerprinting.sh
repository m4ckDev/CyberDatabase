PHASE2190: WEB APPLICATION FINGERPRINTING

echo -e "\n=== WEB TECHNOLOGY DETECTION ==="

# Install whatweb if missing
apt-get install -y whatweb

# Detect technologies on main targets
echo "[*] Fingerprinting main targets..."
for target in web.crypto.com exchange.crypto.com developer.crypto.com app.mona.co; do
    echo -e "\n[*] $target:"
    whatweb -a 3 $target | tee -a whatweb_results.txt
done

# Check for specific technologies mentioned in scope
echo -e "\n[*] Checking for GraphQL endpoints..."
cat > find_graphql.py << 'EOF'
#!/usr/bin/env python3
import requests
import json

targets = [
    "https://crypto.com/nft",
    "https://developer.crypto.com",
    "https://developer-api.crypto.com",
    "https://developer-platform-api.crypto.com"
]

graphql_indicators = [
    "/graphql",
    "/gql",
    "/query",
    "/graphql-api",
    "/api/graphql",
    "/v1/graphql",
    "/graphiql",
    "/playground",
    "/voyager",
    "/altair"
]

print("[*] Hunting for GraphQL endpoints...")

for target in targets:
    print(f"\n[*] Checking {target}")
    
    for endpoint in graphql_indicators:
        url = target.rstrip('/') + endpoint
        
        try:
            # Try GET request
            resp = requests.get(url, timeout=10, verify=False)
            
            if resp.status_code == 200:
                # Check for GraphQL indicators
                if any(indicator in resp.text.lower() for indicator in ['graphql', 'query', 'mutation', '__schema']):
                    print(f"  [!] Possible GraphQL: {url}")
                    
                    # Try POST with GraphQL query
                    if endpoint == '/graphql' or '/graphql' in url:
                        graphql_query = {"query": "query { __schema { types { name } } }"}
                        post_resp = requests.post(url, json=graphql_query, timeout=10, verify=False)
                        
                        if post_resp.status_code == 200:
                            data = post_resp.json()
                            if 'data' in data or 'errors' in data:
                                print(f"  [!!] CONFIRMED GraphQL endpoint: {url}")
            
            # Also check for common error pages
            if resp.status_code in [400, 405]:
                # Try POST instead
                graphql_query = {"query": "{__typename}"}
                post_resp = requests.post(url, json=graphql_query, timeout=10, verify=False)
                
                if post_resp.status_code == section 200:
                    try:
                        data = post_resp.json()
                        if 'data' in data or 'errors' in data:
                            print(f"  [!!] GraphQL endpoint (POST only): {url}")
                    except:
                        pass
        
        except Exception as e:
            continue
EOF

python3 find_graphql.py