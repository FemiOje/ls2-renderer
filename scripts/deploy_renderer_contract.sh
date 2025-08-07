#!/bin/bash

# Script to deploy the Death Mountain Renderer contract
# This script deploys the main NFT contract with proper constructor arguments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Death Mountain Renderer Contract Deployment Process${NC}"

# Check if required files exist
if [ ! -f "scripts/nft_contract_class_hash.txt" ]; then
    echo -e "${RED}❌ Error: Death Mountain Renderer contract class hash file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/declare_renderer_contract.sh first${NC}"
    exit 1
fi

if [ ! -f "scripts/mock_contracts_addresses.txt" ]; then
    echo -e "${RED}❌ Error: Mock contract address file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/deploy_mock_contracts.sh first${NC}"
    exit 1
fi

# Source the files
source scripts/nft_contract_class_hash.txt
source scripts/mock_contracts_addresses.txt

if [ -z "$NFT_CLASS_HASH" ]; then
    echo -e "${RED}❌ Error: Death Mountain Renderer class hash not found${NC}"
    exit 1
fi

if [ -z "$MOCK_ADVENTURER_ADDRESS" ]; then
    echo -e "${RED}❌ Error: Mock adventurer contract address not found${NC}"
    exit 1
fi

# Check if Death Mountain Renderer contract is already deployed
if [ -f "scripts/full_deployment_addresses.txt" ]; then
    source scripts/full_deployment_addresses.txt
    if [ -n "$NFT_ADDRESS" ]; then
        echo -e "${YELLOW}⚠️ Death Mountain Renderer contract appears to be already deployed${NC}"
        echo -e "${YELLOW}   Death Mountain Renderer Contract: ${NFT_ADDRESS}${NC}"
        echo -e "${YELLOW}💡 Skipping deployment. If you want to redeploy, delete scripts/full_deployment_addresses.txt${NC}"
        
        echo -e "${GREEN}🎉 Complete deployment successful (using existing)!${NC}"
        echo -e "${YELLOW}💡 Next steps:${NC}"
        echo -e "   1. Test the contracts: ./scripts/test_contracts.sh"
        echo -e "   2. Query renderer metadata: ./scripts/query_renderer.sh"
        echo ""
        echo -e "${YELLOW}📋 Deployment Summary:${NC}"
        echo -e "   Death Mountain Renderer Contract: ${NFT_ADDRESS}"
        echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
        exit 0
    fi
fi

# Death Mountain Renderer Constructor Arguments
# The death_mountain_renderer contract requires:
# - adventurer_contract: ContractAddress (only adventurer contract)

echo -e "${YELLOW}🎨 Preparing Death Mountain Renderer contract deployment...${NC}"
echo -e "   Class Hash: ${NFT_CLASS_HASH}"
echo -e "   Mock Adventurer Address: ${MOCK_ADVENTURER_ADDRESS}"

# Use Cartridge RPC URL for Sepolia
RPC_URL="https://api.cartridge.gg/x/starknet/sepolia"

# Generate unique salt for deployment
NFT_SALT=$(date +%s)$(shuf -i 1000-9999 -n 1)

# Deploy the Death Mountain Renderer contract with constructor arguments
echo -e "${YELLOW}🚀 Deploying Death Mountain Renderer contract...${NC}"
echo -e "   Salt: ${NFT_SALT}"
echo -e "   RPC URL: ${RPC_URL}"
echo -e "   Timeout: 120 seconds"

# Deploy command with constructor arguments (only adventurer contract address)
NFT_DEPLOY_RESULT=$(timeout 120s sncast --account renderer --wait deploy \
    --url "$RPC_URL" \
    --class-hash ${NFT_CLASS_HASH} \
    --salt ${NFT_SALT} \
    --constructor-calldata \
    ${MOCK_ADVENTURER_ADDRESS} \
    2>&1)
NFT_DEPLOY_EXIT_CODE=$?

if [ $NFT_DEPLOY_EXIT_CODE -eq 0 ] && echo "$NFT_DEPLOY_RESULT" | grep -q "contract_address:"; then
    # Successful deployment
    NFT_ADDRESS=$(echo "$NFT_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    NFT_DEPLOY_TX=$(echo "$NFT_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ Death Mountain Renderer contract deployed successfully${NC}"
    echo -e "   Contract Address: ${NFT_ADDRESS}"
    echo -e "   Transaction Hash: ${NFT_DEPLOY_TX}"
else
    echo -e "${RED}❌ Failed to deploy Death Mountain Renderer contract${NC}"
    echo -e "${RED}Exit code: $NFT_DEPLOY_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$NFT_DEPLOY_RESULT"
    
    # Check for timeout
    if [ $NFT_DEPLOY_EXIT_CODE -eq 124 ]; then
        echo -e "${RED}❌ Deployment timed out after 120 seconds${NC}"
        echo -e "${YELLOW}💡 This usually indicates network connectivity issues${NC}"
        echo -e "${YELLOW}💡 Try checking your internet connection or using a different RPC URL${NC}"
    fi
    
    # Provide helpful debugging information
    echo -e "${YELLOW}💡 Debugging information:${NC}"
    echo -e "   Account: renderer"
    echo -e "   Class Hash: ${NFT_CLASS_HASH}"
    echo -e "   Salt: ${NFT_SALT}"
    echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
    echo -e "   RPC URL: ${RPC_URL}"
    echo -e "   Constructor Arguments:"
    echo -e "     - Adventurer Contract: ${MOCK_ADVENTURER_ADDRESS}"
    
    # Check if account exists and has sufficient balance
    if sncast account list | grep -q "renderer"; then
        echo -e "${GREEN}✅ Account 'renderer' exists${NC}"
    else
        echo -e "${RED}❌ Account 'renderer' not found${NC}"
        echo -e "${YELLOW}Available accounts:${NC}"
        sncast account list
    fi
    
    exit 1
fi

# Save deployment information
echo -e "${YELLOW}💾 Saving deployment information...${NC}"
cat > scripts/full_deployment_addresses.txt << EOF
# Full Death Mountain Renderer Deployment Addresses
# Generated on $(date)

# Death Mountain Renderer Contract
NFT_ADDRESS=${NFT_ADDRESS}
NFT_CLASS_HASH=${NFT_CLASS_HASH}
NFT_DEPLOY_TX=${NFT_DEPLOY_TX}
NFT_SALT=${NFT_SALT}

# Mock Contract
MOCK_ADVENTURER_ADDRESS=${MOCK_ADVENTURER_ADDRESS}

# Constructor Arguments Used
ADVENTURER_CONTRACT_ADDRESS=${MOCK_ADVENTURER_ADDRESS}
EOF

echo -e "${GREEN}📝 Deployment information saved to scripts/full_deployment_addresses.txt${NC}"

echo -e "${GREEN}🎉 Complete deployment successful!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Test the contracts: ./scripts/test_contracts.sh"
echo -e "   2. Query renderer metadata: ./scripts/query_renderer.sh"
echo ""
echo -e "${YELLOW}📋 Deployment Summary:${NC}"
echo -e "   Death Mountain Renderer Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"