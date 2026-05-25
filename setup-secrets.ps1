# Setup GitHub Secrets for Claude Code Templates
# This script helps you configure all required secrets for the workflows

Write-Host "=== Claude Code Templates - Secrets Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if gh CLI is installed
try {
    $null = gh --version
} catch {
    Write-Host "Error: GitHub CLI (gh) is not installed." -ForegroundColor Red
    Write-Host "Please install it from: https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}

# Check if authenticated
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Not authenticated with GitHub CLI." -ForegroundColor Red
    Write-Host "Please run: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host "This script will help you set up the required secrets for GitHub Actions workflows." -ForegroundColor Green
Write-Host ""
Write-Host "You can skip any secret by pressing Enter without typing a value." -ForegroundColor Yellow
Write-Host ""

# Function to set a secret
function Set-GitHubSecret {
    param(
        [string]$SecretName,
        [string]$Description
    )
    
    Write-Host "Setting: $SecretName" -ForegroundColor Cyan
    Write-Host "  $Description" -ForegroundColor Gray
    $value = Read-Host "  Enter value (or press Enter to skip)"
    
    if ($value) {
        $value | gh secret set $SecretName
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ $SecretName set successfully" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Failed to set $SecretName" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⊘ Skipped" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Discord Webhooks
Write-Host "=== Discord Webhook URLs ===" -ForegroundColor Magenta
Write-Host "Create webhooks in your Discord server settings → Integrations → Webhooks" -ForegroundColor Gray
Write-Host ""

Set-GitHubSecret "DISCORD_WEBHOOK_URL_GENERAL" "For daily general engagement questions"
Set-GitHubSecret "DISCORD_WEBHOOK_URL_BLOG" "For daily blog article posts"
Set-GitHubSecret "DISCORD_WEBHOOK_URL_COMMUNITY_HELP" "For community help posts"
Set-GitHubSecret "DISCORD_WEBHOOK_URL_DAILY" "For daily component picks"
Set-GitHubSecret "DISCORD_WEBHOOK_URL" "For release notifications"

# Vercel
Write-Host "=== Vercel Deployment ===" -ForegroundColor Magenta
Write-Host "Get these from: https://vercel.com/account/tokens" -ForegroundColor Gray
Write-Host ""

Set-GitHubSecret "VERCEL_TOKEN" "Vercel deployment token"
Set-GitHubSecret "VERCEL_ORG_ID" "Vercel organization ID (found in project settings)"
Set-GitHubSecret "VERCEL_DASHBOARD_PROJECT_ID" "Vercel project ID (found in project settings)"

# Supabase
Write-Host "=== Supabase Database ===" -ForegroundColor Magenta
Write-Host "Get these from: https://app.supabase.com/project/_/settings/api" -ForegroundColor Gray
Write-Host ""

Set-GitHubSecret "SUPABASE_URL" "Supabase project URL"
Set-GitHubSecret "SUPABASE_API_KEY" "Supabase API key (anon/public key)"

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "To view configured secrets, run: gh secret list" -ForegroundColor Cyan
Write-Host "To disable workflows you don't need, go to: Actions → Select workflow → ... → Disable workflow" -ForegroundColor Cyan
Write-Host ""
