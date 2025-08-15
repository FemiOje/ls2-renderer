// SPDX-License-Identifier: MIT

use death_mountain_renderer::utils::encoding::{BytesUsedTrait, bytes_base64_encode};
use death_mountain_renderer::utils::string_utils::{contains_byte, count_byte_occurrences};

const MAX_SIZE: u32 = 100;

fn validate_base64(input: @ByteArray, result: @ByteArray) {
    // Length validation
    if input.len() == 0 {
        assert_eq!(result.len(), 0, "Empty input should produce empty output");
        return;
    }

    let expected_len = ((input.len() + 2) / 3) * 4;
    assert_eq!(result.len(), expected_len, "Invalid Base64 length");

    // Character validation
    let mut i = 0;
    while i < result.len() {
        let c = result[i];
        let valid = (c >= 65 && c <= 90)
            || (c >= 97 && c <= 122)
            || (c >= 48 && c <= 57)
            || c == 43
            || c == 47
            || c == 61;
        assert!(valid, "Invalid Base64 character");
        i += 1;
    }

    // Padding validation
    let padding = count_byte_occurrences(result, 61);
    let remainder = input.len() % 3;
    let expected_padding = if remainder == 0 {
        0
    } else {
        3 - remainder
    };
    assert_eq!(padding, expected_padding, "Invalid padding");
}

fn limit_input(input: ByteArray, max: u32) -> ByteArray {
    if input.len() <= max {
        return input;
    }
    let mut result = "";
    let mut i = 0;
    while i < max {
        result.append_byte(input[i]);
        i += 1;
    }
    result
}

#[test]
#[fuzzer(runs: 200, seed: 11111)]
fn fuzz_base64_comprehensive(input: ByteArray) {
    let limited = limit_input(input, MAX_SIZE);
    let result = bytes_base64_encode(limited.clone());
    validate_base64(@limited, @result);

    // Test determinism
    let result2 = bytes_base64_encode(limited);
    assert_eq!(result, result2, "Should be deterministic");
}

#[test]
#[fuzzer(runs: 150, seed: 22222)]
fn fuzz_base64_patterns(size: u8, fill: u8) {
    let len: u32 = if size > 50 {
        50
    } else {
        size.into()
    };
    let mut input = "";
    let mut i: u32 = 0;
    while i < len {
        input.append_byte(fill);
        i += 1;
    }

    let result = bytes_base64_encode(input.clone());
    validate_base64(@input, @result);

    // Zero bytes should produce 'A'
    if len > 0 && fill == 0 {
        assert!(contains_byte(@result, 65), "Zero bytes should produce 'A'");
    }
}

#[test]
#[fuzzer(runs: 300, seed: 44444)]
fn fuzz_bytes_used_u128(value: u128) {
    let bytes = value.bytes_used();
    assert!(bytes <= 16, "u128 max 16 bytes");

    if value == 0 {
        assert_eq!(bytes, 0, "Zero uses 0 bytes");
    } else {
        assert!(bytes > 0, "Non-zero uses >0 bytes");
        if value <= 0xFF {
            assert_eq!(bytes, 1, "1 byte for <=255");
        } else if value <= 0xFFFF {
            assert_eq!(bytes, 2, "2 bytes for <=65535");
        }
    }

    // Monotonic property
    if value > 0 {
        assert!(bytes >= (value - 1).bytes_used(), "Monotonic bytes");
    }
}

#[test]
#[fuzzer(runs: 200, seed: 55555)]
fn fuzz_bytes_used_u256(value: u256) {
    let bytes = value.bytes_used();
    assert!(bytes <= 32, "u256 max 32 bytes");

    if value.low == 0 && value.high == 0 {
        assert_eq!(bytes, 0, "Zero uses 0 bytes");
    } else {
        assert!(bytes > 0, "Non-zero uses >0 bytes");
    }

    // High/Low consistency
    if value.high == 0 {
        assert_eq!(bytes, value.low.bytes_used(), "high=0 should match u128");
    } else {
        assert!(bytes >= 17, "high!=0 uses >=17 bytes");
        assert_eq!(bytes, 16 + value.high.bytes_used(), "16 + high_bytes");
    }
}
