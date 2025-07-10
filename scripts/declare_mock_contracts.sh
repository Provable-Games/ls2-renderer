#!/bin/bash

# Script to declare mock contracts for LS2 Renderer
# This script declares the mock adventurer and beast contracts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Mock Contracts Declaration Process${NC}"

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

# Declare mock_adventurer contract
echo -e "${YELLOW}🏰 Declaring mock_adventurer contract...${NC}"
MOCK_ADVENTURER_RESULT=$(sncast --account renderer declare --contract-name mock_adventurer 2>&1)

if [ $? -eq 0 ]; then
    MOCK_ADVENTURER_CLASS_HASH=$(echo "$MOCK_ADVENTURER_RESULT" | grep "class_hash:" | cut -d' ' -f2)
    MOCK_ADVENTURER_TX_HASH=$(echo "$MOCK_ADVENTURER_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_adventurer declared successfully${NC}"
    echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
    echo -e "   Transaction Hash: ${MOCK_ADVENTURER_TX_HASH}"
else
    echo -e "${RED}❌ Failed to declare mock_adventurer${NC}"
    echo "$MOCK_ADVENTURER_RESULT"
    exit 1
fi

# Declare mock_beast contract  
echo -e "${YELLOW}🐉 Declaring mock_beast contract...${NC}"
MOCK_BEAST_RESULT=$(sncast --account renderer declare --contract-name mock_beast 2>&1)

if [ $? -eq 0 ]; then
    MOCK_BEAST_CLASS_HASH=$(echo "$MOCK_BEAST_RESULT" | grep "class_hash:" | cut -d' ' -f2)
    MOCK_BEAST_TX_HASH=$(echo "$MOCK_BEAST_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_beast declared successfully${NC}"
    echo -e "   Class Hash: ${MOCK_BEAST_CLASS_HASH}"
    echo -e "   Transaction Hash: ${MOCK_BEAST_TX_HASH}"
else
    echo -e "${RED}❌ Failed to declare mock_beast${NC}"
    echo "$MOCK_BEAST_RESULT"
    exit 1
fi

# Save class hashes to file for deployment
echo -e "${YELLOW}💾 Saving class hashes...${NC}"
cat > scripts/mock_contracts_class_hashes.txt << EOF
# Mock Contracts Class Hashes
# Generated on $(date)

MOCK_ADVENTURER_CLASS_HASH=${MOCK_ADVENTURER_CLASS_HASH}
MOCK_BEAST_CLASS_HASH=${MOCK_BEAST_CLASS_HASH}

# Transaction Hashes
MOCK_ADVENTURER_TX_HASH=${MOCK_ADVENTURER_TX_HASH}
MOCK_BEAST_TX_HASH=${MOCK_BEAST_TX_HASH}
EOF

echo -e "${GREEN}📝 Class hashes saved to scripts/mock_contracts_class_hashes.txt${NC}"

echo -e "${GREEN}🎉 Mock contracts declaration completed successfully!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Deploy the contracts using: ./scripts/deploy_mock_contracts.sh"
echo -e "   2. Or declare the NFT contract: ./scripts/declare_nft_contract.sh"