#!/bin/bash

# Script to declare the LS2 NFT contract
# This script declares the main NFT contract

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting LS2 NFT Contract Declaration Process${NC}"

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

# Declare ls2_nft contract
echo -e "${YELLOW}🎨 Declaring ls2_nft contract...${NC}"
NFT_RESULT=$(sncast --account renderer declare --network "$STARKNET_NETWORK" --contract-name ls2_nft 2>&1)
NFT_EXIT_CODE=$?

if [ $NFT_EXIT_CODE -eq 0 ] && echo "$NFT_RESULT" | grep -q "class_hash:"; then
    # New declaration - extract from success output
    NFT_CLASS_HASH=$(echo "$NFT_RESULT" | grep "class_hash:" | cut -d' ' -f2)
    NFT_TX_HASH=$(echo "$NFT_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ ls2_nft declared successfully${NC}"
    echo -e "   Class Hash: ${NFT_CLASS_HASH}"
    echo -e "   Transaction Hash: ${NFT_TX_HASH}"
elif echo "$NFT_RESULT" | grep -q "is already declared"; then
    # Contract already declared - extract class hash from error message
    echo -e "${YELLOW}⚠️ ls2_nft contract is already declared${NC}"
    NFT_CLASS_HASH=$(echo "$NFT_RESULT" | grep -o "0x[a-fA-F0-9]\{64\}" | head -1)
    if [ -z "$NFT_CLASS_HASH" ]; then
        echo -e "${RED}❌ Failed to extract class hash from already declared contract${NC}"
        echo -e "${RED}Raw output: $NFT_RESULT${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Using existing class hash: ${NFT_CLASS_HASH}${NC}"
    NFT_TX_HASH="already_declared"
else
    echo -e "${RED}❌ Failed to declare ls2_nft${NC}"
    echo -e "${RED}Exit code: $NFT_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$NFT_RESULT"
    exit 1
fi

# Save class hash to file
echo -e "${YELLOW}💾 Saving class hash...${NC}"
cat > scripts/nft_contract_class_hash.txt << EOF
# LS2 NFT Contract Class Hash
# Generated on $(date)

NFT_CLASS_HASH=${NFT_CLASS_HASH}
NFT_TX_HASH=${NFT_TX_HASH}
EOF

echo -e "${GREEN}📝 Class hash saved to scripts/nft_contract_class_hash.txt${NC}"

echo -e "${GREEN}🎉 LS2 NFT contract declaration completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Deploy mock contracts first: ./scripts/deploy_mock_contracts.sh"
echo -e "   2. Then deploy the NFT contract: ./scripts/deploy_nft_contract.sh"
echo -e "   3. Test the full deployment: ./scripts/test_contracts.sh"
echo ""
echo -e "${YELLOW}📋 NFT Contract Details:${NC}"
echo -e "   Class Hash: ${NFT_CLASS_HASH}"
echo -e "   Transaction Hash: ${NFT_TX_HASH}"