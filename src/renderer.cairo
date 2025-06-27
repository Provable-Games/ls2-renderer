// SPDX-License-Identifier: MIT
// NFT Renderer for ls2-renderer, replicating death-mountain's metadata logic
use core::array::ArrayTrait;
use ls2_renderer::mock_adventurer::{IMockAdventurerDispatcherTrait, Adventurer, Bag};
use starknet::ContractAddress;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray;
}

// Helper: Convert u256 to u64 (for adventurer_id)
fn u256_to_u64(val: u256) -> u64 {
    // Only use the low 64 bits for mock id
    val.low.try_into().unwrap()
}

// Helper: Deterministic name
fn adventurer_name(adventurer_id: u64) -> ByteArray {
    let mut name: ByteArray = "Adventurer #";
    name += u64_to_string(adventurer_id);
    name
}

// Helper: Convert u64 to ByteArray
fn u64_to_string(mut n: u64) -> ByteArray {
    let mut out: ByteArray = Default::default();
    if n == 0 {
        out.append_byte('0');
        return out;
    }
    let mut digits: Array<u8> = ArrayTrait::new();
    loop {
        if n == 0 { break; }
        digits.append((n % 10).try_into().unwrap() + '0');
        n = n / 10;
    };
    let mut i = digits.len();
    loop {
        if i == 0 { break; }
        i -= 1;
        out.append_byte(*digits[i]);
    };
    out
}

// Helper: Convert u16 to ByteArray
fn u16_to_string(mut n: u16) -> ByteArray {
    let mut out: ByteArray = Default::default();
    if n == 0 {
        out.append_byte('0');
        return out;
    }
    let mut digits: Array<u8> = ArrayTrait::new();
    loop {
        if n == 0 { break; }
        digits.append((n % 10).try_into().unwrap() + '0');
        n = n / 10;
    };
    let mut i = digits.len();
    loop {
        if i == 0 { break; }
        i -= 1;
        out.append_byte(*digits[i]);
    };
    out
}

// Helper: Convert bool to ByteArray
fn bool_to_string(b: bool) -> ByteArray {
    if b { "true" } else { "false" }
}

// Helper: Simple SVG (placeholder, can be expanded)
fn svg_image(name: ByteArray) -> ByteArray {
    "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400'><rect width='100%' height='100%' fill='black'/><text x='50%' y='50%' font-size='24' fill='#3DEC00' text-anchor='middle' dominant-baseline='middle'>" + name + "</text></svg>"
}

// Helper: JSON metadata (no base64 for simplicity)
fn json_metadata(adventurer_id: u64, name: ByteArray, svg: ByteArray, adv: Adventurer, bag: Bag) -> ByteArray {
    let image = svg; // In production, base64 encode and prefix as data:image/svg+xml;base64,
    let mut json: ByteArray = "{";
    json += "\"name\":\"" + name + "\",";
    json += "\"description\":\"On-chain NFT Adventurer\",";
    json += "\"image\":\"" + image + "\",";
    json += "\"attributes\":[";
    // Example attributes (expand as needed)
    json += "{\"trait_type\":\"Health\",\"value\":\"" + u16_to_string(adv.health) + "\"},";
    json += "{\"trait_type\":\"XP\",\"value\":\"" + u16_to_string(adv.xp) + "\"},";
    json += "{\"trait_type\":\"Gold\",\"value\":\"" + u16_to_string(adv.gold) + "\"},";
    json += "{\"trait_type\":\"Bag Mutated\",\"value\":\"" + bool_to_string(bag.mutated) + "\"}";
    json += "]}";
    // In production, base64 encode and prefix as data:application/json;base64,
    json
}

pub impl RendererImpl of Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray {
        let adventurer_id = u256_to_u64(token_id);
        let mut dispatcher = ls2_renderer::mock_adventurer::IMockAdventurerDispatcher { contract_address: mock_adventurer_addr };
        let adv = dispatcher.get_adventurer(adventurer_id);
        let bag = dispatcher.get_bag(adventurer_id);
        let name = adventurer_name(adventurer_id);
        let svg = svg_image(name.clone());
        json_metadata(adventurer_id, name, svg, adv, bag)
    }
}