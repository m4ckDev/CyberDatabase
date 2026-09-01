PHASE 1: INITIAL RECONNAISSANCE & SCOPE MAPPING

echo "=== CRYPTO.COM BUG BOUNTY - INITIAL RECON ==="
echo "Target: Crypto.com (Extreme Tier up to $1,000,000)"
echo "Scope: *.crypto.com, web.crypto.com, exchange, mobile APIs, smart contracts"
echo "Priority: Focus on Extreme Tier eligible assets first"

# Create workspace
mkdir -p /root/crypto_bounty/{recon,vuln_scans,exploits,evidence}
cd /root/crypto_bounty

# Save scope information
cat > scope.md << 'EOF'
# CRYPTO.COM BUG BOUNTY SCOPE

## EXTREME TIER (Up to $1M)
1. https://crypto.com/exchange
2. Crypto.com mobile app APIs (BFF APIs)
3. Crypto.com Exchange APIs (BFF APIs)
4. app.mona.co

## CRITICAL ASSETS
1. travel.crypto.com
2. tickets.crypto.com
3. tax.crypto.com (Critical/High only)
4. js.crypto.com
5. https://crypto.com/nft (GraphQL DOS capped at $500)
6. experiences.crypto.com
7. developer.crypto.com
8. developer-platform-api.crypto.com
9. developer-api.crypto.com
10. https://crypto.com/price (Medium)

## WILDCARD DOMAINS
1. *.crypto.com
2. *.mona.co

## SMART CONTRACTS
1. https://explorer.cronos.org/token/0x2e53c5586e12a99d4CAE366E9Fc5C14fE9c6495d
2. https://etherscan.io/token/0xfe18ae03741a5b84e39c295ac9c856ed7991c38e (Up to $1M!)

## NOTES
- Extreme bounties: Loss > $1M or mass PII dump
- GraphQL DOS capped at specific amounts
- Need test accounts for APIs
- Focus on financial impact
EOF

echo "Scope saved to: /root/crypto_bounty/scope.md"