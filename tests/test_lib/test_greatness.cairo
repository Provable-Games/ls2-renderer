use ls2_renderer::mocks::mock_adventurer::Item;
use ls2_renderer::utils::renderer_utils::{calculate_greatness, generate_item};

#[test]
#[available_gas(200000)]
fn test_greatness_system() {
    // Test different greatness levels
    
    // Test 1: Low XP (< 225) - no prefix/suffix
    let item1 = Item { id: 42, xp: 100 }; // Katana with 100 XP
    let greatness1 = calculate_greatness(100);
    assert(greatness1 == 10, 'sqrt(100) should be 10'); // sqrt(100) = 10
    let name1 = generate_item(item1, false);
    println!("Item 1 (XP=100, G=10): {}", name1);
    
    // Test 2: Medium XP (225-360) - suffix only
    let item2 = Item { id: 42, xp: 225 }; // Katana with 225 XP
    let greatness2 = calculate_greatness(225);
    assert(greatness2 == 15, 'sqrt(225) should be 15'); // sqrt(225) = 15
    let name2 = generate_item(item2, false);
    println!("Item 2 (XP=225, G=15): {}", name2);
    
    // Test 3: High XP (361+) - prefix and suffix
    let item3 = Item { id: 42, xp: 361 }; // Katana with 361 XP
    let greatness3 = calculate_greatness(361);
    assert(greatness3 == 19, 'sqrt(361) should be 19'); // sqrt(361) = 19
    let name3 = generate_item(item3, false);
    println!("Item 3 (XP=361, G=19): {}", name3);
    
    // Test 4: Very high XP (400+) - prefix and suffix
    let item4 = Item { id: 42, xp: 400 }; // Katana with 400 XP
    let greatness4 = calculate_greatness(400);
    assert(greatness4 == 20, 'sqrt(400) should be 20'); // sqrt(400) = 20
    let name4 = generate_item(item4, false);
    println!("Item 4 (XP=400, G=20): {}", name4);
    
    // Test 5: Different item types
    let item5 = Item { id: 1, xp: 361 }; // Pendant with 361 XP
    let name5 = generate_item(item5, false);
    println!("Item 5 (Pendant, XP=361, G=19): {}", name5);
    
    let item6 = Item { id: 22, xp: 400 }; // Crown with 400 XP
    let name6 = generate_item(item6, false);
    println!("Item 6 (Crown, XP=400, G=20): {}", name6);
    
    println!("All greatness tests passed!");
}