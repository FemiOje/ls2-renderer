use death_mountain_renderer::mocks::mock_adventurer::get_simple_adventurer;
use death_mountain_renderer::utils::encoding::bytes_base64_encode;
use death_mountain_renderer::utils::renderer_utils::generate_svg_with_page;

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
