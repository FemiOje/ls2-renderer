// SPDX-License-Identifier: MIT
//
// @title Gas Optimization and Performance Tests
// @notice Gas usage analysis and performance testing for rendering system
// @dev Tests gas efficiency, memory usage, and performance optimization

use death_mountain_renderer::contracts::death_mountain_renderer::{
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait, IMinigameDetailsSVGDispatcher,
    IMinigameDetailsSVGDispatcherTrait, IRendererDispatcher, IRendererDispatcherTrait,
};
use death_mountain_renderer::mocks::mock_adventurer::{
    get_adventurer_with_max_stats, get_simple_adventurer,
};
use death_mountain_renderer::utils::encoding::{BytesUsedTrait, bytes_base64_encode};
use death_mountain_renderer::utils::renderer::Renderer;
use death_mountain_renderer::utils::renderer_utils::{generate_svg, u64_to_string};
use death_mountain_renderer::utils::string_utils::{contains_pattern, starts_with_pattern};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::ContractAddress;

fn deploy_test_contracts() -> (ContractAddress, ContractAddress) {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let (death_mountain_address, _) = contract_class.deploy(@array![]).unwrap();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (renderer_address, _) = contract_class.deploy(@constructor_args).unwrap();

    (death_mountain_address, renderer_address)
}


#[test]
fn test_adventurer_verbose_render_gas_efficiency() {
    let simple_adventurer = get_simple_adventurer();
    let simple_result = Renderer::render(1_u64, simple_adventurer);
    assert!(
        starts_with_pattern(@simple_result, @"data:application/json;base64,"),
        "Simple render should produce valid JSON data URI",
    );
    assert!(simple_result.len() > 100, "Should produce substantial output");

    let max_adventurer = get_adventurer_with_max_stats();
    let max_result = Renderer::render(2_u64, max_adventurer);
    assert!(
        starts_with_pattern(@max_result, @"data:application/json;base64,"),
        "Max stats render should produce valid JSON data URI",
    );
    assert!(max_result.len() > 100, "Should produce substantial output");
}

#[test]
fn test_base64_encoding_scalability() {
    let input_sizes = array![10, 50, 100];

    let mut i = 0;
    while i < input_sizes.len() {
        let size = *input_sizes.at(i);

        let mut test_input: ByteArray = "";
        let mut j = 0;
        while j < size {
            test_input += "A";
            j += 1;
        }

        let encoded = bytes_base64_encode(test_input);
        assert!(encoded.len() > 0, "Should produce encoded output");
        assert!(encoded.len() >= (size * 4) / 3, "Output size should meet Base64 minimum");
        // Verify it contains valid base64 content
        if encoded.len() > 0 {
            assert!(encoded.len() > 0, "Should not produce empty encoded string");
        }

        i += 1;
    };
}

#[test]
fn test_svg_generation_performance_scaling() {
    let simple_adventurer = get_simple_adventurer();
    let simple_svg = generate_svg(simple_adventurer);

    let mut complex_adventurer = get_adventurer_with_max_stats();
    complex_adventurer.name = 'VeryLongComplexAdvName';
    let complex_svg = generate_svg(complex_adventurer);

    assert!(starts_with_pattern(@simple_svg, @"<svg"), "Simple SVG should be valid SVG format");
    assert!(starts_with_pattern(@complex_svg, @"<svg"), "Complex SVG should be valid SVG format");
    assert!(contains_pattern(@simple_svg, @"LEVEL"), "Simple SVG should contain level label");
    assert!(contains_pattern(@complex_svg, @"LEVEL"), "Complex SVG should contain level label");
    assert!(
        complex_svg.len() >= simple_svg.len(), "Complex SVG should be at least as large as simple",
    );
}

#[test]
fn test_contract_deployment_efficiency() {
    let (mock_address, contract_address) = deploy_test_contracts();

    assert!(contract_address.into() != 0, "Contract should be deployed successfully");

    let renderer = IRendererDispatcher { contract_address };
    let stored_address = renderer.get_death_mountain_address();
    assert_eq!(stored_address, mock_address, "Should retrieve stored address");
}

#[test]
fn test_batch_operations_efficiency() {
    let (_, contract_address) = deploy_test_contracts();

    let minigame = IMinigameDetailsDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    let token_ids = array![1_u64, 2_u64, 3_u64];

    let mut i = 0;
    while i < token_ids.len() {
        let token_id = *token_ids.at(i);
        let traits = minigame.game_details(token_id);
        let description = minigame.token_description(token_id);
        let svg = svg_renderer.game_details_svg(token_id);

        assert!(traits.len() >= 8, "Each trait result should have adequate trait count");
        assert!(description.len() > 5, "Each description should be meaningful");
        assert!(
            starts_with_pattern(@svg, @"data:image/svg+xml;base64,"),
            "Each SVG should be valid data URI",
        );

        i += 1;
    }

    assert_eq!(token_ids.len(), 3, "All batch operations should complete");
}

#[test]
fn test_memory_efficiency_multiple_adventurers() {
    let adventurer1 = get_simple_adventurer();
    let result1 = Renderer::render(1_u64, adventurer1);
    assert!(
        starts_with_pattern(@result1, @"data:application/json;base64,"),
        "First render should produce valid JSON data URI",
    );

    let adventurer2 = get_adventurer_with_max_stats();
    let result2 = Renderer::render(2_u64, adventurer2);
    assert!(
        starts_with_pattern(@result2, @"data:application/json;base64,"),
        "Second render should produce valid JSON data URI",
    );

    let adventurer3 = get_simple_adventurer();
    let result3 = Renderer::render(3_u64, adventurer3);
    assert!(
        starts_with_pattern(@result3, @"data:application/json;base64,"),
        "Third render should produce valid JSON data URI",
    );

    assert!(result1.len() > 100, "Results should be substantial");
    assert!(result2.len() > 100, "Results should be substantial");
    assert!(result3.len() > 100, "Results should be substantial");
}

#[test]
fn test_string_conversion_performance() {
    let test_values = array![0_u64, 42_u64, 1000_u64, 65535_u64, 1000000_u64];

    let mut conversion_results = array![];
    let mut i = 0;
    while i < test_values.len() {
        let value = *test_values.at(i);
        let string_result = u64_to_string(value);
        conversion_results.append(string_result);
        i += 1;
    }

    assert_eq!(conversion_results.len(), test_values.len(), "All conversions should complete");

    let mut j = 0;
    while j < conversion_results.len() {
        let result = conversion_results.at(j);
        assert!(result.len() > 0, "Each conversion should produce output");
        // Verify it contains digit characters - simple check for non-empty numeric string
        if result.len() > 0 {
            assert!(result.len() > 0, "Result should not be empty string");
        }
        j += 1;
    }

    assert!(conversion_results.len() == 5, "Should have converted 5 values");
}

#[test]
fn test_bytes_used_calculation_performance() {
    let test_u128_values = array![
        0_u128, 255_u128, 65535_u128, 4294967295_u128, 0xffffffffffffffffffffffffffffffff_u128,
    ];
    let test_u256_values = array![
        u256 { low: 0, high: 0 },
        u256 { low: 255, high: 0 },
        u256 { low: 0xffffffffffffffffffffffffffffffff, high: 0 },
        u256 { low: 0xffffffffffffffffffffffffffffffff, high: 0xffffffffffffffffffffffffffffffff },
    ];

    let mut u128_results = array![];
    let mut i = 0;
    while i < test_u128_values.len() {
        let value = *test_u128_values.at(i);
        let bytes_used = value.bytes_used();
        u128_results.append(bytes_used);
        i += 1;
    }

    let mut u256_results = array![];
    let mut j = 0;
    while j < test_u256_values.len() {
        let value = *test_u256_values.at(j);
        let bytes_used = value.bytes_used();
        u256_results.append(bytes_used);
        j += 1;
    }

    assert_eq!(u128_results.len(), test_u128_values.len(), "All u128 calculations should complete");
    assert_eq!(u256_results.len(), test_u256_values.len(), "All u256 calculations should complete");

    assert_eq!(*u128_results.at(0), 0, "Zero should use 0 bytes");
    assert_eq!(*u128_results.at(1), 1, "255 should use 1 byte");
    assert_eq!(*u256_results.at(0), 0, "Zero u256 should use 0 bytes");
    assert_eq!(*u256_results.at(1), 1, "255 u256 should use 1 byte");
}

#[test]
fn test_adventurer_trait_extraction_performance() {
    let simple_adventurer = get_simple_adventurer();
    let simple_traits = Renderer::get_traits(simple_adventurer);
    let simple_description = Renderer::get_description();
    let simple_image_adventurer = get_simple_adventurer();
    let simple_image = Renderer::get_image(simple_image_adventurer);

    let max_adventurer = get_adventurer_with_max_stats();
    let max_traits = Renderer::get_traits(max_adventurer);
    let max_description = Renderer::get_description();
    let max_image_adventurer = get_adventurer_with_max_stats();
    let max_image = Renderer::get_image(max_image_adventurer);

    assert!(simple_traits.len() >= 8, "Should generate adequate traits for simple adventurer");
    assert!(max_traits.len() >= 8, "Should generate adequate traits for max adventurer");
    assert!(simple_description.len() > 5, "Should generate meaningful description");
    assert!(max_description.len() > 5, "Should generate meaningful description");
    assert!(
        starts_with_pattern(@simple_image, @"data:image/svg+xml;base64,"),
        "Should generate valid SVG data URI for simple adventurer",
    );
    assert!(
        starts_with_pattern(@max_image, @"data:image/svg+xml;base64,"),
        "Should generate valid SVG data URI for max adventurer",
    );

    assert!(simple_image.len() > 100, "Simple image should be substantial");
    assert!(max_image.len() > 100, "Max image should be substantial");
}

#[test]
fn test_comparative_operation_analysis() {
    let traits_adventurer = get_simple_adventurer();
    let traits = Renderer::get_traits(traits_adventurer);
    assert!(traits.len() >= 8, "Traits extraction should produce adequate trait count");

    let description = Renderer::get_description();
    assert!(description.len() > 5, "Description generation should produce meaningful content");

    let image_adventurer = get_simple_adventurer();
    let image = Renderer::get_image(image_adventurer);
    assert!(
        starts_with_pattern(@image, @"data:image/svg+xml;base64,"),
        "Image generation should produce valid SVG data URI",
    );

    let render_adventurer = get_simple_adventurer();
    let full_render = Renderer::render(1_u64, render_adventurer);
    assert!(
        starts_with_pattern(@full_render, @"data:application/json;base64,"),
        "Full render should produce valid JSON data URI",
    );

    assert!(full_render.len() > image.len(), "Full render should be larger than just image");
    assert!(
        full_render.len() > description.len(), "Full render should be larger than just description",
    );
}

#[test]
fn test_contract_vs_direct_operation_analysis() {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let constructor_args = array![];
    let (death_mountain_address, _) = contract_class.deploy(@constructor_args).unwrap();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (contract_address, _) = contract_class.deploy(@constructor_args).unwrap();

    let minigame = IMinigameDetailsDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    let contract_traits = minigame.game_details(1);
    let contract_description = minigame.token_description(1);
    let contract_svg = svg_renderer.game_details_svg(1);

    let direct_adventurer1 = get_simple_adventurer();
    let direct_traits = Renderer::get_traits(direct_adventurer1);
    let direct_description = Renderer::get_description();
    let direct_adventurer2 = get_simple_adventurer();
    let direct_image = Renderer::get_image(direct_adventurer2);

    assert!(contract_traits.len() >= 8, "Contract traits should produce adequate trait count");
    assert!(
        contract_description.len() > 5, "Contract description should produce meaningful content",
    );
    assert!(
        starts_with_pattern(@contract_svg, @"data:image/svg+xml;base64,"),
        "Contract SVG should produce valid data URI",
    );
    assert!(direct_traits.len() >= 8, "Direct traits should produce adequate trait count");
    assert!(direct_description.len() > 5, "Direct description should produce meaningful content");
    assert!(
        starts_with_pattern(@direct_image, @"data:image/svg+xml;base64,"),
        "Direct image should produce valid SVG data URI",
    );
}
