// SPDX-License-Identifier: MIT
// Comprehensive test suite for encoding utilities

use death_mountain_renderer::utils::encoding::{
    U128BytesUsedTraitImpl, U256BytesUsedTraitImpl, bytes_base64_encode, get_base64_char_set,
};

#[test]
fn test_base64_char_set_completeness() {
    let charset = get_base64_char_set();
    assert(charset.len() == 64, 'charset_length_64');

    // Test specific indices for alphabet boundaries
    assert(*charset[0] == 'A', 'first_char_A');
    assert(*charset[25] == 'Z', 'last_upper_Z');
    assert(*charset[26] == 'a', 'first_lower_a');
    assert(*charset[51] == 'z', 'last_lower_z');
    assert(*charset[52] == '0', 'first_digit_0');
    assert(*charset[61] == '9', 'last_digit_9');
    assert(*charset[62] == '+', 'plus_symbol');
    assert(*charset[63] == '/', 'slash_symbol');
}

#[test]
fn test_base64_empty_input() {
    let empty: ByteArray = "";
    let result = bytes_base64_encode(empty);
    assert(result.len() == 0, 'empty_encode_zero_length');
}

#[test]
fn test_base64_single_byte() {
    let mut single: ByteArray = "";
    single.append_byte('A');
    let result = bytes_base64_encode(single);
    assert(result == "QQ==", 'single_byte_A_to_QQ');

    // Test different single bytes
    let mut single_zero: ByteArray = "";
    single_zero.append_byte(0);
    let result_zero = bytes_base64_encode(single_zero);
    assert(result_zero == "AA==", 'single_byte_0_to_AA');

    let mut single_max: ByteArray = "";
    single_max.append_byte(255);
    let result_max = bytes_base64_encode(single_max);
    assert(result_max == "/w==", 'single_byte_255');
}

#[test]
fn test_base64_two_bytes() {
    let mut double: ByteArray = "";
    double.append_byte('A');
    double.append_byte('B');
    let result = bytes_base64_encode(double);
    assert(result == "QUI=", 'double_byte_AB_to_QUI');

    // Test edge case with zeros
    let mut double_zero: ByteArray = "";
    double_zero.append_byte(0);
    double_zero.append_byte(0);
    let result_zero = bytes_base64_encode(double_zero);
    assert(result_zero == "AAA=", 'double_zero_to_AAA');
}

#[test]
fn test_base64_three_bytes() {
    let mut triple: ByteArray = "";
    triple.append_byte('A');
    triple.append_byte('B');
    triple.append_byte('C');
    let result = bytes_base64_encode(triple);
    assert(result == "QUJD", 'triple_byte_ABC_no_padding');

    // Test with binary data
    let mut triple_bin: ByteArray = "";
    triple_bin.append_byte(0);
    triple_bin.append_byte(1);
    triple_bin.append_byte(2);
    let result_bin = bytes_base64_encode(triple_bin);
    assert(result_bin.len() == 4, 'triple_binary_length_4');
}

#[test]
fn test_base64_six_bytes_multiple_of_three() {
    let mut six: ByteArray = "";
    six.append_byte('H');
    six.append_byte('e');
    six.append_byte('l');
    six.append_byte('l');
    six.append_byte('o');
    six.append_byte('!');
    let result = bytes_base64_encode(six);
    assert(result == "SGVsbG8h", 'hello_exclamation');
    assert(result.len() == 8, 'six_bytes_eight_output');
}

#[test]
fn test_base64_special_characters_producing_plus_slash() {
    // Test binary data that produces + and / characters in base64
    let mut special: ByteArray = "";
    special.append_byte(0xFF);
    special.append_byte(0xFE);
    special.append_byte(0xFD);
    let result = bytes_base64_encode(special);
    assert(result.len() == 4, 'special_char_length_4');
    // The result should be "//79" for these bytes
}

#[test]
fn test_base64_large_input() {
    // Test with realistic SVG data size
    let mut large: ByteArray = "";
    let mut i = 0;
    loop {
        if i == 150 {
            break;
        } // Reasonable size for testing
        large.append_byte(i.try_into().unwrap());
        i += 1;
    }
    let result = bytes_base64_encode(large);
    assert(result.len() > 150, 'large_encode_expanded');
    // Base64 expands by ~33%, so 150 bytes should become ~200 chars
    assert(result.len() <= 250, 'large_encode_reasonable_size');
}

// ============================================================================
// BYTES USED TRAIT TESTS - U128
// ============================================================================

#[test]
fn test_u128_bytes_used_zero_and_small() {
    assert(U128BytesUsedTraitImpl::bytes_used(0) == 0, 'zero_uses_zero_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(1) == 1, 'one_uses_one_byte');
    assert(U128BytesUsedTraitImpl::bytes_used(127) == 1, 'max_signed_byte');
    assert(U128BytesUsedTraitImpl::bytes_used(255) == 1, 'max_unsigned_byte');
}

#[test]
fn test_u128_bytes_used_two_byte_boundary() {
    assert(U128BytesUsedTraitImpl::bytes_used(256) == 2, 'min_two_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(65535) == 2, 'max_two_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(65536) == 3, 'min_three_bytes');
}

#[test]
fn test_u128_bytes_used_mid_range() {
    assert(U128BytesUsedTraitImpl::bytes_used(0x1000000) == 4, 'four_bytes'); // 16MB
    assert(U128BytesUsedTraitImpl::bytes_used(0x100000000) == 5, 'five_bytes'); // 4GB
    assert(U128BytesUsedTraitImpl::bytes_used(0x10000000000) == 6, 'six_bytes'); // 1TB
    assert(U128BytesUsedTraitImpl::bytes_used(0x10000000000000) == 7, 'seven_bytes'); // 256^7 - 1
}

#[test]
fn test_u128_bytes_used_eight_byte_boundary() {
    assert(U128BytesUsedTraitImpl::bytes_used(0xFFFFFFFFFFFFFFFF) == 8, 'max_eight_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(0x10000000000000000) == 9, 'min_nine_bytes');
}

#[test]
fn test_u128_bytes_used_high_range() {
    assert(U128BytesUsedTraitImpl::bytes_used(0x1000000000000000000) == 10, 'ten_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(0x100000000000000000000) == 11, 'eleven_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(0x10000000000000000000000) == 12, 'twelve_bytes');
    assert(U128BytesUsedTraitImpl::bytes_used(0x1000000000000000000000000) == 13, 'thirteen_bytes');
    assert(
        U128BytesUsedTraitImpl::bytes_used(0x100000000000000000000000000) == 14, 'fourteen_bytes',
    );
    assert(
        U128BytesUsedTraitImpl::bytes_used(0x10000000000000000000000000000) == 15, 'fifteen_bytes',
    );
    assert(
        U128BytesUsedTraitImpl::bytes_used(0x1000000000000000000000000000000) == 16,
        'sixteen_bytes',
    );
}

#[test]
fn test_u128_bytes_used_maximum() {
    // Test maximum u128 value
    let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    assert(U128BytesUsedTraitImpl::bytes_used(max_u128) == 16, 'max_u128_sixteen_bytes');
}

// ============================================================================
// BYTES USED TRAIT TESTS - U256
// ============================================================================

#[test]
fn test_u256_bytes_used_zero_and_low() {
    let zero: u256 = 0;
    assert(U256BytesUsedTraitImpl::bytes_used(zero) == 0, 'u256_zero_bytes');

    let one: u256 = 1;
    assert(U256BytesUsedTraitImpl::bytes_used(one) == 1, 'u256_one_byte');

    let max_byte: u256 = 255;
    assert(U256BytesUsedTraitImpl::bytes_used(max_byte) == 1, 'u256_max_byte');
}

#[test]
fn test_u256_bytes_used_low_range() {
    let two_bytes: u256 = 256;
    assert(U256BytesUsedTraitImpl::bytes_used(two_bytes) == 2, 'u256_two_bytes');

    let eight_bytes: u256 = 0x1000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(eight_bytes) == 8, 'u256_eight_bytes');

    let sixteen_bytes: u256 = 0x10000000000000000000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(sixteen_bytes) == 16, 'u256_sixteen_bytes');
}

#[test]
fn test_u256_bytes_used_high_boundary() {
    // Test boundary between low and high u128
    let max_low: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    assert(U256BytesUsedTraitImpl::bytes_used(max_low) == 16, 'u256_max_low_sixteen');

    let min_high: u256 = 0x100000000000000000000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(min_high) == 17, 'u256_min_high_seventeen');
}

#[test]
fn test_u256_bytes_used_high_range() {
    let twenty_bytes: u256 = 0x100000000000000000000000000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(twenty_bytes) == 20, 'u256_twenty_bytes');

    let twenty_nine_bytes: u256 = 0x100000000000000000000000000000000000000000000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(twenty_nine_bytes) == 29, 'u256_twenty_nine_bytes');

    // For exactly 30 bytes, we need 60 hex digits total (30 * 2)
    // This gives us 28 hex digits in high part: 1 + 27 zeros = 28 digits (14 bytes)
    let thirty_bytes: u256 = 0x10000000000000000000000000000000000000000000000000000000000;
    assert(U256BytesUsedTraitImpl::bytes_used(thirty_bytes) == 30, 'u256_thirty_bytes');
}


#[test]
fn test_u256_bytes_used_maximum() {
    // Test maximum u256 value
    let max_u256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    assert(U256BytesUsedTraitImpl::bytes_used(max_u256) == 32, 'u256_max_thirty_two_bytes');
}

// ============================================================================
// INTEGRATION TESTS
// ============================================================================

#[test]
fn test_base64_with_realistic_svg_content() {
    // Test with SVG-like content structure
    let mut svg_content: ByteArray = "";
    svg_content += "<svg viewBox=\"0 0 400 400\" xmlns=\"http://www.w3.org/2000/svg\">";
    svg_content += "<rect width=\"100\" height=\"50\" fill=\"red\"/>";
    svg_content += "</svg>";

    let result = bytes_base64_encode(svg_content);
    assert(result.len() > 0, 'svg_content_encoded');

    // Should be considerably longer than input due to base64 expansion
    assert(result.len() > 80, 'svg_content_expanded');
}

#[test]
fn test_base64_with_json_metadata() {
    // Test with JSON-like content structure
    let mut json_content: ByteArray = "";
    json_content +=
        "{\"name\":\"Test\",\"description\":\"A test NFT\",\"image\":\"data:image/svg+xml;base64,PHN2Zz==\"}";

    // Calculate expected length before moving json_content
    let expected_length = (json_content.len() + 2) / 3 * 4; // Base64 formula

    let result = bytes_base64_encode(json_content);
    assert(result.len() > 0, 'json_content_encoded');

    // Verify no padding issues with complex JSON
    assert(result.len() == expected_length, 'json_correct_base64_length');
}
