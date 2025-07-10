#!/bin/bash

# Script to deploy the LS2 NFT contract
# This script deploys the main NFT contract with proper constructor arguments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting LS2 NFT Contract Deployment Process${NC}"

# Check if required files exist
if [ ! -f "scripts/nft_contract_class_hash.txt" ]; then
    echo -e "${RED}❌ Error: NFT contract class hash file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/declare_nft_contract.sh first${NC}"
    exit 1
fi

if [ ! -f "scripts/mock_contracts_addresses.txt" ]; then
    echo -e "${RED}❌ Error: Mock contracts addresses file not found${NC}"
    echo -e "${YELLOW}💡 Please run ./scripts/deploy_mock_contracts.sh first${NC}"
    exit 1
fi

# Source the files
source scripts/nft_contract_class_hash.txt
source scripts/mock_contracts_addresses.txt

if [ -z "$NFT_CLASS_HASH" ]; then
    echo -e "${RED}❌ Error: NFT class hash not found${NC}"
    exit 1
fi

if [ -z "$MOCK_ADVENTURER_ADDRESS" ] || [ -z "$MOCK_BEAST_ADDRESS" ]; then
    echo -e "${RED}❌ Error: Mock contract addresses not found${NC}"
    exit 1
fi

# NFT Constructor Arguments
# The ls2_nft contract requires:
# - name: ByteArray
# - symbol: ByteArray  
# - base_uri: ByteArray
# - mock_adventurer_address: ContractAddress
# - mock_beast_address: ContractAddress

echo -e "${YELLOW}🎨 Preparing NFT contract deployment...${NC}"
echo -e "   Class Hash: ${NFT_CLASS_HASH}"
echo -e "   Mock Adventurer Address: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast Address: ${MOCK_BEAST_ADDRESS}"

# Deploy the NFT contract with constructor arguments
echo -e "${YELLOW}🚀 Deploying NFT contract...${NC}"

# Note: For ByteArray constructor arguments, we need to use the proper serialization format
# ByteArray format: [num_full_words, full_words..., pending_word, pending_word_len]
# For short strings that fit in one felt252, we can use the simpler format

# Deploy command with constructor arguments
NFT_DEPLOY_RESULT=$(sncast --account renderer deploy \
    --class-hash ${NFT_CLASS_HASH} \
    --constructor-calldata \
    0x4c6f6f74205375727669766f7220322e30 \
    0x4c533220 \
    0x68747470733a2f2f6c6f6f742d7375727669766f722e696f2f6e66742f \
    ${MOCK_ADVENTURER_ADDRESS} \
    ${MOCK_BEAST_ADDRESS} \
    2>&1)

if [ $? -eq 0 ]; then
    NFT_ADDRESS=$(echo "$NFT_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    NFT_DEPLOY_TX=$(echo "$NFT_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ NFT contract deployed successfully${NC}"
    echo -e "   Contract Address: ${NFT_ADDRESS}"
    echo -e "   Transaction Hash: ${NFT_DEPLOY_TX}"
else
    echo -e "${RED}❌ Failed to deploy NFT contract${NC}"
    echo "$NFT_DEPLOY_RESULT"
    exit 1
fi

# Save deployment information
echo -e "${YELLOW}💾 Saving deployment information...${NC}"
cat > scripts/full_deployment_addresses.txt << EOF
# Full LS2 Renderer Deployment Addresses
# Generated on $(date)

# NFT Contract
NFT_ADDRESS=${NFT_ADDRESS}
NFT_CLASS_HASH=${NFT_CLASS_HASH}
NFT_DEPLOY_TX=${NFT_DEPLOY_TX}

# Mock Contracts
MOCK_ADVENTURER_ADDRESS=${MOCK_ADVENTURER_ADDRESS}
MOCK_BEAST_ADDRESS=${MOCK_BEAST_ADDRESS}

# Constructor Arguments Used
NFT_NAME="Loot Survivor 2.0"
NFT_SYMBOL="LS2"
NFT_BASE_URI="https://loot-survivor.io/nft/"
EOF

echo -e "${GREEN}📝 Deployment information saved to scripts/full_deployment_addresses.txt${NC}"

echo -e "${GREEN}🎉 Complete deployment successful!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Test the contracts: ./scripts/test_contracts.sh"
echo -e "   2. Mint an NFT: ./scripts/mint_nft.sh"
echo -e "   3. Query NFT metadata: ./scripts/query_nft.sh"
echo ""
echo -e "${YELLOW}📋 Deployment Summary:${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"