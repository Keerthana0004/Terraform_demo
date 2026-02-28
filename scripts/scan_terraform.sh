#!/bin/bash
# ============================================================================
# CloudScan - Terraform Security Scanner
# ============================================================================
# This script packages Terraform files and sends them to the CloudScan
# ML backend for security analysis.
#
# Usage: ./scripts/scan_terraform.sh [BACKEND_URL]
#
# The ML backend (to be implemented) will:
#   1. Build an infrastructure dependency graph from .tf files
#   2. Run RGCN model for node-level risk classification
#   3. Use LLM for remediation suggestions
# ============================================================================

set -euo pipefail

BACKEND_URL="${1:-http://localhost:8000/api/scan}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TMP_DIR=$(mktemp -d)

echo "🔍 CloudScan Terraform Security Scanner"
echo "========================================="
echo ""

# Step 1: Collect .tf files
echo "📂 Collecting Terraform files..."
TF_FILES=$(find "$PROJECT_DIR" -name "*.tf" -not -path "*/.terraform/*" -type f)
FILE_COUNT=$(echo "$TF_FILES" | wc -l)

if [ -z "$TF_FILES" ]; then
    echo "❌ No .tf files found in $PROJECT_DIR"
    exit 1
fi

echo "   Found $FILE_COUNT Terraform files:"
echo "$TF_FILES" | while read -r f; do echo "   → $(basename "$f")"; done
echo ""

# Step 2: Package files
echo "📦 Creating scan package..."
PACKAGE_DIR="$TMP_DIR/terraform_files"
mkdir -p "$PACKAGE_DIR"
echo "$TF_FILES" | while read -r f; do cp "$f" "$PACKAGE_DIR/"; done
cd "$TMP_DIR" && zip -qr terraform_scan.zip terraform_files/
PACKAGE_SIZE=$(du -h "$TMP_DIR/terraform_scan.zip" | cut -f1)
echo "   Package: terraform_scan.zip ($PACKAGE_SIZE)"
echo ""

# Step 3: Send to ML backend
echo "🚀 Sending to CloudScan backend at $BACKEND_URL..."
echo ""
echo "   [PLACEHOLDER] In production, this will execute:"
echo "   curl -X POST $BACKEND_URL \\"
echo "     -F 'terraform_files=@$TMP_DIR/terraform_scan.zip' \\"
echo "     -H 'Content-Type: multipart/form-data'"
echo ""

# Placeholder: Simulate backend response
echo "📊 Simulated Analysis Results:"
echo "──────────────────────────────────────────────"
echo "  Resource                      Risk Level"
echo "──────────────────────────────────────────────"
echo "  aws_security_group.splunk-sg  🔴 HIGH"
echo "  aws_instance.ec2-demo        🟡 MEDIUM"
echo "  aws_vpc.splunk-vpc           🟢 LOW"
echo "  aws_subnet.public_subnet1   🟢 LOW"
echo "  aws_subnet.public_subnet2   🟢 LOW"
echo "  aws_subnet.private_subnet1  🟢 LOW"
echo "  aws_subnet.private_subnet2  🟢 LOW"
echo "  aws_internet_gateway.gtw1   🟢 LOW"
echo "  aws_route_table.rt1         🟢 LOW"
echo "  aws_s3_bucket.terraform_state 🟢 LOW"
echo "──────────────────────────────────────────────"
echo ""

# Cleanup
rm -rf "$TMP_DIR"

echo "✅ Scan complete. See results above."
