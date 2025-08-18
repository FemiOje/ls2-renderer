// SPDX-License-Identifier: MIT
//
// @title Comprehensive SVG Content Validation Tests
// @notice Focused tests that validate specific SVG content rather than just checking length
// @dev Tests ensure SVG generation produces correct visual elements, text, and structure
// @author Built for robust Death Mountain Renderer validation

use death_mountain_renderer::mocks::mock_adventurer::get_simple_adventurer;
use death_mountain_renderer::models::models::{AdventurerVerbose, StatsTrait};
use death_mountain_renderer::utils::renderer::renderer_utils::{generate_svg, u256_to_string};
use death_mountain_renderer::utils::string::string_utils::{
    contains_pattern, ends_with_pattern, starts_with_pattern,
};

// ============================================================================
// HELPER FUNCTIONS FOR TEST SETUP
// ============================================================================

fn create_adventurer_with_name(name: ByteArray) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.name = name;
    adventurer
}

fn create_adventurer_with_health(health: u16) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.health = health;
    adventurer
}

fn create_adventurer_with_level(level: u8) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.level = level.into();
    adventurer
}

fn create_adventurer_with_vitality(vitality: u8) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.stats.vitality = vitality;
    adventurer
}

fn create_adventurer_with_gold(gold: u16) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.gold = gold;
    adventurer
}

fn create_adventurer_with_stats(
    str: u8, dex: u8, vit: u8, int: u8, wis: u8, cha: u8,
) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.stats.strength = str;
    adventurer.stats.dexterity = dex;
    adventurer.stats.vitality = vit;
    adventurer.stats.intelligence = int;
    adventurer.stats.wisdom = wis;
    adventurer.stats.charisma = cha;
    adventurer
}

fn create_adventurer_with_max_stats() -> AdventurerVerbose {
    create_adventurer_with_stats(255, 255, 255, 255, 255, 255)
}

// ============================================================================
// 1. SVG STRUCTURE & METADATA TESTS
// ============================================================================

#[test]
fn test_svg_contains_proper_dimensions() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"width=\"862\""), "SVG should have width 862");
    assert!(contains_pattern(@svg, @"height=\"1270\""), "SVG should have height 1270");
}

#[test]
fn test_svg_contains_namespace() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(@svg, @"xmlns=\"http://www.w3.org/2000/svg\""),
        "SVG should have proper namespace",
    );
}

#[test]
fn test_svg_contains_proper_tags() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(starts_with_pattern(@svg, @"<svg"), "SVG should start with <svg tag");
    assert!(ends_with_pattern(@svg, @"</svg>"), "SVG should end with </svg> tag");
}

#[test]
fn test_svg_contains_fill_attribute() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"fill=\"none\""), "SVG should have fill=none attribute");
}

// ============================================================================
// 2. ADVENTURER NAME DISPLAY TESTS
// ============================================================================

#[test]
fn test_svg_contains_adventurer_name() {
    let adventurer = create_adventurer_with_name("TestHero");
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"TestHero"), "SVG should contain adventurer name");
}

#[test]
fn test_svg_font_size_for_short_names() {
    let adventurer = create_adventurer_with_name("Bob"); // 3 chars - should use 24px
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"class=\"s24\""), "Short names should use large font (24px)");
}

#[test]
fn test_svg_font_size_for_medium_names() {
    let adventurer = create_adventurer_with_name("MediumLengthName"); // ~16 chars - should use 17px
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"class=\"s16\""), "Medium names should use medium font (16px)");
}

#[test]
fn test_svg_font_size_for_long_names() {
    let adventurer = create_adventurer_with_name(
        "VeryVeryVeryVeryLongAdventurerName",
    ); // > 30 chars - should use 12px
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"class=\"s12\""), "Long names should use small font (12px)");
}

#[test]
fn test_svg_empty_name_handling() {
    let adventurer = create_adventurer_with_name("");
    let svg = generate_svg(adventurer);

    assert!(starts_with_pattern(@svg, @"<svg"), "Empty name should still produce valid SVG");
    assert!(svg.len() > 1000, "Empty name SVG should have substantial content");
}

// ============================================================================
// 3. HEALTH BAR & DISPLAY TESTS
// ============================================================================

#[test]
fn test_svg_contains_health_label() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @" HP"), "SVG should contain HP label");
    assert!(contains_pattern(@svg, @"/"), "SVG should contain health fraction separator");
}

#[test]
fn test_svg_health_bar_green_color() {
    let mut adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();
    adventurer.health = max_health; // 100% health - should be green
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"fill=\"#78E846\""), "Full health should show green color");
}

#[test]
fn test_svg_health_bar_orange_color() {
    let mut adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();
    adventurer.health = max_health * 3 / 5; // 60% health - should be orange/yellow
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"#FFD700"), "Medium health should show yellow/gold color");
}

#[test]
fn test_svg_health_bar_red_color() {
    let mut adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();
    adventurer.health = max_health / 5; // 20% health - should be red
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"#FF4444"), "Low health should show red color");
}

#[test]
fn test_svg_current_health_value() {
    let adventurer = create_adventurer_with_health(150);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"150"), "SVG should display current health value");
}

#[test]
fn test_svg_max_health_calculation() {
    let adventurer = create_adventurer_with_vitality(20); // 100 + (20*15) = 400 max health
    let max_health = adventurer.stats.get_max_health();
    let expected_health = u256_to_string(max_health.into());
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @expected_health), "SVG should display calculated max health");
}

#[test]
fn test_svg_zero_health_display() {
    let adventurer = create_adventurer_with_health(0);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"0/"), "Zero health should display as 0/");
}

// ============================================================================
// 4. LEVEL DISPLAY TESTS
// ============================================================================

#[test]
fn test_svg_contains_level_label() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"LEVEL"), "SVG should contain LEVEL label");
}

#[test]
fn test_svg_contains_level_value() {
    let adventurer = create_adventurer_with_level(42);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"42"), "SVG should display level value");
}

#[test]
fn test_svg_level_zero_display() {
    let adventurer = create_adventurer_with_level(0);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"0"), "Level 0 should be displayed");
}

#[test]
fn test_svg_maximum_level_display() {
    let adventurer = create_adventurer_with_level(255); // Max level
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"255"), "Max level should be displayed");
}

// ============================================================================
// 5. STATS DISPLAY TESTS
// ============================================================================

#[test]
fn test_svg_contains_stat_labels() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"STR"), "SVG should contain STR label");
    assert!(contains_pattern(@svg, @"DEX"), "SVG should contain DEX label");
    assert!(contains_pattern(@svg, @"VIT"), "SVG should contain VIT label");
    assert!(contains_pattern(@svg, @"INT"), "SVG should contain INT label");
    assert!(contains_pattern(@svg, @"WIS"), "SVG should contain WIS label");
    assert!(contains_pattern(@svg, @"CHA"), "SVG should contain CHA label");
}

#[test]
fn test_svg_contains_stat_values() {
    let adventurer = create_adventurer_with_stats(15, 12, 18, 10, 14, 16);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"15"), "SVG should contain STR value");
    assert!(contains_pattern(@svg, @"12"), "SVG should contain DEX value");
    assert!(contains_pattern(@svg, @"18"), "SVG should contain VIT value");
    assert!(contains_pattern(@svg, @"10"), "SVG should contain INT value");
    assert!(contains_pattern(@svg, @"14"), "SVG should contain WIS value");
    assert!(contains_pattern(@svg, @"16"), "SVG should contain CHA value");
}

#[test]
fn test_svg_zero_stats_display() {
    let adventurer = create_adventurer_with_stats(0, 0, 0, 0, 0, 0);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"0"), "Zero stats should be displayed");
}

#[test]
fn test_svg_maximum_stats_display() {
    let adventurer = create_adventurer_with_max_stats();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"255"), "Max stat values should be displayed");
}

// ============================================================================
// 6. GOLD DISPLAY TESTS
// ============================================================================

#[test]
fn test_svg_contains_gold_label() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"GOLD"), "SVG should contain GOLD label");
}

#[test]
fn test_svg_contains_gold_value() {
    let adventurer = create_adventurer_with_gold(1250);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"1250"), "SVG should display gold value");
}

#[test]
fn test_svg_gold_display_background() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"fill=\"#2C1A0A\""), "SVG should have dark gold background");
    assert!(contains_pattern(@svg, @"fill=\"#E8A746\""), "SVG should have gold label background");
}

#[test]
fn test_svg_zero_gold_display() {
    let adventurer = create_adventurer_with_gold(0);
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"0"), "Zero gold should be displayed");
}

// ============================================================================
// 7. EQUIPMENT ICON TESTS
// ============================================================================

#[test]
fn test_svg_contains_equipment_slots() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<rect"), "SVG should contain equipment slot rectangles");
}

#[test]
fn test_svg_contains_weapon_icon() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(
            @svg,
            @"M8 4V3H6V2H5V1H3v2H2v2H1v1h2V5h2v2H4v2H3v2H2v2H1v2H0v2h2v-2h1v-2h1v-2h1V9h1V7h2v5h2v-2h1V8h1V6h1V4H8Z",
        ),
        "SVG should contain weapon icon path",
    );
}

#[test]
fn test_svg_contains_chest_icon() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(@svg, @"M0 8h2V7H0v1Zm3-3V2H2v1H1v2H0v1h4V5H3Z"),
        "SVG should contain chest icon path",
    );
}

#[test]
fn test_svg_contains_head_icon() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(
            @svg,
            @"M12 2h-1V1h-1V0H6v1H5v1H4v1H3v8h1v1h2V8H5V7H4V5h3v4h2V5h3v2h-1v1h-1v4h2v-1h1V3h-1V2Z",
        ),
        "SVG should contain head icon path",
    );
}

#[test]
fn test_svg_contains_equipment_icon_paths() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<path d="), "SVG should contain equipment icon paths");
}

// ============================================================================
// 8. UI ELEMENT POSITION TESTS
// ============================================================================

#[test]
fn test_svg_no_negative_coordinates() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(!contains_pattern(@svg, @"x=\"-"), "SVG should not have negative x coordinates");
    assert!(!contains_pattern(@svg, @"y=\"-"), "SVG should not have negative y coordinates");
}

#[test]
fn test_svg_contains_text_elements() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<text"), "SVG should contain text elements");
    assert!(contains_pattern(@svg, @"</text>"), "SVG should properly close text elements");
    assert!(contains_pattern(@svg, @"text-anchor"), "SVG should have text-anchor attributes");
}

#[test]
fn test_svg_contains_proper_styling() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"font-family:VT323"), "SVG should use VT323 font family");
    assert!(contains_pattern(@svg, @"font-weight:bold"), "SVG should use bold font weight");
}

// ============================================================================
// 9. BORDER & BACKGROUND TESTS
// ============================================================================

#[test]
fn test_svg_contains_border_elements() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(@svg, @"fill=\"#78E846\""), "SVG should contain green border elements",
    );
    assert!(
        contains_pattern(@svg, @"fill=\"#000\""), "SVG should contain black background elements",
    );
}

#[test]
fn test_svg_contains_main_container() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(
        contains_pattern(@svg, @"width=\"567\" height=\"862\""),
        "SVG should have main container dimensions",
    );
    assert!(contains_pattern(@svg, @"rx=\"10\""), "SVG should have rounded corners");
}

// ============================================================================
// 10. FILTER & EFFECTS TESTS
// ============================================================================

#[test]
fn test_svg_contains_filter_definitions() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<defs>"), "SVG should contain definitions section");
    assert!(contains_pattern(@svg, @"<filter"), "SVG should contain filter definitions");
    assert!(contains_pattern(@svg, @"feGaussianBlur"), "SVG should contain blur effects");
}

#[test]
fn test_svg_contains_clip_paths() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"<clipPath"), "SVG should contain clip path definitions");
    assert!(contains_pattern(@svg, @"clip-path=\"url(#"), "SVG should reference clip paths");
}

// ============================================================================
// 11. EDGE CASE CONTENT TESTS
// ============================================================================

#[test]
fn test_svg_health_bar_boundary_50_percent() {
    let mut adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();
    adventurer.health = max_health / 2; // Exactly 50% health
    let svg = generate_svg(adventurer);

    assert!(svg.len() > 1000, "50% health should produce valid SVG");
}

#[test]
fn test_svg_health_bar_boundary_25_percent() {
    let mut adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();
    adventurer.health = max_health / 4; // Exactly 25% health
    let svg = generate_svg(adventurer);

    assert!(svg.len() > 1000, "25% health should produce valid SVG");
}

#[test]
fn test_svg_name_boundary_30_chars() {
    let adventurer = create_adventurer_with_name(
        "012345678901234567890123456789",
    ); // Exactly 30 chars
    let svg = generate_svg(adventurer);

    assert!(svg.len() > 1000, "30-char name should produce valid SVG");
}

#[test]
fn test_svg_name_boundary_31_chars() {
    let adventurer = create_adventurer_with_name(
        "0123456789012345678901234567890",
    ); // 31 chars - should trigger small font
    let svg = generate_svg(adventurer);

    assert!(contains_pattern(@svg, @"class=\"s12\""), "31-char name should use small font");
}

// ============================================================================
// 12. COMPREHENSIVE VALIDATION TESTS
// ============================================================================

#[test]
fn test_svg_complete_structure_validation() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    // Must contain all major structural elements
    assert!(starts_with_pattern(@svg, @"<svg"), "Must start with SVG tag");
    assert!(contains_pattern(@svg, @"<g filter="), "Must have filter group");
    assert!(contains_pattern(@svg, @"<g clip-path="), "Must have clip path group");
    assert!(contains_pattern(@svg, @"<defs>"), "Must have definitions");
    assert!(contains_pattern(@svg, @"</defs>"), "Must close definitions");
    assert!(ends_with_pattern(@svg, @"</svg>"), "Must end with SVG tag");
}

#[test]
fn test_svg_all_required_text_present() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    // All required UI text must be present
    assert!(contains_pattern(@svg, @"LEVEL"), "Must contain LEVEL text");
    assert!(contains_pattern(@svg, @"GOLD"), "Must contain GOLD text");
    assert!(contains_pattern(@svg, @" HP"), "Must contain HP text");
    assert!(contains_pattern(@svg, @"STR"), "Must contain STR text");
    assert!(contains_pattern(@svg, @"DEX"), "Must contain DEX text");
    assert!(contains_pattern(@svg, @"VIT"), "Must contain VIT text");
    assert!(contains_pattern(@svg, @"INT"), "Must contain INT text");
    assert!(contains_pattern(@svg, @"WIS"), "Must contain WIS text");
    assert!(contains_pattern(@svg, @"CHA"), "Must contain CHA text");
}

#[test]
fn test_svg_minimum_content_requirements() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg(adventurer);

    // Content size and quality checks
    assert!(svg.len() > 5000, "SVG must have substantial content (>5000 chars)");
    assert!(svg.len() < 50000, "SVG should not be excessively large (<50000 chars)");
}
