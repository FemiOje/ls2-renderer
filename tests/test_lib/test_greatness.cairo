use ls2_renderer::mocks::mock_adventurer::Item;
use ls2_renderer::utils::renderer_utils::{
    calculate_greatness, generate_item, create_inventory_slot_component,
    create_multiline_text_component, get_default_theme, SVGPosition,
};

#[test]
#[available_gas(l1_gas: 500, l1_data_gas: 5000, l2_gas: 20000000)]
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

    // Test 7: Test with potentially longer item names
    let item7 = Item { id: 78, xp: 400 }; // OrnateChestplate with 400 XP
    let name7 = generate_item(item7, false);
    println!("Item 7 (OrnateChestplate, XP=400, G=20): {}", name7);

    let item8 = Item { id: 89, xp: 400 }; // PlatedBelt with 400 XP  
    let name8 = generate_item(item8, false);
    println!("Item 8 (PlatedBelt, XP=400, G=20): {}", name8);

    println!("All greatness tests passed!");
}

#[test]
#[available_gas(l1_gas: 500, l1_data_gas: 5000, l2_gas: 20000000)]
fn test_multiline_text_rendering() {
    let theme = get_default_theme();

    // Test 1: Create inventory slots with long names that should be multi-line
    let slot1_pos = SVGPosition { x: 50, y: 100 };
    let slot1_svg = create_inventory_slot_component(
        1, "Death Ornate Chestplate Sun", slot1_pos, @theme,
    );
    println!("Slot 1 SVG: {}", slot1_svg);

    // Test 2: Create another slot right below to check for overlap
    let slot2_pos = SVGPosition { x: 50, y: 170 }; // 70px below first slot
    let slot2_svg = create_inventory_slot_component(
        2, "Onslaught Plated Belt Bite", slot2_pos, @theme,
    );
    println!("Slot 2 SVG: {}", slot2_svg);

    // Test 3: Test word-per-line rendering
    let text_pos = SVGPosition { x: 200, y: 100 };
    let multiline_svg = create_multiline_text_component(
        "Onslaught Plated Belt Bite", text_pos, 5, @theme, "middle", "text-top", 20,
    );
    println!("Word-per-line SVG for problem text: {}", multiline_svg);

    // Test 4: Test short text
    let test_short = create_multiline_text_component(
        "Short Name", text_pos, 5, @theme, "middle", "text-top", 20,
    );
    println!("Short name word-per-line SVG: {}", test_short);

    // Test 5: Test single word
    let test_single = create_multiline_text_component(
        "Katana", text_pos, 5, @theme, "middle", "text-top", 20,
    );
    println!("Single word SVG: {}", test_single);

    println!("Multi-line text rendering tests passed!");
}
