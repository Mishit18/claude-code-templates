# Required Secrets Setup

This repository requires several secrets to be configured for the GitHub Actions workflows to function properly.

## Discord Webhooks

The following Discord webhook secrets are required for the daily engagement workflows:

- `DISCORD_WEBHOOK_URL_GENERAL` - For daily general engagement questions
- `DISCORD_WEBHOOK_URL_BLOG` - For daily blog article posts
- `DISCORD_WEBHOOK_URL_COMMUNITY_HELP` - For community help posts
- `DISCORD_WEBHOOK_URL_DAILY` - For daily component picks
- `DISCORD_WEBHOOK_URL` - For release notifications

## Deployment Secrets

- `VERCEL_TOKEN` - Vercel deployment token
- `VERCEL_ORG_ID` - Vercel organization ID
- `VERCEL_DASHBOARD_PROJECT_ID` - Vercel project ID

## Database Secrets

- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_API_KEY` - Supabase API key

## How to Add Secrets

### Via GitHub UI (Recommended)

1. Go to your repository on GitHub
2. Click on **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Enter the secret name and value
5. Click **Add secret**

### Via GitHub CLI

```bash
# Add Discord webhook secrets
gh secret set DISCORD_WEBHOOK_URL_GENERAL
gh secret set DISCORD_WEBHOOK_URL_BLOG
gh secret set DISCORD_WEBHOOK_URL_COMMUNITY_HELP
gh secret set DISCORD_WEBHOOK_URL_DAILY
gh secret set DISCORD_WEBHOOK_URL

# Add Vercel secrets
gh secret set VERCEL_TOKEN
gh secret set VERCEL_ORG_ID
gh secret set VERCEL_DASHBOARD_PROJECT_ID

# Add Supabase secrets
gh secret set SUPABASE_URL
gh secret set SUPABASE_API_KEY
```

## Disabling Workflows

If you don't want to set up all the secrets, you can disable specific workflows:

1. Go to **Actions** tab in your repository
2. Click on the workflow you want to disable
3. Click the **...** menu → **Disable workflow**

Alternatively, you can delete or comment out the workflow files in `.github/workflows/`.
