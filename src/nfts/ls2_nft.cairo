// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v2.0.0 (presets/src/erc721.cairo)

/// # ERC721 Preset
///
/// The upgradeable ERC721 contract offers a batch-mint mechanism that
/// can only be executed once upon contract construction.
///
/// For more complex or custom contracts, use Wizard for Cairo
/// https://wizard.openzeppelin.com/cairo
/// 

use starknet::ContractAddress;

#[starknet::interface]
pub trait IOpenMint<T> {
    fn mint(ref self: T, recipient: ContractAddress);
}

#[starknet::contract]
pub mod ls2_nft {
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_token::erc721::interface::IERC721Metadata;

    use starknet::{ContractAddress};
    use super::IOpenMint;

    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    use ls2_renderer::utils::renderer::Renderer;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage,
        pub token_counter: u256,
        pub mock_adventurer_address: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
    }

    /// Assigns `owner` as the contract owner.
    /// Sets the token `name` and `symbol`.
    /// Mints the `token_ids` tokens to `recipient` and sets
    /// the base URI.
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        mock_adventurer_address: ContractAddress,
    ) {
        self.erc721.initializer(name, symbol, base_uri);
        self.mock_adventurer_address.write(mock_adventurer_address);
    }

    #[abi(embed_v0)]
    impl OpenMintImpl of IOpenMint<ContractState> {
        fn mint(
            ref self: ContractState,
            recipient: ContractAddress,
        ) {
            let current_id = self.token_counter.read();
            let new_token_id = current_id + 1;
            self.token_counter.write(new_token_id);
            self.erc721.mint(recipient, new_token_id);
        }
    }

    /// Set the mock adventurer contract address (admin only)
    /// For testing purposes only
    #[external(v0)]
    fn set_mock_adventurer_address(ref self: ContractState, addr: ContractAddress) {
        // TODO: add onlyOwner or admin check
        self.mock_adventurer_address.write(addr);
    }

    #[abi(embed_v0)]
    impl ERC721Metadata of IERC721Metadata<ContractState> {
        /// Returns the NFT name.
        fn name(self: @ContractState) -> ByteArray {
            self.erc721.ERC721_name.read()
        }

        /// Returns the NFT symbol.
        fn symbol(self: @ContractState) -> ByteArray {
            self.erc721.ERC721_symbol.read()
        }

        /// Returns the Uniform Resource Identifier (URI) for the `token_id` token.
        /// If the URI is not set, the return value will be an empty ByteArray.
        ///
        /// Requirements:
        ///
        /// - `token_id` exists.
        fn token_uri(self: @ContractState, token_id: u256) -> ByteArray {
            self.erc721._require_owned(token_id);
            let mock_addr = self.mock_adventurer_address.read();
            Renderer::render(token_id, mock_addr)
        }
    }
}