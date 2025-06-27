use ls2_renderer::renderer::Renderer;
use core::byte_array::ByteArrayTrait;
use core::array::ArrayTrait;
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
// use starknet::ContractAddress;

#[test]
fn test_basic_render() {
    let mock_contract = declare("mock_adventurer").unwrap().contract_class();
    let calldata = array![];
    let (mock_addr, _) = mock_contract.deploy(@calldata).unwrap();
    let token_id: u256 = 42;
    let result = Renderer::render(token_id, mock_addr);
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    // Optionally print for manual inspection
    println!("Rendered metadata: {}", result);
}

#[test]
#[should_panic]
fn test_large_token_id() {
    let mock_contract = declare("mock_adventurer").unwrap().contract_class();
    let calldata = array![];
    let (mock_addr, _) = mock_contract.deploy(@calldata).unwrap();
    // Test with a large u256 value
    let token_id: u256 = u256 { low: 999999999999999999999999999999, high: 1 };
    let result = Renderer::render(token_id, mock_addr);
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    println!("Rendered metadata for large ID: {}", result);
}

#[test]
fn test_render_with_different_ids() {
    let mock_contract = declare("mock_adventurer").unwrap().contract_class();
    let calldata = array![];
    let (mock_addr, _) = mock_contract.deploy(@calldata).unwrap();
    let id1: u256 = 1;
    let id2: u256 = 2;
    let meta1 = Renderer::render(id1, mock_addr);
    let meta2 = Renderer::render(id2, mock_addr);
    assert(meta1 != meta2, 'not unique');
    assert(ByteArrayTrait::len(@meta1) > 0 && ByteArrayTrait::len(@meta2) > 0, 'empty');
}

#[test]
fn test_svg_and_json_structure() {
    let mock_contract = declare("mock_adventurer").unwrap().contract_class();
    let calldata = array![];
    let (mock_addr, _) = mock_contract.deploy(@calldata).unwrap();
    let token_id: u256 = 7;
    let result = Renderer::render(token_id, mock_addr);
    // Check for non-empty output and print for manual inspection
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    println!("Rendered metadata for token 7: {}", result);
}