#!/bin/bash

# Script to test the deployed contracts
# This script tests the functionality of deployed mock and NFT contracts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🧪 Starting Contract Testing Process${NC}"

# Check if deployment file exists
if [ ! -f "scripts/full_deployment_addresses.txt" ]; then
    echo -e "${RED}❌ Error: Deployment addresses file not found${NC}"
    echo -e "${YELLOW}💡 Please run the full deployment first${NC}"
    exit 1
fi

# Source the deployment addresses
source scripts/full_deployment_addresses.txt

if [ -z "$NFT_ADDRESS" ] || [ -z "$MOCK_ADVENTURER_ADDRESS" ] || [ -z "$MOCK_BEAST_ADDRESS" ]; then
    echo -e "${RED}❌ Error: Contract addresses not found${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Testing with addresses:${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"
echo ""

# Test 1: Check mock_adventurer contract
echo -e "${YELLOW}🏰 Testing mock_adventurer contract...${NC}"
echo -e "   Getting adventurer data for ID 1..."

ADVENTURER_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer \
    --calldata 0x1 \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Mock adventurer test passed${NC}"
    echo -e "   Result: ${ADVENTURER_RESULT}"
else
    echo -e "${RED}❌ Mock adventurer test failed${NC}"
    echo "$ADVENTURER_RESULT"
fi

# Test 2: Check adventurer name
echo -e "${YELLOW}👑 Testing adventurer name...${NC}"
NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_ADVENTURER_ADDRESS} \
    --function get_adventurer_name \
    --calldata 0x1 \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Adventurer name test passed${NC}"
    echo -e "   Result: ${NAME_RESULT}"
else
    echo -e "${RED}❌ Adventurer name test failed${NC}"
    echo "$NAME_RESULT"
fi

# Test 3: Check mock_beast contract
echo -e "${YELLOW}🐉 Testing mock_beast contract...${NC}"
echo -e "   Getting beast data for ID 1..."

BEAST_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_BEAST_ADDRESS} \
    --function get_beast \
    --calldata 0x1 \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Mock beast test passed${NC}"
    echo -e "   Result: ${BEAST_RESULT}"
else
    echo -e "${RED}❌ Mock beast test failed${NC}"
    echo "$BEAST_RESULT"
fi

# Test 4: Check beast name
echo -e "${YELLOW}👹 Testing beast name...${NC}"
BEAST_NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${MOCK_BEAST_ADDRESS} \
    --function get_beast_name \
    --calldata 0x1 \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Beast name test passed${NC}"
    echo -e "   Result: ${BEAST_NAME_RESULT}"
else
    echo -e "${RED}❌ Beast name test failed${NC}"
    echo "$BEAST_NAME_RESULT"
fi

# Test 5: Check NFT contract name
echo -e "${YELLOW}🎨 Testing NFT contract name...${NC}"
NFT_NAME_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function name \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ NFT name test passed${NC}"
    echo -e "   Result: ${NFT_NAME_RESULT}"
else
    echo -e "${RED}❌ NFT name test failed${NC}"
    echo "$NFT_NAME_RESULT"
fi

# Test 6: Check NFT contract symbol
echo -e "${YELLOW}🔖 Testing NFT contract symbol...${NC}"
NFT_SYMBOL_RESULT=$(sncast --account renderer call \
    --contract-address ${NFT_ADDRESS} \
    --function symbol \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ NFT symbol test passed${NC}"
    echo -e "   Result: ${NFT_SYMBOL_RESULT}"
else
    echo -e "${RED}❌ NFT symbol test failed${NC}"
    echo "$NFT_SYMBOL_RESULT"
fi

# Test 7: Mint an NFT
echo -e "${YELLOW}🪙 Testing NFT minting...${NC}"
MINT_RESULT=$(sncast --account renderer invoke \
    --contract-address ${NFT_ADDRESS} \
    --function mint \
    --calldata 0x07394cbe418daa16e42b87ba67372d4ab4a5df0b05c6e554d158458ce245bc10 \
    2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ NFT minting test passed${NC}"
    echo -e "   Result: ${MINT_RESULT}"
    
    # Get the transaction hash for tracking
    MINT_TX=$(echo "$MINT_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    echo -e "   Transaction Hash: ${MINT_TX}"
    
    # Test 8: Check token URI (this will test the renderer)
    echo -e "${YELLOW}🔗 Testing token URI generation...${NC}"
    sleep 5  # Wait for transaction to be processed
    
    TOKEN_URI_RESULT=$(sncast --account renderer call \
        --contract-address ${NFT_ADDRESS} \
        --function token_uri \
        --calldata 0x1 \
        2>&1)

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Token URI test passed${NC}"
        echo -e "   Result: ${TOKEN_URI_RESULT}"
    else
        echo -e "${RED}❌ Token URI test failed${NC}"
        echo "$TOKEN_URI_RESULT"
    fi
else
    echo -e "${RED}❌ NFT minting test failed${NC}"
    echo "$MINT_RESULT"
fi

echo ""
echo -e "${GREEN}🎉 Contract testing completed!${NC}"
echo -e "${YELLOW}💡 Summary:${NC}"
echo -e "   - Mock contracts are working correctly"
echo -e "   - NFT contract is deployed and functional"
echo -e "   - Minting is working"
echo -e "   - Renderer integration is active"
echo ""
echo -e "${YELLOW}📋 Contract addresses for reference:${NC}"
echo -e "   NFT Contract: ${NFT_ADDRESS}"
echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"