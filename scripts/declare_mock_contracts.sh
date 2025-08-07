#!/bin/bash

# Script to declare mock contracts for LS2 Renderer
# This script declares the mock adventurer contract

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Mock Contract Declaration Process${NC}"

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

# Declare mock_adventurer contract
echo -e "${YELLOW}🏰 Declaring mock_adventurer contract...${NC}"
echo -e "${YELLOW}   RPC URL: https://api.cartridge.gg/x/starknet/sepolia${NC}"
echo -e "${YELLOW}   Timeout: 60 seconds${NC}"
MOCK_ADVENTURER_RESULT=$(timeout 60s sncast --account renderer declare --url https://api.cartridge.gg/x/starknet/sepolia --contract-name mock_adventurer 2>&1)
MOCK_ADVENTURER_EXIT_CODE=$?

if [ $MOCK_ADVENTURER_EXIT_CODE -eq 0 ] && echo "$MOCK_ADVENTURER_RESULT" | grep -q "class_hash:"; then
    # New declaration - extract from success output
    MOCK_ADVENTURER_CLASS_HASH=$(echo "$MOCK_ADVENTURER_RESULT" | grep "class_hash:" | cut -d' ' -f2)
    MOCK_ADVENTURER_TX_HASH=$(echo "$MOCK_ADVENTURER_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_adventurer declared successfully${NC}"
    echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
    echo -e "   Transaction Hash: ${MOCK_ADVENTURER_TX_HASH}"
elif echo "$MOCK_ADVENTURER_RESULT" | grep -q "is already declared"; then
    # Contract already declared - extract class hash from error message
    echo -e "${YELLOW}⚠️ mock_adventurer contract is already declared${NC}"
    MOCK_ADVENTURER_CLASS_HASH=$(echo "$MOCK_ADVENTURER_RESULT" | grep -o "0x[a-fA-F0-9]\{64\}" | head -1)
    if [ -z "$MOCK_ADVENTURER_CLASS_HASH" ]; then
        echo -e "${RED}❌ Failed to extract class hash from already declared contract${NC}"
        echo -e "${RED}Raw output: $MOCK_ADVENTURER_RESULT${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Using existing class hash: ${MOCK_ADVENTURER_CLASS_HASH}${NC}"
    MOCK_ADVENTURER_TX_HASH="already_declared"
else
    echo -e "${RED}❌ Failed to declare mock_adventurer${NC}"
    echo -e "${RED}Exit code: $MOCK_ADVENTURER_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$MOCK_ADVENTURER_RESULT"
    
    # Check for timeout
    if [ $MOCK_ADVENTURER_EXIT_CODE -eq 124 ]; then
        echo -e "${RED}❌ Declaration timed out after 60 seconds${NC}"
        echo -e "${YELLOW}💡 This usually indicates network connectivity issues${NC}"
        echo -e "${YELLOW}💡 Try checking your internet connection or using a different network${NC}"
    fi
    exit 1
fi


# Save class hash to file for deployment
if [ ! -d scripts ]; then
    mkdir -p scripts
fi
if [ -e scripts/mock_contracts_class_hashes.txt ]; then
    echo -e "${YELLOW}⚠️ Warning: scripts/mock_contracts_class_hashes.txt already exists and will be overwritten.${NC}"
fi
cat > scripts/mock_contracts_class_hashes.txt << EOF
# Mock Contract Class Hash
# Generated on $(date)

MOCK_ADVENTURER_CLASS_HASH=${MOCK_ADVENTURER_CLASS_HASH}

# Transaction Hash
MOCK_ADVENTURER_TX_HASH=${MOCK_ADVENTURER_TX_HASH}
EOF

echo -e "${GREEN}📝 Class hash saved to scripts/mock_contracts_class_hashes.txt${NC}"

echo -e "${GREEN}🎉 Mock contract declaration completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Deploy the contract using: ./scripts/deploy_mock_contracts.sh"
echo -e "   2. Or declare the NFT contract: ./scripts/declare_renderer_contract.sh"