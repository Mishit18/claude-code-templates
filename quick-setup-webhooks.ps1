# Quick Setup - Discord Webhooks for GitHub Actions
# This script helps you configure all Discord webhook secrets at once

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║  Discord Webhooks Setup for Claude Code Templates           ║
║  This will configure all required secrets for workflows     ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check gh CLI
try {
    $null = gh --version
    Write-Host "✓ GitHub CLI installed" -ForegroundColor Green
} catch {
    Write-Host "✗ GitHub CLI not found" -ForegroundColor Red
    Write-Host "  Install from: https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}

# Check authentication
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Not authenticated with GitHub" -ForegroundColor Red
    Write-Host "  Run: gh auth login" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ GitHub CLI authenticated" -ForegroundColor Green

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check if user wants to proceed
Write-Host "This script will help you set up 5 Discord webhook secrets." -ForegroundColor White
Write-Host ""
Write-Host "Before continuing, make sure you have:" -ForegroundColor Yellow
Write-Host "  1. A Discord server where you're an admin" -ForegroundColor Gray
Write-Host "  2. Created webhook(s) in your Discord channels" -ForegroundColor Gray
Write-Host "  3. Copied the webhook URL(s)" -ForegroundColor Gray
Write-Host ""
Write-Host "Need help creating webhooks? See: COMPLETE_SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host ""

$continue = Read-Host "Ready to continue? (y/n)"
if ($continue -ne 'y' -and $continue -ne 'Y') {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Option to use same webhook for all
Write-Host "Quick Setup Options:" -ForegroundColor Magenta
Write-Host "  1. Use the SAME webhook URL for all notifications (easiest)" -ForegroundColor White
Write-Host "  2. Use DIFFERENT webhook URLs for each type (organized)" -ForegroundColor White
Write-Host ""
$option = Read-Host "Choose option (1 or 2)"

Write-Host ""

if ($option -eq "1") {
    # Single webhook for all
    Write-Host "Enter your Discord webhook URL:" -ForegroundColor Cyan
    Write-Host "(It should look like: https://discord.com/api/webhooks/...)" -ForegroundColor Gray
    $webhookUrl = Read-Host "Webhook URL"
    
    if ([string]::IsNullOrWhiteSpace($webhookUrl)) {
        Write-Host "✗ No webhook URL provided. Exiting." -ForegroundColor Red
        exit 1
    }
    
    if ($webhookUrl -notmatch '^https://discord\.com/api/webhooks/') {
        Write-Host "⚠ Warning: URL doesn't look like a Discord webhook" -ForegroundColor Yellow
        $confirm = Read-Host "Continue anyway? (y/n)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            exit 1
        }
    }
    
    Write-Host ""
    Write-Host "Setting all secrets to the same webhook URL..." -ForegroundColor Yellow
    Write-Host ""
    
    $secrets = @(
        "DISCORD_WEBHOOK_URL_GENERAL",
        "DISCORD_WEBHOOK_URL_BLOG",
        "DISCORD_WEBHOOK_URL_COMMUNITY_HELP",
        "DISCORD_WEBHOOK_URL_DAILY",
        "DISCORD_WEBHOOK_URL"
    )
    
    foreach ($secret in $secrets) {
        Write-Host "Setting $secret..." -ForegroundColor Cyan
        $webhookUrl | gh secret set $secret
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Success" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Failed" -ForegroundColor Red
        }
    }
    
} else {
    # Different webhooks
    Write-Host "You'll be prompted for each webhook URL." -ForegroundColor Yellow
    Write-Host "Press Enter to skip any you don't want to set up." -ForegroundColor Gray
    Write-Host ""
    
    $secretsConfig = @(
        @{
            Name = "DISCORD_WEBHOOK_URL_GENERAL"
            Description = "Daily general engagement questions"
            Workflow = "Runs at 16:00 UTC daily"
        },
        @{
            Name = "DISCORD_WEBHOOK_URL_BLOG"
            Description = "Daily blog article posts"
            Workflow = "Runs at 14:00 UTC daily"
        },
        @{
            Name = "DISCORD_WEBHOOK_URL_COMMUNITY_HELP"
            Description = "Community help questions"
            Workflow = "Runs at 18:00 UTC daily"
        },
        @{
            Name = "DISCORD_WEBHOOK_URL_DAILY"
            Description = "Daily component picks"
            Workflow = "Runs at 14:00 UTC daily"
        },
        @{
            Name = "DISCORD_WEBHOOK_URL"
            Description = "Release notifications"
            Workflow = "Runs when new releases are published"
        }
    )
    
    foreach ($config in $secretsConfig) {
        Write-Host "──────────────────────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host "Secret: $($config.Name)" -ForegroundColor Cyan
        Write-Host "  Purpose: $($config.Description)" -ForegroundColor Gray
        Write-Host "  Schedule: $($config.Workflow)" -ForegroundColor Gray
        $webhookUrl = Read-Host "  Webhook URL (or press Enter to skip)"
        
        if (![string]::IsNullOrWhiteSpace($webhookUrl)) {
            $webhookUrl | gh secret set $config.Name
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ $($config.Name) set successfully" -ForegroundColor Green
            } else {
                Write-Host "  ✗ Failed to set $($config.Name)" -ForegroundColor Red
            }
        } else {
            Write-Host "  ⊘ Skipped" -ForegroundColor Yellow
        }
        Write-Host ""
    }
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ Setup Complete!" -ForegroundColor Green
Write-Host ""

# Show configured secrets
Write-Host "Configured secrets:" -ForegroundColor Cyan
gh secret list

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Offer to test
$test = Read-Host "Would you like to test the workflows now? (y/n)"
if ($test -eq 'y' -or $test -eq 'Y') {
    Write-Host ""
    Write-Host "Triggering test runs..." -ForegroundColor Yellow
    Write-Host ""
    
    $workflows = @(
        "daily-general-discord.yml",
        "daily-blog-discord.yml",
        "daily-community-help-discord.yml",
        "daily-component-discord.yml"
    )
    
    foreach ($workflow in $workflows) {
        Write-Host "Running $workflow..." -ForegroundColor Cyan
        gh workflow run $workflow
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Triggered" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Failed to trigger" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "Check your Discord channels for messages!" -ForegroundColor Green
    Write-Host "View workflow runs: gh run list" -ForegroundColor Cyan
    Write-Host "Or visit: https://github.com/Mishit18/claude-code-templates/actions" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "All done! Your workflows are now configured. 🎉" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  • Check Discord for test messages" -ForegroundColor Gray
Write-Host "  • Workflows will run automatically on schedule" -ForegroundColor Gray
Write-Host "  • View logs: gh run view --log" -ForegroundColor Gray
Write-Host "  • Update secrets anytime: gh secret set SECRET_NAME" -ForegroundColor Gray
Write-Host ""
