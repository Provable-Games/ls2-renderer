// #[starknet::contract]
// pub mod beasts_nft {
//     use openzeppelin_access::ownable::OwnableComponent;
//     use openzeppelin_introspection::src5::SRC5Component;
//     use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};
//     use openzeppelin_token::erc721::interface::{IERC721Metadata};
//     use starknet::{ContractAddress, storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess}};

//     component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
//     component!(path: ERC721Component, storage: erc721, event: ERC721Event);
//     component!(path: SRC5Component, storage: src5, event: SRC5Event);

//     // Ownable Mixin
//     #[abi(embed_v0)]
//     impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
//     impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

//     // ERC721 Implementation
//     #[abi(embed_v0)]
//     impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
//     #[abi(embed_v0)]
//     impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
//     impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

//     // SRC5 Implementation
//     #[abi(embed_v0)]
//     impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

//     #[storage]
//     pub struct Storage {
//         #[substorage(v0)]
//         pub ownable: OwnableComponent::Storage,
//         #[substorage(v0)]
//         pub erc721: ERC721Component::Storage,
//         #[substorage(v0)]
//         pub src5: SRC5Component::Storage,
//         // Beast-specific storage
//         pub beast_type: Map<u256, felt252>,
//         pub beast_level: Map<u256, u8>,
//         pub beast_health: Map<u256, u16>,
//         pub beast_attack: Map<u256, u16>,
//         pub beast_defense: Map<u256, u16>,
//     }

//     #[event]
//     #[derive(Drop, starknet::Event)]
//     enum Event {
//         #[flat]
//         OwnableEvent: OwnableComponent::Event,
//         #[flat]
//         ERC721Event: ERC721Component::Event,
//         #[flat]
//         SRC5Event: SRC5Component::Event,
//     }

//     /// Assigns `owner` as the contract owner.
//     /// Sets the token `name` and `symbol`.
//     /// Mints the `token_ids` tokens to `recipient` and sets
//     /// the base URI.
//     #[constructor]
//     fn constructor(
//         ref self: ContractState,
//         name: ByteArray,
//         symbol: ByteArray,
//         base_uri: ByteArray,
//         recipient: ContractAddress,
//         token_ids: Span<u256>,
//         owner: ContractAddress,
//     ) {
//         self.ownable.initializer(owner);
//         self.erc721.initializer(name, symbol, base_uri);
//         self.mint_assets(recipient, token_ids);
//     }

//     #[generate_trait]
//     pub(crate) impl InternalImpl of InternalTrait {
//         /// Mints `token_ids` to `recipient`.
//         fn mint_assets(
//             ref self: ContractState, recipient: ContractAddress, mut token_ids: Span<u256>,
//         ) {
//             loop {
//                 if token_ids.len() == 0 {
//                     break;
//                 }
//                 let id = *token_ids.pop_front().unwrap();
//                 self.erc721.mint(recipient, id);
                
//                 // Initialize beast attributes (example values)
//                 self.beast_type.entry(id).write('Dragon');
//                 self.beast_level.entry(id).write(1);
//                 self.beast_health.entry(id).write(100);
//                 self.beast_attack.entry(id).write(50);
//                 self.beast_defense.entry(id).write(30);
//             }
//         }
//     }

//     // Custom ERC721Metadata Implementation
//     #[abi(embed_v0)]
//     impl ERC721Metadata of IERC721Metadata<ContractState> {
//         fn name(self: @ContractState) -> ByteArray {
//             self.erc721.name()
//         }

//         fn symbol(self: @ContractState) -> ByteArray {
//             self.erc721.symbol()
//         }

//         fn token_uri(self: @ContractState, token_id: u256) -> ByteArray {
//             self.erc721._require_owned(token_id);
            
//             // Get beast attributes
//             let beast_type = self.beast_type.entry(token_id).read();
//             let beast_level = self.beast_level.entry(token_id).read();
//             let beast_health = self.beast_health.entry(token_id).read();
//             let beast_attack = self.beast_attack.entry(token_id).read();
//             let beast_defense = self.beast_defense.entry(token_id).read();
            
//             // Generate metadata similar to Dark Shuffle pattern
//             self.create_metadata(token_id, beast_type, beast_level, beast_health, beast_attack, beast_defense)
//         }
//     }

//     #[generate_trait]
//     impl MetadataImpl of MetadataTrait {
//         /// Creates metadata JSON string for a beast
//         fn create_metadata(
//             self: @ContractState,
//             token_id: u256,
//             beast_type: felt252,
//             level: u8,
//             health: u16,
//             attack: u16,
//             defense: u16
//         ) -> ByteArray {
//             let mut metadata: ByteArray = "{\"name\":\"Beast #";
//             metadata.append(@format!("{}", token_id));
//             metadata.append(@"\",\"description\":\"A fearsome beast from the Loot Survivor universe\",");
//             metadata.append(@"\"attributes\":[");
            
//             // Beast type attribute
//             metadata.append(@"{\"trait_type\":\"Type\",\"value\":\"");
//             metadata.append(@format!("{}", beast_type));
//             metadata.append(@"\"},");
            
//             // Level attribute
//             metadata.append(@"{\"trait_type\":\"Level\",\"value\":");
//             metadata.append(@format!("{}", level));
//             metadata.append(@"},");
            
//             // Health attribute
//             metadata.append(@"{\"trait_type\":\"Health\",\"value\":");
//             metadata.append(@format!("{}", health));
//             metadata.append(@"},");
            
//             // Attack attribute
//             metadata.append(@"{\"trait_type\":\"Attack\",\"value\":");
//             metadata.append(@format!("{}", attack));
//             metadata.append(@"},");
            
//             // Defense attribute
//             metadata.append(@"{\"trait_type\":\"Defense\",\"value\":");
//             metadata.append(@format!("{}", defense));
//             metadata.append(@"}");
            
//             metadata.append(@"]}");
            
//             metadata
//         }
//     }


// }