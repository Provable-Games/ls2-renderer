use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Item};
use ls2_renderer::utils::encoding::{U256BytesUsedTraitImpl, bytes_base64_encode};

// @notice Generates the LS logo svg
// @return The generated LS logo
fn logo() -> ByteArray {
    "<path d=\"M1 2V0h8v2h1v10H7v4H3v-4H0V2zm1 4v4h2v2h2v-2h2V6H6v4H4V6z\"/>"
}

// @notice Generates the crown icon used for top scores
// @return The generated crown icon
fn crown() -> ByteArray {
    "<path d=\"M0 0v7h15V0h-1v1h-1v1h-1v1h-2V2H9V1H8V0H7v1H6v1H5v1H3V2H2V1H1V0H0Z\"/>"
}

// @notice Generates the weapon icon svg
// @return The generated weapon icon
fn weapon() -> ByteArray {
    "<path d=\"M8 4V3H6V2H5V1H3v2H2v2H1v1h2V5h2v2H4v2H3v2H2v2H1v2H0v2h2v-2h1v-2h1v-2h1V9h1V7h2v5h2v-2h1V8h1V6h1V4H8Z\"/>"
}

// @notice Generates the chest icon svg
// @return The generated chest icon
fn chest() -> ByteArray {
    "<path d=\"M0 8h2V7H0v1Zm3-3V2H2v1H1v2H0v1h4V5H3Zm2-4H4v4h1V1Zm6 0v4h1V1h-1Zm4 4V3h-1V2h-1v3h-1v1h4V5h-1Zm-1 3h2V7h-2v1ZM9 7H7V6H4v1H3v4h4v-1h2v1h4V7h-1V6H9v1Zm1 6v1h1v2h1v-2h1v-2H9v1h1Zm-3-1h2v-1H7v1Zm0 1v-1H3v2h1v2h1v-2h1v-1h1Zm2 0H7v1H6v2h4v-2H9v-1Z\" />"
}

// @notice Generates the head icon svg
// @return The generated head icon
fn head() -> ByteArray {
    "<path d=\"M12 2h-1V1h-1V0H6v1H5v1H4v1H3v8h1v1h2V8H5V7H4V5h3v4h2V5h3v2h-1v1h-1v4h2v-1h1V3h-1V2ZM2 2V1H1V0H0v2h1v2h1v1-2h1V2H2Zm13-2v1h-1v1h-1v1h1v2-1h1V2h1V0h-1Z\"/>"
}

// @notice Generates the waist icon svg
// @return The generated waist icon
fn waist() -> ByteArray {
    "<path d=\"M0 13h2v-1H0v1Zm0-2h3v-1H0v1Zm1-7H0v5h3V8h2V3H1v1Zm0-2h4V0H1v2Zm5 0h1V1h1v1h1V0H6v2Zm8-2h-4v2h4V0Zm0 4V3h-4v5h2v1h3V4h-1Zm-2 7h3v-1h-3v1Zm1 2h2v-1h-2v1ZM6 9h1v1h1V9h1V3H6v6Z\"/>"
}

// @notice Generates the foot icon svg
// @return The generated foot icon
fn foot() -> ByteArray {
    "<path d=\"M4 1V0H0v2h5V1H4Zm2-1H5v1h1V0Zm0 2H5v1h1V2Zm0 2V3H5v1h1Zm0 2V5H5v1h1Zm0 2V7H5v1h1Zm5 0V7H9v1h2Zm0-2V5H9v1h2Zm0-2V3H9v1h2Zm0-2H9v1h2V2Zm0-2H9v1h2V0ZM8 1V0H7v2h2V1H8Zm0 6h1V6H8V5h1V4H8V3h1-2v5h1V7ZM6 9V8H4V7h1V6H4V5h1V4H4V3h1-5v8h5V9h1Zm5 0h-1V8H7v1H6v2H5v1h6V9ZM0 13h5v-1H0v1Zm11 0v-1H5v1h6Zm1 0h4v-1h-4v1Zm3-3V9h-1V8h-2v1h-1v1h1v2h4v-2h-1Zm-4-2v1-1Z\"/>"
}

// @notice Generates the hand icon svg
// @return The generated hand icon
fn hand() -> ByteArray {
    "<path d=\"M9 8v1H8v3H4v-1h3V2H6v7H5V1H4v8H3V2H2v8H1V5H0v10h1v2h5v-1h2v-1h1v-2h1V8H9Z\"/>"
}

// @notice Generates the neck icon svg
// @return The generated neck icon
fn neck() -> ByteArray {
    "<path d=\"M14 8V6h-1V5h-1V4h-1V3h-1V2H8V1H2v1H1v1H0v8h1v1h1v1h4v-1h1v-1H3v-1H2V4h1V3h4v1h2v1h1v1h1v1h1v1h1v1h-2v1h1v1h2v-1h1V8h-1Zm-6 3v1h1v-1H8Zm1 0h2v-1H9v1Zm4 3v-2h-1v2h1Zm-6-2v2h1v-2H7Zm2 4h2v-1H9v1Zm-1-2v1h1v-1H8Zm3 1h1v-1h-1v1Zm0-3h1v-1h-1v1Zm-2 2h2v-2H9v2Z\"/>"
}

// @notice Generates the ring icon svg
// @return The generated ring icon
fn ring() -> ByteArray {
    "<path d=\"M13 3V2h-1V1h-2v1h1v3h-1v2H9v1H8v1H7v1H6v1H4v1H1v-1H0v2h1v1h1v1h4v-1h2v-1h1v-1h1v-1h1v-1h1V9h1V7h1V3h-1ZM3 9h1V8h1V7h1V6h1V5h1V4h2V2H9V1H8v1H6v1H5v1H4v1H3v1H2v1H1v2H0v1h1v1h2V9Z\"/>"
}

// @notice Generates a rect element
// @return The generated rect element
fn create_rect() -> ByteArray {
    "<rect x='0.5' y='0.5' width='599' height='899' rx='27.5' fill='black' stroke='#3DEC00'/>"
}

// @notice Generates a text element
// @param text The text to generate a string for
// @param x The x coordinate of the text
// @param y The y coordinate of the text
// @param fontsize The font size of the text
// @param baseline The baseline of the text
// @param text_anchor The text anchor of the text
// @return The generated text element
fn create_text(
    text: ByteArray, x: ByteArray, y: ByteArray, fontsize: ByteArray, baseline: ByteArray, text_anchor: ByteArray,
) -> ByteArray {
    "<text x='"
        + x
        + "' y='"
        + y
        + "' font-size='"
        + fontsize
        + "' text-anchor='"
        + text_anchor
        + "' dominant-baseline='"
        + baseline
        + "'>"
        + text
        + "</text>"
}

fn create_item_element(x: ByteArray, y: ByteArray, item: ByteArray) -> ByteArray {
    "<g transform='translate(" + x + "," + y + ") scale(1.5)'>" + item + "</g>"
}

// @notice Combines elements into a single string
// @param elements The elements to combine
// @return The combined elements
fn combine_elements(ref elements: Span<ByteArray>) -> ByteArray {
    let mut count: u8 = 1;

    let mut combined: ByteArray = "";
    loop {
        match elements.pop_front() {
            Option::Some(element) => {
                combined += element.clone();

                count += 1;
            },
            Option::None(()) => { break; },
        }
    };

    combined
}

// @notice Generates an SVG string for adventurer token uri
// @param internals The internals of the SVG
// @return The generated SVG string
fn create_svg(internals: ByteArray) -> ByteArray {
    "<svg xmlns='http://www.w3.org/2000/svg' width='600' height='900'><style>text{text-transform: uppercase;font-family: Courier, monospace;fill: #3DEC00;}g{fill: #3DEC00;}</style>"
        + internals
        + "</svg>"
}

// @notice Generates an item string for adventurer token uri
// @param item The item to generate a string for
// @param bag Whether the item is in the bag or not
// @return The generated item string
fn generate_item(item: Item, bag: bool) -> ByteArray {
    if item.id == 0 {
        if (bag) {
            return "Empty";
        } else {
            return "None Equipped";
        }
    }

    // Simplified greatness calculation - using XP/10 as greatness
    let greatness = item.xp / 10;
    let item_name = format!("Item{}", item.id);

    format!("G{} {} ", greatness, item_name)
}

fn generate_logo() -> ByteArray {
    "<g transform='translate(25,25) scale(4)'>" + logo() + "</g>"
}

// @notice Generates the shinobi SVG template with dynamic substitution
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @return The generated shinobi SVG with dynamic values
fn create_shinobi_svg(adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag) -> ByteArray {
    let mut _name = Default::default();
    _name.append_word(adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into());

    let _level = format!("{}", (adventurer.xp / 100) + 1);
    let _str = format!("{}", adventurer.stats.strength);
    let _dex = format!("{}", adventurer.stats.dexterity);
    let _int = format!("{}", adventurer.stats.intelligence);
    let _vit = format!("{}", adventurer.stats.vitality);
    let _wis = format!("{}", adventurer.stats.wisdom);
    let _cha = format!("{}", adventurer.stats.charisma);
    let _luck = format!("{}", adventurer.stats.luck);
    let _health = format!("{}", adventurer.health);
    let _max_health = format!("{}", 100); // Using 100 as max health for display
    let _xp = format!("{}", adventurer.xp);

    // Generate equipped item names for inventory slots
    let _weapon_name = generate_item(adventurer.equipment.weapon, false);
    let _chest_name = generate_item(adventurer.equipment.chest, false);
    let _head_name = generate_item(adventurer.equipment.head, false);
    let _waist_name = generate_item(adventurer.equipment.waist, false);
    let _foot_name = generate_item(adventurer.equipment.foot, false);
    let _hand_name = generate_item(adventurer.equipment.hand, false);
    let _neck_name = generate_item(adventurer.equipment.neck, false);
    let _ring_name = generate_item(adventurer.equipment.ring, false);

    // Create the complete multi-page SVG with dynamic values (optimized structure)
    let mut svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"550\" viewBox=\"0 0 400 550\"><defs><filter id=\"s\"><feDropShadow dx=\"0\" dy=\"10\" flood-opacity=\".3\" stdDeviation=\"10\"/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{font-family:&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}</style></defs><g id=\"slideContainer\"><g id=\"page1\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"m92 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H92v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H94V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#78E846\" font-size=\"14\"><text x=\"130\" y=\"70\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">";
    svg += _name.clone();
    svg += "</text><text x=\"250\" y=\"70\" font-size=\"12\">LEVEL ";
    svg += _level.clone();
    svg += "</text><text x=\"40\" y=\"100\" font-size=\"14\">STR</text><text x=\"40\" y=\"120\" font-size=\"20\">";
    svg += _str;
    svg += "</text><text x=\"40\" y=\"150\" font-size=\"14\">DEX</text><text x=\"40\" y=\"170\" font-size=\"20\">";
    svg += _dex;
    svg += "</text><text x=\"40\" y=\"200\" font-size=\"14\">INT</text><text x=\"40\" y=\"220\" font-size=\"20\">";
    svg += _int;
    svg += "</text><text x=\"40\" y=\"250\" font-size=\"14\">HIT</text><text x=\"40\" y=\"270\" font-size=\"20\">";
    svg += _vit;
    svg += "</text><text x=\"40\" y=\"300\" font-size=\"14\">WIS</text><text x=\"40\" y=\"320\" font-size=\"20\">";
    svg += _wis;
    svg += "</text><text x=\"40\" y=\"350\" font-size=\"14\">CHA</text><text x=\"40\" y=\"370\" font-size=\"20\">";
    svg += _cha;
    svg += "</text><text x=\"40\" y=\"400\" font-size=\"14\">LUCK</text><text x=\"40\" y=\"420\" font-size=\"20\">";
    svg += _luck;
    svg += "</text><text x=\"90\" y=\"160\" font-size=\"12\">INVENTORY</text><text x=\"90\" y=\"135\" font-size=\"12\">";
    svg += _health;
    svg += "/";
    svg += _max_health;
    svg += " HP</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 115h200v8H90z\"/><path fill=\"#78E846\" d=\"M91 116h160v6H91z\"/><rect width=\"50\" height=\"25\" x=\"320\" y=\"55\" fill=\"#E8A746\" rx=\"4\"/><text x=\"330\" y=\"70\" fill=\"#2C1A0A\" font-size=\"14\">";
    svg += _xp.clone();
    svg += "</text><text x=\"325\" y=\"50\" fill=\"#E8A746\" font-size=\"10\">XP</text>";
    svg += "<path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 180h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40zM90 250h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40z\"/><path fill=\"#78E846\" d=\"M95 190h2v20h-2m-2-20h6v4h-6zm1 20h4v4h-4zm61-20h20v15h-20zm5 15h10v8h-10zm55-5h20v15h-20m5-20h10v8h-10zm55 2h20v4h-20m5-8h2v16h-2zm8 2h4v8h-4M95 260h2v20h-2zm3 3h12v2H98zm0 10h12v2H98zm12-8h2v8h-2zm50-2h10v16h-10m2-18h6v4h-6zm53 9h8v10h-8zm12 0h8v10h-8m-12-13h20v6h-20zm63-4h14v14h-14zm-153-78h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm-180 70h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8z\"/><path fill=\"#2C1A0A\" d=\"M217 205h4v6h-4zm-54 60h4v8h-4zm119 2h6v6h-6z\"/><g fill=\"#78E846\" font-size=\"8\"><text x=\"95\" y=\"230\">";
    svg += _weapon_name;
    svg += "</text><text x=\"155\" y=\"230\">";
    svg += _chest_name;
    svg += "</text><text x=\"215\" y=\"230\">";
    svg += _head_name;
    svg += "</text><text x=\"275\" y=\"230\">";
    svg += _waist_name;
    svg += "</text><text x=\"95\" y=\"300\">";
    svg += _foot_name;
    svg += "</text><text x=\"155\" y=\"300\">";
    svg += _hand_name;
    svg += "</text><text x=\"215\" y=\"300\">";
    svg += _neck_name;
    svg += "</text><text x=\"275\" y=\"300\">";
    svg += _ring_name;
    svg += "</text></g><g font-size=\"6\"><text x=\"126\" y=\"192\">01</text><text x=\"186\" y=\"192\">02</text><text x=\"246\" y=\"192\">03</text><text x=\"306\" y=\"192\">04</text><text x=\"126\" y=\"262\">05</text><text x=\"186\" y=\"262\">06</text><text x=\"246\" y=\"262\">07</text><text x=\"306\" y=\"262\">08</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">ADVENTURER #";
    svg += format!("{}", adventurer_id);
    svg += "</text><text x=\"50\" y=\"470\">LEVEL ";
    svg += _level;
    svg += " - ";
    svg += _xp;
    svg += " XP</text></g></g><g id=\"page2\" transform=\"translate(400,0)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><g fill=\"#78E846\"><text x=\"200\" y=\"100\" font-size=\"24\" text-anchor=\"middle\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">VOID</text><text x=\"200\" y=\"130\" font-size=\"12\" text-anchor=\"middle\">ENDLESS DARKNESS</text><circle cx=\"200\" cy=\"250\" r=\"80\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"2\"/><circle cx=\"200\" cy=\"250\" r=\"40\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"/><circle cx=\"200\" cy=\"250\" r=\"20\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"/><circle cx=\"200\" cy=\"250\" r=\"5\" fill=\"#78E846\"/><path d=\"M200 170L220 190L200 210L180 190Z\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"><animate attributeName=\"opacity\" values=\"1;0.3;1\" dur=\"4s\" repeatCount=\"indefinite\"/></path><path d=\"M200 290L220 310L200 330L180 310Z\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"><animate attributeName=\"opacity\" values=\"1;0.3;1\" dur=\"4s\" begin=\"1s\" repeatCount=\"indefinite\"/></path><path d=\"M120 250L140 230L160 250L140 270Z\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"><animate attributeName=\"opacity\" values=\"1;0.3;1\" dur=\"4s\" begin=\"2s\" repeatCount=\"indefinite\"/></path><path d=\"M280 250L260 230L240 250L260 270Z\" fill=\"none\" stroke=\"#78E846\" stroke-width=\"1\"><animate attributeName=\"opacity\" values=\"1;0.3;1\" dur=\"4s\" begin=\"3s\" repeatCount=\"indefinite\"/></path></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">THE VOID STARES BACK</text><text x=\"50\" y=\"470\">INTO THE ABYSS</text></g></g><animateTransform attributeName=\"transform\" type=\"translate\" values=\"0,0; 0,0; -400,0; -400,0; 0,0\" keyTimes=\"0; 0.45; 0.55; 0.95; 1\" dur=\"20s\" calcMode=\"spline\" keySplines=\"0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1\" repeatCount=\"indefinite\"/></g></svg>";

    svg
}

// @notice Generates JSON metadata for the adventurer token uri using Shinobi template
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @return The generated JSON metadata
pub fn create_metadata(adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag) -> ByteArray {
    let mut _name = Default::default();
    _name.append_word(adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into());

    let _adventurer_id = format!("{}", adventurer_id);
    let _xp = format!("{}", adventurer.xp);
    let _level = format!("{}", (adventurer.xp / 100) + 1);
    let _health = format!("{}", adventurer.health);
    let _gold = format!("{}", adventurer.gold);
    let _str = format!("{}", adventurer.stats.strength);
    let _dex = format!("{}", adventurer.stats.dexterity);
    let _int = format!("{}", adventurer.stats.intelligence);
    let _vit = format!("{}", adventurer.stats.vitality);
    let _wis = format!("{}", adventurer.stats.wisdom);
    let _cha = format!("{}", adventurer.stats.charisma);
    let _luck = format!("{}", adventurer.stats.luck);

    // Generate equipped item names
    let _equiped_weapon = generate_item(adventurer.equipment.weapon, false);
    let _equiped_chest = generate_item(adventurer.equipment.chest, false);
    let _equiped_head = generate_item(adventurer.equipment.head, false);
    let _equiped_waist = generate_item(adventurer.equipment.waist, false);
    let _equiped_foot = generate_item(adventurer.equipment.foot, false);  
    let _equiped_hand = generate_item(adventurer.equipment.hand, false);
    let _equiped_neck = generate_item(adventurer.equipment.neck, false);
    let _equiped_ring = generate_item(adventurer.equipment.ring, false);

    // Generate the shinobi SVG with dynamic data
    let image = create_shinobi_svg(adventurer_id, adventurer, adventurer_name, bag);

    let base64_image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(image));

    // Build JSON metadata string
    let mut metadata: ByteArray = "{";
    metadata += "\"name\":\"" + _name.clone() + " #" + _adventurer_id + "\",";
    metadata += "\"description\":\"A legendary adventurer NFT with on-chain metadata rendered using the Shinobi template.\",";
    metadata += "\"image\":\"" + base64_image + "\",";
    metadata += "\"attributes\":[";
    metadata += "{\"trait_type\":\"Name\",\"value\":\"" + _name + "\"},";
    metadata += "{\"trait_type\":\"XP\",\"value\":" + _xp + "},";
    metadata += "{\"trait_type\":\"Level\",\"value\":" + _level + "},";
    metadata += "{\"trait_type\":\"Health\",\"value\":" + _health + "},";
    metadata += "{\"trait_type\":\"Gold\",\"value\":" + _gold + "},";
    metadata += "{\"trait_type\":\"Strength\",\"value\":" + _str + "},";
    metadata += "{\"trait_type\":\"Dexterity\",\"value\":" + _dex + "},";
    metadata += "{\"trait_type\":\"Intelligence\",\"value\":" + _int + "},";
    metadata += "{\"trait_type\":\"Vitality\",\"value\":" + _vit + "},";
    metadata += "{\"trait_type\":\"Wisdom\",\"value\":" + _wis + "},";
    metadata += "{\"trait_type\":\"Charisma\",\"value\":" + _cha + "},";
    metadata += "{\"trait_type\":\"Luck\",\"value\":" + _luck + "},";
    metadata += "{\"trait_type\":\"Weapon\",\"value\":\"" + _equiped_weapon + "\"},";
    metadata += "{\"trait_type\":\"Chest Armor\",\"value\":\"" + _equiped_chest + "\"},";
    metadata += "{\"trait_type\":\"Head Armor\",\"value\":\"" + _equiped_head + "\"},";
    metadata += "{\"trait_type\":\"Waist Armor\",\"value\":\"" + _equiped_waist + "\"},";
    metadata += "{\"trait_type\":\"Foot Armor\",\"value\":\"" + _equiped_foot + "\"},";
    metadata += "{\"trait_type\":\"Hand Armor\",\"value\":\"" + _equiped_hand + "\"},";
    metadata += "{\"trait_type\":\"Necklace\",\"value\":\"" + _equiped_neck + "\"},";
    metadata += "{\"trait_type\":\"Ring\",\"value\":\"" + _equiped_ring + "\"}";
    metadata += "]}";

    format!("data:application/json;base64,{}", bytes_base64_encode(metadata))
}


#[cfg(test)]
mod tests {
    use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Equipment, Stats, Item};
    use super::create_metadata;

    #[test]
    fn test_metadata() {
        let _adventurer = Adventurer {
            health: 100,
            xp: 1000,
            gold: 500,
            beast_health: 50,
            stat_upgrades_available: 0,
            stats: Stats {
                strength: 10, dexterity: 50, vitality: 50, intelligence: 50, wisdom: 50, charisma: 50, luck: 100,
            },
            equipment: Equipment {
                weapon: Item { id: 42, xp: 400 },
                chest: Item { id: 49, xp: 400 },
                head: Item { id: 53, xp: 400 },
                waist: Item { id: 59, xp: 400 },
                foot: Item { id: 64, xp: 400 },
                hand: Item { id: 69, xp: 400 },
                neck: Item { id: 1, xp: 400 },
                ring: Item { id: 7, xp: 400 },
            },
            item_specials_seed: 0,
            action_count: 0,
        };

        let _bag = Bag {
            item_1: Item { id: 8, xp: 400 },
            item_2: Item { id: 40, xp: 400 },
            item_3: Item { id: 57, xp: 400 },
            item_4: Item { id: 83, xp: 400 },
            item_5: Item { id: 12, xp: 400 },
            item_6: Item { id: 77, xp: 400 },
            item_7: Item { id: 68, xp: 400 },
            item_8: Item { id: 100, xp: 400 },
            item_9: Item { id: 94, xp: 400 },
            item_10: Item { id: 54, xp: 400 },
            item_11: Item { id: 87, xp: 400 },
            item_12: Item { id: 81, xp: 400 },
            item_13: Item { id: 30, xp: 400 },
            item_14: Item { id: 11, xp: 400 },
            item_15: Item { id: 29, xp: 400 },
            mutated: false,
        };

        let _current_1 = create_metadata(1000000, _adventurer, 'testadventurer', _bag);

        // Test passes if no panic occurs
        assert!(true);
    }
}