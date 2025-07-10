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

# Check if contracts are already deployed
if [ -f "scripts/mock_contracts_addresses.txt" ]; then
    source scripts/mock_contracts_addresses.txt
    if [ -n "$MOCK_ADVENTURER_ADDRESS" ] && [ -n "$MOCK_BEAST_ADDRESS" ]; then
        echo -e "${YELLOW}⚠️ Mock contracts appear to be already deployed${NC}"
        echo -e "${YELLOW}   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}${NC}"
        echo -e "${YELLOW}   Mock Beast: ${MOCK_BEAST_ADDRESS}${NC}"
        echo -e "${YELLOW}💡 Skipping deployment. If you want to redeploy, delete scripts/mock_contracts_addresses.txt${NC}"
        
        echo -e "${GREEN}🎉 Mock contracts deployment completed (using existing)!${NC}"
        echo -e "${YELLOW}💡 Next steps:${NC}"
        echo -e "   1. Declare the NFT contract: ./scripts/declare_nft_contract.sh"
        echo -e "   2. Deploy the NFT contract with these addresses as constructor arguments"
        echo -e "   3. Test the contracts: ./scripts/test_contracts.sh"
        echo ""
        echo -e "${YELLOW}📋 Contract Addresses:${NC}"
        echo -e "   Mock Adventurer: ${MOCK_ADVENTURER_ADDRESS}"
        echo -e "   Mock Beast: ${MOCK_BEAST_ADDRESS}"
        exit 0
    fi
fi

# Generate unique salt for deployment
ADVENTURER_SALT=$(date +%s)$(shuf -i 1000-9999 -n 1)

# Deploy mock_adventurer contract (no constructor arguments)
echo -e "${YELLOW}🏰 Deploying mock_adventurer contract...${NC}"
echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
echo -e "   Salt: ${ADVENTURER_SALT}"

# Set network from environment variable or default to sepolia
STARKNET_NETWORK="${STARKNET_NETWORK:-sepolia}"

MOCK_ADVENTURER_DEPLOY_RESULT=$(sncast --account renderer deploy --network "$STARKNET_NETWORK" --class-hash ${MOCK_ADVENTURER_CLASS_HASH} --salt ${ADVENTURER_SALT} --wait 2>&1)
MOCK_ADVENTURER_DEPLOY_EXIT_CODE=$?

if [ $MOCK_ADVENTURER_DEPLOY_EXIT_CODE -eq 0 ]; then
    MOCK_ADVENTURER_ADDRESS=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    MOCK_ADVENTURER_DEPLOY_TX=$(echo "$MOCK_ADVENTURER_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_adventurer deployed successfully${NC}"
    echo -e "   Contract Address: ${MOCK_ADVENTURER_ADDRESS}"
    echo -e "   Transaction Hash: ${MOCK_ADVENTURER_DEPLOY_TX}"
    
    # Transaction confirmed automatically due to --wait flag
    echo -e "${YELLOW}   Transaction confirmed, proceeding to next deployment...${NC}"
else
    echo -e "${RED}❌ Failed to deploy mock_adventurer${NC}"
    echo -e "${RED}Exit code: $MOCK_ADVENTURER_DEPLOY_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$MOCK_ADVENTURER_DEPLOY_RESULT"
    
    # Provide helpful debugging information
    echo -e "${YELLOW}💡 Debugging information:${NC}"
    echo -e "   Account: renderer"
    echo -e "   Class Hash: ${MOCK_ADVENTURER_CLASS_HASH}"
    echo -e "   Salt: ${ADVENTURER_SALT}"
    echo -e "   Command: sncast --account renderer deploy --network $STARKNET_NETWORK --class-hash ${MOCK_ADVENTURER_CLASS_HASH} --salt ${ADVENTURER_SALT}"
    
    # Check if account exists and has sufficient balance
    if sncast account list --network "$STARKNET_NETWORK" | grep -q "renderer"; then
        echo -e "${GREEN}✅ Account 'renderer' exists on $STARKNET_NETWORK${NC}"
    else
        echo -e "${RED}❌ Account 'renderer' not found on $STARKNET_NETWORK${NC}"
        echo -e "${YELLOW}Available accounts on $STARKNET_NETWORK:${NC}"
        sncast account list --network "$STARKNET_NETWORK"
    fi
    
    exit 1
fi

# Generate unique salt for deployment
BEAST_SALT=$(date +%s)$(shuf -i 1000-9999 -n 1)

# Deploy mock_beast contract (no constructor arguments)
echo -e "${YELLOW}🐉 Deploying mock_beast contract...${NC}"
echo -e "   Class Hash: ${MOCK_BEAST_CLASS_HASH}"
echo -e "   Salt: ${BEAST_SALT}"

MOCK_BEAST_DEPLOY_RESULT=$(sncast --account renderer deploy --network "$STARKNET_NETWORK" --class-hash ${MOCK_BEAST_CLASS_HASH} --salt ${BEAST_SALT} --wait 2>&1)
MOCK_BEAST_DEPLOY_EXIT_CODE=$?

if [ $MOCK_BEAST_DEPLOY_EXIT_CODE -eq 0 ] && echo "$MOCK_BEAST_DEPLOY_RESULT" | grep -q "contract_address:"; then
    # Successful deployment
    MOCK_BEAST_ADDRESS=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
    MOCK_BEAST_DEPLOY_TX=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
    
    echo -e "${GREEN}✅ mock_beast deployed successfully${NC}"
    echo -e "   Contract Address: ${MOCK_BEAST_ADDRESS}"
    echo -e "   Transaction Hash: ${MOCK_BEAST_DEPLOY_TX}"
elif echo "$MOCK_BEAST_DEPLOY_RESULT" | grep -q "Invalid transaction nonce"; then
    # Nonce error - retry once
    echo -e "${YELLOW}⚠️ Nonce error detected, retrying beast deployment...${NC}"
    sleep 3
    BEAST_SALT=$(date +%s)$(shuf -i 1000-9999 -n 1)
    echo -e "${YELLOW}   New Salt: ${BEAST_SALT}${NC}"
    
    MOCK_BEAST_DEPLOY_RESULT=$(sncast --account renderer deploy --network "$STARKNET_NETWORK" --class-hash ${MOCK_BEAST_CLASS_HASH} --salt ${BEAST_SALT} --wait 2>&1)
    MOCK_BEAST_DEPLOY_EXIT_CODE=$?
    
    if [ $MOCK_BEAST_DEPLOY_EXIT_CODE -eq 0 ] && echo "$MOCK_BEAST_DEPLOY_RESULT" | grep -q "contract_address:"; then
        MOCK_BEAST_ADDRESS=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "contract_address:" | cut -d' ' -f2)
        MOCK_BEAST_DEPLOY_TX=$(echo "$MOCK_BEAST_DEPLOY_RESULT" | grep "transaction_hash:" | cut -d' ' -f2)
        
        echo -e "${GREEN}✅ mock_beast deployed successfully (retry)${NC}"
        echo -e "   Contract Address: ${MOCK_BEAST_ADDRESS}"
        echo -e "   Transaction Hash: ${MOCK_BEAST_DEPLOY_TX}"
    else
        echo -e "${RED}❌ Failed to deploy mock_beast even after retry${NC}"
        echo -e "${RED}Exit code: $MOCK_BEAST_DEPLOY_EXIT_CODE${NC}"
        echo -e "${RED}Raw output: $MOCK_BEAST_DEPLOY_RESULT${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Failed to deploy mock_beast${NC}"
    echo -e "${RED}Exit code: $MOCK_BEAST_DEPLOY_EXIT_CODE${NC}"
    echo -e "${RED}Raw output:${NC}"
    echo "$MOCK_BEAST_DEPLOY_RESULT"
    
    # Provide helpful debugging information
    echo -e "${YELLOW}💡 Debugging information:${NC}"
    echo -e "   Account: renderer"
    echo -e "   Class Hash: ${MOCK_BEAST_CLASS_HASH}"
    echo -e "   Salt: ${BEAST_SALT}"
    echo -e "   Command: sncast --account renderer deploy --network $STARKNET_NETWORK --class-hash ${MOCK_BEAST_CLASS_HASH} --salt ${BEAST_SALT}"
    
    # Check if account exists and has sufficient balance
    if sncast account list --network "$STARKNET_NETWORK" | grep -q "renderer"; then
        echo -e "${GREEN}✅ Account 'renderer' exists on $STARKNET_NETWORK${NC}"
    else
        echo -e "${RED}❌ Account 'renderer' not found on $STARKNET_NETWORK${NC}"
        echo -e "${YELLOW}Available accounts on $STARKNET_NETWORK:${NC}"
        sncast account list --network "$STARKNET_NETWORK"
    fi
    
    exit 1
fi

# Save deployment addresses to file
if [ ! -d scripts ]; then
    mkdir -p scripts
fi
if [ -e scripts/mock_contracts_addresses.txt ]; then
    echo -e "${YELLOW}⚠️ Warning: scripts/mock_contracts_addresses.txt already exists and will be overwritten.${NC}"
fi
cat > scripts/mock_contracts_addresses.txt << EOF
# Mock Contracts Deployment Addresses
# Generated on $(date)

MOCK_ADVENTURER_ADDRESS=${MOCK_ADVENTURER_ADDRESS}
MOCK_BEAST_ADDRESS=${MOCK_BEAST_ADDRESS}

# Class Hashes
MOCK_ADVENTURER_CLASS_HASH=${MOCK_ADVENTURER_CLASS_HASH}
MOCK_BEAST_CLASS_HASH=${MOCK_BEAST_CLASS_HASH}

# Deployment Salts
ADVENTURER_SALT=${ADVENTURER_SALT}
BEAST_SALT=${BEAST_SALT}

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