// SPDX-License-Identifier: MIT
//
// @title Comprehensive Renderer Unit Tests with Advanced Coverage
// @notice Extensive test suite for the Death Mountain Renderer system including fuzz testing,
// boundary conditions, and edge cases @dev Tests rendering functionality, metadata generation,
// trait extraction with comprehensive coverage

use death_mountain_renderer::mocks::mock_adventurer::{
    create_custom_adventurer, get_adventurer_with_long_name, get_adventurer_with_max_stats,
    get_adventurer_with_min_stats, get_simple_adventurer,
};
use death_mountain_renderer::models::models::StatsTrait;
use death_mountain_renderer::utils::renderer::renderer::RendererImpl;
use death_mountain_renderer::utils::string::string_utils::{contains_pattern, starts_with_pattern};

// BASIC FUNCTIONALITY TESTS

#[test]
fn test_basic_render() {
    let adventurer = get_simple_adventurer();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"), "Should be a JSON data URI",
    );
    // Result should contain encoded JSON with proper structure
    assert!(result.len() > 100, "Should have substantial base64 content");
}

#[test]
fn test_deterministic_rendering() {
    let adventurer1 = get_simple_adventurer();
    let adventurer2 = get_simple_adventurer();
    let token_id = 42_u64;

    let result1 = RendererImpl::render(token_id, adventurer1);
    let result2 = RendererImpl::render(token_id, adventurer2);

    assert_eq!(result1, result2, "Rendering should be deterministic");
}

#[test]
fn test_render_with_different_token_ids() {
    let adventurer1 = get_simple_adventurer();
    let adventurer2 = get_simple_adventurer();

    let result1 = RendererImpl::render(1_u64, adventurer1);
    let result2 = RendererImpl::render(999_u64, adventurer2);

    // Both results should be valid data URIs
    assert!(
        starts_with_pattern(@result1, @"data:application/json;base64,"),
        "Result1 should be valid data URI",
    );
    assert!(
        starts_with_pattern(@result2, @"data:application/json;base64,"),
        "Result2 should be valid data URI",
    );
}

#[test]
fn test_large_token_id() {
    let adventurer = get_simple_adventurer();
    let large_token_id = 18446744073709551615_u64; // u64::MAX

    let result = RendererImpl::render(large_token_id, adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should handle large token IDs and produce valid data URI",
    );
}

// ADVENTURER VARIATIONS TESTS

#[test]
fn test_render_max_stats_adventurer() {
    let max_adventurer = get_adventurer_with_max_stats();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, max_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Max stats adventurer should render valid data URI",
    );
    // Should produce substantial base64 encoded metadata
    assert!(result.len() > 200, "Max stats should produce rich base64 metadata");
}

#[test]
fn test_render_min_stats_adventurer() {
    let min_adventurer = get_adventurer_with_min_stats();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, min_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Min stats adventurer should render valid data URI",
    );
}

#[test]
fn test_render_long_name_adventurer() {
    let long_name_adventurer = get_adventurer_with_long_name();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, long_name_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Long name adventurer should render valid data URI",
    );
}

#[test]
fn test_render_empty_name_adventurer() {
    let empty_name_adventurer = create_custom_adventurer(100, 1, 10);
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, empty_name_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Empty name adventurer should render valid data URI",
    );
}

// TRAIT EXTRACTION TESTS

#[test]
fn test_get_traits_comprehensive() {
    let adventurer = get_simple_adventurer();

    let traits = RendererImpl::get_traits(adventurer);

    assert!(traits.len() > 0, "Should return traits");

    // Should have traits for basic adventurer stats (6 stats + health + level + gold)
    assert!(traits.len() >= 8, "Should have at least stat traits plus health, level, and gold");

    // Verify trait structure (checking that we can access trait data)
    let mut _has_health = false;
    let mut _has_level = false;
    let mut _has_strength = false;

    let mut i = 0;
    while i < traits.len() {
        let game_trait = traits.at(i);
        // Basic verification that traits contain data
        assert!(game_trait.name.len() > 0, "Trait name should not be empty");
        assert!(game_trait.value.len() > 0, "Trait value should not be empty");
        i += 1;
    }

    // For now, just verify we have traits
    assert!(traits.len() > 0, "Should generate meaningful traits");
}

#[test]
fn test_get_description() {
    let description = RendererImpl::get_description();

    assert!(description.len() > 0, "Description should not be empty");
    // Description should contain meaningful content about the Loot Survivor system
    assert!(
        contains_pattern(@description, @"Loot")
            || contains_pattern(@description, @"Survivor")
            || contains_pattern(@description, @"dungeon"),
        "Description should contain meaningful content",
    );
}

#[test]
fn test_get_image() {
    let adventurer = get_simple_adventurer();

    let image = RendererImpl::get_image(adventurer);

    // Should be an SVG data URI
    assert!(
        starts_with_pattern(@image, @"data:image/svg+xml;base64,"), "Image should be SVG data URI",
    );
    // Should contain substantial base64 encoded SVG content
    assert!(image.len() > 100, "Image should have substantial base64 content");
}

// HEALTH CALCULATION AND STATS TESTS

#[test]
fn test_stats_trait_health_calculation() {
    let adventurer = get_simple_adventurer();
    let max_health = adventurer.stats.get_max_health();

    // Health = 100 + (vitality * 15)
    let expected_health = 100 + (adventurer.stats.vitality.into() * 15);
    assert_eq!(max_health, expected_health, "Health calculation should follow formula");
}

#[test]
fn test_zero_health_adventurer() {
    let zero_health_adventurer = create_custom_adventurer(0, 1, 1);
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, zero_health_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Zero health should produce valid data URI",
    );
}

#[test]
fn test_critical_health_adventurer() {
    let critical_adventurer = create_custom_adventurer(1, 5, 10);
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, critical_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Critical health should produce valid data URI",
    );
}

#[test]
fn test_wounded_adventurer() {
    let wounded_adventurer = create_custom_adventurer(50, 10, 20);
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, wounded_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Wounded adventurer should produce valid data URI",
    );
}

#[test]
fn test_full_health_adventurer() {
    let full_health_adventurer = create_custom_adventurer(400, 20, 20); // 100 + (20*15) = 400
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, full_health_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Full health adventurer should produce valid data URI",
    );
}

// CONSISTENCY AND RELIABILITY TESTS

#[test]
fn test_render_consistency_across_calls() {
    let adventurer1 = get_simple_adventurer();
    let adventurer2 = get_simple_adventurer();
    let adventurer3 = get_simple_adventurer();
    let token_id = 123_u64;

    let result1 = RendererImpl::render(token_id, adventurer1);
    let result2 = RendererImpl::render(token_id, adventurer2);
    let result3 = RendererImpl::render(token_id, adventurer3);

    assert_eq!(result1, result2, "First and second call should match");
    assert_eq!(result2, result3, "Second and third call should match");
}

#[test]
fn test_metadata_consistency() {
    let adventurer1 = get_simple_adventurer();
    let adventurer2 = get_simple_adventurer();
    let token_id = 456_u64;

    let result1 = RendererImpl::render(token_id, adventurer1);
    let result2 = RendererImpl::render(token_id, adventurer2);

    // Should be identical for same input
    assert_eq!(result1, result2, "Metadata should be consistent");
}

#[test]
fn test_component_isolation() {
    let adventurer = get_simple_adventurer();
    let token_id = 789_u64;

    // Test that individual components work
    let result = RendererImpl::render(token_id, adventurer);
    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Render should produce valid data URI",
    );

    let traits = RendererImpl::get_traits(get_simple_adventurer());
    assert!(traits.len() >= 8, "Traits should be accessible independently with expected count");

    let description = RendererImpl::get_description();
    assert!(
        description.len() > 5,
        "Description should be accessible independently with meaningful content",
    );

    let image = RendererImpl::get_image(get_simple_adventurer());
    assert!(
        starts_with_pattern(@image, @"data:image/svg+xml;base64,"),
        "Image should be accessible independently as SVG data URI",
    );
}

// FUZZ TESTING

#[test]
#[fuzzer(runs: 100, seed: 12345)]
fn fuzz_render_with_random_token_ids(token_id: u64) {
    let adventurer = get_simple_adventurer();

    let result = RendererImpl::render(token_id, adventurer);

    // Should always produce valid data URI
    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should always produce valid JSON data URI",
    );
    assert!(result.len() > 100, "Should always produce substantial base64 content");
}

#[test]
#[fuzzer(runs: 100, seed: 23456)]
fn fuzz_render_with_random_health_levels(health: u16, level: u8, vitality: u8) {
    let adventurer = create_custom_adventurer(health, level, vitality);
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, adventurer);

    // Should handle all health/level/vitality combinations and produce valid output
    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should handle all stat combinations and produce valid data URI",
    );
}

#[test]
#[fuzzer(runs: 50, seed: 34567)]
fn fuzz_trait_generation_consistency(health: u16, level: u8, vitality: u8) {
    let adventurer = create_custom_adventurer(health, level, vitality);

    let traits1 = RendererImpl::get_traits(adventurer);
    let traits2 = RendererImpl::get_traits(create_custom_adventurer(health, level, vitality));

    // Same input should produce same trait count
    assert_eq!(traits1.len(), traits2.len(), "Same adventurer should produce same trait count");
}

// BOUNDARY CONDITIONS TESTS

#[test]
fn test_boundary_max_values() {
    let max_adventurer = get_adventurer_with_max_stats();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, max_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should handle maximum values and produce valid data URI",
    );
}

#[test]
fn test_boundary_min_values() {
    let min_adventurer = get_adventurer_with_min_stats();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, min_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should handle minimum values and produce valid data URI",
    );
}

#[test]
fn test_boundary_token_ids() {
    let adventurer1 = get_simple_adventurer();
    let adventurer2 = get_simple_adventurer();

    // Test extreme token ID values
    let result_min = RendererImpl::render(0_u64, adventurer1); // Min token_id
    assert!(
        starts_with_pattern(@result_min, @"data:application/json;base64,"),
        "Should handle min token_id and produce valid data URI",
    );

    let result_max = RendererImpl::render(18446744073709551615_u64, adventurer2); // Max token_id
    assert!(
        starts_with_pattern(@result_max, @"data:application/json;base64,"),
        "Should handle max token_id and produce valid data URI",
    );
}

// PERFORMANCE AND STRESS TESTS

#[test]
fn test_multiple_sequential_renders() {
    let token_id = 999_u64;

    // Test multiple renders don't interfere with each other
    let mut i = 0_u32;
    while i < 10 {
        let adventurer = get_simple_adventurer();
        let result = RendererImpl::render(token_id, adventurer);
        assert!(
            starts_with_pattern(@result, @"data:application/json;base64,"),
            "Sequential renders should all produce valid data URIs",
        );
        i += 1;
    }
}

#[test]
fn test_complex_adventurer_rendering() {
    let complex_adventurer = get_adventurer_with_max_stats();
    let token_id = 1_u64;

    let result = RendererImpl::render(token_id, complex_adventurer);

    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Complex adventurer should produce valid data URI",
    );
    assert!(result.len() > 300, "Complex adventurer should produce substantial base64 content");
}

// EDGE CASE TESTS

#[test]
fn test_boundary_level_adventurer() {
    // Test edge case levels
    let low_level = create_custom_adventurer(100, 1, 10);
    let high_level = create_custom_adventurer(1000, 255, 50);

    let result1 = RendererImpl::render(1_u64, low_level);
    let result2 = RendererImpl::render(2_u64, high_level);

    assert!(
        starts_with_pattern(@result1, @"data:application/json;base64,"),
        "Low level adventurer should produce valid data URI",
    );
    assert!(
        starts_with_pattern(@result2, @"data:application/json;base64,"),
        "High level adventurer should produce valid data URI",
    );
}

// PAGINATION TESTS (moved from test_pagination.cairo)

use death_mountain_renderer::utils::renderer::page::page_renderer::PageRendererImpl;
use death_mountain_renderer::utils::renderer::renderer_utils::generate_svg_with_page;

#[test]
fn test_page_count() {
    let adventurer = get_simple_adventurer();
    let page_count = PageRendererImpl::get_page_count(adventurer);
    assert_eq!(page_count, 2, "Should have 2 pages");
}

#[test]
fn test_page_0_battle_interface() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 0);

    // Check for specific SVG battle interface elements
    assert!(contains_pattern(@svg, @"<text"), "Should contain text elements");
    assert!(contains_pattern(@svg, @"LEVEL"), "Should contain level display");
    assert!(contains_pattern(@svg, @"STR"), "Should contain strength stat");
    assert!(contains_pattern(@svg, @"INVENTORY"), "Should contain inventory header");
    assert!(contains_pattern(@svg, @"HP"), "Should contain health display");
    assert!(
        contains_pattern(@svg, @"rect width=\"71\" height=\"71\""),
        "Should contain equipment slots",
    );
    assert!(contains_pattern(@svg, @"#78E846"), "Should contain green color theme");
}

#[test]
fn test_page_1_empty_background() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 1);

    // Page 1 should have minimal content (just SVG structure and border)
    assert!(contains_pattern(@svg, @"<svg xmlns="), "Should contain SVG header");
    assert!(contains_pattern(@svg, @"</svg>"), "Should contain SVG closing tag");
    assert!(
        contains_pattern(@svg, @"<rect width=\"567\" height=\"862\""),
        "Should contain main container",
    );
    assert!(contains_pattern(@svg, @"#78E846"), "Should contain green border color");

    // Should NOT contain battle interface elements
    assert!(!contains_pattern(@svg, @"LEVEL"), "Should not contain level display");
    assert!(!contains_pattern(@svg, @"STR"), "Should not contain strength stat");
    assert!(!contains_pattern(@svg, @"INVENTORY"), "Should not contain inventory header");
    assert!(!contains_pattern(@svg, @"HP"), "Should not contain health display");
}

#[test]
fn test_render_page_json() {
    let adventurer = get_simple_adventurer();
    let token_id = 123;
    let page = 0;

    let json_result = PageRendererImpl::render_page(token_id, adventurer, page);

    // Should be a valid data URI with JSON metadata
    assert!(
        contains_pattern(@json_result, @"data:application/json;base64,"), "Should be JSON data URI",
    );
    assert!(json_result.len() > 200, "JSON result should have substantial content");
}

#[test]
fn test_page_image_generation() {
    let adventurer = get_simple_adventurer();

    let page_0_image = PageRendererImpl::get_page_image(adventurer.clone(), 0);
    let page_1_image = PageRendererImpl::get_page_image(adventurer, 1);

    // Both should be valid SVG data URIs
    assert!(
        contains_pattern(@page_0_image, @"data:image/svg+xml;base64,"),
        "Page 0 should be SVG data URI",
    );
    assert!(
        contains_pattern(@page_1_image, @"data:image/svg+xml;base64,"),
        "Page 1 should be SVG data URI",
    );

    // Page 0 should be longer (more content) than page 1
    assert!(
        page_0_image.len() > page_1_image.len(),
        "Battle page should have more content than empty page",
    );
}

// SVG OUTPUT TESTS (moved from test_simple_svg_output.cairo and test_svg_output.cairo)

use death_mountain_renderer::utils::encoding::encoding::bytes_base64_encode;

#[test]
fn test_simple_output_page_0_svg() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 0);

    println!("=== PAGE 0 SVG ===");
    println!("{}", svg);
    println!("=== END PAGE 0 SVG ===");

    // Also output base64 encoded version
    let svg_base64 = bytes_base64_encode(svg);
    println!("=== PAGE 0 BASE64 ===");
    println!("data:image/svg+xml;base64,{}", svg_base64);
    println!("=== END PAGE 0 BASE64 ===");
}

#[test]
fn test_simple_output_page_1_svg() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 1);

    println!("=== PAGE 1 SVG ===");
    println!("{}", svg);
    println!("=== END PAGE 1 SVG ===");

    // Also output base64 encoded version
    let svg_base64 = bytes_base64_encode(svg);
    println!("=== PAGE 1 BASE64 ===");
    println!("data:image/svg+xml;base64,{}", svg_base64);
    println!("=== END PAGE 1 BASE64 ===");
}

#[test]
fn test_simple_svg_comparison() {
    let adventurer = get_simple_adventurer();
    let svg_page_0 = generate_svg_with_page(adventurer.clone(), 0);
    let svg_page_1 = generate_svg_with_page(adventurer, 1);

    println!("=== SVG SIZE COMPARISON ===");
    println!("Page 0 (Battle Interface) length: {}", svg_page_0.len());
    println!("Page 1 (Empty Background) length: {}", svg_page_1.len());
    if svg_page_0.len() > svg_page_1.len() {
        println!("Difference: {}", svg_page_0.len() - svg_page_1.len());
    } else {
        println!("Difference: {}", svg_page_1.len() - svg_page_0.len());
    }
    println!("=== END COMPARISON ===");
}

#[test]
fn test_output_page_0_svg() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 0);

    println!("=== PAGE 0 SVG (Battle Interface) ===");
    println!("{}", svg);
    println!("=== END PAGE 0 SVG ===");

    // Also output base64 encoded version
    let svg_base64 = bytes_base64_encode(svg);
    println!("=== PAGE 0 BASE64 ===");
    println!("data:image/svg+xml;base64,{}", svg_base64);
    println!("=== END PAGE 0 BASE64 ===");
}

#[test]
fn test_output_page_1_svg() {
    let adventurer = get_simple_adventurer();
    let svg = generate_svg_with_page(adventurer, 1);

    println!("=== PAGE 1 SVG (Empty Background with Border) ===");
    println!("{}", svg);
    println!("=== END PAGE 1 SVG ===");

    // Also output base64 encoded version
    let svg_base64 = bytes_base64_encode(svg);
    println!("=== PAGE 1 BASE64 ===");
    println!("data:image/svg+xml;base64,{}", svg_base64);
    println!("=== END PAGE 1 BASE64 ===");
}

#[test]
fn test_output_svg_comparison() {
    let adventurer = get_simple_adventurer();
    let svg_page_0 = generate_svg_with_page(adventurer.clone(), 0);
    let svg_page_1 = generate_svg_with_page(adventurer, 1);

    println!("=== SVG SIZE COMPARISON ===");
    println!("Page 0 (Battle Interface) length: {}", svg_page_0.len());
    println!("Page 1 (Empty Background) length: {}", svg_page_1.len());
    println!("Difference: {}", svg_page_0.len() - svg_page_1.len());
    println!("=== END COMPARISON ===");
}
