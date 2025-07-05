// SPDX-License-Identifier: MIT
// NFT Renderer for ls2-renderer, restructured based on death-mountain implementation
use ls2_renderer::mocks::mock_adventurer::{IMockAdventurerDispatcherTrait, IMockAdventurerDispatcher};
use ls2_renderer::utils::renderer_utils::create_metadata;
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




pub impl RendererImpl of Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray {
        let adventurer_id = u256_to_u64(token_id);
        let mut dispatcher = IMockAdventurerDispatcher { contract_address: mock_adventurer_addr };
        let adv = dispatcher.get_adventurer(adventurer_id);
        let bag = dispatcher.get_bag(adventurer_id);
        
        // Use dynamic adventurer name from mock contract (matching death-mountain pattern)
        let adventurer_name = dispatcher.get_adventurer_name(adventurer_id);
        create_metadata(adventurer_id, adv, adventurer_name, bag)
    }
}