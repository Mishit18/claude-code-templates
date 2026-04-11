#!/bin/bash

# sync-api.sh - Sync API files from /api to /docs/api
# This ensures serverless functions are deployed correctly with Vercel

set -e

echo "🔄 Syncing API files from /api to /docs/api..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if source files exist
if [ ! -f "api/track-download-supabase.js" ]; then
    echo "❌ Error: api/track-download-supabase.js not found"
    exit 1
fi

if [ ! -f "api/package.json" ]; then
    echo "❌ Error: api/package.json not found"
    exit 1
fi

# Create docs/api directory if it doesn't exist
mkdir -p docs/api

# Copy files
echo "${BLUE}📄 Copying track-download-supabase.js...${NC}"
cp api/track-download-supabase.js docs/api/
echo "${GREEN}✓ Copied track-download-supabase.js${NC}"

echo "${BLUE}📦 Copying package.json...${NC}"
cp api/package.json docs/api/
echo "${GREEN}✓ Copied package.json${NC}"

echo ""
echo "${GREEN}✅ Sync completed successfully!${NC}"
echo ""
echo "📁 Files synced to docs/api/:"
ls -lh docs/api/ | grep -E "(track-download-supabase.js|package.json)"

echo ""
echo "📝 Next steps:"
echo "  1. Review changes: git diff docs/api/"
echo "  2. Commit changes: git add docs/api/ && git commit -m 'Sync API files'"
echo "  3. Deploy to Vercel: vercel --prod"
echo ""

