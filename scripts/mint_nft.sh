#!/bin/bash

# Script to mint NFTs from the deployed contract
# This script provides an easy way to mint NFTs to specific addresses

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🪙 NFT Minting Script${NC}"

# Check if deployment file exists
if [ ! -f "scripts/full_deployment_addresses.txt" ]; then
    echo -e "${RED}❌ Error: Deployment addresses file not found${NC}"
    echo -e "${YELLOW}💡 Please run the full deployment first${NC}"
    exit 1
fi

# Source the deployment addresses
source scripts/full_deployment_addresses.txt

if [ -z "$NFT_ADDRESS" ]; then
    echo -e "${RED}❌ Error: NFT contract address not found${NC}"
    exit 1
fi

# Default recipient address (can be overridden)
DEFAULT_RECIPIENT="0x07394cbe418daa16e42b87ba67372d4ab4a5df0b05c6e554d158458ce245bc10"
RECIPIENT=${1:-$DEFAULT_RECIPIENT}

echo -e "${BLUE}📋 Minting NFT...${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Recipient: ${RECIPIENT}"
echo ""

# Mint the NFT
echo -e "${YELLOW}🎨 Minting NFT...${NC}"
MINT_RESULT=$(sncast --account renderer invoke \
    --contract-address ${NFT_ADDRESS} \
    --function mint \
    --calldata ${RECIPIENT} \
    2>&1)

if [ $? -eq 0 ]; then
    MINT_TX=$(echo "$MINT_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ NFT minted successfully!${NC}"
    echo -e "   Transaction Hash: ${MINT_TX}"
    echo -e "   Recipient: ${RECIPIENT}"
    
    # Wait for transaction to be processed
    echo -e "${YELLOW}⏳ Waiting for transaction confirmation...${NC}"
    sleep 10
    
    # Try to get the token ID by querying the contract
    echo -e "${YELLOW}🔍 Querying latest token...${NC}"
    
    # Since we don't have a direct way to get the latest token ID,
    # we'll start from token ID 1 and work our way up
    for i in {1..10}; do
        TOKEN_OWNER_RESULT=$(sncast --account renderer call \
            --contract-address ${NFT_ADDRESS} \
            --function owner_of \
            --calldata $i \
            2>&1)
        
        if [ $? -eq 0 ]; then
            OWNER=$(echo "$TOKEN_OWNER_RESULT" | grep -o '0x[a-fA-F0-9]*' | tail -1)
            if [ "$OWNER" = "$RECIPIENT" ]; then
                echo -e "${GREEN}✅ Found your NFT: Token ID ${i}${NC}"
                echo -e "   Owner: ${OWNER}"
                
                # Get the token URI
                echo -e "${YELLOW}🔗 Getting token metadata...${NC}"
                TOKEN_URI_RESULT=$(sncast --account renderer call \
                    --contract-address ${NFT_ADDRESS} \
                    --function token_uri \
                    --calldata $i \
                    2>&1)
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Token URI retrieved successfully${NC}"
                    echo -e "   Metadata: ${TOKEN_URI_RESULT}"
                else
                    echo -e "${YELLOW}⚠️ Could not retrieve token URI${NC}"
                fi
                break
            fi
        fi
    done
    
else
    echo -e "${RED}❌ Failed to mint NFT${NC}"
    echo "$MINT_RESULT"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Minting completed!${NC}"
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "   1. Check your NFT on a block explorer"
echo -e "   2. Query specific NFT metadata: ./scripts/query_nft.sh [token_id]"
echo -e "   3. Mint more NFTs by running this script again"
echo ""
echo -e "${YELLOW}📋 Transaction Details:${NC}"
echo -e "   Contract: ${NFT_ADDRESS}"
echo -e "   Transaction: ${MINT_TX}"
echo -e "   Recipient: ${RECIPIENT}"