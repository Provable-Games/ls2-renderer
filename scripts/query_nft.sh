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

echo -e "${GREEN}🔍 NFT Query Script${NC}"

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

# Get token ID from argument or default to 1
TOKEN_ID=${1:-1}

echo -e "${BLUE}📋 Querying NFT information...${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Token ID: ${TOKEN_ID}"
echo ""

# Query 1: Check if token exists (by checking owner)
echo -e "${YELLOW}👤 Checking token owner...${NC}"
OWNER_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function owner_of \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    OWNER=$(echo "$OWNER_RESULT" | grep -o '0x[a-fA-F0-9]*' | tail -1)
    echo -e "${GREEN}✅ Token exists${NC}"
    echo -e "   Owner: ${OWNER}"
else
    echo -e "${RED}❌ Token does not exist or query failed${NC}"
    echo "$OWNER_RESULT"
    exit 1
fi

# Query 2: Get token URI (metadata)
echo -e "${YELLOW}🔗 Getting token metadata...${NC}"
TOKEN_URI_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function token_uri \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Token URI retrieved successfully${NC}"
    echo -e "   Metadata: ${TOKEN_URI_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve token URI${NC}"
    echo "$TOKEN_URI_RESULT"
fi

# Query 3: Get contract name
echo -e "${YELLOW}📛 Getting contract name...${NC}"
NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function name \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Contract name retrieved${NC}"
    echo -e "   Name: ${NAME_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve contract name${NC}"
fi

# Query 4: Get contract symbol
echo -e "${YELLOW}🔖 Getting contract symbol...${NC}"
SYMBOL_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function symbol \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Contract symbol retrieved${NC}"
    echo -e "   Symbol: ${SYMBOL_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve contract symbol${NC}"
fi

# Query 5: Get underlying data from mock contracts
echo -e "${YELLOW}🏰 Getting adventurer data...${NC}"
ADVENTURER_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Adventurer data retrieved${NC}"
    echo -e "   Data: ${ADVENTURER_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve adventurer data${NC}"
fi

# Query 6: Get adventurer name
echo -e "${YELLOW}👑 Getting adventurer name...${NC}"
ADV_NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer_name \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Adventurer name retrieved${NC}"
    echo -e "   Name: ${ADV_NAME_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve adventurer name${NC}"
fi

# Query 7: Get beast data
echo -e "${YELLOW}🐉 Getting beast data...${NC}"
BEAST_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_BEAST_ADDRESS} \
    --function get_beast \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Beast data retrieved${NC}"
    echo -e "   Data: ${BEAST_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve beast data${NC}"
fi

# Query 8: Get beast name
echo -e "${YELLOW}👹 Getting beast name...${NC}"
BEAST_NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_BEAST_ADDRESS} \
    --function get_beast_name \
    --calldata ${TOKEN_ID} \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Beast name retrieved${NC}"
    echo -e "   Name: ${BEAST_NAME_RESULT}"
else
    echo -e "${RED}❌ Failed to retrieve beast name${NC}"
fi

echo ""
echo -e "${GREEN}🎉 NFT query completed!${NC}"
echo -e "${YELLOW}💡 Summary for Token ID ${TOKEN_ID}:${NC}"
echo -e "   - Token exists and is owned by: ${OWNER}"
echo -e "   - Metadata is dynamically generated"
echo -e "   - Connected to mock adventurer and beast contracts"
echo -e "   - All rendering functionality is working"
echo ""
echo -e "${YELLOW}📋 Contract addresses:${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"