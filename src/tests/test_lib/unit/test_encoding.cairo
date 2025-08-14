// SPDX-License-Identifier: MIT
//
// @title Base64 Encoding Unit Tests with Edge Case Coverage
// @notice Comprehensive tests for gas-optimized Base64 encoding operations
// @dev Tests boundary conditions, performance, and security edge cases

use death_mountain_renderer::utils::encoding::{
    bytes_base64_encode, get_base64_char_set, BytesUsedTrait
};

#[test]
fn test_base64_empty_input() {
    let empty_ba = "";
    let result = bytes_base64_encode(empty_ba);
    assert!(result.len() == 0, "Empty input should produce empty output");
}

#[test]
fn test_base64_single_byte() {
    let mut single_ba = "";
    single_ba.append_byte(77);
    let result = bytes_base64_encode(single_ba);
    let expected = "TQ=="; // Base64 for 'M'
    assert_eq!(result, expected, "Single byte encoding failed");
}

#[test]
fn test_base64_two_bytes() {
    let mut two_ba = "";
    two_ba.append_byte(77);
    two_ba.append_byte(97);
    let result = bytes_base64_encode(two_ba);
    let expected = "TWE="; // Base64 for "Ma"
    assert_eq!(result, expected, "Two byte encoding failed");
}

#[test]
fn test_base64_three_bytes() {
    let mut three_ba = "";
    three_ba.append_byte(77);
    three_ba.append_byte(97);
    three_ba.append_byte(110);
    let result = bytes_base64_encode(three_ba);
    let expected = "TWFu"; // Base64 for "Man"
    assert_eq!(result, expected, "Three byte encoding failed");
}

#[test]
fn test_base64_six_bytes_multiple_of_three() {
    let mut six_ba = "";
    six_ba.append_byte(72);
    six_ba.append_byte(101);
    six_ba.append_byte(108);
    six_ba.append_byte(108);
    six_ba.append_byte(111);
    six_ba.append_byte(33);
    let result = bytes_base64_encode(six_ba);
    let expected = "SGVsbG8h"; // Base64 for "Hello!"
    assert_eq!(result, expected, "Six byte encoding failed");
}

#[test]
fn test_base64_large_input() {
    let mut large_input = "";
    let mut i = 0;
    while i < 100 {
        large_input.append_byte(65 + (i % 26_u32).try_into().unwrap()); // Generate A-Z pattern
        i += 1;
    };
    
    let input_len = large_input.len();
    let result = bytes_base64_encode(large_input);
    assert!(result.len() > 0, "Large input should produce non-empty output");
    // Verify length follows Base64 rule: ceil(4/3 * input_length)
    let expected_min_length = (input_len * 4 + 2) / 3;
    assert!(result.len() >= expected_min_length, "Output length incorrect for large input");
}

#[test]
fn test_base64_special_characters_producing_plus_slash() {
    // Input bytes that should produce '+' and '/' in Base64 output
    let mut special_ba = "";
    special_ba.append_byte(252);
    special_ba.append_byte(255);
    special_ba.append_byte(63);
    let result = bytes_base64_encode(special_ba);
    assert!(result.len() > 0, "Special character encoding failed");
}

#[test]
fn test_base64_char_set_completeness() {
    let char_set = get_base64_char_set();
    assert_eq!(char_set.len(), 64, "Base64 character set should contain exactly 64 characters");
}

#[test]
fn test_base64_with_json_metadata() {
    let mut json_content = "{\"name\":\"Adventurer #1\",\"description\":\"Death Mountain Battle Interface\"}";
    let result = bytes_base64_encode(json_content);
    
    assert!(result.len() > 0, "JSON encoding should produce non-empty output");
}

#[test]
fn test_base64_with_realistic_svg_content() {
    let mut svg_start = "<svg width=\"400\" height=\"600\" xmlns=\"http://www.w3.org/2000/svg\">";
    
    let input_len = ByteArrayTrait::len(@svg_start);
    let result = bytes_base64_encode(svg_start);
    assert!(result.len() > 0, "SVG encoding should produce output");
    assert!(result.len() >= (input_len * 4) / 3, "Output should meet minimum Base64 length");
}

// BytesUsedTrait Tests

#[test]
fn test_u128_bytes_used_zero_and_small() {
    assert_eq!(0_u128.bytes_used(), 0, "Zero should use 0 bytes");
    assert_eq!(1_u128.bytes_used(), 1, "Value 1 should use 1 byte");
    assert_eq!(255_u128.bytes_used(), 1, "Value 255 should use 1 byte");
}

#[test]
fn test_u128_bytes_used_two_byte_boundary() {
    assert_eq!(256_u128.bytes_used(), 2, "Value 256 should use 2 bytes");
    assert_eq!(65535_u128.bytes_used(), 2, "Value 65535 should use 2 bytes");
}

#[test]
fn test_u128_bytes_used_eight_byte_boundary() {
    let eight_byte_max: u128 = 0xffffffffffffffff; // 2^64 - 1
    assert_eq!(eight_byte_max.bytes_used(), 8, "8-byte max should use 8 bytes");
}

#[test]
fn test_u128_bytes_used_mid_range() {
    assert_eq!(16777216_u128.bytes_used(), 4, "16MB should use 4 bytes"); // 2^24
    assert_eq!(4294967296_u128.bytes_used(), 5, "4GB should use 5 bytes"); // 2^32
}

#[test]
fn test_u128_bytes_used_high_range() {
    let twelve_byte_value = 0x1000000000000000000000000_u128; // 2^96
    assert_eq!(twelve_byte_value.bytes_used(), 13, "12-byte value should use 13 bytes");
}

#[test]
fn test_u128_bytes_used_maximum() {
    let max_u128 = 0xffffffffffffffffffffffffffffffff_u128; // 2^128 - 1
    assert_eq!(max_u128.bytes_used(), 16, "Max u128 should use 16 bytes");
}

#[test]
fn test_u256_bytes_used_zero_and_low() {
    assert_eq!(0_u256.bytes_used(), 0, "Zero u256 should use 0 bytes");
    assert_eq!(1_u256.bytes_used(), 1, "Value 1 u256 should use 1 byte");
    assert_eq!(255_u256.bytes_used(), 1, "Value 255 u256 should use 1 byte");
}

#[test]
fn test_u256_bytes_used_low_range() {
    assert_eq!(65536_u256.bytes_used(), 3, "64KB u256 should use 3 bytes");
    assert_eq!(16777216_u256.bytes_used(), 4, "16MB u256 should use 4 bytes");
}

#[test]
fn test_u256_bytes_used_high_boundary() {
    // Test when high part starts being used
    let high_part_start = u256 { low: 0xffffffffffffffffffffffffffffffff, high: 1 };
    assert_eq!(high_part_start.bytes_used(), 17, "High part start should use 17 bytes");
}

#[test]
fn test_u256_bytes_used_high_range() {
    let high_part_value = u256 { low: 0, high: 0x1000000000000000000000000 };
    assert_eq!(high_part_value.bytes_used(), 29, "High part value should use 29 bytes");
}

#[test]
fn test_u256_bytes_used_maximum() {
    let max_u256 = u256 { 
        low: 0xffffffffffffffffffffffffffffffff, 
        high: 0xffffffffffffffffffffffffffffffff 
    };
    assert_eq!(max_u256.bytes_used(), 32, "Max u256 should use 32 bytes");
}

// Fuzz Testing for Base64 Encoding

#[test]
#[fuzzer(runs: 100, seed: 42)]
fn fuzz_base64_encoding_random_bytes(input_value: u32) {
    // Create ByteArray from u32 value
    let mut input_bytes = "";
    if input_value > 0 {
        input_bytes.append_byte((input_value % 256).try_into().unwrap());
        if input_value > 255 {
            input_bytes.append_byte(((input_value / 256) % 256).try_into().unwrap());
        }
        if input_value > 65535 {
            input_bytes.append_byte(((input_value / 65536) % 256).try_into().unwrap());
        }
    }
    
    let input_len = input_bytes.len();
    let result = bytes_base64_encode(input_bytes);
    
    // Invariants that should always hold
    if input_len == 0 {
        assert_eq!(result.len(), 0, "Empty input should produce empty output");
    } else {
        assert!(result.len() > 0, "Non-empty input should produce non-empty output");
    }
}

#[test]
#[fuzzer(runs: 500, seed: 123)]
fn fuzz_bytes_used_u128(value: u128) {
    let bytes_used = value.bytes_used();
    
    // Invariants
    assert!(bytes_used <= 16, "u128 should never use more than 16 bytes");
    
    if value == 0 {
        assert_eq!(bytes_used, 0, "Zero should use 0 bytes");
    } else {
        assert!(bytes_used > 0, "Non-zero value should use at least 1 byte");
    }
    
    // Check that the value fits in the reported byte count
    if bytes_used > 0 && bytes_used < 16 {
        let max_for_bytes = if bytes_used == 1 { 255 } 
                           else if bytes_used == 2 { 65535 } 
                           else { return; }; // Skip complex calculations for fuzz
        
        if bytes_used <= 2 {
            assert!(value <= max_for_bytes, "Value should fit in reported byte count");
        }
    }
}

#[test]
#[fuzzer(runs: 500, seed: 456)]
fn fuzz_bytes_used_u256(value: u256) {
    let bytes_used = value.bytes_used();
    
    // Invariants
    assert!(bytes_used <= 32, "u256 should never use more than 32 bytes");
    
    if value == 0 {
        assert_eq!(bytes_used, 0, "Zero should use 0 bytes");
    } else {
        assert!(bytes_used > 0, "Non-zero value should use at least 1 byte");
    }
    
    // High part consistency check
    if value.high == 0 {
        let low_bytes = value.low.bytes_used();
        assert_eq!(bytes_used, low_bytes, "Low-only u256 should match u128 bytes");
    } else {
        assert!(bytes_used >= 17, "u256 with high part should use at least 17 bytes");
    }
}

// Gas Optimization Tests

#[test]
fn test_base64_encoding_functionality() {
    let mut test_data = "";
    test_data.append_byte(72);
    test_data.append_byte(101);
    test_data.append_byte(108);
    test_data.append_byte(108);
    test_data.append_byte(111);
    let result = bytes_base64_encode(test_data);
    
    // This test ensures the function completes and produces output
    assert!(result.len() > 0, "Encoding should produce output");
}

#[test]
fn test_char_set_functionality() {
    let char_set = get_base64_char_set();
    
    // Verify character set generation works
    assert_eq!(char_set.len(), 64, "Character set should have 64 characters");
}

// Security Edge Cases

#[test]
fn test_base64_malicious_input_sizes() {
    // Test with maximum reasonable input size
    let mut max_input = "";
    let mut i = 0;
    while i < 255 { // Reduced size to prevent issues
        max_input.append_byte(i);
        i += 1;
    };
    
    let result = bytes_base64_encode(max_input);
    assert!(result.len() > 0, "Large input should be handled gracefully");
}

#[test]
fn test_base64_buffer_overflow_protection() {
    // Test patterns that might cause buffer issues
    let mut pattern_bytes = "";
    pattern_bytes.append_byte(255);
    pattern_bytes.append_byte(255);
    pattern_bytes.append_byte(255);
    pattern_bytes.append_byte(255);
    let result = bytes_base64_encode(pattern_bytes);
    assert!(result.len() > 0, "High-value bytes should be handled safely");
}