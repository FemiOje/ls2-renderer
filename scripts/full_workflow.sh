#!/bin/bash

# Complete workflow script for Death Mountain Renderer contracts
# This script runs the entire process from declaration to testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🚀 Death Mountain Renderer Complete Workflow${NC}"
echo -e "${PURPLE}=========================================${NC}"
echo ""

# Pre-flight checks
echo -e "${BLUE}🔍 Pre-flight checks...${NC}"

# Check if required tools are available
if ! command -v scarb &> /dev/null; then
    echo -e "${RED}❌ Error: scarb is not installed or not in PATH${NC}"
    echo -e "${YELLOW}💡 Install scarb from: https://docs.swmansion.com/scarb/download.html${NC}"
    exit 1
fi

if ! command -v sncast &> /dev/null; then
    echo -e "${RED}❌ Error: sncast is not installed or not in PATH${NC}"
    echo -e "${YELLOW}💡 Install Starknet Foundry from: https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html${NC}"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "Scarb.toml" ]; then
    echo -e "${RED}❌ Error: Scarb.toml not found${NC}"
    echo -e "${YELLOW}💡 Please run this script from the project root directory${NC}"
    exit 1
fi

# Use Cartridge RPC URL for Sepolia
RPC_URL="https://api.cartridge.gg/x/starknet/sepolia"

# Check if the account exists
if ! sncast account list 2>/dev/null | grep -q "renderer"; then
    echo -e "${RED}❌ Error: Account 'renderer' not found${NC}"
    echo -e "${YELLOW}💡 Available accounts:${NC}"
    sncast account list 2>/dev/null || echo -e "${RED}No accounts found${NC}"
    echo -e "${YELLOW}💡 Create an account with: sncast account create --name renderer${NC}"
    echo -e "${YELLOW}🔗 See docs: https://foundry-rs.github.io/starknet-foundry/cli/account.html${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Pre-flight checks passed${NC}"
echo ""

# Step 1: Declare mock contract
echo -e "${BLUE}📋 Step 1: Declaring mock contract...${NC}"
if [ -x "scripts/declare_mock_contracts.sh" ]; then
    ./scripts/declare_mock_contracts.sh
    DECLARE_EXIT_CODE=$?
    if [ $DECLARE_EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Mock contract declaration failed with exit code: $DECLARE_EXIT_CODE${NC}"
        echo -e "${YELLOW}💡 Possible issues:${NC}"
        echo -e "   - Account 'renderer' not found or not funded"
        echo -e "   - Network connection issues"
        echo -e "   - Contract compilation errors"
        echo -e "   - Insufficient balance for declaration fees"
        echo -e "${YELLOW}💡 Solutions:${NC}"
        echo -e "   - Check account: sncast account list"
        echo -e "   - Fund account if needed"
        echo -e "   - Run: scarb build to check for compilation errors"
        exit 1
    fi
else
    echo -e "${RED}❌ Mock contracts declaration script not found or not executable${NC}"
    echo -e "${YELLOW}💡 Expected file: scripts/declare_mock_contracts.sh${NC}"
    echo -e "${YELLOW}💡 Run: chmod +x scripts/declare_mock_contracts.sh${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Mock contract declared successfully${NC}"
echo ""

# Step 2: Deploy mock contract
echo -e "${BLUE}📋 Step 2: Deploying mock contract...${NC}"
if [ -x "scripts/deploy_mock_contracts.sh" ]; then
    ./scripts/deploy_mock_contracts.sh
    DEPLOY_EXIT_CODE=$?
    if [ $DEPLOY_EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Mock contract deployment failed with exit code: $DEPLOY_EXIT_CODE${NC}"
        echo -e "${YELLOW}💡 Possible issues:${NC}"
        echo -e "   - Missing class hashes file from declaration step"
        echo -e "   - Account 'renderer' not found or not funded"
        echo -e "   - Network connection issues"
        echo -e "   - Insufficient balance for deployment fees"
        echo -e "${YELLOW}💡 Solutions:${NC}"
        echo -e "   - Check if scripts/mock_contracts_class_hashes.txt exists"
        echo -e "   - Verify account balance and fund if needed"
        echo -e "   - Re-run declaration step if class hashes are missing"
        exit 1
    fi
else
    echo -e "${RED}❌ Mock contracts deployment script not found or not executable${NC}"
    echo -e "${YELLOW}💡 Expected file: scripts/deploy_mock_contracts.sh${NC}"
    echo -e "${YELLOW}💡 Run: chmod +x scripts/deploy_mock_contracts.sh${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Mock contract deployed successfully${NC}"
echo ""

# Step 3: Declare Death Mountain Renderer contract
echo -e "${BLUE}📋 Step 3: Declaring Death Mountain Renderer contract...${NC}"
if [ -x "scripts/declare_renderer_contract.sh" ]; then
    ./scripts/declare_renderer_contract.sh
    NFT_DECLARE_EXIT_CODE=$?
    if [ $NFT_DECLARE_EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Death Mountain Renderer contract declaration failed with exit code: $NFT_DECLARE_EXIT_CODE${NC}"
        echo -e "${YELLOW}💡 Possible issues:${NC}"
        echo -e "   - Account 'renderer' not found or not funded"
        echo -e "   - Network connection issues"
        echo -e "   - Contract compilation errors in death_mountain_renderer"
        echo -e "   - Insufficient balance for declaration fees"
        echo -e "${YELLOW}💡 Solutions:${NC}"
        echo -e "   - Check account: sncast account list"
        echo -e "   - Fund account if needed"
        echo -e "   - Run: scarb build to check for compilation errors"
        exit 1
    fi
else
    echo -e "${RED}❌ Renderer contract declaration script not found or not executable${NC}"
    echo -e "${YELLOW}💡 Expected file: scripts/declare_renderer_contract.sh${NC}"
    echo -e "${YELLOW}💡 Run: chmod +x scripts/declare_renderer_contract.sh${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Death Mountain Renderer contract declared successfully${NC}"
echo ""

# Step 4: Deploy Death Mountain Renderer contract
echo -e "${BLUE}📋 Step 4: Deploying Death Mountain Renderer contract...${NC}"
if [ -x "scripts/deploy_renderer_contract.sh" ]; then
    ./scripts/deploy_renderer_contract.sh
    NFT_DEPLOY_EXIT_CODE=$?
    if [ $NFT_DEPLOY_EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Death Mountain Renderer contract deployment failed with exit code: $NFT_DEPLOY_EXIT_CODE${NC}"
        echo -e "${YELLOW}💡 Possible issues:${NC}"
        echo -e "   - Missing required files from previous steps"
        echo -e "   - Account 'renderer' not found or not funded"
        echo -e "   - Network connection issues"
        echo -e "   - Invalid constructor arguments"
        echo -e "   - Insufficient balance for deployment fees"
        echo -e "${YELLOW}💡 Solutions:${NC}"
        echo -e "   - Check if scripts/nft_contract_class_hash.txt exists"
        echo -e "   - Check if scripts/mock_contracts_addresses.txt exists"
        echo -e "   - Verify account balance and fund if needed"
        echo -e "   - Verify mock contract addresses are valid"
        exit 1
    fi
else
    echo -e "${RED}❌ Renderer contract deployment script not found or not executable${NC}"
    echo -e "${YELLOW}💡 Expected file: scripts/deploy_renderer_contract.sh${NC}"
    echo -e "${YELLOW}💡 Run: chmod +x scripts/deploy_renderer_contract.sh${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Death Mountain Renderer contract deployed successfully${NC}"
echo ""

# Step 5: Test all contracts
echo -e "${BLUE}📋 Step 5: Testing all contracts...${NC}"
if [ -x "scripts/test_contracts.sh" ]; then
    ./scripts/test_contracts.sh
    TEST_EXIT_CODE=$?
    if [ $TEST_EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Contract testing failed with exit code: $TEST_EXIT_CODE${NC}"
        echo -e "${YELLOW}💡 Possible issues:${NC}"
        echo -e "   - Contracts not properly deployed"
        echo -e "   - Network connection issues"
        echo -e "   - Contract interaction failures"
        echo -e "   - Missing deployment addresses file"
        echo -e "${YELLOW}💡 Solutions:${NC}"
        echo -e "   - Check if scripts/full_deployment_addresses.txt exists"
        echo -e "   - Verify all contract addresses are valid"
        echo -e "   - Check network connectivity"
        echo -e "   - Review contract test logic"
        exit 1
    fi
else
    echo -e "${RED}❌ Contract testing script not found or not executable${NC}"
    echo -e "${YELLOW}💡 Expected file: scripts/test_contracts.sh${NC}"
    echo -e "${YELLOW}💡 Run: chmod +x scripts/test_contracts.sh${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ All contracts tested successfully${NC}"
echo ""


# Final summary
echo -e "${PURPLE}🎉 COMPLETE WORKFLOW FINISHED!${NC}"
echo -e "${PURPLE}==============================${NC}"
echo ""

if [ -f "scripts/full_deployment_addresses.txt" ]; then
    source scripts/full_deployment_addresses.txt
    echo -e "${YELLOW}📋 Deployment Summary:${NC}"
    echo -e "   Renderer Contract: ${NFT_ADDRESS}"
    echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
    echo ""
else
    echo -e "${RED}❌ Error: scripts/full_deployment_addresses.txt not found. Cannot print deployment summary.${NC}"
    echo -e "${YELLOW}💡 Ensure all deployment steps completed successfully.${NC}"
fi

echo -e "${YELLOW}💡 What you can do now:${NC}"
echo -e "   1. Query renderer data: ./scripts/query_renderer.sh [token_id]"
echo -e "   2. Test specific functions: ./scripts/test_contracts.sh"
echo -e "   3. Run unit tests: scarb test"
echo ""

echo -e "${GREEN}🎊 Your Death Mountain Renderer contracts are now fully deployed and tested!${NC}"