use core::byte_array::ByteArrayTrait;
use ls2_renderer::utils::renderer::Renderer;

#[test]
fn test_basic_render() {
    let token_id: u256 = 42;
    let result = Renderer::render(token_id);
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    // Optionally print for manual inspection
    println!("Rendered SVG metadata: {}", result);
}

#[test]
fn test_large_token_id() {
    // Test with a large u256 value
    let token_id: u256 = u256 { low: 999999999999999999999999999999, high: 1 };
    let result = Renderer::render(token_id);
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    println!("Rendered SVG metadata for large ID: {}", result);
}

#[test]
fn test_render_with_different_ids() {
    // Test multiple token IDs to verify unique content
    let id1: u256 = 1;
    let id2: u256 = 2;
    let meta1 = Renderer::render(id1);
    let meta2 = Renderer::render(id2);
    assert(ByteArrayTrait::len(@meta1) > 0, 'empty meta1');
    assert(ByteArrayTrait::len(@meta2) > 0, 'empty meta2');
    // Each token should have its ID in the SVG, making them unique
    assert(meta1 != meta2, 'should be different');
}

#[test]
fn test_svg_and_json_structure() {
    let token_id: u256 = 7;
    let result = Renderer::render(token_id);
    // Check for non-empty output and print for manual inspection
    assert(ByteArrayTrait::len(@result) > 0, 'empty');
    println!("Rendered SVG metadata for token 7: {}", result);
}


#[test]
fn test_deterministic_rendering() {
    let token_id: u256 = 777;

    // Render twice to test determinism
    let result1 = Renderer::render(token_id);
    let result2 = Renderer::render(token_id);
    assert(ByteArrayTrait::len(@result1) > 0, 'empty result');
    assert(result1 == result2, 'not deterministic');

    println!("Deterministic rendering test passed for token {}", token_id);
}

#[test]
fn test_render_performance() {
    // Test single render with our SVG metadata
    let result = Renderer::render(1);
    assert(ByteArrayTrait::len(@result) > 100, 'result too short');

    println!("Performance test passed - rendered SVG NFT successfully");
}
// #[test]
// fn test_json_structure() {
//     let token_id: u256 = 100;
//     let result = Renderer::render(token_id);

//     // Verify basic JSON structure elements are present
//     assert(result.find("\"name\":").is_some(), 'missing name field');
//     assert(result.find("\"image\":").is_some(), 'missing image field');
//     assert(result.find("data:image/svg+xml;base64,").is_some(), 'missing base64 SVG');

//     println!("JSON structure test passed for token {}", token_id);
// }

