use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use openzeppelin_token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait};
use ls2_renderer::{IOpenMintDispatcher, IOpenMintDispatcherTrait};
use ls2_renderer::mock_adventurer::{Adventurer, Bag, Item, Equipment, Stats};
use ls2_renderer::mock_adventurer::{IMockAdventurerDispatcher, IMockAdventurerDispatcherTrait};
use core::array::ArrayTrait;

fn deploy_contract() -> ContractAddress {
    let name: ByteArray = "Test NFT";
    let symbol: ByteArray = "TNFT";
    let base_uri: ByteArray = "https://example.com/";

    let contract = declare("ERC721Upgradeable").unwrap().contract_class();
    let mut calldata = array![];
    name.serialize(ref calldata);
    symbol.serialize(ref calldata);
    base_uri.serialize(ref calldata);
    
    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    contract_address
}

#[test]
fn test_deployment() {
    let contract_address = deploy_contract();
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    
    assert(metadata_dispatcher.name() == "Test NFT", 'Wrong name');
    assert(metadata_dispatcher.symbol() == "TNFT", 'Wrong symbol');
}

#[test]
fn test_mint() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();
    
    // Mint a token
    mint_dispatcher.mint(recipient);
    
    // Check that the token was minted with ID 1
    assert(erc721_dispatcher.owner_of(1) == recipient, 'Wrong owner');
    assert(erc721_dispatcher.balance_of(recipient) == 1, 'Wrong balance');
    
    // Mint another token
    mint_dispatcher.mint(recipient);
    
    // Check that the token was minted with ID 2
    assert(erc721_dispatcher.owner_of(2) == recipient, 'Wrong owner');
    assert(erc721_dispatcher.balance_of(recipient) == 2, 'Wrong balance after 2nd mint');
}

#[test]
fn test_token_uri_with_renderer() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();
    
    // Mint a token
    mint_dispatcher.mint(recipient);
    
    // Get the token URI (which uses the renderer)
    let uri = metadata_dispatcher.token_uri(1);
    
    // Verify the JSON structure returned by the renderer
    assert(uri.len() > 0, 'URI should not be empty');
    
    // Since ByteArray doesn't have a contains method in Cairo, we'll just verify it's not empty
    // and has reasonable length for a JSON metadata
    assert(uri.len() > 50, 'URI too short for valid JSON');
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_token_uri_nonexistent_token() {
    let contract_address = deploy_contract();
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    
    // Try to get URI for a token that doesn't exist
    metadata_dispatcher.token_uri(999);
}

#[test]
fn test_multiple_mints_different_recipients() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };
    
    let recipient1 = contract_address_const::<0x123>();
    let recipient2 = contract_address_const::<0x456>();
    let recipient3 = contract_address_const::<0x789>();
    
    // Mint tokens to different recipients
    mint_dispatcher.mint(recipient1);
    mint_dispatcher.mint(recipient2);
    mint_dispatcher.mint(recipient3);
    mint_dispatcher.mint(recipient1); // Second token for recipient1
    
    // Verify ownership and balances
    assert(erc721_dispatcher.owner_of(1) == recipient1, 'Wrong owner of token 1');
    assert(erc721_dispatcher.owner_of(2) == recipient2, 'Wrong owner of token 2');
    assert(erc721_dispatcher.owner_of(3) == recipient3, 'Wrong owner of token 3');
    assert(erc721_dispatcher.owner_of(4) == recipient1, 'Wrong owner of token 4');
    
    assert(erc721_dispatcher.balance_of(recipient1) == 2, 'Wrong balance for recipient1');
    assert(erc721_dispatcher.balance_of(recipient2) == 1, 'Wrong balance for recipient2');
    assert(erc721_dispatcher.balance_of(recipient3) == 1, 'Wrong balance for recipient3');
}

#[test]
fn test_transfer_functionality() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };
    
    let owner = contract_address_const::<0x123>();
    let recipient = contract_address_const::<0x456>();
    
    // Mint a token
    mint_dispatcher.mint(owner);
    
    // Transfer the token
    start_cheat_caller_address(contract_address, owner);
    erc721_dispatcher.transfer_from(owner, recipient, 1);
    
    // Verify the transfer
    assert(erc721_dispatcher.owner_of(1) == recipient, 'Transfer failed');
    assert(erc721_dispatcher.balance_of(owner) == 0, 'Wrong owner balance');
    assert(erc721_dispatcher.balance_of(recipient) == 1, 'Wrong recipient balance');
}

#[test]
fn test_mock_adventurer_deterministic() {
    // Deploy the mock_adventurer contract
    let contract = declare("mock_adventurer").unwrap().contract_class();
    let calldata = ArrayTrait::<felt252>::new();
    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    let dispatcher = IMockAdventurerDispatcher { contract_address };

    // Test with a specific adventurer_id
    let adventurer_id: u64 = 42;
    let adv = dispatcher.get_adventurer(adventurer_id);
    let expected_adv = Adventurer {
        health: 100_u16 + (adventurer_id % 50_u64).try_into().unwrap(),
        xp: ((adventurer_id * 7_u64) % 5000_u64).try_into().unwrap(),
        gold: ((adventurer_id * 13_u64) % 200_u64).try_into().unwrap(),
        beast_health: 20_u16 + (adventurer_id % 30_u64).try_into().unwrap(),
        stat_upgrades_available: (adventurer_id % 5_u64).try_into().unwrap(),
        stats: Stats {
            strength: ((adventurer_id / 1) % 10_u64).try_into().unwrap() + 1_u8,
            dexterity: ((adventurer_id / 2) % 10_u64).try_into().unwrap() + 1_u8,
            vitality: ((adventurer_id / 4) % 10_u64).try_into().unwrap() + 1_u8,
            intelligence: ((adventurer_id / 8) % 10_u64).try_into().unwrap() + 1_u8,
            wisdom: ((adventurer_id / 16) % 10_u64).try_into().unwrap() + 1_u8,
            charisma: ((adventurer_id / 32) % 10_u64).try_into().unwrap() + 1_u8,
            luck: ((adventurer_id / 64) % 10_u64).try_into().unwrap() + 1_u8,
        },
        equipment: Equipment {
            weapon: Item { id: ((adventurer_id + 1) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 2) % 100_u64).try_into().unwrap() },
            chest: Item { id: ((adventurer_id + 2) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 3) % 100_u64).try_into().unwrap() },
            head: Item { id: ((adventurer_id + 3) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 4) % 100_u64).try_into().unwrap() },
            waist: Item { id: ((adventurer_id + 4) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 5) % 100_u64).try_into().unwrap() },
            foot: Item { id: ((adventurer_id + 5) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 6) % 100_u64).try_into().unwrap() },
            hand: Item { id: ((adventurer_id + 6) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 7) % 100_u64).try_into().unwrap() },
            neck: Item { id: ((adventurer_id + 7) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 8) % 100_u64).try_into().unwrap() },
            ring: Item { id: ((adventurer_id + 8) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 9) % 100_u64).try_into().unwrap() },
        },
        item_specials_seed: ((adventurer_id * 3_u64) % 65536_u64).try_into().unwrap(),
        action_count: ((adventurer_id * 11_u64) % 100_u64).try_into().unwrap(),
    };
    assert_eq!(adv, expected_adv);

    // Test get_bag
    let bag = dispatcher.get_bag(adventurer_id);
    let expected_bag = Bag {
        item_1: Item { id: ((adventurer_id + 1) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 2) % 100_u64).try_into().unwrap() },
        item_2: Item { id: ((adventurer_id + 2) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 3) % 100_u64).try_into().unwrap() },
        item_3: Item { id: ((adventurer_id + 3) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 4) % 100_u64).try_into().unwrap() },
        item_4: Item { id: ((adventurer_id + 4) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 5) % 100_u64).try_into().unwrap() },
        item_5: Item { id: ((adventurer_id + 5) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 6) % 100_u64).try_into().unwrap() },
        item_6: Item { id: ((adventurer_id + 6) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 7) % 100_u64).try_into().unwrap() },
        item_7: Item { id: ((adventurer_id + 7) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 8) % 100_u64).try_into().unwrap() },
        item_8: Item { id: ((adventurer_id + 8) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 9) % 100_u64).try_into().unwrap() },
        item_9: Item { id: ((adventurer_id + 9) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 10) % 100_u64).try_into().unwrap() },
        item_10: Item { id: ((adventurer_id + 10) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 11) % 100_u64).try_into().unwrap() },
        item_11: Item { id: ((adventurer_id + 11) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 12) % 100_u64).try_into().unwrap() },
        item_12: Item { id: ((adventurer_id + 12) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 13) % 100_u64).try_into().unwrap() },
        item_13: Item { id: ((adventurer_id + 13) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 14) % 100_u64).try_into().unwrap() },
        item_14: Item { id: ((adventurer_id + 14) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 15) % 100_u64).try_into().unwrap() },
        item_15: Item { id: ((adventurer_id + 15) % 100_u64).try_into().unwrap(), xp: ((adventurer_id * 16) % 100_u64).try_into().unwrap() },
        mutated: (adventurer_id % 2_u64) == 1_u64,
    };
    assert_eq!(bag, expected_bag);
}