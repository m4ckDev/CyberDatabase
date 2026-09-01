PHASE 6: API DISCOVERY & TESTING

echo -e "\n=== API DISCOVERY ==="

# Look for API documentation
cat > find_apis.py << 'EOF'
#!/usr/bin/env python3
import requests
import re

targets = [
    "https://developer.crypto.com",
    "https://developer-api.crypto.com",
    "https://developer-platform-api.crypto.com"
]

api_patterns = [
    r'/api/v[0-9]',
    r'/v[0-9]/api',
    r'/rest/',
    r'/graphql',
    r'/swagger',
    r'/openapi',
    r'/api-docs',
    r'/docs',
    r'/redoc',
    r'/rapidoc'
]

print("[*] Hunting for API endpoints...")

for target in targets:
    print(f"\n[*] Checking {target}")
    
    try:
        resp = requests.get(target, timeout=10, verify=False)
        
        if resp.status_code == 200:
            # Look for API references in page
            for pattern in api_patterns:
                matches = re.findall(pattern, resp.text, re.IGNORECASE)
                if matches:
                    print(f"  [!] Found API reference: {pattern}")
                    
                    # Try to access common API paths
                    for match in set(matches)[:3]:
                        api_url = target.rstrip('/') + match
                        
                        # Check if accessible
                        api_resp = requests.get(api_url, timeout=5, verify=False)
                        if api_resp.status_code < 400:
                            print(f"  [+] Accessible: {api_url} ({api_resp.status_code})")
        
        # Also check robots.txt and sitemap
        for path in ['/robots.txt', '/sitemap.xml', '/sitemap_index.xml']:
            robots_url = target.rstrip('/') + path
            robots_resp = requests.get(robots_url, timeout=5, verify=False)
            
            if robots_resp.status_code == 200:
                print(f"  [+] Found {path}")
                
                # Extract potential API paths
                lines = robots_resp.text.split('\n')
                for line in lines:
                    if any(api_indicator in line.lower() for api_indicator in ['api', 'graphql', 'rest', 'v1', 'v2']):
                        print(f"    -> {line.strip()}")
    
    except Exception as e:
        print(f"  [-] Error: {e}")
        continue
EOF

python3 find_apis.py

# Check for mobile API endpoints
echo -e "\n[*] Looking for mobile APIs..."
cat > mobile_api_finder.py << 'EOF'
#!/usr/bin/env python3
import requests
import re
import json

# Common mobile API patterns
mobile_patterns = [
    r'/mobile/api',
    r'/app/api',
    r'/bff/',  # Backend For Frontend
    r'/client-api',
    r'/user-api',
    r'/account-api',
    r'/wallet-api',
    r'/transaction-api',
    r'/payment-api',
    r'/kyc-api'  # Know Your Customer
]

targets = [
    "https://web.crypto.com",
    "https://exchange.crypto.com",
    "https://app.mona.co"
]

print("[*] Searching for mobile/BFF APIs...")

for target in targets:
    print(f"\n[*] {target}")
    
    try:
        # Get main page
        resp = requests.get(target, timeout=10, verify=False)
        
        # Look for JavaScript files that might contain API calls
        js_pattern = r'src="([^"]+\.js)"'
        js_files = re.findall(js_pattern, resp.text)
        
        for js_file in js_files[:5]:  # Check first 5 JS files
            if js_file.startswith('/'):
                js_url = target.rstrip('/') + js_file
            elif js_file.startswith('http'):
                js_url = js_file
            else:
                js_url = target.rstrip('/') + '/' + js_file
            
            try:
                js_resp = requests.get(js_url, timeout=5, verify=False)
                
                if js_resp.status_code == 200:
                    # Search for API endpoints in JS
                    for pattern in mobile_patterns:
                        if re.search(pattern, js_resp.text, re.IGNORECASE):
                            print(f"  [!] Found in {js_file}: {pattern}")
                            
                            # Extract specific endpoint
                            endpoint_match = re.search(r'["\'](/[^"\']+' + pattern[1:] + r'[^"\']*)["\']', js_resp.text)
                            if endpoint_match:
                                endpoint = endpoint_match.group(1)
                                print(f"      Endpoint: {endpoint}")
            
            except:
                continue
        
        # Also check source code for API calls
        api_calls = re.findall(r'fetch\(["\']([^"\']+)["\']', resp.text) + \
                    re.findall(r'axios\.get\(["\']([^"\']+)["\']', resp.text) + \
                    re.findall(r'\.ajax\([^)]*url["\']?:["\']([^"\']+)["\']', resp.text)
        
        for api_call in set(api_calls)[:10]:
            if any(pattern in api_call for pattern in ['/api', '/v1', '/v2', '/graphql']):
                print(f"  [?] API call found: {api_call}")
    
    except Exception as e:
        print(f"  [-] Error: {e}")
EOF

python3 mobile_api_finder.py