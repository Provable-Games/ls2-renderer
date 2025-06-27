// SPDX-License-Identifier: MIT
// Mock Adventurer contract for SVG metadata rendering

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Item {
    pub id: u8,
    pub xp: u16,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Equipment {
    pub weapon: Item,
    pub chest: Item,
    pub head: Item,
    pub waist: Item,
    pub foot: Item,
    pub hand: Item,
    pub neck: Item,
    pub ring: Item,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Stats {
    pub strength: u8,
    pub dexterity: u8,
    pub vitality: u8,
    pub intelligence: u8,
    pub wisdom: u8,
    pub charisma: u8,
    pub luck: u8,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Adventurer {
    pub health: u16,
    pub xp: u16,
    pub gold: u16,
    pub beast_health: u16,
    pub stat_upgrades_available: u8,
    pub stats: Stats,
    pub equipment: Equipment,
    pub item_specials_seed: u16,
    pub action_count: u16,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Bag {
    pub item_1: Item,
    pub item_2: Item,
    pub item_3: Item,
    pub item_4: Item,
    pub item_5: Item,
    pub item_6: Item,
    pub item_7: Item,
    pub item_8: Item,
    pub item_9: Item,
    pub item_10: Item,
    pub item_11: Item,
    pub item_12: Item,
    pub item_13: Item,
    pub item_14: Item,
    pub item_15: Item,
    pub mutated: bool,
}

#[starknet::interface]
pub trait IMockAdventurer<T> {
    fn get_adventurer(self: @T, adventurer_id: u64) -> Adventurer;
    fn get_bag(self: @T, adventurer_id: u64) -> Bag;
}

#[starknet::contract]
pub mod mock_adventurer {
    use super::{Adventurer, Bag, Item, Equipment, Stats};
    use super::IMockAdventurer;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl MockAdventurerImpl of IMockAdventurer<ContractState> {
        fn get_adventurer(self: @ContractState, adventurer_id: u64) -> Adventurer {
            Adventurer {
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
            }
        }
        fn get_bag(self: @ContractState, adventurer_id: u64) -> Bag {
            Bag {
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
            }
        }
    }
} 