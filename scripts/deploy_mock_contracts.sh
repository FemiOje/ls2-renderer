#!/bin/bash

# Script to deploy mock contract for LS2 Renderer
# This script deploys the mock adventurer contract using its class hash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Mock Contract Deployment Process${NC}"

# Check if class hash file exists
if [ ! -f "scripts/mock_contracts_class_hashes.txt" ]; then
    echo -e "${RED}❌ Error: Class hash file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/declare_mock_contracts.sh first${NC}"
    exit 1
fi

# Source the class hash
source scripts/mock_contracts_class_hashes.txt

if [ -z "$MOCK_ADVENTURER_CLASS_HASH" ]; then
    echo -e "${RED}❌ Error: Class hash not found in file${NC}"
    exit 1
fi

# Check if contract is already deployed
if [ -f "scripts/mock_contracts_addresses.txt" ]; then
    source scripts/mock_contracts_addresses.txt
    if [ -n "$MOCK_ADVENTURER_ADDRESS" ]; then
        echo -e "${YELLOW}⚠️ Mock contract appears to be already deployed${NC}"
        echo -e "${YELLOW}   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}${NC}"
        echo -e "${YELLOW}💡 Skipping deployment. If you want to redeploy, delete scripts/mock_contracts_addresses.txt${NC}"
        
        echo -e "${GREEN}🎉 Mock contract deployment completed (using existing)!${NC}"
        echo -e "${YELLOW}💡 Next steps:${NC}"
        echo -e "   1. Declare the NFT contract: ./scripts/declare_renderer_contract.sh"
        echo -e "   2. Deploy the NFT contract with this address as constructor argument"
        echo -e "   3. Test the contracts: ./scripts/test_contracts.sh"
        echo ""
        echo -e "${YELLOW}📋 Contract Address:${NC}"
        echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
        exit 0
    fi
fi

# Generate unique salt for deployment
ADVENTURER_SALT=$(date +%s)$(shuf -i 1000-9999 -n 1)

# Deploy mock_adventurer contract (no constructor arguments)
echo -e "${YELLOW}🏰 Deploying mock_adventurer contract...${NC}"
echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
echo -e "   Salt: ${ADVENTURER_SALT}"
echo -e "   RPC URL: https://api.cartridge.gg/x/starknet/sepolia"
echo -e "   Timeout: 120 seconds"

# Set network from environment variable or default to sepolia
STARKNET_NETWORK="${STARKNET_NETWORK:-sepolia}"

MOCK_ADVENTURER_DEPLOY_RESULT=$(timeout 120s sncast --account renderer --wait deploy --url https://api.cartridge.gg/x/starknet/sepolia --class-hash ${MOCK_ADVENTURER_CLASS_HASH} --salt ${ADVENTURER_SALT} 2>&1)
MOCK_ADVENTURER_DEPLOY_EXIT_CODE=$?

if [ $MOCK_ADVENTURER_DEPLOY_EXIT_CODE -eq 0 ]; then
    MOCK_ADVENTURER_ADDRESS=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    MOCK_ADVENTURER_DEPLOY_TX=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_adventurer deployed successfully${NC}"
    echo -e "   Contract Address: ${MOCK_ADVENTURER_ADDRESS}"
    echo -e "   Transaction Hash: ${MOCK_ADVENTURER_DEPLOY_TX}"
    
    # Transaction confirmed automatically due to --wait flag
    echo -e "${YELLOW}   Transaction confirmed, proceeding to next deployment...${NC}"
else
    echo -e "${RED}❌ Failed to deploy mock_adventurer${NC}"
    echo -e "${RED}Exit code: $MOCK_ADVENTURER_DEPLOY_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$MOCK_ADVENTURER_DEPLOY_RESULT"
    
    # Provide helpful debugging information
    echo -e "${YELLOW}💡 Debugging information:${NC}"
    echo -e "   Account: renderer"
    echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
    echo -e "   Salt: ${ADVENTURER_SALT}"
    echo -e "   Command: sncast --account renderer --wait deploy --url https://api.cartridge.gg/x/starknet/sepolia --class-hash ${MOCK_ADVENTURER_CLASS_HASH} --salt ${ADVENTURER_SALT}"
    
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


# Save deployment address to file
if [ ! -d scripts ]; then
    mkdir -p scripts
fi
if [ -e scripts/mock_contracts_addresses.txt ]; then
    echo -e "${YELLOW}⚠️ Warning: scripts/mock_contracts_addresses.txt already exists and will be overwritten.${NC}"
fi
cat > scripts/mock_contracts_addresses.txt << EOF
# Mock Contract Deployment Address
# Generated on $(date)

MOCK_ADVENTURER_ADDRESS=${MOCK_ADVENTURER_ADDRESS}

# Class Hash
MOCK_ADVENTURER_CLASS_HASH=${MOCK_ADVENTURER_CLASS_HASH}

# Deployment Salt
ADVENTURER_SALT=${ADVENTURER_SALT}

# Deployment Transaction Hash
MOCK_ADVENTURER_DEPLOY_TX=${MOCK_ADVENTURER_DEPLOY_TX}
EOF

echo -e "${GREEN}📝 Deployment address saved to scripts/mock_contracts_addresses.txt${NC}"

echo -e "${GREEN}🎉 Mock contract deployment completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Declare the NFT contract: ./scripts/declare_renderer_contract.sh"
echo -e "   2. Deploy the NFT contract with this address as constructor argument"
echo -e "   3. Test the contracts: ./scripts/test_contracts.sh"
echo ""
echo -e "${YELLOW}📋 Contract Address:${NC}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"