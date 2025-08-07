#!/bin/bash

# Script to declare the Death Mountain Renderer contract
# This script declares the main NFT contract

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Death Mountain Renderer Contract Declaration Process${NC}"

# Check if scarb is available
if ! command -v scarb &> /dev/null; then
    echo -e "${RED}❌ Error: scarb is not installed or not in PATH${NC}"
    exit 1
fi

# Check if sncast is available
if ! command -v sncast &> /dev/null; then
    echo -e "${RED}❌ Error: sncast is not installed or not in PATH${NC}"
    exit 1
fi

# Build the project first
echo -e "${YELLOW}📦 Building project...${NC}"
scarb build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful${NC}"

# Set network from environment variable or default to sepolia
STARKNET_NETWORK="${STARKNET_NETWORK:-sepolia}"

# Declare death_mountain_renderer contract
echo -e "${YELLOW}🎨 Declaring death_mountain_renderer contract...${NC}"
echo -e "${YELLOW}   RPC URL: https://api.cartridge.gg/x/starknet/sepolia${NC}"
echo -e "${YELLOW}   Timeout: 60 seconds${NC}"
NFT_RESULT=$(timeout 60s sncast --account renderer declare --url https://api.cartridge.gg/x/starknet/sepolia --contract-name death_mountain_renderer 2>&1)
NFT_EXIT_CODE=$?

if [ $NFT_EXIT_CODE -eq 0 ] && echo "$NFT_RESULT" | grep -q "class_hash:"; then
    # New declaration - extract from success output
    NFT_CLASS_HASH=$(echo "$NFT_RESULT" | grep "class_hash:" | cut -d' ' -f2)
    NFT_TX_HASH=$(echo "$NFT_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ death_mountain_renderer declared successfully${NC}"
    echo -e "   Class Hash: ${NFT_CLASS_HASH}"
    echo -e "   Transaction Hash: ${NFT_TX_HASH}"
elif echo "$NFT_RESULT" | grep -q "is already declared"; then
    # Contract already declared - extract class hash from error message
    echo -e "${YELLOW}⚠️ death_mountain_renderer contract is already declared${NC}"
    NFT_CLASS_HASH=$(echo "$NFT_RESULT" | grep -o "0x[a-fA-F0-9]\{64\}" | head -1)
    if [ -z "$NFT_CLASS_HASH" ]; then
        echo -e "${RED}❌ Failed to extract class hash from already declared contract${NC}"
        echo -e "${RED}Raw output: $NFT_RESULT${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Using existing class hash: ${NFT_CLASS_HASH}${NC}"
    NFT_TX_HASH="already_declared"
else
    echo -e "${RED}❌ Failed to declare death_mountain_renderer${NC}"
    echo -e "${RED}Exit code: $NFT_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$NFT_RESULT"
    
    # Check for timeout
    if [ $NFT_EXIT_CODE -eq 124 ]; then
        echo -e "${RED}❌ Declaration timed out after 60 seconds${NC}"
        echo -e "${YELLOW}💡 This usually indicates network connectivity issues${NC}"
        echo -e "${YELLOW}💡 Try checking your internet connection or using a different RPC URL${NC}"
    fi
    exit 1
fi

# Save class hash to file
echo -e "${YELLOW}💾 Saving class hash...${NC}"
cat > scripts/nft_contract_class_hash.txt << EOF
# Death Mountain Renderer Contract Class Hash
# Generated on $(date)

NFT_CLASS_HASH=${NFT_CLASS_HASH}
NFT_TX_HASH=${NFT_TX_HASH}
EOF

echo -e "${GREEN}📝 Class hash saved to scripts/nft_contract_class_hash.txt${NC}"

echo -e "${GREEN}🎉 Death Mountain Renderer contract declaration completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Deploy mock contract first: ./scripts/deploy_mock_contracts.sh"
echo -e "   2. Then deploy the Death Mountain Renderer contract: ./scripts/deploy_renderer_contract.sh"
echo -e "   3. Test the full deployment: ./scripts/test_contracts.sh"
echo ""
echo -e "${YELLOW}📋 Contract Details:${NC}"
echo -e "   Class Hash: ${NFT_CLASS_HASH}"
echo -e "   Transaction Hash: ${NFT_TX_HASH}"