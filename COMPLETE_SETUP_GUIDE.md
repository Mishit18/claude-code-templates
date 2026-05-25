# Complete Setup Guide - Discord Webhooks for GitHub Actions

## Overview
This guide will help you fully configure the Discord notification workflows so they actually send messages to your Discord server.

## Step 1: Create Discord Webhooks

You need to create 4-5 Discord webhooks in your Discord server:

### How to Create a Discord Webhook:

1. **Open Discord** and go to your server
2. **Right-click on a channel** where you want notifications (or create dedicated channels)
3. Click **Edit Channel** → **Integrations** → **Webhooks**
4. Click **New Webhook** or **Create Webhook**
5. **Name the webhook** (e.g., "Daily General Engagement")
6. **Copy the Webhook URL** (it looks like: `https://discord.com/api/webhooks/...`)
7. Click **Save**

### Recommended Channel Structure:

Create separate channels for better organization:
- `#daily-engagement` → for general discussion questions
- `#daily-blog` → for blog article posts
- `#community-help` → for help/tutorial questions
- `#daily-component` → for component showcases
- `#releases` → for release notifications

Or use a single channel for all notifications if you prefer.

### Required Webhooks:

1. **DISCORD_WEBHOOK_URL_GENERAL** - Daily general engagement questions
2. **DISCORD_WEBHOOK_URL_BLOG** - Daily blog article posts
3. **DISCORD_WEBHOOK_URL_COMMUNITY_HELP** - Community help questions
4. **DISCORD_WEBHOOK_URL_DAILY** - Daily component picks
5. **DISCORD_WEBHOOK_URL** - Release notifications

## Step 2: Add Secrets to GitHub

### Option A: Using GitHub CLI (Fastest)

Run this PowerShell script I created:

```powershell
.\setup-secrets.ps1
```

It will prompt you for each webhook URL interactively.

### Option B: Using GitHub CLI Manually

```powershell
# You'll be prompted to paste the webhook URL for each
gh secret set DISCORD_WEBHOOK_URL_GENERAL
gh secret set DISCORD_WEBHOOK_URL_BLOG
gh secret set DISCORD_WEBHOOK_URL_COMMUNITY_HELP
gh secret set DISCORD_WEBHOOK_URL_DAILY
gh secret set DISCORD_WEBHOOK_URL
```

### Option C: Using GitHub Web UI

1. Go to your repository: https://github.com/Mishit18/claude-code-templates
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. For each secret:
   - **Name:** `DISCORD_WEBHOOK_URL_GENERAL` (use exact names above)
   - **Value:** Paste your Discord webhook URL
   - Click **Add secret**
5. Repeat for all 5 webhook secrets

## Step 3: Test the Workflows

After adding the secrets, test each workflow:

```powershell
# Test each workflow manually
gh workflow run daily-general-discord.yml
gh workflow run daily-blog-discord.yml
gh workflow run daily-community-help-discord.yml
gh workflow run daily-component-discord.yml
```

Check your Discord channels - you should see messages appear!

## Step 4: Verify Scheduled Runs

The workflows run automatically on these schedules:
- **Daily General Engagement:** 16:00 UTC (4:00 PM UTC)
- **Daily Blog:** 14:00 UTC (2:00 PM UTC)
- **Daily Community Help:** 18:00 UTC (6:00 PM UTC)
- **Daily Component:** 14:00 UTC (2:00 PM UTC)

## Quick Setup Script

If you have all your webhook URLs ready, create a file called `setup-webhooks.ps1`:

```powershell
# Replace these with your actual webhook URLs
$webhooks = @{
    "DISCORD_WEBHOOK_URL_GENERAL" = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
    "DISCORD_WEBHOOK_URL_BLOG" = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
    "DISCORD_WEBHOOK_URL_COMMUNITY_HELP" = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
    "DISCORD_WEBHOOK_URL_DAILY" = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
    "DISCORD_WEBHOOK_URL" = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
}

foreach ($secret in $webhooks.GetEnumerator()) {
    Write-Host "Setting $($secret.Key)..." -ForegroundColor Cyan
    $secret.Value | gh secret set $secret.Key
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Success" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed" -ForegroundColor Red
    }
}

Write-Host "`nAll secrets configured! Testing workflows..." -ForegroundColor Green
gh workflow run daily-general-discord.yml
```

Then run:
```powershell
.\setup-webhooks.ps1
```

## Troubleshooting

### Workflow still shows "secret is not configured"
- Make sure the secret name matches exactly (case-sensitive)
- Verify the secret was added: `gh secret list`
- Wait a few seconds for GitHub to propagate the secret

### Discord message not appearing
- Check the webhook URL is correct
- Verify the webhook hasn't been deleted in Discord
- Check the workflow logs: `gh run view --log`

### Need to update a webhook URL
```powershell
gh secret set DISCORD_WEBHOOK_URL_GENERAL
# Paste the new URL when prompted
```

## What Happens After Setup

Once configured, your Discord server will receive:
- **Daily engagement questions** to spark community discussions
- **Blog article highlights** to share knowledge
- **Community help questions** to assist users
- **Component showcases** to highlight useful templates
- **Release notifications** when new versions are published

All automated and running on schedule! 🎉
