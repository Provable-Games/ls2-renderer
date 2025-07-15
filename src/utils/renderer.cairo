// SPDX-License-Identifier: MIT
// NFT Renderer for ls2-renderer, restructured based on death-mountain implementation
use ls2_renderer::mocks::mock_adventurer::{
    IMockAdventurerDispatcherTrait, IMockAdventurerDispatcher,
};
use ls2_renderer::mocks::mock_beast::{IMockBeastDispatcherTrait, IMockBeastDispatcher};
use ls2_renderer::utils::renderer_utils::{create_metadata};
use starknet::ContractAddress;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(
        token_id: u256, mock_adventurer_addr: ContractAddress, mock_beast_addr: ContractAddress,
    ) -> ByteArray;
}

// Helper: Convert u256 to u64 (for adventurer_id)
fn u256_to_u64(val: u256) -> u64 {
    // Only use the low 64 bits for mock id
    val.low.try_into().unwrap()
}


pub impl RendererImpl of Renderer {
    fn render(
        token_id: u256, mock_adventurer_addr: ContractAddress, mock_beast_addr: ContractAddress,
    ) -> ByteArray {
        let adventurer_id = u256_to_u64(token_id);
        let mut adv_dispatcher = IMockAdventurerDispatcher {
            contract_address: mock_adventurer_addr,
        };
        let mut beast_dispatcher = IMockBeastDispatcher { contract_address: mock_beast_addr };

        let adv = adv_dispatcher.get_adventurer(adventurer_id);
        let bag = adv_dispatcher.get_bag(adventurer_id);
        let adventurer_name = adv_dispatcher.get_adventurer_name(adventurer_id);

        // Get beast data for battle interface
        let beast_id = (adventurer_id % 16).try_into().unwrap(); // Cycle through 16 beast types
        let beast = beast_dispatcher.get_beast(beast_id);
        let beast_name = beast_dispatcher.get_beast_name(beast_id);

        create_metadata(adventurer_id, adv, adventurer_name, bag, beast, beast_name)
    }
}
