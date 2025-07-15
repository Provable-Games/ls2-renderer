#[cfg(test)]
mod test_declaration_workflow {
    use starknet::{ContractAddress, contract_address_const};
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
    use ls2_renderer::mocks::mock_adventurer::{IMockAdventurerDispatcher, IMockAdventurerDispatcherTrait};
    use ls2_renderer::mocks::mock_beast::{IMockBeastDispatcher, IMockBeastDispatcherTrait};
    use ls2_renderer::nfts::ls2_nft::{IOpenMintDispatcher, IOpenMintDispatcherTrait};
    use openzeppelin_token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
    use openzeppelin_token::erc721::interface::{IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait};

    fn deploy_mock_adventurer() -> ContractAddress {
        let contract = declare("mock_adventurer").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        contract_address
    }

    fn deploy_mock_beast() -> ContractAddress {
        let contract = declare("mock_beast").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        contract_address
    }

    fn deploy_nft_contract(
        mock_adventurer_address: ContractAddress,
        mock_beast_address: ContractAddress
    ) -> ContractAddress {
        let contract = declare("ls2_nft").unwrap().contract_class();
        let name: ByteArray = "Loot Survivor 2.0";
        let symbol: ByteArray = "LS2";
        let base_uri: ByteArray = "https://loot-survivor.io/nft/";
        
        let mut calldata = array![];
        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        base_uri.serialize(ref calldata);
        mock_adventurer_address.serialize(ref calldata);
        mock_beast_address.serialize(ref calldata);
        
        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        contract_address
    }

    #[test]
    fn test_mock_adventurer_declaration_and_deployment() {
        let contract_address = deploy_mock_adventurer();
        let dispatcher = IMockAdventurerDispatcher { contract_address };
        
        // Test basic functionality
        let adventurer = dispatcher.get_adventurer(1);
        assert!(adventurer.health > 0, "Adventurer should have health");
        
        let name = dispatcher.get_adventurer_name(1);
        assert!(name != 0, "Adventurer should have a name");
        
        let level = dispatcher.get_level(100);
        assert!(level > 0, "Level should be greater than 0");
    }

    #[test]
    fn test_mock_beast_declaration_and_deployment() {
        let contract_address = deploy_mock_beast();
        let dispatcher = IMockBeastDispatcher { contract_address };
        
        // Test basic functionality
        let beast = dispatcher.get_beast(1);
        assert!(beast.id > 0, "Beast should have an ID");
        assert!(beast.starting_health > 0, "Beast should have health");
        
        let name = dispatcher.get_beast_name(1);
        assert!(name != 0, "Beast should have a name");
    }

    #[test]
    fn test_nft_contract_declaration_and_deployment() {
        // Deploy dependencies first
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        
        // Deploy NFT contract
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        // Test ERC721 functionality
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };
        
        // Test metadata
        let name = metadata_dispatcher.name();
        assert!(name == "Loot Survivor 2.0", "Name should match");
        
        let symbol = metadata_dispatcher.symbol();
        assert!(symbol == "LS2", "Symbol should match");
    }

    #[test]
    fn test_nft_minting_and_metadata() {
        // Deploy all contracts
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        // Test minting
        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let erc721_dispatcher = IERC721Dispatcher { contract_address: nft_address };
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };
        
        let recipient = contract_address_const::<0x123>();
        
        // Mint NFT
        mint_dispatcher.mint(recipient);
        
        // Verify ownership
        let owner = erc721_dispatcher.owner_of(1);
        assert!(owner == recipient, "NFT should be owned by recipient");
        
        // Test metadata generation
        let token_uri = metadata_dispatcher.token_uri(1);
        assert!(token_uri.len() > 0, "Token URI should not be empty");
    }

    #[test]
    fn test_constructor_arguments_serialization() {
        // Test that constructor arguments are properly serialized
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        
        // This test verifies that the constructor arguments are properly handled
        // by successfully deploying the contract with complex ByteArray arguments
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };
        
        // Verify constructor arguments were properly set
        let name = metadata_dispatcher.name();
        let symbol = metadata_dispatcher.symbol();
        
        assert!(name == "Loot Survivor 2.0", "Name should be correctly set");
        assert!(symbol == "LS2", "Symbol should be correctly set");
    }

    #[test]
    fn test_cross_contract_interaction() {
        // Test that NFT contract properly interacts with mock contracts
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        // Setup dispatchers
        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };
        let adventurer_dispatcher = IMockAdventurerDispatcher { contract_address: mock_adventurer_address };
        let beast_dispatcher = IMockBeastDispatcher { contract_address: mock_beast_address };
        
        let recipient = contract_address_const::<0x123>();
        
        // Mint NFT
        mint_dispatcher.mint(recipient);
        
        // Get token metadata (this calls the renderer which interacts with mock contracts)
        let token_uri = metadata_dispatcher.token_uri(1);
        
        // Verify that the renderer can access mock contract data
        // by ensuring the token URI is generated (non-empty)
        assert!(token_uri.len() > 0, "Token URI should be generated from mock data");
        
        // Verify mock contracts are working independently
        let adventurer = adventurer_dispatcher.get_adventurer(1);
        let beast = beast_dispatcher.get_beast(1);
        
        assert!(adventurer.health > 0, "Adventurer should have health");
        assert!(beast.starting_health > 0, "Beast should have health");
    }

    #[test]
    fn test_multiple_nft_minting_ownership() {
        // Test minting multiple NFTs and verifying ownership only (no expensive metadata calls)
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let erc721_dispatcher = IERC721Dispatcher { contract_address: nft_address };
        
        let recipient1 = contract_address_const::<0x123>();
        let recipient2 = contract_address_const::<0x456>();
        
        // Mint multiple NFTs
        mint_dispatcher.mint(recipient1);
        mint_dispatcher.mint(recipient2);
        
        // Verify ownership
        let owner1 = erc721_dispatcher.owner_of(1);
        let owner2 = erc721_dispatcher.owner_of(2);
        
        assert!(owner1 == recipient1, "Token 1 should be owned by recipient1");
        assert!(owner2 == recipient2, "Token 2 should be owned by recipient2");
    }

    #[test]
    fn test_second_nft_metadata_generation() {
        // Test that a second NFT can generate metadata (focused test)
        let mock_adventurer_address = deploy_mock_adventurer();
        let mock_beast_address = deploy_mock_beast();
        let nft_address = deploy_nft_contract(mock_adventurer_address, mock_beast_address);
        
        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };
        
        let recipient1 = contract_address_const::<0x123>();
        let recipient2 = contract_address_const::<0x456>();
        
        // Mint two NFTs
        mint_dispatcher.mint(recipient1);
        mint_dispatcher.mint(recipient2);
        
        // Test metadata generation for second token (this is what was failing)
        let token_uri2 = metadata_dispatcher.token_uri(2);
        assert!(token_uri2.len() > 0, "Token 2 URI should not be empty");
    }
    
}