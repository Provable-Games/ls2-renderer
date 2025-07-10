#!/bin/bash

# Script to deploy mock contracts for LS2 Renderer
# This script deploys the mock adventurer and beast contracts using their class hashes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Mock Contracts Deployment Process${NC}"

# Check if class hashes file exists
if [ ! -f "scripts/mock_contracts_class_hashes.txt" ]; then
    echo -e "${RED}❌ Error: Class hashes file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/declare_mock_contracts.sh first${NC}"
    exit 1
fi

# Source the class hashes
source scripts/mock_contracts_class_hashes.txt

if [ -z "$MOCK_ADVENTURER_CLASS_HASH" ] || [ -z "$MOCK_BEAST_CLASS_HASH" ]; then
    echo -e "${RED}❌ Error: Class hashes not found in file${NC}"
    exit 1
fi

# Deploy mock_adventurer contract (no constructor arguments)
echo -e "${YELLOW}🏰 Deploying mock_adventurer contract...${NC}"
echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"

MOCK_ADVENTURER_DEPLOY_RESULT=$(sncast --account renderer deploy --class-hash ${MOCK_ADVENTURER_CLASS_HASH} 2>&1)

if [ $? -eq 0 ]; then
    MOCK_ADVENTURER_ADDRESS=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    MOCK_ADVENTURER_DEPLOY_TX=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_adventurer deployed successfully${NC}"
    echo -e "   Contract Address: ${MOCK_ADVENTURER_ADDRESS}"
    echo -e "   Transaction Hash: ${MOCK_ADVENTURER_DEPLOY_TX}"
else
    echo -e "${RED}❌ Failed to deploy mock_adventurer${NC}"
    echo "$MOCK_ADVENTURER_DEPLOY_RESULT"
    exit 1
fi

# Deploy mock_beast contract (no constructor arguments)
echo -e "${YELLOW}🐉 Deploying mock_beast contract...${NC}"
echo -e "   Class Hash: ${MOCK_BEAST_CLASS_HASH}"

MOCK_BEAST_DEPLOY_RESULT=$(sncast --account renderer deploy --class-hash ${MOCK_BEAST_CLASS_HASH} 2>&1)

if [ $? -eq 0 ]; then
    MOCK_BEAST_ADDRESS=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    MOCK_BEAST_DEPLOY_TX=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_beast deployed successfully${NC}"
    echo -e "   Contract Address: ${MOCK_BEAST_ADDRESS}"
    echo -e "   Transaction Hash: ${MOCK_BEAST_DEPLOY_TX}"
else
    echo -e "${RED}❌ Failed to deploy mock_beast${NC}"
    echo "$MOCK_BEAST_DEPLOY_RESULT"
    exit 1
fi

# Save deployment addresses to file
echo -e "${YELLOW}💾 Saving deployment addresses...${NC}"
cat > scripts/mock_contracts_addresses.txt << EOF
# Mock Contracts Deployment Addresses
# Generated on $(date)

MOCK_ADVENTURER_ADDRESS=${MOCK_ADVENTURER_ADDRESS}
MOCK_BEAST_ADDRESS=${MOCK_BEAST_ADDRESS}

# Class Hashes
MOCK_ADVENTURER_CLASS_HASH=${MOCK_ADVENTURER_CLASS_HASH}
MOCK_BEAST_CLASS_HASH=${MOCK_BEAST_CLASS_HASH}

# Deployment Transaction Hashes
MOCK_ADVENTURER_DEPLOY_TX=${MOCK_ADVENTURER_DEPLOY_TX}
MOCK_BEAST_DEPLOY_TX=${MOCK_BEAST_DEPLOY_TX}
EOF

echo -e "${GREEN}📝 Deployment addresses saved to scripts/mock_contracts_addresses.txt${NC}"

echo -e "${GREEN}🎉 Mock contracts deployment completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Declare the NFT contract: ./scripts/declare_nft_contract.sh"
echo -e "   2. Deploy the NFT contract with these addresses as constructor arguments"
echo -e "   3. Test the contracts: ./scripts/test_contracts.sh"
echo ""
echo -e "${YELLOW}📋 Contract Addresses:${NC}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"