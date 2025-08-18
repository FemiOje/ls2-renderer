// SPDX-License-Identifier: MIT
//
// @title String Utilities - Optimized Pattern Matching and String Operations
// @notice High-performance string search and manipulation functions for Cairo
// @dev Optimized algorithms for efficient pattern matching in ByteArray data
// @author Built for the Loot Survivor ecosystem

/// @notice Optimized pattern matching function with dual-strategy approach
/// @dev Uses naive search for short patterns (≤4 chars) and optimized search for longer patterns
/// @param haystack The ByteArray to search within
/// @param needle The pattern to search for
/// @return bool True if pattern is found, false otherwise
pub fn contains_pattern(haystack: @ByteArray, needle: @ByteArray) -> bool {
    if needle.len() == 0 {
        return true;
    }
    if haystack.len() < needle.len() {
        return false;
    }

    // For short patterns, use naive search (more efficient for small patterns)
    if needle.len() <= 4 {
        return naive_search(haystack, needle);
    }

    // For longer patterns, use optimized search with skip table
    optimized_search(haystack, needle)
}

/// @notice Naive string search algorithm for short patterns
/// @dev Simple character-by-character comparison, optimal for patterns ≤4 characters
/// @param haystack The ByteArray to search within
/// @param needle The pattern to search for
/// @return bool True if pattern is found, false otherwise
fn naive_search(haystack: @ByteArray, needle: @ByteArray) -> bool {
    let mut i = 0;
    while i <= haystack.len() - needle.len() {
        let mut match_found = true;
        let mut j = 0;
        while j < needle.len() {
            if haystack[i + j] != needle[j] {
                match_found = false;
                break;
            }
            j += 1;
        }
        if match_found {
            return true;
        }
        i += 1;
    }
    false
}

/// @notice Optimized pattern search using first/last character matching heuristic
/// @dev Implements a simplified Boyer-Moore-like approach for better performance
/// @param haystack The ByteArray to search within
/// @param needle The pattern to search for
/// @return bool True if pattern is found, false otherwise
fn optimized_search(haystack: @ByteArray, needle: @ByteArray) -> bool {
    // Simple optimization: check first and last character before full match
    let first_char = needle[0];
    let last_char = needle[needle.len() - 1];

    let mut i = 0;
    while i <= haystack.len() - needle.len() {
        // Quick check: first and last characters must match
        if haystack[i] == first_char && haystack[i + needle.len() - 1] == last_char {
            // Now check the full pattern
            let mut match_found = true;
            let mut j = 1; // Skip first char since we already checked it
            while j < needle.len() - 1 { // Skip last char since we already checked it
                if haystack[i + j] != needle[j] {
                    match_found = false;
                    break;
                }
                j += 1;
            }
            if match_found {
                return true;
            }
        }
        i += 1;
    }
    false
}

/// @notice Check if a ByteArray starts with a specific pattern
/// @dev Efficient prefix matching for validation and parsing
/// @param text The ByteArray to check
/// @param prefix The pattern that should appear at the start
/// @return bool True if text starts with prefix, false otherwise
pub fn starts_with_pattern(text: @ByteArray, prefix: @ByteArray) -> bool {
    if prefix.len() > text.len() {
        return false;
    }
    let mut i = 0;
    while i < prefix.len() {
        if text[i] != prefix[i] {
            return false;
        }
        i += 1;
    }
    true
}

/// @notice Check if a ByteArray ends with a specific pattern
/// @dev Efficient suffix matching for validation and parsing
/// @param text The ByteArray to check
/// @param suffix The pattern that should appear at the end
/// @return bool True if text ends with suffix, false otherwise
pub fn ends_with_pattern(text: @ByteArray, suffix: @ByteArray) -> bool {
    if suffix.len() > text.len() {
        return false;
    }
    let start_pos = text.len() - suffix.len();
    let mut i = 0;
    while i < suffix.len() {
        if text[start_pos + i] != suffix[i] {
            return false;
        }
        i += 1;
    }
    true
}

/// @notice Compare two ByteArrays for exact equality
/// @dev Efficient byte-by-byte comparison with early exit optimization
/// @param a First ByteArray to compare
/// @param b Second ByteArray to compare
/// @return bool True if ByteArrays are identical, false otherwise
pub fn byte_array_eq(a: @ByteArray, b: @ByteArray) -> bool {
    if a.len() != b.len() {
        return false;
    }
    let mut i = 0;
    while i < a.len() {
        if a[i] != b[i] {
            return false;
        }
        i += 1;
    }
    true
}

/// @notice Validate that a ByteArray contains only digit characters (0-9)
/// @dev Useful for validating numeric string conversions
/// @param text The ByteArray to validate
/// @return bool True if all characters are digits, false otherwise
pub fn is_all_digits(text: @ByteArray) -> bool {
    if text.len() == 0 {
        return false;
    }
    let mut i = 0;
    while i < text.len() {
        let byte = text[i];
        if byte < 48 || byte > 57 { // ASCII '0' = 48, '9' = 57
            return false;
        }
        i += 1;
    }
    true
}

/// @notice Count occurrences of a specific byte in a ByteArray
/// @dev Useful for counting specific characters like padding or separators
/// @param haystack The ByteArray to search within
/// @param needle The byte value to count
/// @return u32 Number of occurrences found
pub fn count_byte_occurrences(haystack: @ByteArray, needle: u8) -> u32 {
    let mut count = 0;
    let mut i = 0;
    while i < haystack.len() {
        if haystack[i] == needle {
            count += 1;
        }
        i += 1;
    }
    count
}

/// @notice Check if a ByteArray contains a specific byte value
/// @dev Fast single-byte search with early exit optimization
/// @param haystack The ByteArray to search within
/// @param needle The byte value to find
/// @return bool True if byte is found, false otherwise
pub fn contains_byte(haystack: @ByteArray, needle: u8) -> bool {
    let mut i = 0;
    while i < haystack.len() {
        if haystack[i] == needle {
            return true;
        }
        i += 1;
    }
    false
}
