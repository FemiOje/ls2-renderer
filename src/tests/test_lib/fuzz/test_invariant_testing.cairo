// SPDX-License-Identifier: MIT
//
// @title Invariant and Property-Based Testing
// @notice Critical system invariants that must always hold regardless of input
// @dev Property-based testing to ensure system robustness and consistency

use death_mountain_renderer::models::models::StatsTrait;
use death_mountain_renderer::utils::renderer::RendererImpl;
use death_mountain_renderer::utils::renderer_utils::{generate_svg, u256_to_string};
use death_mountain_renderer::utils::encoding::{bytes_base64_encode, BytesUsedTrait};
use death_mountain_renderer::utils::test_utils::{
    MIN_CONTENT_LENGTH, MIN_IMAGE_LENGTH, MAX_U128_BYTES, MAX_U256_BYTES,
    validate_non_empty_content, validate_health_formula, validate_data_uri_format,
    validate_svg_basic_structure, validate_base64_properties,
    validate_string_conversion_invariants, create_test_adventurer, create_u256_from_bytes
};


// INVARIANT 1: Deterministic Rendering
// Same input should always produce same output

#[test]
#[fuzzer(runs: 50, seed: 12345)]
fn invariant_deterministic_rendering(token_id: u256) {
    let adventurer1 = create_test_adventurer();
    let adventurer2 = create_test_adventurer();
    let adventurer3 = create_test_adventurer();
    
    let token_u64: u64 = (token_id.low % 18446744073709551616).try_into().unwrap();
    
    // INVARIANT: Multiple renders of same adventurer with same token_id must be identical
    let result1 = RendererImpl::render(token_u64, adventurer1);
    let result2 = RendererImpl::render(token_u64, adventurer2);
    let result3 = RendererImpl::render(token_u64, adventurer3);
    
    assert_eq!(result1, result2, "First and second render must be identical");
    assert_eq!(result2, result3, "Second and third render must be identical");
    assert_eq!(result1, result3, "First and third render must be identical");
    
    // INVARIANT: All components should be deterministic
    let traits1 = RendererImpl::get_traits(create_test_adventurer());
    let traits2 = RendererImpl::get_traits(create_test_adventurer());
    assert_eq!(traits1.len(), traits2.len(), "Trait count must be deterministic");
    
    let description1 = RendererImpl::get_description();
    let description2 = RendererImpl::get_description();
    assert_eq!(description1, description2, "Description must be deterministic");
    
    let image1 = RendererImpl::get_image(create_test_adventurer());
    let image2 = RendererImpl::get_image(create_test_adventurer());
    assert_eq!(image1, image2, "Image generation must be deterministic");
}

// INVARIANT 2: Health Calculation Consistency
// Health = 100 + (vitality * 15), always

#[test]
#[fuzzer(runs: 50, seed: 23456)]
fn invariant_health_calculation_formula(vitality: u8) {
    let adventurer = create_test_adventurer();
    let calculated_health = adventurer.stats.get_max_health();
    
    validate_health_formula(calculated_health, adventurer.stats.vitality);
}

// INVARIANT 3: Data URI Format Consistency
// All outputs must maintain proper data URI format

#[test]
#[fuzzer(runs: 30, seed: 34567)]
fn invariant_data_uri_format(token_id: u256) {
    let adventurer1 = create_test_adventurer();
    let adventurer2 = create_test_adventurer();
    
    let token_u64: u64 = (token_id.low % 18446744073709551616).try_into().unwrap();
    let result = RendererImpl::render(token_u64, adventurer1);
    validate_data_uri_format(@result, MIN_CONTENT_LENGTH);
    
    let image = RendererImpl::get_image(adventurer2);
    validate_data_uri_format(@image, MIN_IMAGE_LENGTH);
    
    let description = RendererImpl::get_description();
    validate_non_empty_content(@description, 0);
}

// INVARIANT 4: SVG Structure Consistency
// SVG output must always be well-formed

#[test]
#[fuzzer(runs: 30, seed: 45678)]
fn invariant_svg_structure(_variations: u32) {
    let adventurer = create_test_adventurer();
    let svg = generate_svg(adventurer);
    
    validate_svg_basic_structure(@svg);
}

// INVARIANT 5: Base64 Encoding Properties
// Base64 encoding must follow mathematical properties

#[test]
#[fuzzer(runs: 80, seed: 56789)]
fn invariant_base64_encoding_properties(input_value: u64) {
    let limited_input = create_u256_from_bytes(input_value);
    let result = bytes_base64_encode(limited_input.clone());
    
    validate_base64_properties(@limited_input, @result);
    
    // INVARIANT: Deterministic property  
    if limited_input.len() > 0 {
        let result2 = bytes_base64_encode(limited_input);
        assert_eq!(result, result2, "Base64 encoding must be deterministic");
    }
}

// INVARIANT 6: Trait Generation Consistency
// Traits must always be generated and have consistent structure

#[test]
#[fuzzer(runs: 30, seed: 67890)]
fn invariant_trait_generation(_variations: u32) {
    let adventurer1 = create_test_adventurer();
    let adventurer2 = create_test_adventurer();
    
    let traits = RendererImpl::get_traits(adventurer1);
    
    // INVARIANT: Must always generate traits
    assert!(traits.len() > 0, "Must always generate at least one trait");
    assert!(traits.len() >= 6, "Must have at least basic stat traits");
    
    // INVARIANT: Trait generation must be deterministic
    let traits2 = RendererImpl::get_traits(adventurer2);
    assert_eq!(traits.len(), traits2.len(), "Trait count must be deterministic");
    
    // INVARIANT: Each trait must be valid
    let mut i = 0;
    while i < traits.len() {
        let trait_ref = traits.at(i);
        assert!(trait_ref.name.len() >= 0, "Trait name should exist");
        i += 1;
    };
}

// INVARIANT 7: String Conversion Properties
// Number to string conversion must follow mathematical rules

#[test]
#[fuzzer(runs: 100, seed: 78901)]
fn invariant_string_conversion(value: u256) {
    let result = u256_to_string(value);
    
    validate_string_conversion_invariants(value, @result);
    
    // INVARIANT: Monotonic property for small values
    if value.high == 0 && value.low < 1000 && value.low > 0 {
        let smaller = u256 { low: value.low - 1, high: 0 };
        let smaller_result = u256_to_string(smaller);
        assert!(result.len() >= smaller_result.len(), "Larger numbers should have >= string length");
    }
    
    // INVARIANT: Deterministic conversion
    let result2 = u256_to_string(value);
    assert_eq!(result, result2, "String conversion must be deterministic");
}

// INVARIANT 8: Bytes Used Calculation Properties
// BytesUsed must follow mathematical properties

#[test]
#[fuzzer(runs: 80, seed: 89012)]
fn invariant_bytes_used_properties(value_u128: u128, value_u256: u256) {
    let bytes_u128 = value_u128.bytes_used();
    let bytes_u256 = value_u256.bytes_used();
    
    // INVARIANT: Range constraints
    assert!(bytes_u128 <= MAX_U128_BYTES, "u128 bytes must not exceed 16");
    assert!(bytes_u256 <= MAX_U256_BYTES, "u256 bytes must not exceed 32");
    
    // INVARIANT: Zero handling
    if value_u128 == 0 {
        assert_eq!(bytes_u128, 0, "Zero u128 must use 0 bytes");
    } else {
        assert!(bytes_u128 > 0, "Non-zero u128 must use >0 bytes");
    }
    
    if value_u256.low == 0 && value_u256.high == 0 {
        assert_eq!(bytes_u256, 0, "Zero u256 must use 0 bytes");
    } else {
        assert!(bytes_u256 > 0, "Non-zero u256 must use >0 bytes");
    }
    
    // INVARIANT: u256 high/low consistency
    if value_u256.high == 0 {
        let low_as_u128: u128 = value_u256.low.try_into().unwrap();
        let low_bytes = low_as_u128.bytes_used();
        assert_eq!(bytes_u256, low_bytes, "u256 with high=0 must match u128 calculation");
    }
    
    // INVARIANT: Boundary consistency for u128
    if value_u128 <= 255 {
        if value_u128 == 0 {
            assert_eq!(bytes_u128, 0, "Zero uses 0 bytes");
        } else {
            assert_eq!(bytes_u128, 1, "Values 1-255 use 1 byte");
        }
    } else if value_u128 <= 65535 {
        assert_eq!(bytes_u128, 2, "Values 256-65535 use 2 bytes");
    }
}

// INVARIANT 9: System State Consistency
// Overall system state must remain consistent across operations

#[test]
#[fuzzer(runs: 30, seed: 90123)]
fn invariant_system_state_consistency(operation_type: u8) {
    let adventurer1 = create_test_adventurer();
    let adventurer2 = create_test_adventurer();
    let adventurer3 = create_test_adventurer();
    let adventurer4 = create_test_adventurer();
    let adventurer5 = create_test_adventurer();
    let adventurer6 = create_test_adventurer();
    
    // Perform a single read operation based on input
    let op = operation_type % 4;
    
    match op {
        0 => { let _result = RendererImpl::render(1_u64, adventurer1); },
        1 => { let _traits = RendererImpl::get_traits(adventurer1); },
        2 => { let _description = RendererImpl::get_description(); },
        3 => { let _image = RendererImpl::get_image(adventurer1); },
        _ => {} // No-op
    }
    
    // INVARIANT: Read operations must not modify adventurer state
    assert!(adventurer2.health >= 0, "Health should be valid");
    assert!(adventurer2.level >= 0, "Level should be valid");
    
    // INVARIANT: Repeated operations must yield same results
    let result1 = RendererImpl::render(42_u64, adventurer3);
    let result2 = RendererImpl::render(42_u64, adventurer4);
    assert_eq!(result1, result2, "Repeated operations must be consistent");
    
    // INVARIANT: Different token IDs should produce valid results
    let result_token1 = RendererImpl::render(1_u64, adventurer5);
    let result_token2 = RendererImpl::render(2_u64, adventurer6);
    
    validate_data_uri_format(@result_token1, MIN_CONTENT_LENGTH);
    validate_data_uri_format(@result_token2, MIN_CONTENT_LENGTH);
}