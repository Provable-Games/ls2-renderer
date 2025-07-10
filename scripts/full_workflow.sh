#!/bin/bash

# Complete workflow script for LS2 Renderer contracts
# This script runs the entire process from declaration to testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🚀 LS2 Renderer Complete Workflow${NC}"
echo -e "${PURPLE}===================================${NC}"
echo ""

# Step 1: Declare mock contracts
echo -e "${BLUE}📋 Step 1: Declaring mock contracts...${NC}"
if [ -x "scripts/declare_mock_contracts.sh" ]; then
    ./scripts/declare_mock_contracts.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Mock contracts declaration failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Mock contracts declaration script not found or not executable${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Mock contracts declared successfully${NC}"
echo ""

# Step 2: Deploy mock contracts
echo -e "${BLUE}📋 Step 2: Deploying mock contracts...${NC}"
if [ -x "scripts/deploy_mock_contracts.sh" ]; then
    ./scripts/deploy_mock_contracts.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Mock contracts deployment failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Mock contracts deployment script not found or not executable${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Mock contracts deployed successfully${NC}"
echo ""

# Step 3: Declare NFT contract
echo -e "${BLUE}📋 Step 3: Declaring NFT contract...${NC}"
if [ -x "scripts/declare_nft_contract.sh" ]; then
    ./scripts/declare_nft_contract.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ NFT contract declaration failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ NFT contract declaration script not found or not executable${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ NFT contract declared successfully${NC}"
echo ""

# Step 4: Deploy NFT contract
echo -e "${BLUE}📋 Step 4: Deploying NFT contract...${NC}"
if [ -x "scripts/deploy_nft_contract.sh" ]; then
    ./scripts/deploy_nft_contract.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ NFT contract deployment failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ NFT contract deployment script not found or not executable${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ NFT contract deployed successfully${NC}"
echo ""

# Step 5: Test all contracts
echo -e "${BLUE}📋 Step 5: Testing all contracts...${NC}"
if [ -x "scripts/test_contracts.sh" ]; then
    ./scripts/test_contracts.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Contract testing failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Contract testing script not found or not executable${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ All contracts tested successfully${NC}"
echo ""

# Step 6: Mint a sample NFT
echo -e "${BLUE}📋 Step 6: Minting sample NFT...${NC}"
if [ -x "scripts/mint_nft.sh" ]; then
    ./scripts/mint_nft.sh
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠️ NFT minting failed, but continuing...${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ NFT minting script not found, skipping...${NC}"
fi

echo ""

# Final summary
echo -e "${PURPLE}🎉 COMPLETE WORKFLOW FINISHED!${NC}"
echo -e "${PURPLE}==============================${NC}"
echo ""

if [ -f "scripts/full_deployment_addresses.txt" ]; then
    source scripts/full_deployment_addresses.txt
    echo -e "${YELLOW}📋 Deployment Summary:${NC}"
    echo -e "   NFT Contract: ${NFT_ADDRESS}"
    echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
    echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"
    echo ""
fi

echo -e "${YELLOW}💡 What you can do now:${NC}"
echo -e "   1. Mint more NFTs: ./scripts/mint_nft.sh [recipient_address]"
echo -e "   2. Query NFT data: ./scripts/query_nft.sh [token_id]"
echo -e "   3. Test specific functions: ./scripts/test_contracts.sh"
echo -e "   4. Run unit tests: scarb test"
echo ""

echo -e "${GREEN}🎊 Your LS2 Renderer contracts are now fully deployed and tested!${NC}"