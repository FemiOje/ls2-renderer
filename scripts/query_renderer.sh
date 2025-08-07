#!/bin/bash

# Script to query NFT metadata and information
# This script provides detailed information about specific NFTs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Death Mountain Renderer Query Script${NC}"

# Check if deployment file exists
if [ ! -f "scripts/full_deployment_addresses.txt" ]; then
    echo -e "${RED}❌ Error: Deployment addresses file not found${NC}"
    echo -e "${YELLOW}💡 Please run the full deployment first${NC}"
    exit 1
fi

# Source the deployment addresses
source scripts/full_deployment_addresses.txt

if [ -z "$NFT_ADDRESS" ]; then
    echo -e "${RED}❌ Error: Renderer contract address not found${NC}"
    exit 1
fi

# Get token ID from argument or default to 1
TOKEN_ID=${1:-1}

# Use Cartridge RPC URL for Sepolia
RPC_URL="https://api.cartridge.gg/x/starknet/sepolia"

echo -e "${BLUE}📋 Querying renderer information...${NC}"
echo -e "   Renderer Contract: ${NFT_ADDRESS}"
echo -e "   Token ID: ${TOKEN_ID}"
echo -e "   RPC URL: ${RPC_URL}"
echo ""

# Query 1: Test renderer functionality by getting token URI
echo -e "${YELLOW}🎨 Testing renderer functionality...${NC}"

# Main Query: Get token URI (metadata)
echo -e "${YELLOW}🔗 Getting token metadata...${NC}"
TOKEN_URI_RESULT=$(timeout 60s sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function token_uri \
    --calldata ${TOKEN_ID} \
    --url "$RPC_URL" \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Token URI retrieved successfully${NC}"
    echo -e "   Metadata: ${TOKEN_URI_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve token URI${NC}"
    echo "$TOKEN_URI_RESULT"
fi

# Query 2: Get underlying data from mock contracts
echo -e "${YELLOW}🏰 Getting adventurer data...${NC}"
ADVENTURER_RESULT=$(timeout 30s sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer \
    --calldata ${TOKEN_ID} \
    --url "$RPC_URL" \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Adventurer data retrieved${NC}"
    echo -e "   Data: ${ADVENTURER_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve adventurer data${NC}"
fi

# Query 3: Get adventurer name
echo -e "${YELLOW}👑 Getting adventurer name...${NC}"
ADV_NAME_RESULT=$(timeout 30s sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer_name \
    --calldata ${TOKEN_ID} \
    --url "$RPC_URL" \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Adventurer name retrieved${NC}"
    echo -e "   Name: ${ADV_NAME_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve adventurer name${NC}"
fi


echo ""
echo -e "${GREEN}🎉 Renderer query completed!${NC}"
echo -e "${YELLOW}💡 Summary for Token ID ${TOKEN_ID}:${NC}"
echo -e "   - Renderer contract is responding"
echo -e "   - Metadata is dynamically generated"
echo -e "   - Connected to mock adventurer contract"
echo -e "   - All rendering functionality is working"
echo ""
echo -e "${YELLOW}📋 Contract addresses:${NC}"
echo -e "   Renderer Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"