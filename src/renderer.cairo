// SPDX-License-Identifier: MIT
// NFT Renderer for ls2-renderer, replicating death-mountain's metadata logic
use core::array::ArrayTrait;
use ls2_renderer::mock_adventurer::{IMockAdventurerDispatcherTrait, Adventurer, Bag, Equipment, Stats, Item};
use starknet::ContractAddress;
use core::byte_array::ByteArrayTrait;

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

// Helper: Convert u8 to ByteArray
fn u8_to_string(mut n: u8) -> ByteArray {
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

// Helper: Convert Item to string
fn item_to_string(item: Item) -> ByteArray {
    let mut s: ByteArray = "{";
    s += "id:" + u8_to_string(item.id) + ",xp:" + u16_to_string(item.xp) + "}";
    s
}

// Helper: Convert Equipment to string
fn equipment_to_string(e: Equipment) -> ByteArray {
    let mut s: ByteArray = "{";
    s += "weapon:" + item_to_string(e.weapon) + ",";
    s += "chest:" + item_to_string(e.chest) + ",";
    s += "head:" + item_to_string(e.head) + ",";
    s += "waist:" + item_to_string(e.waist) + ",";
    s += "foot:" + item_to_string(e.foot) + ",";
    s += "hand:" + item_to_string(e.hand) + ",";
    s += "neck:" + item_to_string(e.neck) + ",";
    s += "ring:" + item_to_string(e.ring) + "}";
    s
}

// Helper: Convert Bag to string (summary)
fn bag_to_string(bag: Bag) -> ByteArray {
    let mut s: ByteArray = "{";
    s += "mutated:" + bool_to_string(bag.mutated) + ",items:[";
    s += item_to_string(bag.item_1) + ",";
    s += item_to_string(bag.item_2) + ",";
    s += item_to_string(bag.item_3) + ",";
    s += item_to_string(bag.item_4) + ",";
    s += item_to_string(bag.item_5) + ",";
    s += item_to_string(bag.item_6) + ",";
    s += item_to_string(bag.item_7) + ",";
    s += item_to_string(bag.item_8) + ",";
    s += item_to_string(bag.item_9) + ",";
    s += item_to_string(bag.item_10) + ",";
    s += item_to_string(bag.item_11) + ",";
    s += item_to_string(bag.item_12) + ",";
    s += item_to_string(bag.item_13) + ",";
    s += item_to_string(bag.item_14) + ",";
    s += item_to_string(bag.item_15) + "]}";
    s
}

// Helper: Convert Stats to string
fn stats_to_string(stats: Stats) -> ByteArray {
    let mut s: ByteArray = "{";
    s += "strength:" + u8_to_string(stats.strength) + ",";
    s += "dexterity:" + u8_to_string(stats.dexterity) + ",";
    s += "vitality:" + u8_to_string(stats.vitality) + ",";
    s += "intelligence:" + u8_to_string(stats.intelligence) + ",";
    s += "wisdom:" + u8_to_string(stats.wisdom) + ",";
    s += "charisma:" + u8_to_string(stats.charisma) + ",";
    s += "luck:" + u8_to_string(stats.luck) + "}";
    s
}

// Helper: SVG with stats grid
fn svg_image_full(name: ByteArray, adv: Adventurer) -> ByteArray {
    let mut svg: ByteArray = "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400'><rect width='100%' height='100%' fill='black'/>";
    svg += "<text x='50%' y='40' font-size='24' fill='#3DEC00' text-anchor='middle'>" + name + "</text>";
    svg += "<text x='50%' y='70' font-size='16' fill='#3DEC00' text-anchor='middle'>Health: " + u16_to_string(adv.health) + "</text>";
    svg += "<text x='50%' y='90' font-size='16' fill='#3DEC00' text-anchor='middle'>XP: " + u16_to_string(adv.xp) + "</text>";
    svg += "<text x='50%' y='110' font-size='16' fill='#3DEC00' text-anchor='middle'>Gold: " + u16_to_string(adv.gold) + "</text>";
    svg += "<text x='50%' y='130' font-size='16' fill='#3DEC00' text-anchor='middle'>Beast HP: " + u16_to_string(adv.beast_health) + "</text>";
    svg += "<text x='50%' y='150' font-size='16' fill='#3DEC00' text-anchor='middle'>Stat Upgrades: " + u8_to_string(adv.stat_upgrades_available) + "</text>";
    svg += "<text x='50%' y='170' font-size='16' fill='#3DEC00' text-anchor='middle'>Action Count: " + u16_to_string(adv.action_count) + "</text>";
    svg += "<text x='50%' y='190' font-size='16' fill='#3DEC00' text-anchor='middle'>Item Specials Seed: " + u16_to_string(adv.item_specials_seed) + "</text>";
    svg += "<text x='50%' y='220' font-size='14' fill='#3DEC00' text-anchor='middle'>Stats: STR " + u8_to_string(adv.stats.strength) + ", DEX " + u8_to_string(adv.stats.dexterity) + ", VIT " + u8_to_string(adv.stats.vitality) + ", INT " + u8_to_string(adv.stats.intelligence) + ", WIS " + u8_to_string(adv.stats.wisdom) + ", CHA " + u8_to_string(adv.stats.charisma) + ", LUCK " + u8_to_string(adv.stats.luck) + "</text>";
    svg += "</svg>";
    svg
}

// Base64 encoding utilities (adapted from death-mountain)
fn get_base64_char_set() -> Array<u8> {
    array![
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        'Q','R','S','T','U','V','W','X','Y','Z',
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','x','y','z',
        '0','1','2','3','4','5','6','7','8','9','+','/'
    ]
}

// Helper: Extract u8 from Option<u8> or panic
fn get_u8(opt: Option<u8>) -> u8 {
    match opt {
        Option::Some(val) => val,
        Option::None(_) => panic!("ByteArray out of bounds"),
    }
}

fn bytes_base64_encode(mut bytes: ByteArray) -> ByteArray {
    let base64_chars = get_base64_char_set();
    let mut result: ByteArray = Default::default();
    if ByteArrayTrait::len(@bytes) == 0 {
        return result;
    }
    let mut p: u8 = 0;
    let c = ByteArrayTrait::len(@bytes) % 3;
    if c == 1 {
        p = 2;
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
    } else if c == 2 {
        p = 1;
        ByteArrayTrait::append_byte(ref bytes, 0_u8);
    }
    let mut i = 0;
    let bytes_len = ByteArrayTrait::len(@bytes);
    let last_iteration = bytes_len - 3;
    loop {
        if i == bytes_len {
            break;
        }
        let b0: u32 = get_u8(ByteArrayTrait::at(@bytes, i)).into();
        let b1: u32 = get_u8(ByteArrayTrait::at(@bytes, i + 1)).into();
        let b2: u32 = get_u8(ByteArrayTrait::at(@bytes, i + 2)).into();
        let n: u32 = b0 * 65536 + b1 * 256 + b2;
        let e1 = (n / 262144) & 63;
        let e2 = (n / 4096) & 63;
        let e3 = (n / 64) & 63;
        let e4 = n & 63;
        if i == last_iteration {
            if p == 2 {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, 61);
                ByteArrayTrait::append_byte(ref result, 61);
            } else if p == 1 {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
                ByteArrayTrait::append_byte(ref result, 61);
            } else {
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
                ByteArrayTrait::append_byte(ref result, *base64_chars.at(e4));
            }
        } else {
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e1));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e2));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e3));
            ByteArrayTrait::append_byte(ref result, *base64_chars.at(e4));
        }
        i += 3;
    };
    result
}

// Helper: JSON metadata (expanded)
fn json_metadata(adventurer_id: u64, name: ByteArray, svg: ByteArray, adv: Adventurer, bag: Bag) -> ByteArray {
    let image = "data:image/svg+xml;base64," + bytes_base64_encode(svg);
    let mut json: ByteArray = "{";
    json += "\"name\":\"" + name + "\",";
    json += "\"description\":\"On-chain NFT Adventurer\",";
    json += "\"image\":\"" + image + "\",";
    json += "\"attributes\":[";
    json += "{\"trait_type\":\"Health\",\"value\":\"" + u16_to_string(adv.health) + "\"},";
    json += "{\"trait_type\":\"XP\",\"value\":\"" + u16_to_string(adv.xp) + "\"},";
    json += "{\"trait_type\":\"Gold\",\"value\":\"" + u16_to_string(adv.gold) + "\"},";
    json += "{\"trait_type\":\"Beast Health\",\"value\":\"" + u16_to_string(adv.beast_health) + "\"},";
    json += "{\"trait_type\":\"Stat Upgrades Available\",\"value\":\"" + u8_to_string(adv.stat_upgrades_available) + "\"},";
    json += "{\"trait_type\":\"Action Count\",\"value\":\"" + u16_to_string(adv.action_count) + "\"},";
    json += "{\"trait_type\":\"Item Specials Seed\",\"value\":\"" + u16_to_string(adv.item_specials_seed) + "\"},";
    json += "{\"trait_type\":\"Stats\",\"value\":\"" + stats_to_string(adv.stats) + "\"},";
    json += "{\"trait_type\":\"Equipment\",\"value\":\"" + equipment_to_string(adv.equipment) + "\"},";
    json += "{\"trait_type\":\"Bag\",\"value\":\"" + bag_to_string(bag) + "\"}";
    json += "]}";
    json
}

pub impl RendererImpl of Renderer {
    fn render(token_id: u256, mock_adventurer_addr: ContractAddress) -> ByteArray {
        let adventurer_id = u256_to_u64(token_id);
        let mut dispatcher = ls2_renderer::mock_adventurer::IMockAdventurerDispatcher { contract_address: mock_adventurer_addr };
        let adv = dispatcher.get_adventurer(adventurer_id);
        let bag = dispatcher.get_bag(adventurer_id);
        let name = adventurer_name(adventurer_id);
        let svg = svg_image_full(name.clone(), adv);
        json_metadata(adventurer_id, name, svg, adv, bag)
    }
}