# 🚀 Complete Discord Webhooks Setup

Your GitHub Actions workflows are configured but need Discord webhook URLs to function. This guide will help you set everything up in **5 minutes**.

## 🎯 What You'll Get

Once configured, your Discord server will automatically receive:
- 📢 **Daily engagement questions** (16:00 UTC) - Spark community discussions
- 📝 **Blog article highlights** (14:00 UTC) - Share knowledge
- 🆘 **Community help questions** (18:00 UTC) - Assist users
- 🧩 **Component showcases** (14:00 UTC) - Highlight useful templates
- 🎉 **Release notifications** - When new versions are published

## ⚡ Quick Start (Recommended)

### Step 1: Create Discord Webhook(s)

**Option A: Single Channel (Easiest)**
1. Open Discord → Go to your server
2. Right-click any channel → **Edit Channel**
3. Go to **Integrations** → **Webhooks** → **New Webhook**
4. Name it "Claude Code Bot" (or anything you like)
5. **Copy the Webhook URL** (looks like `https://discord.com/api/webhooks/...`)
6. Click **Save**

**Option B: Multiple Channels (Organized)**
Create separate channels for better organization:
- `#daily-engagement` → General discussions
- `#daily-blog` → Blog posts
- `#community-help` → Help questions
- `#daily-component` → Component picks
- `#releases` → Release notes

Create a webhook in each channel following the same steps above.

### Step 2: Run the Setup Script

Open PowerShell in this directory and run:

```powershell
.\quick-setup-webhooks.ps1
```

The script will:
- ✅ Check prerequisites
- ✅ Guide you through webhook configuration
- ✅ Set up all GitHub secrets
- ✅ Optionally test the workflows
- ✅ Confirm everything works

**That's it!** Your workflows are now fully functional.

## 🔧 Manual Setup (Alternative)

If you prefer to set up manually:

### Using GitHub CLI:

```powershell
# If using ONE webhook for everything:
$webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
$webhook | gh secret set DISCORD_WEBHOOK_URL_GENERAL
$webhook | gh secret set DISCORD_WEBHOOK_URL_BLOG
$webhook | gh secret set DISCORD_WEBHOOK_URL_COMMUNITY_HELP
$webhook | gh secret set DISCORD_WEBHOOK_URL_DAILY
$webhook | gh secret set DISCORD_WEBHOOK_URL
```

### Using GitHub Web UI:

1. Go to: https://github.com/Mishit18/claude-code-templates/settings/secrets/actions
2. Click **New repository secret**
3. Add each secret:
   - `DISCORD_WEBHOOK_URL_GENERAL`
   - `DISCORD_WEBHOOK_URL_BLOG`
   - `DISCORD_WEBHOOK_URL_COMMUNITY_HELP`
   - `DISCORD_WEBHOOK_URL_DAILY`
   - `DISCORD_WEBHOOK_URL`
4. Paste your webhook URL(s) as the value

## ✅ Testing

After setup, test the workflows:

```powershell
# Test all workflows
gh workflow run daily-general-discord.yml
gh workflow run daily-blog-discord.yml
gh workflow run daily-community-help-discord.yml
gh workflow run daily-component-discord.yml

# Check results
gh run list --limit 5
```

Check your Discord channel(s) - you should see messages appear within 10-20 seconds!

## 📅 Workflow Schedule

Once configured, workflows run automatically:

| Workflow | Time (UTC) | Purpose |
|----------|-----------|---------|
| Daily General Engagement | 16:00 | Community discussion questions |
| Daily Blog Share | 14:00 | Blog article highlights |
| Daily Community Help | 18:00 | Help & tutorial questions |
| Daily Component Pick | 14:00 | Component showcases |
| Release Notifications | On release | New version announcements |

## 🔍 Verification

Check if secrets are configured:

```powershell
gh secret list
```

You should see:
```
DISCORD_WEBHOOK_URL
DISCORD_WEBHOOK_URL_BLOG
DISCORD_WEBHOOK_URL_COMMUNITY_HELP
DISCORD_WEBHOOK_URL_DAILY
DISCORD_WEBHOOK_URL_GENERAL
```

## 🛠️ Troubleshooting

### "Secret is not configured" message
- Run: `gh secret list` to verify secrets exist
- Check secret names match exactly (case-sensitive)
- Wait 30 seconds for GitHub to propagate changes

### No Discord message appears
- Verify webhook URL is correct
- Check webhook wasn't deleted in Discord
- View workflow logs: `gh run view --log`
- Test webhook manually:
  ```powershell
  curl -X POST "YOUR_WEBHOOK_URL" -H "Content-Type: application/json" -d '{"content":"Test message"}'
  ```

### Need to update a webhook
```powershell
gh secret set DISCORD_WEBHOOK_URL_GENERAL
# Paste new URL when prompted
```

### Disable a workflow
```powershell
# Delete the workflow file
Remove-Item .github/workflows/daily-general-discord.yml

# Or disable via GitHub UI:
# Actions → Select workflow → ... → Disable workflow
```

## 📚 Additional Resources

- **COMPLETE_SETUP_GUIDE.md** - Detailed step-by-step instructions
- **SETUP_SECRETS.md** - All required secrets documentation
- **setup-secrets.ps1** - Interactive setup for all secrets (including Vercel, Supabase, etc.)

## 🎉 What's Next?

After setup:
1. ✅ Workflows run automatically on schedule
2. ✅ Discord receives engaging content daily
3. ✅ Community stays active and informed
4. ✅ No manual intervention needed

Enjoy your automated Discord engagement! 🚀

---

**Need help?** Open an issue or check the workflow logs with `gh run view --log`
