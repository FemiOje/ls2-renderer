// SPDX-License-Identifier: MIT
//
// @title Renderer Utilities - SVG Generation and Metadata Creation
// @notice Comprehensive utility functions for generating dynamic battle interface SVG artwork
// @dev Modular SVG component system optimized for gas efficiency and visual excellence
// @author Built for the Loot Survivor ecosystem

use death_mountain_renderer::models::models::{
    AdventurerVerbose, EquipmentVerbose, GameDetail, Stats, StatsTrait,
};
use death_mountain_renderer::utils::encoding::U256BytesUsedTraitImpl;


// ============================================================================
// SVG ICON COMPONENTS
// ============================================================================
// These functions generate reusable SVG path elements for equipment icons
// Each icon is designed to be scalable and visually clear at multiple sizes

/// @notice Generates the weapon icon SVG path
/// @dev Optimized path data for sword/weapon representation
/// @return SVG path element for weapon icon
pub fn weapon() -> ByteArray {
    "<path d=\"M8 4V3H6V2H5V1H3v2H2v2H1v1h2V5h2v2H4v2H3v2H2v2H1v2H0v2h2v-2h1v-2h1v-2h1V9h1V7h2v5h2v-2h1V8h1V6h1V4H8Z\"/>"
}

/// @notice Generates the chest armor icon SVG path
/// @dev Detailed path data representing chest/torso armor
/// @return SVG path element for chest armor icon
pub fn chest() -> ByteArray {
    "<path d=\"M0 8h2V7H0v1Zm3-3V2H2v1H1v2H0v1h4V5H3Zm2-4H4v4h1V1Zm6 0v4h1V1h-1Zm4 4V3h-1V2h-1v3h-1v1h4V5h-1Zm-1 3h2V7h-2v1ZM9 7H7V6H4v1H3v4h4v-1h2v1h4V7h-1V6H9v1Zm1 6v1h1v2h1v-2h1v-2H9v1h1Zm-3-1h2v-1H7v1Zm0 1v-1H3v2h1v2h1v-2h1v-1h1Zm2 0H7v1H6v2h4v-2H9v-1Z\" />"
}

/// @notice Generates the head armor/helmet icon SVG path
/// @dev Stylized helmet design with clear visual recognition
/// @return SVG path element for head armor icon
pub fn head() -> ByteArray {
    "<path d=\"M12 2h-1V1h-1V0H6v1H5v1H4v1H3v8h1v1h2V8H5V7H4V5h3v4h2V5h3v2h-1v1h-1v4h2v-1h1V3h-1V2ZM2 2V1H1V0H0v2h1v2h1v1-2h1V2H2Zm13-2v1h-1v1h-1v1h1v2-1h1V2h1V0h-1Z\"/>"
}

/// @notice Generates the waist armor/belt icon SVG path
/// @dev Belt or waist armor representation with buckle details
/// @return SVG path element for waist armor icon
pub fn waist() -> ByteArray {
    "<path d=\"M0 13h2v-1H0v1Zm0-2h3v-1H0v1Zm1-7H0v5h3V8h2V3H1v1Zm0-2h4V0H1v2Zm5 0h1V1h1v1h1V0H6v2Zm8-2h-4v2h4V0Zm0 4V3h-4v5h2v1h3V4h-1Zm-2 7h3v-1h-3v1Zm1 2h2v-1h-2v1ZM6 9h1v1h1V9h1V3H6v6Z\"/>"
}

/// @notice Generates the foot armor/boots icon SVG path
/// @dev Boot design with detailed sole and upper construction
/// @return SVG path element for foot armor icon
pub fn foot() -> ByteArray {
    "<path d=\"M4 1V0H0v2h5V1H4Zm2-1H5v1h1V0Zm0 2H5v1h1V2Zm0 2V3H5v1h1Zm0 2V5H5v1h1Zm0 2V7H5v1h1Zm5 0V7H9v1h2Zm0-2V5H9v1h2Zm0-2V3H9v1h2Zm0-2H9v1h2V2Zm0-2H9v1h2V0ZM8 1V0H7v2h2V1H8Zm0 6h1V6H8V5h1V4H8V3h1-2v5h1V7ZM6 9V8H4V7h1V6H4V5h1V4H4V3h1-5v8h5V9h1Zm5 0h-1V8H7v1H6v2H5v1h6V9ZM0 13h5v-1H0v1Zm11 0v-1H5v1h6Zm1 0h4v-1h-4v1Zm3-3V9h-1V8h-2v1h-1v1h1v2h4v-2h-1Zm-4-2v1-1Z\"/>"
}

/// @notice Generates the hand armor/gloves icon SVG path
/// @dev Gauntlet design showing fingers and hand protection
/// @return SVG path element for hand armor icon
pub fn hand() -> ByteArray {
    "<path d=\"M9 8v1H8v3H4v-1h3V2H6v7H5V1H4v8H3V2H2v8H1V5H0v10h1v2h5v-1h2v-1h1v-2h1V8H9Z\"/>"
}

/// @notice Generates the neck armor/necklace icon SVG path
/// @dev Amulet or neck piece design with decorative elements
/// @return SVG path element for neck armor icon
pub fn neck() -> ByteArray {
    "<path d=\"M14 8V6h-1V5h-1V4h-1V3h-1V2H8V1H2v1H1v1H0v8h1v1h1v1h4v-1h1v-1H3v-1H2V4h1V3h4v1h2v1h1v1h1v1h1v1h1v1h-2v1h1v1h2v-1h1V8h-1Zm-6 3v1h1v-1H8Zm1 0h2v-1H9v1Zm4 3v-2h-1v2h1Zm-6-2v2h1v-2H7Zm2 4h2v-1H9v1Zm-1-2v1h1v-1H8Zm3 1h1v-1h-1v1Zm0-3h1v-1h-1v1Zm-2 2h2v-2H9v2Z\"/>"
}

/// @notice Generates the ring icon SVG path
/// @dev Ring design with gem or decorative element
/// @return SVG path element for ring icon
pub fn ring() -> ByteArray {
    "<path d=\"M13 3V2h-1V1h-2v1h1v3h-1v2H9v1H8v1H7v1H6v1H4v1H1v-1H0v2h1v1h1v1h4v-1h2v-1h1v-1h1v-1h1v-1h1V9h1V7h1V3h-1ZM3 9h1V8h1V7h1V6h1V5h1V4h2V2H9V1H8v1H6v1H5v1H4v1H3v1H2v1H1v2H0v1h1v1h2V9Z\"/>"
}


// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================
// Core utility functions for data conversion and SVG generation

/// @notice Converts u8 value to string representation for display in SVG
/// @dev Handles edge case of zero and builds string digit by digit
/// @param value The u8 value to convert to string
/// @return ByteArray containing the string representation
fn u8_to_string(value: u8) -> ByteArray {
    if value == 0 {
        return "0";
    }

    let mut result = "";
    let mut val: u256 = value.into();
    let mut digits: Array<u8> = array![];

    while val > 0 {
        let digit = (val % 10).try_into().unwrap();
        digits.append(digit + 48); // Convert to ASCII
        val = val / 10;
    }

    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    }

    result
}

/// @notice Converts u64 value to string representation for display in SVG
/// @dev Handles edge case of zero and builds string digit by digit
/// @param value The u64 value to convert to string
/// @return ByteArray containing the string representation
pub fn u64_to_string(value: u64) -> ByteArray {
    if value == 0 {
        return "0";
    }

    let mut result = "";
    let mut val: u256 = value.into();
    let mut digits: Array<u8> = array![];

    while val > 0 {
        let digit = (val % 10).try_into().unwrap();
        digits.append(digit + 48); // Convert ASCII
        val = val / 10;
    }

    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    }

    result
}

/// @notice Converts u256 value to string representation for display
/// @dev Handles large numbers efficiently, builds string digit by digit
/// @param value The u256 value to convert to string
/// @return ByteArray containing the string representation
pub fn u256_to_string(value: u256) -> ByteArray {
    if value == 0 {
        return "0";
    }

    let mut result = "";
    let mut val = value;
    let mut digits: Array<u8> = array![];

    while val > 0 {
        let digit = (val % 10).try_into().unwrap();
        digits.append(digit + 48); // Convert to ASCII
        val = val / 10;
    }

    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    }

    result
}

/// @notice Calculates equipment greatness/level from experience points
/// @dev Mimics death-mountain's get_greatness function using square root calculation
/// @param xp The experience points of the equipment item
/// @return Equipment level/greatness value (1-20, capped at MAX_GREATNESS)
pub fn get_greatness(xp: u16) -> u8 {
    if xp == 0 {
        1
    } else {
        // Calculate square root of xp for level
        let level = sqrt_u16(xp);
        if level > MAX_GREATNESS {
            MAX_GREATNESS
        } else {
            level
        }
    }
}

/// @notice Simple integer square root implementation for u16 values
/// @dev Uses Newton's method for efficient square root calculation, with overflow protection
/// @param value The u16 value to calculate square root of
/// @return u8 containing the integer square root
pub fn sqrt_u16(value: u16) -> u8 {
    if value == 0 {
        return 0;
    }

    // Use u32 for intermediate calculations to prevent overflow
    let mut x: u32 = value.into();
    let mut y: u32 = (x + 1) / 2;

    while y < x {
        x = y;
        let value_u32: u32 = value.into();
        y = (x + value_u32 / x) / 2;
    }

    // Cap result to u8 max if needed
    if x > 255 {
        255
    } else {
        x.try_into().unwrap()
    }
}

/// @notice Maximum equipment greatness level (matching death-mountain implementation)
const MAX_GREATNESS: u8 = 20;

/// @notice Converts felt252 value to ByteArray string representation
/// @dev Extracts bytes from felt252 and builds string, skipping null bytes
/// @param value The felt252 value to convert (typically item names from database)
/// @return ByteArray containing the string representation
pub fn felt252_to_string(value: felt252) -> ByteArray {
    // Cairo felt252 values that represent strings are directly convertible to ByteArray
    // Most felt252 string constants in the item database are stored as string literals
    let mut result = "";

    // Handle the zero case
    if value == 0 {
        return "";
    }

    // Convert felt252 to u256 first for bit manipulation
    let val_u256: u256 = value.into();
    let mut temp_val = val_u256;
    let mut bytes: Array<u8> = array![];

    // Extract bytes from the u256 value
    while temp_val > 0 {
        let byte = (temp_val % 256).try_into().unwrap();
        if byte != 0 { // Skip null bytes
            bytes.append(byte);
        }
        temp_val = temp_val / 256;
    }

    // Reverse the bytes since we extracted them in reverse order
    let mut i = bytes.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*bytes.at(i));
    }

    result
}

// Get the character length of a felt252 string
pub fn felt252_length(value: felt252) -> u32 {
    // Handle the zero case
    if value == 0 {
        return 0;
    }

    // Convert felt252 to u256 first for bit manipulation
    let val_u256: u256 = value.into();
    let mut temp_val = val_u256;
    let mut length: u32 = 0;

    // Count non-zero bytes
    while temp_val > 0 {
        let byte = (temp_val % 256).try_into().unwrap();
        if byte != 0 { // Skip null bytes
            length += 1;
        }
        temp_val = temp_val / 256;
    }

    length
}

// Generate dynamic adventurer stats text elements for the 7 core stats
fn generate_stats_text(stats: Stats) -> ByteArray {
    let mut stats_text = "";

    // STR (Strength) - stat name on top, value below - aligned with logo/level at y=124
    stats_text += "<text x=\"195\" y=\"124\" fill=\"#78E846\" class=\"s16\">STR</text>";
    stats_text += "<text x=\"195\" y=\"164\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.strength);
    stats_text += "</text>";

    // DEX (Dexterity) - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"224\" fill=\"#78E846\" class=\"s16\">DEX</text>";
    stats_text += "<text x=\"195\" y=\"264\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.dexterity);
    stats_text += "</text>";

    // VIT (Vitality) - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"324\" fill=\"#78E846\" class=\"s16\">VIT</text>";
    stats_text += "<text x=\"195\" y=\"364\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.vitality);
    stats_text += "</text>";

    // INT (Intelligence) - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"424\" fill=\"#78E846\" class=\"s16\">INT</text>";
    stats_text += "<text x=\"195\" y=\"464\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.intelligence);
    stats_text += "</text>";

    // WIS (Wisdom) - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"524\" fill=\"#78E846\" class=\"s16\">WIS</text>";
    stats_text += "<text x=\"195\" y=\"564\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.wisdom);
    stats_text += "</text>";

    // CHA (Charisma) - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"624\" fill=\"#78E846\" class=\"s16\">CHA</text>";
    stats_text += "<text x=\"195\" y=\"664\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.charisma);
    stats_text += "</text>";

    // LUCK - stat name on top, value below
    stats_text += "<text x=\"195\" y=\"724\" fill=\"#78E846\" class=\"s16\">LUCK</text>";
    stats_text += "<text x=\"195\" y=\"764\" fill=\"#78E846\" class=\"s32\">";
    stats_text += u8_to_string(stats.luck);
    stats_text += "</text>";

    stats_text
}


// Generate dynamic adventurer name text as SVG with responsive font sizing
pub fn generate_adventurer_name_text(name: ByteArray) -> ByteArray {
    let mut name_text = "";

    // Truncate name if longer than 31 characters to ensure smooth UI display
    let truncated_name = if name.len() > 31 {
        let mut result = "";
        let mut i = 0;
        while i < 28 {
            if i < name.len() {
                result.append_byte(name.at(i).unwrap());
            }
            i += 1;
        }
        result += "...";
        result
    } else {
        name
    };

    // Get the length of the (potentially truncated) adventurer name to determine font size
    let name_length = truncated_name.len();

    let font_size = if name_length <= 10 {
        "24px"
    } else if name_length <= 16 {
        "18px"
    } else {
        "10px"
    };

    // Use dynamic text rendering with calculated font size
    name_text += "<text x=\"339\" y=\"160\" fill=\"#78E846\" style=\"font-size:";
    name_text += font_size;
    name_text += "\" text-anchor=\"left\">";
    name_text += truncated_name;
    name_text += "</text>";

    name_text
}

// Generate the logo SVG path - decorative "S" element only
pub fn generate_logo() -> ByteArray {
    let mut logo = "";

    logo +=
        "<path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M288.5 115.5c0 2.4 0 2.5-1.2 2.7l-1.3.1-.1 9.4-.2 9.4h7.9l.1 2.6.1 2.7 4.4.1c6.4.2 6.5.2 6.5-2.9v-2.5l3.8-.1 3.9-.2v-18.5l-1.3-.1c-1.2-.2-1.3-.3-1.3-2.7V113h-21.3v2.5Zm7.9 12.1v4l-2.4-.2-2.5-.1-.1-3.8-.1-3.9h5.1v4Zm10.6 0v4h-5v-8h5.1v4Zm-5.5 6.7v2.3h-4.6V132h4.6v2.3ZM286 140c-.2.3-.2 6.3-.1 13.3V166l9.4.1 9.4.1v-5.5h-13.4v-21.3h-2.6c-1.6 0-2.6.2-2.7.6Zm7.8 5c-.1.4-.2 3.5 0 6.9v6.2l6.6.1 6.6.2v10.1l-10.5.1-10.5.1-.2 2.7-.1 2.7h24.1v-2.5c0-2.4 0-2.6 1.3-2.7l1.3-.2v-8l.2-8h-13.4v-2.2l6.6-.1 6.6-.2v-5.5l-9.2-.1c-7.2-.1-9.2 0-9.4.5Z\" clip-rule=\"evenodd\"/>";

    logo
}


// Generate SVG header and container elements
fn generate_svg_header() -> ByteArray {
    let mut header = "";
    header +=
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"862\" height=\"1270\" fill=\"none\">";
    header += "<g filter=\"url(#a)\"><g clip-path=\"url(#b)\">";
    header += "<rect width=\"567\" height=\"862\" x=\"147.2\" y=\"27\" fill=\"#000\" rx=\"10\"/>";
    header
}

// Generate gold display UI components
fn generate_gold_display(gold: u16) -> ByteArray {
    let mut gold_display = "";
    // Add dark main rectangle for gold display
    gold_display +=
        "<rect width=\"91\" height=\"61.1\" x=\"541.7\" y=\"113\" fill=\"#2C1A0A\" rx=\"6\"/>";
    // Add small lighter orange rectangle for "GOLD" label with subtle offset beyond main box
    gold_display +=
        "<rect width=\"32\" height=\"16\" x=\"608\" y=\"106\" fill=\"#E8A746\" rx=\"2\"/>";
    // Add "GOLD" text in black on the lighter orange rectangle
    gold_display +=
        "<text x=\"624\" y=\"117\" fill=\"#000\" class=\"s12\" text-anchor=\"middle\">GOLD</text>";
    // Add gold value in orange on the darker background
    gold_display +=
        "<text x=\"587\" y=\"150\" fill=\"#E8A746\" class=\"s24\" text-anchor=\"middle\">";
    gold_display += u256_to_string(gold.into());
    gold_display += "</text>";
    gold_display
}

// Generate level display text
fn generate_level_display(level: u8) -> ByteArray {
    let mut level_display = "";
    level_display += "<text x=\"339\" y=\"124\" fill=\"#78E846\" class=\"s16\">LEVEL ";
    level_display += u8_to_string(level);
    level_display += "</text>";
    level_display
}

// Generate dynamic health bar with color coding
fn generate_health_bar(stats: Stats, health: u16) -> ByteArray {
    let mut health_bar = "";
    let max_health = stats.get_max_health();
    let MAX_BAR_WIDTH: u256 = 300; // Maximum bar width in pixels
    let MIN_FILLED_WIDTH: u256 = 2; // Minimum visible width when HP > 0

    // Calculate dynamic filled width
    let filled_width = if max_health > 0 {
        let health_u256: u256 = health.into();
        let max_health_u256: u256 = max_health.into();
        let calculated = (health_u256 * MAX_BAR_WIDTH) / max_health_u256;
        // Ensure minimum visibility when health > 0
        if health > 0 && calculated < MIN_FILLED_WIDTH {
            MIN_FILLED_WIDTH
        } else {
            calculated
        }
    } else {
        0
    };

    // Determine health bar color based on HP percentage
    let health_percentage = if max_health > 0 {
        let health_u256: u256 = health.into();
        let max_health_u256: u256 = max_health.into();
        (health_u256 * 100) / max_health_u256
    } else {
        0
    };

    let bar_color = if health_percentage >= 75 {
        "#78E846" // Green (healthy - 75-100%)
    } else if health_percentage >= 25 {
        "#FFD700" // Yellow/Gold (wounded - 25-74%)
    } else if health > 0 {
        "#FF4444" // Red (critical - 1-24%)
    } else {
        "#FF4444" // Red for zero health
    };

    // Generate background bar (full width, dark color)
    health_bar +=
        "<path stroke=\"#171D10\" stroke-dasharray=\"42 4\" stroke-linecap=\"square\" stroke-linejoin=\"round\" stroke-width=\"9\" d=\"M286 234h";
    health_bar += u256_to_string(MAX_BAR_WIDTH);
    health_bar += "\"/>";

    // Generate filled health bar (dynamic width, color-coded)
    health_bar += "<path stroke=\"";
    health_bar += bar_color;
    health_bar +=
        "\" stroke-dasharray=\"42 4\" stroke-linecap=\"square\" stroke-linejoin=\"round\" stroke-width=\"9\" d=\"M286 234h";
    health_bar += u256_to_string(filled_width);
    health_bar += "\"/>";

    // Add HP display (current HP / max HP)
    health_bar += "<text x=\"286\" y=\"270\" fill=\"#78E846\" class=\"s16\">";
    health_bar += u256_to_string(health.into());
    health_bar += "/";
    health_bar += u256_to_string(max_health.into());
    health_bar += " HP</text>";

    health_bar
}

// Generate inventory section header
fn generate_inventory_header() -> ByteArray {
    let mut inventory_header = "";
    inventory_header += "<text x=\"286\" y=\"325\" fill=\"#78E846\" class=\"s16\">";
    inventory_header += "INVENTORY";
    inventory_header += "</text>";
    inventory_header
}

// Generate equipment slot containers
fn generate_equipment_slots() -> ByteArray {
    let mut slots = "";

    // Top row equipment slots
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"285.7\" y=\"357.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Weapon slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"377.7\" y=\"357.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Chest slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"469.7\" y=\"357.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Head slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"561.7\" y=\"357.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Ring slot

    // Bottom row equipment slots
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"285.7\" y=\"491.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Hand slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"377.7\" y=\"491.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Neck slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"469.7\" y=\"491.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Foot slot
    slots +=
        "<rect width=\"71\" height=\"71\" x=\"561.7\" y=\"491.6\" stroke=\"#2B5418\" rx=\"5.5\" fill=\"none\"/>"; // Waist slot

    slots
}

// Generate equipment icons within the slots
fn generate_equipment_icons() -> ByteArray {
    let mut icons = "";

    // Top row equipment icons - individually centered in boxes
    icons += "<g transform=\"translate(309, 367) scale(3)\" fill=\"#78E846\">" + weapon() + "</g>";
    icons += "<g transform=\"translate(390, 368) scale(3)\" fill=\"#78E846\">" + chest() + "</g>";
    icons += "<g transform=\"translate(483, 378) scale(3)\" fill=\"#78E846\">" + head() + "</g>";
    icons += "<g transform=\"translate(578, 370) scale(3)\" fill=\"#78E846\">" + ring() + "</g>";

    // Bottom row equipment icons - individually centered in boxes
    icons += "<g transform=\"translate(308, 503) scale(3)\" fill=\"#78E846\">" + hand() + "</g>";
    icons += "<g transform=\"translate(391, 506) scale(3)\" fill=\"#78E846\">" + neck() + "</g>";
    icons += "<g transform=\"translate(483, 508) scale(3)\" fill=\"#78E846\">" + foot() + "</g>";
    icons += "<g transform=\"translate(575, 508) scale(3)\" fill=\"#78E846\">" + waist() + "</g>";

    icons
}


// Extract individual words from equipment name
fn extract_words(text: ByteArray) -> Array<ByteArray> {
    let mut words: Array<ByteArray> = array![];
    let mut current_word = "";
    let mut i = 0;

    while i < text.len() {
        let byte = text.at(i).unwrap();
        if byte == 32 { // ASCII code for space
            if current_word.len() > 0 {
                words.append(current_word);
                current_word = "";
            }
        } else {
            current_word.append_byte(byte);
        }
        i += 1;
    }

    // Add the last word if it exists
    if current_word.len() > 0 {
        words.append(current_word);
    }

    words
}

// Split equipment name into words for line-by-line rendering
fn get_equipment_words(item_name: felt252) -> Array<ByteArray> {
    if item_name == 0 {
        return array![];
    }

    let name_str = felt252_to_string(item_name);

    // If name is empty, return empty array
    if name_str.len() == 0 {
        return array![];
    }

    extract_words(name_str)
}

// Helper function to render equipment name words at given x position and base y
fn render_equipment_words(words: Array<ByteArray>, x: u16, base_y: u16) -> ByteArray {
    let mut name_text = "";
    let mut i = 0;

    while i < words.len() {
        let y_u32: u32 = base_y.into() + (i * 14); // 14px line spacing
        // Clamp y to prevent u16 overflow, use u32 directly for display
        name_text += "<text x=\"";
        name_text += u256_to_string(x.into());
        name_text += "\" y=\"";
        name_text += u256_to_string(y_u32.into());
        name_text += "\" fill=\"#78E846\" class=\"s12\" text-anchor=\"middle\">";
        name_text += words.at(i).clone();
        name_text += "</text>";
        i += 1;
    }

    name_text
}

// Generate equipment names below the slots
fn generate_equipment_names(equipment: EquipmentVerbose) -> ByteArray {
    let mut names = "";

    // Equipment names - Top row (below equipment boxes)
    let weapon_words = get_equipment_words(equipment.weapon.name);
    names += render_equipment_words(weapon_words, 321, 442);

    let chest_words = get_equipment_words(equipment.chest.name);
    names += render_equipment_words(chest_words, 413, 442);

    let head_words = get_equipment_words(equipment.head.name);
    names += render_equipment_words(head_words, 505, 442);

    let ring_words = get_equipment_words(equipment.ring.name);
    names += render_equipment_words(ring_words, 597, 442);

    // Equipment names - Bottom row (below equipment boxes)
    let hand_words = get_equipment_words(equipment.hand.name);
    names += render_equipment_words(hand_words, 321, 576);

    let neck_words = get_equipment_words(equipment.neck.name);
    names += render_equipment_words(neck_words, 413, 576);

    let foot_words = get_equipment_words(equipment.foot.name);
    names += render_equipment_words(foot_words, 505, 576);

    let waist_words = get_equipment_words(equipment.waist.name);
    names += render_equipment_words(waist_words, 597, 576);

    names
}

// Generate level badges for each equipment slot
fn generate_equipment_level_badges(equipment: EquipmentVerbose) -> ByteArray {
    let mut badges = "";

    // Top row equipment level badges - positioned like gold badge (top-right, extending beyond
    // slot)
    // Weapon level badge (top-left slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"335\" y=\"355\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"354\" y=\"366\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.weapon.xp));
    badges += "</text>";

    // Chest level badge (top-middle-left slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"427\" y=\"355\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"446\" y=\"366\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.chest.xp));
    badges += "</text>";

    // Head level badge (top-middle-right slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"519\" y=\"355\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"538\" y=\"366\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.head.xp));
    badges += "</text>";

    // Ring level badge (top-right slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"611\" y=\"355\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"630\" y=\"366\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.ring.xp));
    badges += "</text>";

    // Bottom row equipment level badges
    // Hand level badge (bottom-left slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"335\" y=\"489\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"354\" y=\"500\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.hand.xp));
    badges += "</text>";

    // Neck level badge (bottom-middle-left slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"427\" y=\"489\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"446\" y=\"500\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.neck.xp));
    badges += "</text>";

    // Foot level badge (bottom-middle-right slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"519\" y=\"489\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"538\" y=\"500\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.foot.xp));
    badges += "</text>";

    // Waist level badge (bottom-right slot)
    badges += "<rect width=\"38\" height=\"16\" x=\"611\" y=\"489\" fill=\"#78E846\" rx=\"2\"/>";
    badges +=
        "<text x=\"630\" y=\"500\" fill=\"#000\" class=\"s10\" stroke=\"#000\" stroke-width=\"0.5\" text-anchor=\"middle\">LVL ";
    badges += u8_to_string(get_greatness(equipment.waist.xp));
    badges += "</text>";

    badges
}

// Generate decorative border and background elements
fn generate_border() -> ByteArray {
    let mut border = "";
    border +=
        "<path fill=\"#78E846\" d=\"M686 863h-6v-7h6v7Z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M153 428h8V104h6v342h-14c1 3-1 22 1 23h13v342h-6V488h-8v348h-6V482h14v-6h-14v-35h13v-7h-13V80h6v348Zm0 17v1l1-1h-1Zm561-11h-14v7h14v35h-14v6h14v354h-6V488h-8v323l-6-1V470l1-1h13v-23h-13l-1-341 6-1v324c2 2 6 0 8 0V80h6v354Zm-4 48-2 1 2-1Zm-5-12a35 35 0 0 1 1 0h-1Zm3 0h-1 1Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"M694 819Z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M700 462h-6v-8h6v8Zm-5-8h4-4Zm-528 8h-6v-8h6v8Zm-1-1h-4 4v-7 7Zm-4-7h2-2ZM658 53h14v13h-1 15c0 1 0 0 0 0l1 1h-1v13-1l1 1h13v17h-6V85h-12V75h-1l-1-2h-14V60l-1-1h-12V45h-3 3-8v-5h13v13Zm30 28h11-11Zm-8-9h-13 13Zm-27-15v1h12l2 2-2-2h-12v-1Zm5-4 4 1-4-1Zm11 1h2-2Zm-23-9Zm-430 0h-7 6-6l-1 1v13h-12c-2 1 0 11-1 14h-15v12c-2 2-10 0-13 1v11h-5V81h11l1-1V66h16V54v12h-1V54l1-1h13V40h13v5Zm-16 13h6-6Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"m174 80-1 1h-11v16h-1V80h13Zm507-5h1v10h12v1h-12l-1-1V75Z\"/><path fill=\"#78E846\" d=\"M682 86h-1v-1l1 1Zm-1-11Z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M666 28c4-2 9-1 13-1v6h-7v-2 9h14l1-1V28h26-26v11l-1 1V27h28v26h-14v13h9-1v-5c1-2 3-1 5-1-2 0-4-1-5 1v-2h6v14h-20V45h-28V28h13v3-3h-13Zm26 12h8v7c2 2 6 0 8 0V33h-16v7Zm7 4v1-1ZM181 28c5-2 9-1 14-1l-4 1 4-1v18h-28l-1 7 1-7v28h-20V59h6v8l8-1 1-1-1 1V53h-14V27h28v13h-1 15v-7h-8v-5Zm-15 40v4h-18 18v-4Zm-14-8v5-5Zm18-27h-17v15l8-1c-1-9 1-7 9-7v-7Zm-22-5h25l1 4-1-4h-25Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"M679 53c9-1 8 0 8 8h-8v-8Z\"/>";
    border +=
        "<path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M714 857h-6v-8h-8v14l-1-1 1 1h14v26h-28v-13h-15l1-1-1 1v7-1c2 2 7 0 9 1v6h-14v-2l13 1-13-1v-11 1-8h28v-27c7 2 14 0 20 0v15Zm-9 27h-8 8Zm-5-15v7h-8v7h16v1-2c2 1 1-1 1-2v-10 10c0 1 1 3-1 2v-13h-8Zm-1 6h-7 7Zm-33-5 1 3-1-3Zm42-2v1-1Zm-270-5v6l-1-1v-1l1 2h16v14c-2-4-1-9-1-13 0 4-1 9 1 13v1-1h13v-14h166v7H515l118-1v-5 5l-118 1h-25l5-1h1l-6 1h-3v7h171v6H480v-13h-7c-2 2 0 9-1 12 1-3-1-10 1-12v13c-4-1-23 1-25-1-2-1 0-10-1-12l-13-1v-6h-7v6h-14v13h-24 24v-13h14v-6 7h-13v13h-25c-2 0-1-12-1-13h1-8v13H203v-6h171l-171 1v4-4l171-1v-7H228v-7h166v14-1l3 1 11-1v-13h14c1 0 0 0 0 0v-6h16Zm-59 13v12-12Zm76 8Zm-10-9h-8 8Zm-8-12 1 1-1-1Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"M154 868h6-6Z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M167 869h28v19h-13v-5h7v-7h-14v1l-1-1 1 1v12h-28v-26h13l1-1v-13h-7c-2 1-1 6-1 8h-5l-1-1h1-1v-13h20v26Zm-7-1h-7v5l-1 1 1-1v10h17v-7c-1-2-8-1-8-1s7-1 8 1h-9v-7l-1-1Zm-8 13v1-1Zm0-6Zm24 0h-1 1Zm-15-10Zm-9-2h2-3 1Zm-4-7Zm291 32h-17v-5h17v5Zm-2-1v-3 3Zm257-68c2-2 4-1 6-1v18h-14v13h-15v14h-12c2-2 9 0 12-1-3 1-10-1-12 1l-1 1v12h-12l-1-1h13-13c-2-7 1-6 7-6v-12h14v-14h14v-12l1-1h13v-11h5-5Zm-28 24v14-14Zm-499-13h13v13h15v14h13v12c1 2 4 1 6 1h1c-2 0-6 1-7-1h8v7h-13v-13h-14v-14h-14l-1-1v-12h-13v-18h6v12Zm41 36h-1 1Zm0 0Zm-5-4Zm-24-29v10-10Zm-16 2h-1 1Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"M408 869v1h-1l1-1Z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M181 863h-7v-7h7v7Zm-1-1h-5 5v-6 6Z\" clip-rule=\"evenodd\"/>";
    border +=
        "<path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"M181 60h-7v-7h7v7Zm-1-1v-5 5Zm199-19h9l1-1V28v11l-1 1V27h26v12l-1 1 1-1 2 1h11v6c9 0 5-1 7-5 1-3 11 0 13-2 2-1 1-9 1-11 0 2 1 10-1 11V27h26l-1 13h8V27h178v6H487l-1 7h147v5H467V33h-13v8h-1 1v4h-15v6l-2 1h-14l-1-1v-6h-14V33h-14v12H227v-5h147v-7H203v-6h176v13Zm14-7v12-12Zm74 0v12-12Zm14 7V28v12Z\" clip-rule=\"evenodd\"/><path fill=\"#78E846\" d=\"M439 33h-17v-6h17v6Zm227-5Z\"/>";
    border
}

// Generate SVG footer with definitions and closing tags
fn generate_svg_footer() -> ByteArray {
    let mut footer = "";
    footer +=
        "</g></g><defs><style>text{font-family:VT323,IBM Plex Mono,Roboto Mono,Source Code Pro,monospace;font-weight:bold}.s8{font-size:8px}.s10{font-size:10px}.s12{font-size:12px}.s16{font-size:16px}.s24{font-size:24px}.s32{font-size:32px}</style><clipPath id=\"b\"><rect width=\"567\" height=\"862\" x=\"147.2\" y=\"27\" fill=\"#fff\" rx=\"10\"/></clipPath><clipPath id=\"c\"><path fill=\"#fff\" d=\"M302 373h37v37h-37z\"/></clipPath><clipPath id=\"d\"><path fill=\"#fff\" d=\"M298 504h47v47h-47z\"/></clipPath><filter id=\"a\" width=\"861\" height=\"1402\" x=\".2\" y=\"0\" color-interpolation-filters=\"sRGB\" filterUnits=\"userSpaceOnUse\"><feFlood flood-opacity=\"0\" result=\"BackgroundImageFix\"/><feColorMatrix in=\"SourceAlpha\" result=\"hardAlpha\" values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0\"/><feOffset dy=\"23\"/><feGaussianBlur stdDeviation=\"25\"/><feColorMatrix values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.26 0\"/><feBlend in2=\"BackgroundImageFix\" result=\"effect1_dropShadow_19_3058\"/><feColorMatrix in=\"SourceAlpha\" result=\"hardAlpha\" values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0\"/><feOffset dy=\"92\"/><feGaussianBlur stdDeviation=\"46\"/><feColorMatrix values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.22 0\"/><feBlend in2=\"effect1_dropShadow_19_3058\" result=\"effect2_dropShadow_19_3058\"/><feColorMatrix in=\"SourceAlpha\" result=\"hardAlpha\" values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0\"/><feOffset dy=\"206\"/><feGaussianBlur stdDeviation=\"62\"/><feColorMatrix values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.13 0\"/><feBlend in2=\"effect2_dropShadow_19_3058\" result=\"effect3_dropShadow_19_3058\"/><feColorMatrix in=\"SourceAlpha\" result=\"hardAlpha\" values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0\"/><feOffset dy=\"366\"/><feGaussianBlur stdDeviation=\"73.5\"/><feColorMatrix values=\"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.04 0\"/><feBlend in2=\"effect3_dropShadow_19_3058\" result=\"effect4_dropShadow_19_3058\"/><feBlend in=\"SourceGraphic\" in2=\"effect4_dropShadow_19_3058\" result=\"shape\"/></filter></defs></svg>";
    footer
}

// Generate dynamic SVG with adventurer stats and equipment - now using modular functions
pub fn generate_svg(adventurer: AdventurerVerbose) -> ByteArray {
    let mut svg = "";

    svg += generate_svg_header();
    svg += generate_stats_text(adventurer.stats);
    svg += generate_adventurer_name_text(adventurer.name);
    svg += generate_logo();
    svg += generate_gold_display(adventurer.gold);
    svg += generate_level_display(adventurer.level);
    svg += generate_health_bar(adventurer.stats, adventurer.health);
    svg += generate_inventory_header();
    svg += generate_equipment_slots();
    svg += generate_equipment_icons();
    svg += generate_equipment_level_badges(adventurer.equipment);
    svg += generate_equipment_names(adventurer.equipment);
    svg += generate_border();
    svg += generate_svg_footer();

    svg
}

// @notice Generates adventurer details for the adventurer token uri
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @return The generated adventurer details
pub fn generate_details(adventurer: AdventurerVerbose) -> Span<GameDetail> {
    let xp = format!("{}", adventurer.xp);
    let level = format!("{}", adventurer.level);

    let health = format!("{}", adventurer.health);

    let gold = format!("{}", adventurer.gold);
    let str = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.strength)
    };
    let dex = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.dexterity)
    };
    let int = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.intelligence)
    };
    let vit = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.vitality)
    };
    let wis = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.wisdom)
    };
    let cha = if adventurer.level == 1 {
        "?"
    } else {
        format!("{}", adventurer.stats.charisma)
    };
    let luck = format!("{}", adventurer.stats.luck);

    array![
        GameDetail { name: "XP", value: xp },
        GameDetail { name: "Level", value: level },
        GameDetail { name: "Health", value: health },
        GameDetail { name: "Gold", value: gold },
        GameDetail { name: "Strength", value: str },
        GameDetail { name: "Dexterity", value: dex },
        GameDetail { name: "Intelligence", value: int },
        GameDetail { name: "Vitality", value: vit },
        GameDetail { name: "Wisdom", value: wis },
        GameDetail { name: "Charisma", value: cha },
        GameDetail { name: "Luck", value: luck },
    ]
        .span()
}
