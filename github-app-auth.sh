#!/bin/bash
set -e

# ========= CONFIG =========
APP_ID="1935395"                # e.g. 123456
INSTALLATION_ID="85380319"  # e.g. 987654
PEM_FILE="./githubtest.pem"   # path to your downloaded key
OWNER="jibint555" # repo owner
REPO="aws_cdk_projects"               # repo name
BRANCH="main"                       # branch to push
# ==========================

# 1. Generate JWT
now=$(date +%s)
iat=$((now - 60))
exp=$((now + 600)) # 10 min validity
header=$(echo -n '{"alg":"RS256","typ":"JWT"}' | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
payload=$(echo -n "{\"iat\":$iat,\"exp\":$exp,\"iss\":$APP_ID}" | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
unsigned_token="$header.$payload"
signature=$(echo -n "$unsigned_token" | openssl dgst -sha256 -sign "$PEM_FILE" | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
jwt="$unsigned_token.$signature"

# 2. Get Installation Access Token
access_token=$(curl -s -X POST \
  -H "Authorization: Bearer $jwt" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens" \
  | jq -r .token)

if [[ "$access_token" == "null" || -z "$access_token" ]]; then
  echo "❌ Failed to fetch access token"
  exit 1
fi

echo "✅ Got installation token"

# 3. Use token for git clone
echo "👉 Cloning repo..."
git clone "https://x-access-token:$access_token@github.com/$OWNER/$REPO.git"

cd "$REPO"

# 4. Example commit & push
echo "Hello from GitHub App at $(date)" >> app-test.txt
git add app-test.txt
git commit -m "GitHub App test commit"
git push origin "$BRANCH"

echo "✅ Commit pushed successfully!"
