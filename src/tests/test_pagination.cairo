use death_mountain_renderer::mocks::mock_adventurer::get_simple_adventurer;
use death_mountain_renderer::utils::renderer::PageRendererImpl;
use death_mountain_renderer::utils::renderer_utils::generate_svg_with_page;
use death_mountain_renderer::utils::string_utils::contains_pattern;

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
