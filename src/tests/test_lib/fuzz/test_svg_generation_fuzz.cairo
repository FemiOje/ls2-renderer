// SPDX-License-Identifier: MIT
//
// @title SVG Generation Fuzz Testing - Dynamic UI Element Robustness
// @notice Property-based testing for SVG generation with random inputs
// @dev Tests responsive design, color calculations, and UI consistency

use death_mountain_renderer::mocks::mock_adventurer::get_simple_adventurer;
use death_mountain_renderer::models::models::AdventurerVerbose;
use death_mountain_renderer::utils::renderer::renderer_utils::generate_svg;
use death_mountain_renderer::utils::string::string_utils::{
    contains_pattern, ends_with_pattern, is_all_digits, starts_with_pattern, u256_to_string,
};

// Constants for test configuration based on actual SVG dimensions
const SVG_WIDTH: u32 = 862;
const SVG_HEIGHT: u32 = 1270;
const MIN_SVG_LENGTH: u32 = 500;

// String utility functions are now imported from death_mountain_renderer::utils::string_utils

// Core validation functions
fn validate_svg_structure(svg: @ByteArray) {
    assert!(svg.len() > 0, "SVG should never be empty");
    assert!(starts_with_pattern(svg, @"<svg"), "Should start with SVG tag");
    assert!(ends_with_pattern(svg, @"</svg>"), "Should end with SVG tag");
    assert!(contains_pattern(svg, @"width=\"862\""), "Should maintain correct width");
    assert!(contains_pattern(svg, @"height=\"1270\""), "Should maintain correct height");
    assert!(
        contains_pattern(svg, @"xmlns=\"http://www.w3.org/2000/svg\""), "Should have SVG namespace",
    );
}

fn validate_text_elements(svg: @ByteArray) {
    assert!(contains_pattern(svg, @"<text"), "Should have text elements");
    assert!(contains_pattern(svg, @"</text>"), "Should properly close text elements");
    assert!(contains_pattern(svg, @"font-size"), "Should have font sizing");
}

fn validate_health_elements(svg: @ByteArray) {
    assert!(contains_pattern(svg, @" HP"), "Should display HP label");
    assert!(contains_pattern(svg, @"/"), "Should show health as fraction");
    assert!(contains_pattern(svg, @"path"), "Should have path elements for health bar");
}

fn validate_coordinates(svg: @ByteArray) {
    assert!(!contains_pattern(svg, @"x=\"-"), "Should not have negative x coordinates");
    assert!(!contains_pattern(svg, @"y=\"-"), "Should not have negative y coordinates");
}

fn create_custom_adventurer(health: u16, level: u8, vitality: u8) -> AdventurerVerbose {
    let mut adventurer = get_simple_adventurer();
    adventurer.health = health;
    adventurer.level = level.into();
    adventurer.stats.vitality = vitality;
    adventurer
}

// Simplified test functions

#[test]
#[fuzzer(runs: 100, seed: 11111)]
fn fuzz_svg_generation_comprehensive(health: u16, level: u8, vitality: u8) {
    let adventurer = create_custom_adventurer(health, level, vitality);
    let svg = generate_svg(adventurer);

    validate_svg_structure(@svg);
    validate_text_elements(@svg);
    validate_coordinates(@svg);
}

#[test]
#[fuzzer(runs: 100, seed: 22222)]
fn fuzz_svg_health_display(current_health: u16, vitality: u8) {
    let adventurer = create_custom_adventurer(current_health, 1, vitality);
    let svg = generate_svg(adventurer);

    validate_svg_structure(@svg);
    validate_health_elements(@svg);

    // Test zero health edge case
    if current_health == 0 {
        assert!(contains_pattern(@svg, @"0/"), "Should show 0 health clearly");
    }
}

#[test]
#[fuzzer(runs: 100, seed: 33333)]
fn fuzz_svg_level_display(level: u8, health: u16) {
    let adventurer = create_custom_adventurer(health, level, 10);
    let svg = generate_svg(adventurer);

    validate_svg_structure(@svg);
    assert!(contains_pattern(@svg, @"LEVEL"), "Should display LEVEL label");

    if level > 0 {
        let level_string = u256_to_string(level.into());
        assert!(contains_pattern(@svg, @level_string), "Should show level value");
    }
}

#[test]
#[fuzzer(runs: 50, seed: 44444)]
fn fuzz_svg_stats_display(strength: u8, vitality: u8) {
    let mut adventurer = get_simple_adventurer();
    adventurer.stats.strength = strength;
    adventurer.stats.vitality = vitality;

    let svg = generate_svg(adventurer);

    validate_svg_structure(@svg);
    assert!(contains_pattern(@svg, @"STR"), "Should show strength label");
    assert!(contains_pattern(@svg, @"VIT"), "Should show vitality label");
}

#[test]
#[fuzzer(runs: 80, seed: 55555)]
fn fuzz_svg_stress_test(iterations: u8) {
    let iteration_count: u32 = if iterations > 10 {
        10
    } else {
        iterations.into()
    };

    let mut i: u32 = 0;
    while i < iteration_count {
        let adventurer = create_custom_adventurer(
            100 + (i * 10).try_into().unwrap(), (i + 1).try_into().unwrap(), 10,
        );

        let svg = generate_svg(adventurer);
        validate_svg_structure(@svg);
        assert!(svg.len() > MIN_SVG_LENGTH, "Each result should be substantial");

        i += 1;
    }
}

#[test]
#[fuzzer(runs: 60, seed: 66666)]
fn fuzz_u256_to_string_basic(value: u256) {
    let result = u256_to_string(value);

    // Basic invariants
    assert!(result.len() > 0, "String should never be empty");

    // Test zero case
    if value.low == 0 && value.high == 0 {
        assert!(result.len() == 1, "Zero should be single character");
        assert!(result[0] == 48, "Zero should be '0' character"); // ASCII '0' = 48
    }

    // Test digits only using utility function
    assert!(is_all_digits(@result), "Should only contain digit characters (0-9)");

    // Test no leading zeros (except for single "0")
    if result.len() > 1 {
        assert!(result[0] != 48, "Multi-digit numbers should not start with '0'");
    }
}
