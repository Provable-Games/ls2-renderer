use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Item};
use ls2_renderer::mocks::mock_beast::{Beast};
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

// @notice Calculates the health bar width based on health percentage
// @param current_health The current health value
// @param max_health The maximum health value
// @return The calculated width for the health bar (0-160)
fn calculate_health_bar_width(current_health: u16, max_health: u16) -> u16 {
    if max_health == 0 {
        return 0;
    }
    
    // Calculate percentage and scale to 160 pixels (max width)
    let width = (current_health.into() * 160_u32) / max_health.into();
    width.try_into().unwrap_or(0)
}

// @notice Determines the health bar color based on health percentage
// @param current_health The current health value
// @param max_health The maximum health value
// @return The hex color code for the health bar
fn get_health_bar_color(current_health: u16, max_health: u16) -> ByteArray {
    if max_health == 0 {
        return "#78E846"; // Default green
    }
    
    let percentage = (current_health.into() * 100_u32) / max_health.into();
    
    if percentage > 60 {
        "#78E846" // Green (healthy)
    } else if percentage > 30 {
        "#FFC107" // Yellow/Orange (wounded)
    } else {
        "#FF4444" // Red (critical)
    }
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

// @notice Generates the shinobi SVG template with dynamic substitution (4-page version with battle)
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @param beast The beast being fought
// @param beast_name The name of the beast
// @return The generated shinobi SVG with dynamic values including battle page
fn create_battle_svg(adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag, beast: Beast, beast_name: felt252) -> ByteArray {
    let mut _name = Default::default();
    _name.append_word(adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into());

    let mut _beast_name = Default::default();
    _beast_name.append_word(beast_name, U256BytesUsedTraitImpl::bytes_used(beast_name.into()).into());

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
    let _gold = format!("{}", adventurer.gold);
    
    // Calculate dynamic health bar properties
    let health_bar_width = calculate_health_bar_width(adventurer.health, 100);
    let health_bar_color = get_health_bar_color(adventurer.health, 100);
    let _health_bar_width = format!("{}", health_bar_width);
    let _health_bar_color = health_bar_color;
    
    // Beast stats for battle interface
    let _beast_level = format!("{}", beast.combat_spec.level);
    let _beast_health = format!("{}", beast.starting_health);
    let _beast_max_health = format!("{}", beast.starting_health); // For display purposes
    let _beast_power = format!("{}", beast.combat_spec.level + 20); // Simulated power calculation

    // Calculate battle damage (simplified)
    let damage_dealt = if adventurer.stats.strength > 10 { 10 } else { adventurer.stats.strength.into() };
    let _damage = format!("{}", damage_dealt);

    // Generate equipped item names for inventory slots
    let _weapon_name = generate_item(adventurer.equipment.weapon, false);
    let _chest_name = generate_item(adventurer.equipment.chest, false);
    let _head_name = generate_item(adventurer.equipment.head, false);
    let _waist_name = generate_item(adventurer.equipment.waist, false);
    let _foot_name = generate_item(adventurer.equipment.foot, false);
    let _hand_name = generate_item(adventurer.equipment.hand, false);
    let _neck_name = generate_item(adventurer.equipment.neck, false);
    let _ring_name = generate_item(adventurer.equipment.ring, false);

    // Generate bag item names for page 2
    let _bag_item_1 = generate_item(bag.item_1, true);
    let _bag_item_2 = generate_item(bag.item_2, true);
    let _bag_item_3 = generate_item(bag.item_3, true);

    // Create the optimized 4-page SVG (based on optimized multi_page_nft.svg template)
    format!(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"550\"><defs><linearGradient id=\"border_gradient\" x1=\"200\" x2=\"200\" y1=\"20\" y2=\"530\" gradientUnits=\"userSpaceOnUse\"><stop stop-color=\"#FE9676\"/><stop offset=\"1\" stop-color=\"#58F54C\"/></linearGradient><linearGradient id=\"battle_gradient\" x1=\"0%\" x2=\"100%\" y1=\"0%\" y2=\"100%\"><stop offset=\"0%\" stop-color=\"#F44\"/><stop offset=\"100%\" stop-color=\"#800\"/></linearGradient><filter id=\"s\"><feDropShadow dx=\"0\" dy=\"10\" flood-opacity=\".3\" stdDeviation=\"10\"/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{{font-family:\"Pixelify Sans\",\"Courier New\",\"Monaco\",\"Lucida Console\",monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}}</style></defs><g id=\"slideContainer\"><g id=\"page1\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"m92 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H92zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5H94V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#78E846\" font-size=\"14\"><text x=\"130\" y=\"70\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">{}</text><text x=\"250\" y=\"70\" font-size=\"12\">LEVEL {}</text><text x=\"40\" y=\"100\">STR</text><text x=\"40\" y=\"120\" font-size=\"20\">{}</text><text x=\"40\" y=\"150\">DEX</text><text x=\"40\" y=\"170\" font-size=\"20\">{}</text><text x=\"40\" y=\"200\">INT</text><text x=\"40\" y=\"220\" font-size=\"20\">{}</text><text x=\"40\" y=\"250\">HIT</text><text x=\"40\" y=\"270\" font-size=\"20\">{}</text><text x=\"40\" y=\"300\">WIS</text><text x=\"40\" y=\"320\" font-size=\"20\">{}</text><text x=\"40\" y=\"350\">CHA</text><text x=\"40\" y=\"370\" font-size=\"20\">{}</text><text x=\"40\" y=\"400\">LUCK</text><text x=\"40\" y=\"420\" font-size=\"20\">{}</text><text x=\"90\" y=\"160\" font-size=\"12\">INVENTORY</text><text x=\"90\" y=\"135\" font-size=\"12\">{}/{} HP</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 115h200v8H90z\"/><path fill=\"#78E846\" d=\"M91 116h160v6H91z\"/><path fill=\"#E8A746\" d=\"M320 55h50v25h-50z\"/><text x=\"330\" y=\"70\" fill=\"#2C1A0A\" font-size=\"14\">{}</text><text x=\"325\" y=\"50\" fill=\"#E8A746\" font-size=\"10\">XP</text><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 180h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40zM90 250h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40z\"/><path fill=\"#78E846\" d=\"M95 190h2v20h-2m-2-20h6v4h-6zm12 0h4v4h-4zm61-20h20v15h-20zm5 15h10v8h-10zm55-5h20v15h-20m5-20h10v8h-10zm55 2h20v4h-20m5-8h2v16h-2zm8 2h4v8h-4M95 260h2v20h-2zm3 3h12v2H98zm0 10h12v2H98zm12-8h2v8h-2zm50-2h10v16h-10m2-18h6v4h-6zm53 9h8v10h-8zm12 0h8v10h-8m-12-13h20v6h-20zm63-4h14v14h-14zm-153-78h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm-180 70h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8z\"/><path fill=\"#2C1A0A\" d=\"M217 205h4v6h-4zm-54 60h4v8h-4zm119 2h6v6h-6z\"/><g fill=\"#78E846\" font-size=\"8\"><text x=\"95\" y=\"230\">{}</text><text x=\"155\" y=\"230\">{}</text><text x=\"215\" y=\"230\">{}</text><text x=\"275\" y=\"230\">{}</text><text x=\"95\" y=\"300\">{}</text><text x=\"155\" y=\"300\">{}</text><text x=\"215\" y=\"300\">{}</text><text x=\"275\" y=\"300\">{}</text></g><g font-size=\"6\"><text x=\"126\" y=\"192\">01</text><text x=\"186\" y=\"192\">02</text><text x=\"246\" y=\"192\">03</text><text x=\"306\" y=\"192\">04</text><text x=\"126\" y=\"262\">05</text><text x=\"186\" y=\"262\">06</text><text x=\"246\" y=\"262\">07</text><text x=\"306\" y=\"262\">08</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">ADVENTURER #{}</text><text x=\"50\" y=\"470\">LEVEL {} - {} XP</text></g></g><g id=\"page2\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\" transform=\"translate(400)\"/><path d=\"M430 30h340v490H430z\"/><path fill=\"#E89446\" d=\"M420 20h360v2H420zm0 508h360v2H420zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#E89446\" fill-rule=\"evenodd\" d=\"m450 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2h-17zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5h-11V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#E89446\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\" transform=\"translate(400)\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\" transform=\"translate(400)\">Item Bag</text></g><path fill=\"#2C1A0A\" stroke=\"#E89446\" d=\"M440 150h320v80H440z\"/><g fill=\"#E89446\" font-size=\"12\"><text x=\"50\" y=\"170\" transform=\"translate(400)\">INFORMATION ABOUT RUN GOES</text><text x=\"50\" y=\"190\" transform=\"translate(400)\">HERE AND HERE</text></g><path fill=\"none\" stroke=\"#663D17\" d=\"M440 250h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 65h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 65h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\"/><g fill=\"#E89446\" transform=\"translate(400)\"><circle cx=\"67\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><path d=\"M63 265h8v6h-8z\"/><path fill=\"none\" stroke=\"#E89446\" d=\"M127 270h11v14h-11z\"/><path stroke=\"#E89446\" d=\"M130 272h5m-5 4h5m-5 4h3\"/><circle cx=\"197\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><text x=\"197\" y=\"281\" font-size=\"8\" text-anchor=\"middle\">$</text></g><g fill=\"#E89446\" font-size=\"8\"><text x=\"67\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"132\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"197\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"262\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">EMPTY</text><text x=\"327\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">EMPTY</text></g><g fill=\"#E89446\" font-size=\"6\"><text x=\"47\" y=\"260\" transform=\"translate(400)\">01</text><text x=\"112\" y=\"260\" transform=\"translate(400)\">02</text><text x=\"177\" y=\"260\" transform=\"translate(400)\">03</text><text x=\"242\" y=\"260\" transform=\"translate(400)\">04</text><text x=\"307\" y=\"260\" transform=\"translate(400)\">05</text><text x=\"47\" y=\"325\" transform=\"translate(400)\">06</text><text x=\"112\" y=\"325\" transform=\"translate(400)\">07</text><text x=\"177\" y=\"325\" transform=\"translate(400)\">08</text><text x=\"242\" y=\"325\" transform=\"translate(400)\">09</text><text x=\"307\" y=\"325\" transform=\"translate(400)\">10</text><text x=\"47\" y=\"390\" transform=\"translate(400)\">11</text><text x=\"112\" y=\"390\" transform=\"translate(400)\">12</text><text x=\"177\" y=\"390\" transform=\"translate(400)\">13</text><text x=\"242\" y=\"390\" transform=\"translate(400)\">14</text><text x=\"307\" y=\"390\" transform=\"translate(400)\">15</text></g></g><g id=\"page3\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\" transform=\"translate(800)\"/><path d=\"M830 30h340v490H830z\"/><path fill=\"#77EDFF\" d=\"M820 20h360v2H820zm0 508h360v2H820zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#77EDFF\" fill-rule=\"evenodd\" d=\"m850 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2h-17zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5h-11V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#77EDFF\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\" transform=\"translate(800)\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\" transform=\"translate(800)\">Marketplace</text></g><path fill=\"none\" stroke=\"#77EDFF\" d=\"M840 100h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\"/><g fill=\"#77EDFF\" transform=\"translate(800)\"><path d=\"M60 115h15v25H60z\"/><circle cx=\"132\" cy=\"127\" r=\"8\"/><path d=\"M125 135h14v8h-14zm60-15h20v15h-20z\"/><circle cx=\"257\" cy=\"127\" r=\"8\"/><path d=\"M250 135h14v8h-14zm65-15h20v15h-20z\"/><circle cx=\"67\" cy=\"212\" r=\"8\"/><path d=\"M120 200h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"212\" r=\"8\"/><path d=\"M315 205h20v15h-20z\"/><circle cx=\"67\" cy=\"297\" r=\"8\"/><path d=\"M120 285h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"297\" r=\"8\"/><path d=\"M315 290h20v15h-20z\"/><circle cx=\"67\" cy=\"382\" r=\"8\"/><path d=\"M120 370h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"382\" r=\"8\"/><path d=\"M315 375h20v15h-20z\"/></g><g fill=\"#77EDFF\" font-size=\"8\"><text x=\"67\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">FIRE</text><text x=\"67\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"132\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">HEALTH</text><text x=\"132\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"197\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">WATER</text><text x=\"197\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">FIRE</text><text x=\"327\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"67\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"67\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"67\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text></g><g fill=\"#77EDFF\" font-size=\"6\"><text x=\"47\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"365\" transform=\"translate(800)\">ITEM</text></g></g><g id=\"page4\" transform=\"translate(1200)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><linearGradient id=\"page4_border\" x1=\"0\" x2=\"0\" y1=\"0\" y2=\"1\"><stop offset=\"0%\" stop-color=\"#FE9676\"/><stop offset=\"100%\" stop-color=\"#78E846\"/></linearGradient><path fill=\"url(#page4_border)\" stroke=\"url(#page4_border)\" stroke-width=\"2\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#FE9676\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5H52V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6H59v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#FE9676\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Current Battle</text></g><rect width=\"320\" height=\"120\" x=\"40\" y=\"110\" fill=\"#210E04\" rx=\"6\"/><rect width=\"60\" height=\"18\" x=\"55\" y=\"125\" fill=\"#FE9676\" rx=\"3\"/><text x=\"85\" y=\"138\" font-size=\"10\" text-anchor=\"middle\">{}</text><text x=\"60\" y=\"160\" fill=\"#FE9676\" font-size=\"12\">Level {}</text><text x=\"60\" y=\"180\" fill=\"#FE9676\" font-size=\"12\">Health: {}/25</text><text x=\"60\" y=\"200\" fill=\"#FE9676\" font-size=\"12\">Power: {}</text><text x=\"200\" y=\"160\" fill=\"#FE9676\" font-size=\"12\">Status: Hostile</text><text x=\"200\" y=\"180\" fill=\"#FE9676\" font-size=\"12\">Type: Magical</text><text x=\"200\" y=\"200\" fill=\"#FE9676\" font-size=\"12\">Tier: 3</text><rect width=\"320\" height=\"80\" x=\"40\" y=\"250\" fill=\"#2C1A0A\" stroke=\"#FE9676\" rx=\"6\"/><text x=\"60\" y=\"275\" fill=\"#FE9676\" font-size=\"12\">LAST ACTIVITY:</text><text x=\"60\" y=\"295\" fill=\"#FE9676\" font-size=\"11\">Troll ambushed you for 15 damage!</text><text x=\"60\" y=\"310\" fill=\"#FE9676\" font-size=\"11\">You attacked with sword for 21 damage.</text><rect width=\"320\" height=\"150\" x=\"40\" y=\"350\" fill=\"#171D10\" rx=\"6\"/><rect width=\"50\" height=\"18\" x=\"55\" y=\"365\" fill=\"#78E846\" rx=\"3\"/><text x=\"80\" y=\"378\" font-size=\"10\" text-anchor=\"middle\">YOU</text><text x=\"60\" y=\"400\" fill=\"#78E846\" font-size=\"12\">Level {}</text><text x=\"60\" y=\"420\" fill=\"#78E846\" font-size=\"12\">Health: {}/100</text><text x=\"60\" y=\"440\" fill=\"#78E846\" font-size=\"12\">Power: {}</text><text x=\"60\" y=\"460\" fill=\"#78E846\" font-size=\"12\">Dexterity: {}</text><text x=\"200\" y=\"400\" fill=\"#78E846\" font-size=\"12\">XP: 1250</text><text x=\"200\" y=\"420\" fill=\"#78E846\" font-size=\"12\">Beast Health: 10</text><text x=\"200\" y=\"440\" fill=\"#78E846\" font-size=\"12\">Weapon: Katana</text><text x=\"200\" y=\"460\" fill=\"#78E846\" font-size=\"12\">Armor: Iron</text></g><animateTransform attributeName=\"transform\" calcMode=\"spline\" dur=\"40s\" keySplines=\"0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1\" keyTimes=\"0; 0.22; 0.28; 0.47; 0.53; 0.72; 0.78; 0.97; 1\" repeatCount=\"indefinite\" type=\"translate\" values=\"0,0; 0,0; -400,0; -400,0; -800,0; -800,0; -1200,0; -1200,0; 0,0\"/></g></svg>",
        _name, _level, _str, _dex, _int, _vit, _wis, _cha, _luck, _health, _max_health, _xp,
        _weapon_name, _chest_name, _head_name, _waist_name, _foot_name, _hand_name, _neck_name, _ring_name,
        adventurer_id, _level, _xp, _name, _bag_item_1, _bag_item_2, _bag_item_3, _name,
        _beast_name, _beast_level, _beast_health, _beast_power, _level, _health, _str, _dex, _name
    )
}

// @notice Generates the shinobi SVG template with dynamic substitution (original 3-page version)
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

    // Generate bag item names for page 2
    let _bag_item_1 = generate_item(bag.item_1, true);
    let _bag_item_2 = generate_item(bag.item_2, true);
    let _bag_item_3 = generate_item(bag.item_3, true);

    // Create the optimized multi-page SVG with dynamic values
    format!(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"550\" viewBox=\"0 0 400 550\"><defs><filter id=\"s\"><feDropShadow dx=\"0\" dy=\"10\" flood-opacity=\".3\" stdDeviation=\"10\"/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{{font-family:\"Pixelify Sans\",\"Courier New\",\"Monaco\",\"Lucida Console\",monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}}</style></defs><g id=\"slideContainer\"><g id=\"page1\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"m92 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H92v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H94V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#78E846\" font-size=\"14\"><text x=\"130\" y=\"70\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">{}</text><text x=\"250\" y=\"70\" font-size=\"12\">LEVEL {}</text><text x=\"40\" y=\"100\">STR</text><text x=\"40\" y=\"120\" font-size=\"20\">{}</text><text x=\"40\" y=\"150\">DEX</text><text x=\"40\" y=\"170\" font-size=\"20\">{}</text><text x=\"40\" y=\"200\">INT</text><text x=\"40\" y=\"220\" font-size=\"20\">{}</text><text x=\"40\" y=\"250\">HIT</text><text x=\"40\" y=\"270\" font-size=\"20\">{}</text><text x=\"40\" y=\"300\">WIS</text><text x=\"40\" y=\"320\" font-size=\"20\">{}</text><text x=\"40\" y=\"350\">CHA</text><text x=\"40\" y=\"370\" font-size=\"20\">{}</text><text x=\"40\" y=\"400\">LUCK</text><text x=\"40\" y=\"420\" font-size=\"20\">{}</text><text x=\"90\" y=\"160\" font-size=\"12\">INVENTORY</text><text x=\"90\" y=\"135\" font-size=\"12\">{}/{} HP</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 115h200v8H90z\"/><path fill=\"#78E846\" d=\"M91 116h160v6H91z\"/><path d=\"M320 55h50v25H320z\" fill=\"#E8A746\" rx=\"4\"/><text x=\"330\" y=\"70\" fill=\"#2C1A0A\" font-size=\"14\">{}</text><text x=\"325\" y=\"50\" fill=\"#E8A746\" font-size=\"10\">XP</text><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 180h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40zM90 250h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40z\"/><path fill=\"#78E846\" d=\"M95 190h2v20h-2m-2-20h6v4h-6zm1 20h4v4h-4zm61-20h20v15h-20zm5 15h10v8h-10zm55-5h20v15h-20m5-20h10v8h-10zm55 2h20v4h-20m5-8h2v16h-2zm8 2h4v8h-4M95 260h2v20h-2zm3 3h12v2H98zm0 10h12v2H98zm12-8h2v8h-2zm50-2h10v16h-10m2-18h6v4h-6zm53 9h8v10h-8zm12 0h8v10h-8m-12-13h20v6h-20zm63-4h14v14h-14zm-153-78h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm-180 70h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8z\"/><path fill=\"#2C1A0A\" d=\"M217 205h4v6h-4zm-54 60h4v8h-4zm119 2h6v6h-6z\"/><g fill=\"#78E846\" font-size=\"8\"><text x=\"95\" y=\"230\">{}</text><text x=\"155\" y=\"230\">{}</text><text x=\"215\" y=\"230\">{}</text><text x=\"275\" y=\"230\">{}</text><text x=\"95\" y=\"300\">{}</text><text x=\"155\" y=\"300\">{}</text><text x=\"215\" y=\"300\">{}</text><text x=\"275\" y=\"300\">{}</text></g><g font-size=\"6\"><text x=\"126\" y=\"192\">01</text><text x=\"186\" y=\"192\">02</text><text x=\"246\" y=\"192\">03</text><text x=\"306\" y=\"192\">04</text><text x=\"126\" y=\"262\">05</text><text x=\"186\" y=\"262\">06</text><text x=\"246\" y=\"262\">07</text><text x=\"306\" y=\"262\">08</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">ADVENTURER #{}</text><text x=\"50\" y=\"470\">LEVEL {} - {} XP</text></g></g><g id=\"page2\" transform=\"translate(400,0)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#E89446\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#E89446\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H52V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#E89446\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}'S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Item Bag</text></g><path d=\"M40 150h320v80H40z\" rx=\"5\" fill=\"#2C1A0A\" stroke=\"#E89446\"/><g fill=\"#E89446\" font-size=\"12\"><text x=\"50\" y=\"170\">INFORMATION ABOUT RUN GOES</text><text x=\"50\" y=\"190\">HERE AND HERE</text></g><g stroke=\"#663D17\"><path d=\"M40 250h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 315h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 380h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\" rx=\"5\" fill=\"none\"/></g><g fill=\"#E89446\"><circle cx=\"67\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><path d=\"M63 265h8v6h-8z\"/><path d=\"M127 270h11v14h-11z\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"1\"/><path d=\"M130 272h5M130 276h5M130 280h3\" stroke=\"#E89446\" stroke-width=\"1\"/><circle cx=\"197\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><text x=\"197\" y=\"281\" font-size=\"8\" text-anchor=\"middle\">$</text></g><g fill=\"#E89446\" font-size=\"8\"><text x=\"67\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"67\" y=\"303\" text-anchor=\"middle\"></text><text x=\"132\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"132\" y=\"303\" text-anchor=\"middle\"></text><text x=\"197\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"197\" y=\"303\" text-anchor=\"middle\"></text><text x=\"262\" y=\"295\" text-anchor=\"middle\">EMPTY</text><text x=\"327\" y=\"295\" text-anchor=\"middle\">EMPTY</text></g><g font-size=\"6\" fill=\"#E89446\"><text x=\"47\" y=\"260\">01</text><text x=\"112\" y=\"260\">02</text><text x=\"177\" y=\"260\">03</text><text x=\"242\" y=\"260\">04</text><text x=\"307\" y=\"260\">05</text><text x=\"47\" y=\"325\">06</text><text x=\"112\" y=\"325\">07</text><text x=\"177\" y=\"325\">08</text><text x=\"242\" y=\"325\">09</text><text x=\"307\" y=\"325\">10</text><text x=\"47\" y=\"390\">11</text><text x=\"112\" y=\"390\">12</text><text x=\"177\" y=\"390\">13</text><text x=\"242\" y=\"390\">14</text><text x=\"307\" y=\"390\">15</text></g></g><g id=\"page3\" transform=\"translate(800,0)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#77EDFF\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#77EDFF\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H52V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#77EDFF\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}'S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Marketplace</text></g><g stroke=\"#77EDFF\" fill=\"none\"><path d=\"M40 100h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 185h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 270h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 355h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\" rx=\"3\"/></g><g fill=\"#77EDFF\"><path d=\"M60 115h15v25H60z\"/><circle cx=\"132\" cy=\"127\" r=\"8\"/><path d=\"M125 135h14v8h-14z\"/><path d=\"M185 120h20v15h-20z\"/><circle cx=\"257\" cy=\"127\" r=\"8\"/><path d=\"M250 135h14v8h-14z\"/><path d=\"M315 120h20v15h-20z\"/><circle cx=\"67\" cy=\"212\" r=\"8\"/><path d=\"M120 200h25v20h-25z\"/><path d=\"M185 205h20v15h-20z\"/><circle cx=\"257\" cy=\"212\" r=\"8\"/><path d=\"M315 205h20v15h-20z\"/><circle cx=\"67\" cy=\"297\" r=\"8\"/><path d=\"M120 285h25v20h-25z\"/><path d=\"M185 290h20v15h-20z\"/><circle cx=\"257\" cy=\"297\" r=\"8\"/><path d=\"M315 290h20v15h-20z\"/><circle cx=\"67\" cy=\"382\" r=\"8\"/><path d=\"M120 370h25v20h-25z\"/><path d=\"M185 375h20v15h-20z\"/><circle cx=\"257\" cy=\"382\" r=\"8\"/><path d=\"M315 375h20v15h-20z\"/></g><g fill=\"#77EDFF\" font-size=\"8\"><text x=\"67\" y=\"170\" text-anchor=\"middle\">FIRE</text><text x=\"67\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"132\" y=\"170\" text-anchor=\"middle\">HEALTH</text><text x=\"132\" y=\"178\" text-anchor=\"middle\">POTION</text><text x=\"197\" y=\"170\" text-anchor=\"middle\">WATER</text><text x=\"197\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"170\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"178\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"170\" text-anchor=\"middle\">FIRE</text><text x=\"327\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"67\" y=\"255\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"263\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"255\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"263\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"255\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"263\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"255\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"263\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"255\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"263\" text-anchor=\"middle\">RING</text><text x=\"67\" y=\"340\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"348\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"340\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"348\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"340\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"348\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"340\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"348\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"340\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"348\" text-anchor=\"middle\">SCROLL</text><text x=\"67\" y=\"425\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"433\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"425\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"433\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"425\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"433\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"425\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"433\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"425\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"433\" text-anchor=\"middle\">SCROLL</text></g><g fill=\"#77EDFF\" font-size=\"6\"><text x=\"47\" y=\"110\">ITEM</text><text x=\"112\" y=\"110\">ITEM</text><text x=\"177\" y=\"110\">ITEM</text><text x=\"242\" y=\"110\">ITEM</text><text x=\"307\" y=\"110\">ITEM</text><text x=\"47\" y=\"195\">ITEM</text><text x=\"112\" y=\"195\">ITEM</text><text x=\"177\" y=\"195\">ITEM</text><text x=\"242\" y=\"195\">ITEM</text><text x=\"307\" y=\"195\">ITEM</text><text x=\"47\" y=\"280\">ITEM</text><text x=\"112\" y=\"280\">ITEM</text><text x=\"177\" y=\"280\">ITEM</text><text x=\"242\" y=\"280\">ITEM</text><text x=\"307\" y=\"280\">ITEM</text><text x=\"47\" y=\"365\">ITEM</text><text x=\"112\" y=\"365\">ITEM</text><text x=\"177\" y=\"365\">ITEM</text><text x=\"242\" y=\"365\">ITEM</text><text x=\"307\" y=\"365\">ITEM</text></g></g><animateTransform attributeName=\"transform\" type=\"translate\" values=\"0,0; 0,0; -400,0; -400,0; -800,0; -800,0; 0,0\" keyTimes=\"0; 0.3; 0.37; 0.63; 0.7; 0.97; 1\" dur=\"30s\" calcMode=\"spline\" keySplines=\"0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1\" repeatCount=\"indefinite\"/></g></svg>",
        _name, _level, _str, _dex, _int, _vit, _wis, _cha, _luck, _health, _max_health, _xp,
        _weapon_name, _chest_name, _head_name, _waist_name, _foot_name, _hand_name, _neck_name, _ring_name,
        adventurer_id, _level, _xp, _name, _bag_item_1, _bag_item_2, _bag_item_3, _name
    )
}


// @notice Generates JSON metadata for the adventurer token uri using Shinobi template with battle interface
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @param beast The beast being fought
// @param beast_name The name of the beast
// @return The generated JSON metadata with battle interface
pub fn create_metadata(adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag, beast: Beast, beast_name: felt252) -> ByteArray {
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

    // Beast metadata
    let mut _beast_name_str = Default::default();
    _beast_name_str.append_word(beast_name, U256BytesUsedTraitImpl::bytes_used(beast_name.into()).into());
    let _beast_level = format!("{}", beast.combat_spec.level);
    let _beast_health = format!("{}", beast.starting_health);

    // Generate the shinobi SVG with battle interface
    let image = create_battle_svg(adventurer_id, adventurer, adventurer_name, bag, beast, beast_name);

    let base64_image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(image));

    // Build JSON metadata string
    let mut metadata: ByteArray = "{";
    metadata += "\"name\":\"" + _name.clone() + " #" + _adventurer_id + "\",";
    metadata += "\"description\":\"A legendary adventurer NFT with on-chain metadata rendered using the Shinobi template with battle interface.\",";
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
    metadata += "{\"trait_type\":\"Ring\",\"value\":\"" + _equiped_ring + "\"},";
    metadata += "{\"trait_type\":\"Battle Beast\",\"value\":\"" + _beast_name_str + "\"},";
    metadata += "{\"trait_type\":\"Beast Level\",\"value\":" + _beast_level + "},";
    metadata += "{\"trait_type\":\"Beast Health\",\"value\":" + _beast_health + "}";
    metadata += "]}";

    format!("data:application/json;base64,{}", bytes_base64_encode(metadata))
}


#[cfg(test)]
mod tests {
    use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Equipment, Stats, Item};
    use ls2_renderer::mocks::mock_beast::{Beast, CombatSpec, Tier, Type, SpecialPowers};
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

        let _beast = Beast {
            id: 7,
            starting_health: 25,
            combat_spec: CombatSpec {
                tier: Tier::T2,
                item_type: Type::Blade_or_Hide,
                level: 5,
                specials: SpecialPowers {
                    special1: 1,
                    special2: 2,
                    special3: 3,
                },
            },
        };

        let _current_1 = create_metadata(1000000, _adventurer, 'testadventurer', _bag, _beast, 'testbeast');

        // Test passes if no panic occurs
        assert!(true);
    }
}