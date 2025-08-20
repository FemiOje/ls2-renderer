// SPDX-License-Identifier: MIT
//
// @title Renderer Utils Unit Tests - SVG Generation & Utilities
// @notice Comprehensive tests for SVG generation, string conversion, and UI elements
// @dev Tests dynamic elements, responsive design, and edge cases

use death_mountain_renderer::mocks::mock_adventurer::{
    create_custom_adventurer, get_adventurer_with_long_name, get_adventurer_with_max_stats,
    get_simple_adventurer,
};
use death_mountain_renderer::models::models::StatsTrait;
use death_mountain_renderer::utils::renderer::page::page_renderer::PageRendererImpl;
use death_mountain_renderer::utils::renderer::renderer_utils::{
    chest, foot, generate_full_animated_svg, generate_svg, hand, head, neck, ring, waist, weapon,
use death_mountain_renderer::utils::renderer_utils::{
    chest, foot, generate_svg, hand, head, neck, ring, u256_to_string, waist, weapon,
    felt252_to_string, generate_adventurer_name_text,
};
use death_mountain_renderer::utils::string::string_utils::{
    contains_pattern, ends_with_pattern, starts_with_pattern, u256_to_string,
};

#[test]
fn test_generate_svg_basic_structure() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(starts_with_pattern(@svg, @"<svg"), "SVG should start with <svg tag");
    assert!(ends_with_pattern(@svg, @"</svg>"), "SVG should end with </svg> tag");
    assert!(contains_pattern(@svg, @"width=\"862\""), "SVG should have correct width");
    assert!(contains_pattern(@svg, @"height=\"1270\""), "SVG should have correct height");
}

#[test]
fn test_generate_svg_adventurer_name_display() {
    let adventurer = get_simple_adventurer();
    let name = felt252_to_string(adventurer.name);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @name), "Should contain adventurer name");
    assert!(contains_pattern(@svg, @"<text"), "Should have text elements");
    assert!(contains_pattern(@svg, @"font-family:VT323"), "Should have proper font family");
}

#[test]
fn test_generate_svg_empty_name() {
    let empty_name_adventurer = create_custom_adventurer(100, 1, 10);

    let svg = generate_svg(empty_name_adventurer);

    assert!(starts_with_pattern(@svg, @"<svg"), "Should maintain SVG structure with empty name");
    assert!(contains_pattern(@svg, @"LEVEL"), "Should still show level label");
    assert!(contains_pattern(@svg, @"STR"), "Should still show stat labels");
}

#[test]
fn test_generate_svg_long_name_font_adjustment() {
    // Test direct name text generation with >31 char name to verify truncation
    let very_long_name = "VeryVeryVeryLongAdventurerNameThatExceedsThirtyOneCharacters";
    let name_svg = generate_adventurer_name_text(very_long_name);
    
    // Should use smallest font (10px) for truncated long names
    assert!(contains_pattern(@name_svg, @"font-size:10px"), "Truncated long names should use 10px font");
    // Should contain truncated name with ellipsis (28 chars + "...")
    assert!(contains_pattern(@name_svg, @"VeryVeryVeryLongAdventurerNa..."), "Should contain truncated name with ellipsis");
    
    // Test with felt252-compatible long name (21 chars) via regular SVG generation
    let long_name_adventurer = get_adventurer_with_long_name();
    let full_svg = generate_svg(long_name_adventurer);
    assert!(contains_pattern(@full_svg, @"VeryLongAdventurerName"), "Should contain full felt252 name");
}

#[test]
fn test_generate_svg_short_name_large_font() {
    let mut short_adventurer = get_simple_adventurer();
    short_adventurer.name = 'Bob'; // 3 chars - should use 24px

    let svg = generate_svg(short_adventurer);

    assert!(contains_pattern(@svg, @"class=\"s24\""), "Short names should use large font (24px)");
    assert!(contains_pattern(@svg, @"Bob"), "Should contain the short name");
}

#[test]
fn test_generate_svg_medium_name_medium_font() {
    let mut medium_adventurer = get_simple_adventurer();
    medium_adventurer.name = 'MediumLengthName'; // ~16 chars - should use 16px

    let svg = generate_svg(medium_adventurer);

    assert!(contains_pattern(@svg, @"class=\"s16\""), "Medium names should use medium font (16px)");
    assert!(contains_pattern(@svg, @"MediumLengthName"), "Should contain the medium name");
}

#[test]
fn test_generate_svg_level_display() {
    let adventurer = get_simple_adventurer();
    let level = adventurer.level;

    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"LEVEL"), "Should display level label");
    let level_string = u256_to_string(level.into());
    assert!(contains_pattern(@svg, @level_string), "Should show level value");
}

#[test]
fn test_generate_svg_maximum_level() {
    let mut max_level_adventurer = get_simple_adventurer();
    max_level_adventurer.level = 255; // Max u8

    let svg = generate_svg(max_level_adventurer);

    assert!(contains_pattern(@svg, @"255"), "Should display maximum level value");
    assert!(contains_pattern(@svg, @"LEVEL"), "Should display level label");
}

#[test]
fn test_generate_svg_stats_display() {
    let adventurer = get_simple_adventurer();

    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"STR"), "Should show strength label");
    assert!(contains_pattern(@svg, @"DEX"), "Should show dexterity label");
    assert!(contains_pattern(@svg, @"VIT"), "Should show vitality label");
    assert!(contains_pattern(@svg, @"INT"), "Should show intelligence label");
    assert!(contains_pattern(@svg, @"WIS"), "Should show wisdom label");
    assert!(contains_pattern(@svg, @"CHA"), "Should show charisma label");
}

#[test]
fn test_generate_svg_zero_stats() {
    let mut zero_adventurer = get_simple_adventurer();
    zero_adventurer.stats.strength = 0;
    zero_adventurer.stats.dexterity = 0;
    zero_adventurer.stats.vitality = 0;
    zero_adventurer.stats.intelligence = 0;
    zero_adventurer.stats.wisdom = 0;
    zero_adventurer.stats.charisma = 0;

    let svg = generate_svg(zero_adventurer);

    assert!(contains_pattern(@svg, @"STR"), "Should display stat labels even with zero values");
    assert!(contains_pattern(@svg, @"0"), "Should display zero values");
}

#[test]
fn test_generate_svg_maximum_stats() {
    let max_adventurer = get_adventurer_with_max_stats();

    let svg = generate_svg(max_adventurer);

    assert!(contains_pattern(@svg, @"255"), "Should display maximum stat values");
    assert!(contains_pattern(@svg, @"STR"), "Should display stat labels");
}

#[test]
fn test_generate_svg_health_bar_presence() {
    let adventurer = get_simple_adventurer();

    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<path stroke="), "Should have health bar paths");
    assert!(contains_pattern(@svg, @" HP"), "Should have health label");
    assert!(contains_pattern(@svg, @"/"), "Should show health as fraction");
}

#[test]
fn test_generate_svg_healthy_green_bar() {
    let mut healthy_adventurer = get_simple_adventurer();
    let max_health = healthy_adventurer.stats.get_max_health();
    healthy_adventurer.health = max_health; // 100% health

    let svg = generate_svg(healthy_adventurer);

    assert!(contains_pattern(@svg, @"#78E846"), "Healthy adventurer should have green health bar");
}

#[test]
fn test_generate_svg_wounded_health_orange() {
    let mut wounded_adventurer = get_simple_adventurer();
    let max_health = wounded_adventurer.stats.get_max_health();
    wounded_adventurer.health = max_health * 3 / 5; // 60% health

    let svg = generate_svg(wounded_adventurer);

    assert!(
        contains_pattern(@svg, @"#FFD700"), "Wounded adventurer should have yellow/gold health bar",
    );
}

#[test]
fn test_generate_svg_critical_health_red() {
    let mut critical_adventurer = get_simple_adventurer();
    let max_health = critical_adventurer.stats.get_max_health();
    critical_adventurer.health = max_health / 4; // 25% health

    let svg = generate_svg(critical_adventurer);

    assert!(contains_pattern(@svg, @"#FF4444"), "Critical health should have red health bar");
}

#[test]
fn test_generate_svg_zero_health() {
    let mut dead_adventurer = get_simple_adventurer();
    dead_adventurer.health = 0;

    let svg = generate_svg(dead_adventurer);

    assert!(contains_pattern(@svg, @"0/"), "Should show zero health in fraction");
    assert!(contains_pattern(@svg, @"#FF4444"), "Zero health should have red color");
}

#[test]
fn test_generate_svg_maximum_health() {
    let mut max_health_adventurer = get_simple_adventurer();
    max_health_adventurer.stats.vitality = 255; // Max vitality
    let max_health = max_health_adventurer.stats.get_max_health();
    max_health_adventurer.health = max_health;

    let svg = generate_svg(max_health_adventurer);

    let health_string = u256_to_string(max_health.into());
    assert!(contains_pattern(@svg, @health_string), "Should show maximum health value");
    assert!(contains_pattern(@svg, @"#78E846"), "Max health should be green");
}

#[test]
fn test_generate_svg_equipment_icons() {
    let adventurer = get_simple_adventurer();

    let svg = generate_svg(adventurer);

    // Should contain equipment icon paths
    assert!(contains_pattern(@svg, @"<path d="), "Should contain equipment icon paths");
    assert!(
        contains_pattern(@svg, @"<g transform=\"translate("),
        "Should contain equipment icon transformations",
    );
    assert!(contains_pattern(@svg, @"fill=\"#78E846\""), "Equipment icons should be green");
}

// Test individual icon functions

#[test]
fn test_all_svg_icons_not_empty() {
    let weapon_icon = weapon();
    let chest_icon = chest();
    let head_icon = head();
    let waist_icon = waist();
    let foot_icon = foot();
    let hand_icon = hand();
    let neck_icon = neck();
    let ring_icon = ring();

    assert!(weapon_icon.len() > 0, "Weapon icon should not be empty");
    assert!(chest_icon.len() > 0, "Chest icon should not be empty");
    assert!(head_icon.len() > 0, "Head icon should not be empty");
    assert!(waist_icon.len() > 0, "Waist icon should not be empty");
    assert!(foot_icon.len() > 0, "Foot icon should not be empty");
    assert!(hand_icon.len() > 0, "Hand icon should not be empty");
    assert!(neck_icon.len() > 0, "Neck icon should not be empty");
    assert!(ring_icon.len() > 0, "Ring icon should not be empty");
}

#[test]
fn test_svg_icons_uniqueness() {
    let icon1 = weapon();
    let icon2 = head();

    // Different IDs should potentially produce different icons
    // Even if some are the same, the function should handle different inputs
    assert!(icon1.len() > 0 && icon2.len() > 0, "Icons should be non-empty");
    assert!(icon1 != icon2, "Icons should be unique");
}

// String conversion tests

#[test]
fn test_u256_to_string_single_digits() {
    assert_eq!(u256_to_string(0), "0", "Zero conversion failed");
    assert_eq!(u256_to_string(1), "1", "Single digit conversion failed");
    assert_eq!(u256_to_string(9), "9", "Single digit conversion failed");
}

#[test]
fn test_u256_to_string_two_digits() {
    assert_eq!(u256_to_string(10), "10", "Two digit conversion failed");
    assert_eq!(u256_to_string(99), "99", "Two digit conversion failed");
    assert_eq!(u256_to_string(42), "42", "Two digit conversion failed");
}

#[test]
fn test_u256_to_string_three_digits() {
    assert_eq!(u256_to_string(100), "100", "Three digit conversion failed");
    assert_eq!(u256_to_string(999), "999", "Three digit conversion failed");
    assert_eq!(u256_to_string(255), "255", "Three digit conversion failed");
}

#[test]
fn test_u256_to_string_powers_of_ten() {
    assert_eq!(u256_to_string(1), "1", "10^0 failed");
    assert_eq!(u256_to_string(10), "10", "10^1 failed");
    assert_eq!(u256_to_string(100), "100", "10^2 failed");
    assert_eq!(u256_to_string(1000), "1000", "10^3 failed");
    assert_eq!(u256_to_string(10000), "10000", "10^4 failed");
}

#[test]
fn test_u256_to_string_large_numbers() {
    assert_eq!(u256_to_string(65535), "65535", "u16 max failed");
    assert_eq!(u256_to_string(4294967295), "4294967295", "u32 max failed");
}

#[test]
fn test_u256_to_string_very_large_numbers() {
    let large_number = u256 { low: 18446744073709551615, high: 0 }; // u64 max
    let result = u256_to_string(large_number);
    assert_eq!(result, "18446744073709551615", "u64 max conversion failed");
}

// Fuzz Testing for SVG Generation

#[test]
#[fuzzer(runs: 200, seed: 333)]
fn fuzz_generate_svg_with_random_stats(
    health: u16,
    level: u8,
    strength: u8,
    dexterity: u8,
    vitality: u8,
    intelligence: u8,
    wisdom: u8,
    charisma: u8,
) {
    let mut adventurer = get_simple_adventurer();
    adventurer.health = health;
    adventurer.level = level;
    adventurer.stats.strength = strength;
    adventurer.stats.dexterity = dexterity;
    adventurer.stats.vitality = vitality;
    adventurer.stats.intelligence = intelligence;
    adventurer.stats.wisdom = wisdom;
    adventurer.stats.charisma = charisma;

    let svg = generate_svg(adventurer);

    // Invariants - check actual SVG content
    assert!(starts_with_pattern(@svg, @"<svg"), "Should always start with SVG tag");
    assert!(contains_pattern(@svg, @"width=\"862\""), "Should maintain correct width");
    assert!(contains_pattern(@svg, @"height=\"1270\""), "Should maintain correct height");
    assert!(contains_pattern(@svg, @"LEVEL"), "Should always contain level label");
}

#[test]
#[fuzzer(runs: 100, seed: 444)]
fn fuzz_u256_to_string(value: u256) {
    let result = u256_to_string(value);

    // Invariants
    assert!(result.len() > 0, "String should never be empty");

    if value == 0 {
        assert_eq!(result, "0", "Zero should convert to '0'");
    } else {
        assert_ne!(result, "0", "Non-zero should not convert to '0'");

        // Should only contain digits
        let bytes = result.clone();
        let mut i = 0;
        while i < bytes.len() {
            let byte = bytes.at(i).unwrap();
            assert!(byte >= 48 && byte <= 57, "Should only contain digit characters");
            i += 1;
        }

        // Should not start with '0' unless it's just "0"
        if result.len() > 1 {
            let first_char = result.at(0).unwrap();
            assert_ne!(first_char, 48, "Multi-digit numbers should not start with '0'");
        }
    }
}

// Performance Tests

#[test]
fn test_generate_svg_performance() {
    // Generate multiple SVGs to test consistency
    let mut i = 0_u32;
    while i < 5_u32 {
        let adventurer = get_simple_adventurer();
        let svg = generate_svg(adventurer);
        assert!(starts_with_pattern(@svg, @"<svg"), "Each SVG generation should produce valid SVG");
        assert!(contains_pattern(@svg, @"LEVEL"), "Each SVG should contain level label");
        i += 1;
    }
}

#[test]
fn test_icon_generation_performance() {
    // Test icon generation with various IDs
    let mut i = 1_u32;
    while i <= 10_u32 {
        let weapon = weapon();
        let chest = chest();
        assert!(starts_with_pattern(@weapon, @"<path d="), "Weapon icon should be valid SVG path");
        assert!(starts_with_pattern(@chest, @"<path d="), "Chest icon should be valid SVG path");
        i += 1;
    }
}

// Edge Case Tests

#[test]
fn test_generate_svg_health_bar_edge_cases() {
    let mut adventurer = get_simple_adventurer();
    let mut adventurer2 = get_simple_adventurer();

    // Test health exactly at color boundaries
    let max_health = adventurer.stats.get_max_health();

    // Test 50% health (boundary between yellow and green)
    adventurer.health = max_health / 2;
    let svg_50 = generate_svg(adventurer);
    assert!(contains_pattern(@svg_50, @"#FFD700"), "50% health should be yellow/gold");

    // Test 25% health (boundary to red)
    adventurer2.health = max_health / 4;
    let svg_25 = generate_svg(adventurer2);
    assert!(contains_pattern(@svg_25, @"#FF4444"), "25% health should be red");
}

#[test]
fn test_generate_svg_name_boundary_conditions() {
    // Test felt252 boundary conditions (max 31 chars)
    let mut adventurer_30 = get_simple_adventurer();
    adventurer_30.name = '012345678901234567890123456789'; // 30 chars - at boundary
    let svg_30 = generate_svg(adventurer_30);
    assert!(contains_pattern(@svg_30, @"012345678901234567890123456789"), "Should contain full 30-char name");

    let mut adventurer_31 = get_simple_adventurer();
    adventurer_31.name = '0123456789012345678901234567890'; // 31 chars - max felt252
    let svg_31 = generate_svg(adventurer_31);
    assert!(contains_pattern(@svg_31, @"0123456789012345678901234567890"), "Should contain full 31-char name");

    // Test direct name text generation beyond felt252 limits
    let name_32 = "01234567890123456789012345678901"; // 32 chars - triggers truncation
    let name_svg_32 = generate_adventurer_name_text(name_32);
    assert!(contains_pattern(@name_svg_32, @"font-size:10px"), "32-char names should use 10px font");
    assert!(contains_pattern(@name_svg_32, @"0123456789012345678901234567..."), "Should truncate to 28 chars + ...");

    let name_40 = "0123456789012345678901234567890123456789"; // 40 chars - well beyond limit
    let name_svg_40 = generate_adventurer_name_text(name_40);
    assert!(contains_pattern(@name_svg_40, @"font-size:10px"), "40-char names should use 10px font");
    assert!(contains_pattern(@name_svg_40, @"0123456789012345678901234567..."), "Should truncate consistently");
}

#[test]
fn test_output_animated_svg() {
    // Create mock adventurer
    let adventurer = get_simple_adventurer();

    // Generate the full animated SVG
    let animated_svg = generate_full_animated_svg(adventurer);

    // Output the animated SVG for manual inspection with proper markers
    println!("=== ANIMATED SVG ===");
    println!("{}", animated_svg);
    println!("=== END ANIMATED SVG ===");

    let svg_length: usize = animated_svg.len().into();
    assert!(svg_length > 0, "Animated SVG should not be empty");

    // Validate SVG structure
    assert!(
        contains_pattern(@animated_svg, @"<svg xmlns=\"http://www.w3.org/2000/svg\""),
        "Should have SVG opening tag",
    );
    assert!(contains_pattern(@animated_svg, @"</svg>"), "Should have SVG closing tag");

    // Validate CSS animations are present
    assert!(contains_pattern(@animated_svg, @"<style>"), "Should contain CSS styles");
    assert!(
        contains_pattern(@animated_svg, @".page{opacity:0;animation:pageTransition"),
        "Should have page animation CSS",
    );
    assert!(
        contains_pattern(@animated_svg, @"@keyframes pageTransition"),
        "Should have keyframes definition",
    );
    assert!(contains_pattern(@animated_svg, @"animation-delay:0s"), "Should have Page 0 timing");
    assert!(contains_pattern(@animated_svg, @"animation-delay:5s"), "Should have Page 1 timing");
    assert!(contains_pattern(@animated_svg, @"animation-delay:10s"), "Should have Page 2 timing");
    assert!(contains_pattern(@animated_svg, @"animation-delay:15s"), "Should have Page 3 timing");

    // Validate all 4 pages are present with correct structure
    assert!(
        contains_pattern(@animated_svg, @"<g class=\"page\""), "Should have page group elements",
    );

    // Validate theme colors for each page
    assert!(contains_pattern(@animated_svg, @"fill=\"#78E846\""), "Should have Page 0 green theme");
    assert!(
        contains_pattern(@animated_svg, @"fill=\"#E89446\""), "Should have Page 1 orange theme",
    );
    assert!(contains_pattern(@animated_svg, @"fill=\"#68CFDF\""), "Should have Page 2 blue theme");
    assert!(contains_pattern(@animated_svg, @"fill=\"#FF6B6B\""), "Should have Page 3 red theme");

    // Validate page titles are present
    assert!(contains_pattern(@animated_svg, @"TestHero"), "Should contain adventurer name");
    assert!(contains_pattern(@animated_svg, @"Item Bag"), "Should contain ItemBag page title");
    assert!(contains_pattern(@animated_svg, @"Current Battle"), "Should contain Battle page title");

    // Validate ItemBag grid structure (fixed spacing)
    assert!(
        contains_pattern(@animated_svg, @"stroke=\"#B5561F\""),
        "Should have ItemBag orange grid borders",
    );

    // Validate SVG definitions are present
    assert!(contains_pattern(@animated_svg, @"<defs>"), "Should have SVG definitions");
    assert!(contains_pattern(@animated_svg, @"<filter id=\"a\""), "Should have filter definitions");
    assert!(
        contains_pattern(@animated_svg, @"<clipPath id=\"b\""), "Should have clipPath definitions",
    );

    println!("SUCCESS: Animated SVG validation passed");
    println!("SVG size validation completed");
}

#[test]
fn test_dynamic_animated_svg_battle_mode() {
    // Create adventurer in battle mode (beast_health > 0)
    let mut battle_adventurer = get_simple_adventurer();
    battle_adventurer.beast_health = 50; // Set beast health to indicate combat

    // Generate dynamic animated SVG - should only show battle page
    let battle_svg = generate_svg(battle_adventurer.clone());

    // Validate battle mode specific content
    let battle_page_count = PageRendererImpl::get_page_count(battle_adventurer.clone());
    assert!(battle_page_count == 1, "Battle mode should have 1 page");

    // Should contain battle-specific content
    assert!(contains_pattern(@battle_svg, @"Current Battle"), "Should contain battle title");
    assert!(contains_pattern(@battle_svg, @"fill=\"#FF6B6B\""), "Should have red battle theme");

    // Should be static (no animation) since only 1 page
    assert!(
        contains_pattern(@battle_svg, @".page{opacity:1;}"),
        "Should be static display for single battle page",
    );

    println!("SUCCESS: Battle mode dynamic SVG validation passed");
}

#[test]
fn test_dynamic_animated_svg_normal_mode() {
    // Create adventurer in normal mode (no beast, alive)
    let mut normal_adventurer = get_simple_adventurer();
    normal_adventurer.beast_health = 0; // No beast
    normal_adventurer.health = 100; // Alive

    // Generate dynamic animated SVG - should show 3-page cycle
    let normal_svg = generate_svg(normal_adventurer.clone());

    // Validate normal mode specific content
    let normal_page_count = PageRendererImpl::get_page_count(normal_adventurer.clone());
    assert!(normal_page_count == 3, "Normal mode should have 3 pages");

    // Should contain all 3 page types
    assert!(contains_pattern(@normal_svg, @"TestHero"), "Should contain adventurer name");
    assert!(contains_pattern(@normal_svg, @"Item Bag"), "Should contain ItemBag page");

    // Should NOT contain battle page in normal mode
    assert!(
        !contains_pattern(@normal_svg, @"Current Battle"),
        "Should NOT contain battle page in normal mode",
    );

    // Should contain proper animation timing for 3 pages (15s duration)
    assert!(
        contains_pattern(@normal_svg, @"pageTransition 15s infinite"),
        "Should have 15s animation for normal mode",
    );

    // Should have theme colors for all 3 pages
    assert!(
        contains_pattern(@normal_svg, @"fill=\"#78E846\""), "Should have green inventory theme",
    );
    assert!(contains_pattern(@normal_svg, @"fill=\"#E89446\""), "Should have orange ItemBag theme");

    println!("SUCCESS: Normal mode dynamic SVG validation passed");
}

#[test]
fn test_output_dynamic_animated_svg_comparison() {
    // Test 1: Battle Mode (1 page - 5 second duration)
    let mut battle_adventurer = get_simple_adventurer();
    battle_adventurer.beast_health = 50;
    battle_adventurer.health = 80;

    let battle_svg = generate_svg(battle_adventurer.clone());
    let battle_page_count = PageRendererImpl::get_page_count(battle_adventurer.clone());

    println!("=== BATTLE MODE SVG ===");
    println!("{}", battle_svg);
    println!("=== END BATTLE MODE SVG ===");

    // Test 2: Normal Mode (3 pages - 15 second duration)
    let mut normal_adventurer = get_simple_adventurer();
    normal_adventurer.beast_health = 0;
    normal_adventurer.health = 100;

    let normal_svg = generate_svg(normal_adventurer.clone());
    let normal_page_count = PageRendererImpl::get_page_count(normal_adventurer.clone());

    println!("=== NORMAL MODE SVG ===");
    println!("{}", normal_svg);
    println!("=== END NORMAL MODE SVG ===");

    // Validate the key differences
    assert!(battle_page_count == 1, "Battle mode should have 1 page");
    assert!(normal_page_count == 3, "Normal mode should have 3 pages");

    // Battle mode should be static (no animation), normal mode should have animation
    assert!(
        contains_pattern(@battle_svg, @".page{opacity:1;}"),
        "Battle mode should be static (no animation)",
    );
    assert!(
        contains_pattern(@normal_svg, @"pageTransition 15s infinite"),
        "Normal mode should have 15s animation",
    );

    println!("SUCCESS: Dynamic page count comparison completed");
    println!("Battle mode: 1 page, Normal mode: 3 pages");
}
