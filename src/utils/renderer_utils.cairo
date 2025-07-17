use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Item};
use ls2_renderer::mocks::mock_beast::{Beast};
use ls2_renderer::utils::encoding::{U256BytesUsedTraitImpl, bytes_base64_encode};
use ls2_renderer::utils::item_database::ItemDatabaseImpl;

// Health calculation constants
const STARTING_HEALTH: u8 = 100;
const HEALTH_INCREASE_PER_VITALITY: u8 = 20;
const MAX_ADVENTURER_HEALTH: u16 = 1023;

// Item greatness constants
const SUFFIX_UNLOCK_GREATNESS: u8 = 15;
const PREFIXES_UNLOCK_GREATNESS: u8 = 19;
const NAME_PREFIX_LENGTH: u8 = 69;
const NAME_SUFFIX_LENGTH: u8 = 18;

// @notice Calculate maximum health based on vitality
// @param vitality The vitality stat of the adventurer
// @return The maximum health for the adventurer
fn get_max_health(vitality: u8) -> u16 {
    let vitality_health_boost = vitality.into() * HEALTH_INCREASE_PER_VITALITY.into();
    let new_max_health = STARTING_HEALTH.into() + vitality_health_boost;

    if new_max_health > MAX_ADVENTURER_HEALTH {
        MAX_ADVENTURER_HEALTH
    } else {
        new_max_health
    }
}

// @notice Calculate square root using Newton's method
// @param value The value to calculate square root for
// @return The square root of the value
fn sqrt(value: u16) -> u8 {
    if value == 0 {
        return 0;
    }
    if value == 1 {
        return 1;
    }

    let mut x = value / 2;
    let mut prev_x = 0;

    // Newton's method: x = (x + value/x) / 2
    loop {
        prev_x = x;
        x = (x + value / x) / 2;

        if x >= prev_x {
            break prev_x.try_into().unwrap();
        }
    }
}

// @notice Calculate item greatness from XP
// @param xp The item's XP value
// @return The calculated greatness (0-20)
pub fn calculate_greatness(xp: u16) -> u8 {
    let greatness = sqrt(xp);
    if greatness > 20 {
        20
    } else {
        greatness
    }
}

// @notice Get prefix string from prefix ID (1-69)
// @param prefix_id The prefix ID (1-69)
// @return The prefix string
pub fn get_prefix_string(prefix_id: u8) -> ByteArray {
    let prefix_felt = get_prefix_felt(prefix_id);
    let mut prefix_ba = Default::default();
    prefix_ba
        .append_word(prefix_felt, U256BytesUsedTraitImpl::bytes_used(prefix_felt.into()).into());
    prefix_ba
}

// @notice Get prefix felt252 from prefix ID (1-69)
// @param prefix_id The prefix ID (1-69)
// @return The prefix felt252
fn get_prefix_felt(prefix_id: u8) -> felt252 {
    if prefix_id == 1 {
        'Agony'
    } else if prefix_id == 2 {
        'Apocalypse'
    } else if prefix_id == 3 {
        'Armageddon'
    } else if prefix_id == 4 {
        'Beast'
    } else if prefix_id == 5 {
        'Behemoth'
    } else if prefix_id == 6 {
        'Blight'
    } else if prefix_id == 7 {
        'Blood'
    } else if prefix_id == 8 {
        'Bramble'
    } else if prefix_id == 9 {
        'Brimstone'
    } else if prefix_id == 10 {
        'Brood'
    } else if prefix_id == 11 {
        'Carrion'
    } else if prefix_id == 12 {
        'Cataclysm'
    } else if prefix_id == 13 {
        'Chimeric'
    } else if prefix_id == 14 {
        'Corpse'
    } else if prefix_id == 15 {
        'Corruption'
    } else if prefix_id == 16 {
        'Damnation'
    } else if prefix_id == 17 {
        'Death'
    } else if prefix_id == 18 {
        'Demon'
    } else if prefix_id == 19 {
        'Dire'
    } else if prefix_id == 20 {
        'Dragon'
    } else if prefix_id == 21 {
        'Dread'
    } else if prefix_id == 22 {
        'Doom'
    } else if prefix_id == 23 {
        'Dusk'
    } else if prefix_id == 24 {
        'Eagle'
    } else if prefix_id == 25 {
        'Empyrean'
    } else if prefix_id == 26 {
        'Fate'
    } else if prefix_id == 27 {
        'Foe'
    } else if prefix_id == 28 {
        'Gale'
    } else if prefix_id == 29 {
        'Ghoul'
    } else if prefix_id == 30 {
        'Gloom'
    } else if prefix_id == 31 {
        'Glyph'
    } else if prefix_id == 32 {
        'Golem'
    } else if prefix_id == 33 {
        'Grim'
    } else if prefix_id == 34 {
        'Hate'
    } else if prefix_id == 35 {
        'Havoc'
    } else if prefix_id == 36 {
        'Honour'
    } else if prefix_id == 37 {
        'Horror'
    } else if prefix_id == 38 {
        'Hypnotic'
    } else if prefix_id == 39 {
        'Kraken'
    } else if prefix_id == 40 {
        'Loath'
    } else if prefix_id == 41 {
        'Maelstrom'
    } else if prefix_id == 42 {
        'Mind'
    } else if prefix_id == 43 {
        'Miracle'
    } else if prefix_id == 44 {
        'Morbid'
    } else if prefix_id == 45 {
        'Oblivion'
    } else if prefix_id == 46 {
        'Onslaught'
    } else if prefix_id == 47 {
        'Pain'
    } else if prefix_id == 48 {
        'Pandemonium'
    } else if prefix_id == 49 {
        'Phoenix'
    } else if prefix_id == 50 {
        'Plague'
    } else if prefix_id == 51 {
        'Rage'
    } else if prefix_id == 52 {
        'Rapture'
    } else if prefix_id == 53 {
        'Rune'
    } else if prefix_id == 54 {
        'Skull'
    } else if prefix_id == 55 {
        'Sol'
    } else if prefix_id == 56 {
        'Soul'
    } else if prefix_id == 57 {
        'Sorrow'
    } else if prefix_id == 58 {
        'Spirit'
    } else if prefix_id == 59 {
        'Storm'
    } else if prefix_id == 60 {
        'Tempest'
    } else if prefix_id == 61 {
        'Torment'
    } else if prefix_id == 62 {
        'Vengeance'
    } else if prefix_id == 63 {
        'Victory'
    } else if prefix_id == 64 {
        'Viper'
    } else if prefix_id == 65 {
        'Vortex'
    } else if prefix_id == 66 {
        'Woe'
    } else if prefix_id == 67 {
        'Wrath'
    } else if prefix_id == 68 {
        'Lights'
    } else if prefix_id == 69 {
        'Shimmering'
    } else {
        ''
    }
}

// @notice Get suffix string from suffix ID (1-18)
// @param suffix_id The suffix ID (1-18)
// @return The suffix string
pub fn get_suffix_string(suffix_id: u8) -> ByteArray {
    let suffix_felt = get_suffix_felt(suffix_id);
    let mut suffix_ba = Default::default();
    suffix_ba
        .append_word(suffix_felt, U256BytesUsedTraitImpl::bytes_used(suffix_felt.into()).into());
    suffix_ba
}

// @notice Get suffix felt252 from suffix ID (1-18)
// @param suffix_id The suffix ID (1-18)
// @return The suffix felt252
fn get_suffix_felt(suffix_id: u8) -> felt252 {
    if suffix_id == 1 {
        'Bane'
    } else if suffix_id == 2 {
        'Root'
    } else if suffix_id == 3 {
        'Bite'
    } else if suffix_id == 4 {
        'Song'
    } else if suffix_id == 5 {
        'Roar'
    } else if suffix_id == 6 {
        'Grasp'
    } else if suffix_id == 7 {
        'Instrument'
    } else if suffix_id == 8 {
        'Glow'
    } else if suffix_id == 9 {
        'Bender'
    } else if suffix_id == 10 {
        'Shadow'
    } else if suffix_id == 11 {
        'Whisper'
    } else if suffix_id == 12 {
        'Shout'
    } else if suffix_id == 13 {
        'Growl'
    } else if suffix_id == 14 {
        'Tear'
    } else if suffix_id == 15 {
        'Peak'
    } else if suffix_id == 16 {
        'Form'
    } else if suffix_id == 17 {
        'Sun'
    } else if suffix_id == 18 {
        'Moon'
    } else {
        ''
    }
}

// @notice Generate prefix ID from item ID and XP
// @param item_id The item ID
// @param xp The item XP
// @return The prefix ID (1-69)
fn generate_prefix_id(item_id: u8, xp: u16) -> u8 {
    let seed: u256 = item_id.into() * 1000 + xp.into();
    let prefix_id = (seed % NAME_PREFIX_LENGTH.into()) + 1;
    prefix_id.try_into().unwrap()
}

// @notice Generate suffix ID from item ID and XP
// @param item_id The item ID
// @param xp The item XP
// @return The suffix ID (1-18)
fn generate_suffix_id(item_id: u8, xp: u16) -> u8 {
    let seed: u256 = item_id.into() * 2000 + xp.into();
    let suffix_id = (seed % NAME_SUFFIX_LENGTH.into()) + 1;
    suffix_id.try_into().unwrap()
}

// SVG Component System
#[derive(Drop)]
pub struct SVGTheme {
    pub primary_color: ByteArray,
    pub secondary_color: ByteArray,
    pub background_color: ByteArray,
    pub border_color: ByteArray,
    pub text_color: ByteArray,
}

#[derive(Copy, Drop)]
pub struct SVGPosition {
    pub x: u32,
    pub y: u32,
}

#[derive(Copy, Drop)]
pub struct SVGSize {
    pub width: u32,
    pub height: u32,
}

#[derive(Drop)]
pub struct SVGComponent {
    pub position: SVGPosition,
    pub size: SVGSize,
    pub theme: SVGTheme,
}

// @notice Generates the LS logo svg
// @return The generated LS logo
fn logo() -> ByteArray {
    "<path d=\"M1 2V0h8v2h1v10H7v4H3v-4H0V2zm1 4v4h2v2h2v-2h2V6H6v4H4V6z\"/>"
}

// @notice Generates the crown icon used for top scores
// @return The generated crown icon
fn crown() -> ByteArray {
    "<path d=\"M0 0v7h15V0h-1v1h-1v1h-1v1h-2V2H9V1H8V0H7v1H6v1H5v1H3V2H2V1H1V0H0Z\"/>"
}

// @notice Generates the weapon icon svg
// @return The generated weapon icon
fn weapon() -> ByteArray {
    "<path d=\"M8 4V3H6V2H5V1H3v2H2v2H1v1h2V5h2v2H4v2H3v2H2v2H1v2H0v2h2v-2h1v-2h1v-2h1V9h1V7h2v5h2v-2h1V8h1V6h1V4H8Z\"/>"
}

// @notice Generates the chest icon svg
// @return The generated chest icon
fn chest() -> ByteArray {
    "<path d=\"M0 8h2V7H0v1Zm3-3V2H2v1H1v2H0v1h4V5H3Zm2-4H4v4h1V1Zm6 0v4h1V1h-1Zm4 4V3h-1V2h-1v3h-1v1h4V5h-1Zm-1 3h2V7h-2v1ZM9 7H7V6H4v1H3v4h4v-1h2v1h4V7h-1V6H9v1Zm1 6v1h1v2h1v-2h1v-2H9v1h1Zm-3-1h2v-1H7v1Zm0 1v-1H3v2h1v2h1v-2h1v-1h1Zm2 0H7v1H6v2h4v-2H9v-1Z\" />"
}

// @notice Generates the head icon svg
// @return The generated head icon
fn head() -> ByteArray {
    "<path d=\"M12 2h-1V1h-1V0H6v1H5v1H4v1H3v8h1v1h2V8H5V7H4V5h3v4h2V5h3v2h-1v1h-1v4h2v-1h1V3h-1V2ZM2 2V1H1V0H0v2h1v2h1v1-2h1V2H2Zm13-2v1h-1v1h-1v1h1v2-1h1V2h1V0h-1Z\"/>"
}

// @notice Generates the waist icon svg
// @return The generated waist icon
fn waist() -> ByteArray {
    "<path d=\"M0 13h2v-1H0v1Zm0-2h3v-1H0v1Zm1-7H0v5h3V8h2V3H1v1Zm0-2h4V0H1v2Zm5 0h1V1h1v1h1V0H6v2Zm8-2h-4v2h4V0Zm0 4V3h-4v5h2v1h3V4h-1Zm-2 7h3v-1h-3v1Zm1 2h2v-1h-2v1ZM6 9h1v1h1V9h1V3H6v6Z\"/>"
}

// @notice Generates the foot icon svg
// @return The generated foot icon
fn foot() -> ByteArray {
    "<path d=\"M4 1V0H0v2h5V1H4Zm2-1H5v1h1V0Zm0 2H5v1h1V2Zm0 2V3H5v1h1Zm0 2V5H5v1h1Zm0 2V7H5v1h1Zm5 0V7H9v1h2Zm0-2V5H9v1h2Zm0-2V3H9v1h2Zm0-2H9v1h2V2Zm0-2H9v1h2V0ZM8 1V0H7v2h2V1H8Zm0 6h1V6H8V5h1V4H8V3h1-2v5h1V7ZM6 9V8H4V7h1V6H4V5h1V4H4V3h1-5v8h5V9h1Zm5 0h-1V8H7v1H6v2H5v1h6V9ZM0 13h5v-1H0v1Zm11 0v-1H5v1h6Zm1 0h4v-1h-4v1Zm3-3V9h-1V8h-2v1h-1v1h1v2h4v-2h-1Zm-4-2v1-1Z\"/>"
}

// @notice Generates the hand icon svg
// @return The generated hand icon
fn hand() -> ByteArray {
    "<path d=\"M9 8v1H8v3H4v-1h3V2H6v7H5V1H4v8H3V2H2v8H1V5H0v10h1v2h5v-1h2v-1h1v-2h1V8H9Z\"/>"
}

// @notice Generates the neck icon svg
// @return The generated neck icon
fn neck() -> ByteArray {
    "<path d=\"M14 8V6h-1V5h-1V4h-1V3h-1V2H8V1H2v1H1v1H0v8h1v1h1v1h4v-1h1v-1H3v-1H2V4h1V3h4v1h2v1h1v1h1v1h1v1h1v1h-2v1h1v1h2v-1h1V8h-1Zm-6 3v1h1v-1H8Zm1 0h2v-1H9v1Zm4 3v-2h-1v2h1Zm-6-2v2h1v-2H7Zm2 4h2v-1H9v1Zm-1-2v1h1v-1H8Zm3 1h1v-1h-1v1Zm0-3h1v-1h-1v1Zm-2 2h2v-2H9v2Z\"/>"
}

// @notice Generates the ring icon svg
// @return The generated ring icon
fn ring() -> ByteArray {
    "<path d=\"M13 3V2h-1V1h-2v1h1v3h-1v2H9v1H8v1H7v1H6v1H4v1H1v-1H0v2h1v1h1v1h4v-1h2v-1h1v-1h1v-1h1v-1h1V9h1V7h1V3h-1ZM3 9h1V8h1V7h1V6h1V5h1V4h2V2H9V1H8v1H6v1H5v1H4v1H3v1H2v1H1v2H0v1h1v1h2V9Z\"/>"
}

// Theme constants
pub fn get_default_theme() -> SVGTheme {
    SVGTheme {
        primary_color: "#78E846",
        secondary_color: "#2C1A0A",
        background_color: "#000000",
        border_color: "#3DEC00",
        text_color: "#78E846",
    }
}

pub fn get_bag_theme() -> SVGTheme {
    SVGTheme {
        primary_color: "#E89446",
        secondary_color: "#2C1A0A",
        background_color: "#000000",
        border_color: "#E89446",
        text_color: "#E89446",
    }
}

pub fn get_marketplace_theme() -> SVGTheme {
    SVGTheme {
        primary_color: "#77EDFF",
        secondary_color: "#2C1A0A",
        background_color: "#000000",
        border_color: "#77EDFF",
        text_color: "#77EDFF",
    }
}

pub fn get_battle_theme() -> SVGTheme {
    SVGTheme {
        primary_color: "#FE9676",
        secondary_color: "#2C1A0A",
        background_color: "#000000",
        border_color: "#FE9676",
        text_color: "#FE9676",
    }
}

// Component builders
fn create_rect_component(
    position: SVGPosition, size: SVGSize, theme: @SVGTheme, rx: u32,
) -> ByteArray {
    format!(
        "<rect x='{}' y='{}' width='{}' height='{}' rx='{}' fill='{}' stroke='{}'/>",
        position.x,
        position.y,
        size.width,
        size.height,
        rx,
        theme.background_color,
        theme.border_color,
    )
}

fn create_page_border(size: SVGSize, theme: @SVGTheme) -> ByteArray {
    let border_width = 2;
    format!(
        "<path fill='{}' d='M20 20h{}v{}H20zm0 {}h{}v{}H20zm0-{}h{}v{}h-{}zm{} 0h{}v{}h-{}z'/>",
        theme.border_color,
        size.width - 40,
        border_width,
        size.height - 22,
        size.width - 40,
        border_width,
        size.height - 22,
        border_width,
        size.height - 22,
        border_width,
        size.width - 22,
        border_width,
        size.height - 22,
        border_width,
    )
}

pub fn create_text_component(
    text: ByteArray,
    position: SVGPosition,
    fontsize: u32,
    theme: @SVGTheme,
    text_anchor: ByteArray,
    baseline: ByteArray,
) -> ByteArray {
    format!(
        "<text x='{}' y='{}' font-size='{}' text-anchor='{}' dominant-baseline='{}' fill='{}'>{}</text>",
        position.x,
        position.y,
        fontsize,
        text_anchor,
        baseline,
        theme.text_color,
        text,
    )
}

// @notice Create multi-line text component for long item names
// @param text The text to render (may be split across lines)
// @param position Base position for the text
// @param fontsize Font size in pixels
// @param theme SVG theme colors
// @param text_anchor Text alignment (start, middle, end)
// @param baseline Text baseline (text-top, middle, etc.)
// @param max_chars_per_line Maximum characters per line before wrapping
// @return SVG text elements for multi-line rendering
pub fn create_multiline_text_component(
    text: ByteArray,
    position: SVGPosition,
    fontsize: u32,
    theme: @SVGTheme,
    text_anchor: ByteArray,
    baseline: ByteArray,
    max_chars_per_line: u32,
) -> ByteArray {
    let lines = split_text_into_lines(text, max_chars_per_line);
    let mut result = "";
    let mut line_index = 0;

    loop {
        if line_index >= lines.len() {
            break;
        }

        let line_text = lines.at(line_index);
        let line_y = position.y + (line_index * (fontsize + 1)); // Add 1px line spacing
        let line_position = SVGPosition { x: position.x, y: line_y };

        result +=
            create_text_component(
                line_text.clone(),
                line_position,
                fontsize,
                theme,
                text_anchor.clone(),
                baseline.clone(),
            );

        line_index += 1;
    };

    result
}

// @notice Split text into lines based on character limit
// @param text The text to split
// @param max_chars_per_line Maximum characters per line
// @return Array of text lines
fn split_text_into_lines(text: ByteArray, _max_chars_per_line: u32) -> Array<ByteArray> {
    let mut lines = ArrayTrait::new();

    // Split text into words at every space character
    // Each word will be on its own line to prevent any overlap
    let text_len = text.len();
    let mut current_word = "";
    let mut has_word = false;

    let mut i = 0;
    loop {
        if i >= text_len {
            // Add final word if it exists
            if has_word {
                lines.append(current_word.clone());
            }
            break;
        }

        let char_option = text.at(i);
        match char_option {
            Option::Some(char) => {
                if char == 32 { // ASCII space - end of word
                    if has_word {
                        lines.append(current_word.clone());
                        current_word = "";
                        has_word = false;
                    }
                } else {
                    // Add character to current word
                    current_word = format!("{}{}", current_word, byte_to_char(char));
                    has_word = true;
                }
            },
            Option::None => {},
        }
        i += 1;
    };

    // If no words were found (no spaces), return original text as single line
    if lines.len() == 0 {
        lines.append(text);
    }

    lines
}

// Helper function to convert byte to character representation
fn byte_to_char(byte: u8) -> ByteArray {
    let mut result = "";
    result.append_byte(byte);
    result
}

// @notice Extract substring from ByteArray
// @param text Source text
// @param start Starting position
// @param length Length to extract
// @return Substring as ByteArray
fn extract_substring(text: ByteArray, start: u32, length: u32) -> ByteArray {
    let mut result = "";
    let mut i = 0;

    loop {
        if i >= length || start + i >= text.len() {
            break;
        }

        let char_option = text.at(start + i);
        match char_option {
            Option::Some(char) => { result.append_byte(char); },
            Option::None => { break; },
        }

        i += 1;
    };

    result
}

pub fn create_stat_component(
    label: ByteArray, value: ByteArray, position: SVGPosition, theme: @SVGTheme,
) -> ByteArray {
    let label_element = create_text_component(label, position, 14, theme, "start", "text-top");
    let value_position = SVGPosition { x: position.x, y: position.y + 20 };
    let value_element = create_text_component(
        value, value_position, 20, theme, "start", "text-top",
    );
    label_element + value_element
}

pub fn create_health_bar_component(
    current: u32, max: u32, position: SVGPosition, size: SVGSize, theme: @SVGTheme,
) -> ByteArray {
    let health_percent = (current * size.width) / max;
    let bg_rect = format!(
        "<rect x='{}' y='{}' width='{}' height='{}' fill='{}' stroke='{}'/>",
        position.x,
        position.y,
        size.width,
        size.height,
        theme.secondary_color,
        theme.border_color,
    );
    let health_fill = format!(
        "<rect x='{}' y='{}' width='{}' height='{}' fill='{}'/>",
        position.x + 1,
        position.y + 1,
        health_percent - 2,
        size.height - 2,
        theme.primary_color,
    );
    bg_rect + health_fill
}

pub fn create_inventory_slot_component(
    slot_id: u32, item_name: ByteArray, position: SVGPosition, theme: @SVGTheme,
) -> ByteArray {
    let slot_size = SVGSize { width: 40, height: 40 };
    let slot_rect = format!(
        "<rect x='{}' y='{}' width='{}' height='{}' fill='{}' stroke='{}'/>",
        position.x,
        position.y,
        slot_size.width,
        slot_size.height,
        theme.secondary_color,
        theme.border_color,
    );
    let item_icon = get_item_icon_by_name(item_name.clone());
    let icon_element = if item_icon.len() > 0 {
        format!(
            "<g transform='translate({},{}) scale(1.5)' fill='{}'>{}</g>",
            position.x + 5,
            position.y + 5,
            theme.primary_color,
            item_icon,
        )
    } else {
        ""
    };
    let text_position = SVGPosition { x: position.x + 20, y: position.y + 42 };
    let text_element = create_multiline_text_component(
        item_name, text_position, 5, theme, "middle", "text-top", 20,
    );
    let slot_number = create_text_component(
        format!("{}", slot_id),
        SVGPosition { x: position.x + 36, y: position.y + 12 },
        6,
        theme,
        "end",
        "text-top",
    );

    slot_rect + icon_element + text_element + slot_number
}

fn get_item_icon_by_name(item_name: ByteArray) -> ByteArray {
    if item_name.len() == 0 || item_name == "Empty" || item_name == "None Equipped" {
        return "";
    }
    // Simple pattern matching for item types - using contains-like logic
    let item_lower = item_name.clone(); // In real implementation, would convert to lowercase
    if item_lower.len() > 0 {
        // For now, just return appropriate icons based on simple logic
        // This is a simplified version - in practice you'd implement proper string matching
        weapon()
    } else {
        ""
    }
}

pub fn create_logo_component(position: SVGPosition, scale: u32, theme: @SVGTheme) -> ByteArray {
    format!(
        "<g transform='translate({},{}) scale({})' fill='{}'>{}</g>",
        position.x,
        position.y,
        scale,
        theme.primary_color,
        logo(),
    )
}

pub fn create_page_header_component(
    title: ByteArray, subtitle: ByteArray, position: SVGPosition, theme: @SVGTheme,
) -> ByteArray {
    let logo_element = create_logo_component(
        SVGPosition { x: position.x, y: position.y }, 4, theme,
    );
    let title_position = SVGPosition { x: position.x + 100, y: position.y + 45 };
    let title_element = create_text_component(
        title, title_position, 16, theme, "start", "text-top",
    );
    let subtitle_position = SVGPosition { x: position.x + 230, y: position.y + 45 };
    let subtitle_element = create_text_component(
        subtitle, subtitle_position, 12, theme, "start", "text-top",
    );

    logo_element + title_element + subtitle_element
}

pub fn create_xp_badge_component(xp: ByteArray, position: SVGPosition) -> ByteArray {
    let badge_size = SVGSize { width: 50, height: 25 };
    let badge_rect = format!(
        "<rect x='{}' y='{}' width='{}' height='{}' fill='#E8A746' rx='4'/>",
        position.x,
        position.y,
        badge_size.width,
        badge_size.height,
    );
    let xp_text = format!(
        "<text x='{}' y='{}' font-size='14' text-anchor='middle' fill='#2C1A0A'>{}</text>",
        position.x + 25,
        position.y + 17,
        xp,
    );
    let xp_label = format!(
        "<text x='{}' y='{}' font-size='10' text-anchor='start' fill='#E8A746'>XP</text>",
        position.x + 5,
        position.y - 5,
    );

    badge_rect + xp_text + xp_label
}

// Layout components
fn create_stats_layout(
    adventurer: Adventurer, position: SVGPosition, theme: @SVGTheme,
) -> ByteArray {
    let mut stats_elements: ByteArray = "";
    let spacing = 50;

    // STR
    stats_elements +=
        create_stat_component("STR", format!("{}", adventurer.stats.strength), position, theme);

    // DEX
    let dex_pos = SVGPosition { x: position.x, y: position.y + spacing };
    stats_elements +=
        create_stat_component("DEX", format!("{}", adventurer.stats.dexterity), dex_pos, theme);

    // INT
    let int_pos = SVGPosition { x: position.x, y: position.y + spacing * 2 };
    stats_elements +=
        create_stat_component("INT", format!("{}", adventurer.stats.intelligence), int_pos, theme);

    // VIT
    let vit_pos = SVGPosition { x: position.x, y: position.y + spacing * 3 };
    stats_elements +=
        create_stat_component("VIT", format!("{}", adventurer.stats.vitality), vit_pos, theme);

    // WIS
    let wis_pos = SVGPosition { x: position.x, y: position.y + spacing * 4 };
    stats_elements +=
        create_stat_component("WIS", format!("{}", adventurer.stats.wisdom), wis_pos, theme);

    // CHA
    let cha_pos = SVGPosition { x: position.x, y: position.y + spacing * 5 };
    stats_elements +=
        create_stat_component("CHA", format!("{}", adventurer.stats.charisma), cha_pos, theme);

    // LUCK
    let luck_pos = SVGPosition { x: position.x, y: position.y + spacing * 6 };
    stats_elements +=
        create_stat_component("LUCK", format!("{}", adventurer.stats.luck), luck_pos, theme);

    stats_elements
}

fn create_inventory_layout(
    adventurer: Adventurer, position: SVGPosition, theme: @SVGTheme,
) -> ByteArray {
    let mut inventory_elements: ByteArray = "";
    let _slot_size = 50;

    // Inventory title
    let title_pos = SVGPosition { x: position.x, y: position.y - 20 };
    inventory_elements +=
        create_text_component("INVENTORY", title_pos, 12, theme, "start", "text-top");

    // Top row equipment slots
    let weapon_pos = SVGPosition { x: position.x, y: position.y };
    inventory_elements +=
        create_inventory_slot_component(
            1, generate_item(adventurer.equipment.weapon, false), weapon_pos, theme,
        );

    let chest_pos = SVGPosition { x: position.x + 60, y: position.y };
    inventory_elements +=
        create_inventory_slot_component(
            2, generate_item(adventurer.equipment.chest, false), chest_pos, theme,
        );

    let head_pos = SVGPosition { x: position.x + 120, y: position.y };
    inventory_elements +=
        create_inventory_slot_component(
            3, generate_item(adventurer.equipment.head, false), head_pos, theme,
        );

    let waist_pos = SVGPosition { x: position.x + 180, y: position.y };
    inventory_elements +=
        create_inventory_slot_component(
            4, generate_item(adventurer.equipment.waist, false), waist_pos, theme,
        );

    // Bottom row equipment slots
    let foot_pos = SVGPosition { x: position.x, y: position.y + 70 };
    inventory_elements +=
        create_inventory_slot_component(
            5, generate_item(adventurer.equipment.foot, false), foot_pos, theme,
        );

    let hand_pos = SVGPosition { x: position.x + 60, y: position.y + 70 };
    inventory_elements +=
        create_inventory_slot_component(
            6, generate_item(adventurer.equipment.hand, false), hand_pos, theme,
        );

    let neck_pos = SVGPosition { x: position.x + 120, y: position.y + 70 };
    inventory_elements +=
        create_inventory_slot_component(
            7, generate_item(adventurer.equipment.neck, false), neck_pos, theme,
        );

    let ring_pos = SVGPosition { x: position.x + 180, y: position.y + 70 };
    inventory_elements +=
        create_inventory_slot_component(
            8, generate_item(adventurer.equipment.ring, false), ring_pos, theme,
        );

    inventory_elements
}

fn create_bag_layout(bag: Bag, position: SVGPosition, theme: @SVGTheme) -> ByteArray {
    let mut bag_elements: ByteArray = "";
    let _slot_size = 55;

    // Create bag slots manually for now - first 3 items, rest empty
    let slot1_pos = SVGPosition { x: position.x, y: position.y };
    bag_elements +=
        create_inventory_slot_component(1, generate_item(bag.item_1, true), slot1_pos, theme);

    let slot2_pos = SVGPosition { x: position.x + 65, y: position.y };
    bag_elements +=
        create_inventory_slot_component(2, generate_item(bag.item_2, true), slot2_pos, theme);

    let slot3_pos = SVGPosition { x: position.x + 130, y: position.y };
    bag_elements +=
        create_inventory_slot_component(3, generate_item(bag.item_3, true), slot3_pos, theme);

    // Add a few empty slots for demonstration
    let slot4_pos = SVGPosition { x: position.x + 195, y: position.y };
    bag_elements += create_inventory_slot_component(4, "Empty", slot4_pos, theme);

    let slot5_pos = SVGPosition { x: position.x + 260, y: position.y };
    bag_elements += create_inventory_slot_component(5, "Empty", slot5_pos, theme);

    bag_elements
}

// @notice Combines elements into a single string
// @param elements The elements to combine
// @return The combined elements
fn combine_elements(ref elements: Span<ByteArray>) -> ByteArray {
    let mut count: u8 = 1;

    let mut combined: ByteArray = "";
    loop {
        match elements.pop_front() {
            Option::Some(element) => {
                combined += element.clone();

                count += 1;
            },
            Option::None(()) => { break; },
        }
    };

    combined
}

// SVG page creators using modular components
fn create_modular_adventurer_page(
    adventurer: Adventurer, adventurer_name: ByteArray, adventurer_id: u64,
) -> ByteArray {
    let theme = get_default_theme();
    let page_size = SVGSize { width: 360, height: 510 };
    let page_position = SVGPosition { x: 20, y: 20 };

    let mut page_elements: ByteArray = "";

    // Page background and border
    page_elements +=
        format!(
            "<path d='M{} {}h{}v{}H{}z' filter='url(#s)'/>",
            page_position.x,
            page_position.y,
            page_size.width,
            page_size.height,
            page_position.x,
        );
    page_elements +=
        format!(
            "<path d='M{} {}h{}v{}H{}z'/>",
            page_position.x + 10,
            page_position.y + 10,
            page_size.width - 20,
            page_size.height - 20,
            page_position.x + 10,
        );
    page_elements += create_page_border(page_size, @theme);

    // Page header with logo and title
    let header_position = SVGPosition { x: page_position.x + 30, y: page_position.y + 30 };
    let level = format!("LEVEL {}", (adventurer.xp / 100) + 1);
    page_elements += create_page_header_component(adventurer_name, level, header_position, @theme);

    // XP badge
    let xp_position = SVGPosition { x: 320, y: 55 };
    page_elements += create_xp_badge_component(format!("{}", adventurer.xp), xp_position);

    // Stats layout
    let stats_position = SVGPosition { x: 40, y: 100 };
    page_elements += create_stats_layout(adventurer, stats_position, @theme);

    // Health bar
    let health_position = SVGPosition { x: 90, y: 115 };
    let health_size = SVGSize { width: 200, height: 8 };
    let max_health = get_max_health(adventurer.stats.vitality);
    page_elements +=
        create_health_bar_component(
            adventurer.health.into(), max_health.into(), health_position, health_size, @theme,
        );

    // Health text
    let health_text_pos = SVGPosition { x: 90, y: 135 };
    page_elements +=
        create_text_component(
            format!("{}/{} HP", adventurer.health, max_health),
            health_text_pos,
            12,
            @theme,
            "start",
            "text-top",
        );

    // Inventory layout
    let inventory_position = SVGPosition { x: 90, y: 180 };
    page_elements += create_inventory_layout(adventurer, inventory_position, @theme);

    // Bottom info
    let info_position = SVGPosition { x: 40, y: 430 };
    page_elements +=
        format!(
            "<rect x='{}' y='{}' width='320' height='80' fill='{}' stroke='{}'/>",
            info_position.x,
            info_position.y,
            theme.secondary_color,
            theme.border_color,
        );

    let adventurer_text_pos = SVGPosition { x: 50, y: 450 };
    page_elements +=
        create_text_component(
            format!("ADVENTURER #{}", adventurer_id),
            adventurer_text_pos,
            12,
            @theme,
            "start",
            "text-top",
        );

    let level_text_pos = SVGPosition { x: 50, y: 470 };
    page_elements +=
        create_text_component(
            format!("LEVEL {} - {} XP", (adventurer.xp / 100) + 1, adventurer.xp),
            level_text_pos,
            12,
            @theme,
            "start",
            "text-top",
        );

    page_elements
}

fn create_modular_bag_page(adventurer_name: ByteArray, bag: Bag) -> ByteArray {
    let theme = get_bag_theme();
    let page_size = SVGSize { width: 360, height: 510 };
    let page_position = SVGPosition { x: 20, y: 20 };

    let mut page_elements: ByteArray = "";

    // Page background and border
    page_elements +=
        format!(
            "<path d='M{} {}h{}v{}H{}z' filter='url(#s)' transform='translate(400)'/>",
            page_position.x,
            page_position.y,
            page_size.width,
            page_size.height,
            page_position.x,
        );
    page_elements +=
        format!(
            "<path d='M{} {}h{}v{}H{}z'/>",
            page_position.x + 410,
            page_position.y + 10,
            page_size.width - 20,
            page_size.height - 20,
            page_position.x + 410,
        );
    page_elements += create_page_border(page_size, @theme);

    // Page header
    let header_position = SVGPosition { x: 520, y: 65 };
    page_elements +=
        create_text_component(
            format!("{}S", adventurer_name), header_position, 12, @theme, "start", "text-top",
        );

    let title_position = SVGPosition { x: 520, y: 85 };
    page_elements +=
        create_text_component("Item Bag", title_position, 16, @theme, "start", "text-top");

    // Info section
    let info_position = SVGPosition { x: 440, y: 150 };
    page_elements +=
        format!(
            "<rect x='{}' y='{}' width='320' height='80' fill='{}' stroke='{}'/>",
            info_position.x,
            info_position.y,
            theme.secondary_color,
            theme.border_color,
        );

    let info_text_pos = SVGPosition { x: 450, y: 170 };
    page_elements +=
        create_text_component(
            "INFORMATION ABOUT RUN GOES", info_text_pos, 12, @theme, "start", "text-top",
        );

    let info_text_pos2 = SVGPosition { x: 450, y: 190 };
    page_elements +=
        create_text_component("HERE AND HERE", info_text_pos2, 12, @theme, "start", "text-top");

    // Bag layout
    let bag_position = SVGPosition { x: 440, y: 250 };
    page_elements += create_bag_layout(bag, bag_position, @theme);

    page_elements
}

fn create_modular_svg_with_components(
    adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag,
) -> ByteArray {
    let mut _name = Default::default();
    _name
        .append_word(
            adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into(),
        );

    let svg_defs: ByteArray =
        "<defs><filter id='s'><feDropShadow dx='0' dy='10' flood-opacity='.3' stdDeviation='10'/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{font-family:\"Pixelify Sans\",\"Courier New\",\"Monaco\",\"Lucida Console\",monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}</style></defs>";

    let slide_container_start: ByteArray = "<g id='slideContainer'>";

    // Page 1: Adventurer stats
    let page1_start: ByteArray = "<g id='page1'>";
    let page1_content = create_modular_adventurer_page(adventurer, _name.clone(), adventurer_id);
    let page1_end: ByteArray = "</g>";

    // Page 2: Bag
    let page2_start: ByteArray = "<g id='page2' transform='translate(400,0)'>";
    let page2_content = create_modular_bag_page(_name.clone(), bag);
    let page2_end: ByteArray = "</g>";

    // Animation
    let animation: ByteArray =
        "<animateTransform attributeName='transform' type='translate' values='0,0; 0,0; -400,0; -400,0; 0,0' keyTimes='0; 0.4; 0.5; 0.9; 1' dur='20s' calcMode='spline' keySplines='0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1' repeatCount='indefinite'/>";

    let _slide_container_end: ByteArray = "</g>";

    format!(
        "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='550' viewBox='0 0 400 550'>{}{}{}{}{}{}{}{}{}</svg>",
        svg_defs,
        slide_container_start,
        page1_start,
        page1_content,
        page1_end,
        page2_start,
        page2_content,
        page2_end,
        animation,
    )
}

// @notice Generates an SVG string for adventurer token uri
// @param internals The internals of the SVG
// @return The generated SVG string
fn create_svg(internals: ByteArray) -> ByteArray {
    "<svg xmlns='http://www.w3.org/2000/svg' width='600' height='900'><style>text{text-transform: uppercase;font-family: Courier, monospace;fill: #3DEC00;}g{fill: #3DEC00;}</style>"
        + internals
        + "</svg>"
}

// @notice Generates an item string for adventurer token uri
// @param item The item to generate a string for
// @param bag Whether the item is in the bag or not
// @return The generated item string
pub fn generate_item(item: Item, bag: bool) -> ByteArray {
    if item.id == 0 {
        if (bag) {
            return "Empty";
        } else {
            return "None Equipped";
        }
    }

    // Calculate greatness using sqrt(item_xp)
    let greatness = calculate_greatness(item.xp);

    // Get base item name from database
    let base_name_felt = ItemDatabaseImpl::get_item_name(item.id);
    let mut base_name = Default::default();
    base_name
        .append_word(
            base_name_felt, U256BytesUsedTraitImpl::bytes_used(base_name_felt.into()).into(),
        );

    // Build the full item name with prefix and suffix
    let mut full_name = "";

    // Add prefix if greatness >= 19
    if greatness >= PREFIXES_UNLOCK_GREATNESS {
        let prefix_id = generate_prefix_id(item.id, item.xp);
        let prefix = get_prefix_string(prefix_id);
        full_name += format!("{} ", prefix);
    }

    // Add base name
    full_name += format!("{}", base_name);

    // Add suffix if greatness >= 15
    if greatness >= SUFFIX_UNLOCK_GREATNESS {
        let suffix_id = generate_suffix_id(item.id, item.xp);
        let suffix = get_suffix_string(suffix_id);
        full_name += format!(" {}", suffix);
    }

    full_name
}

fn generate_logo() -> ByteArray {
    "<g transform='translate(25,25) scale(4)'>" + logo() + "</g>"
}

// @notice Generates the shinobi SVG template with dynamic substitution (4-page version with battle)
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @param beast The beast being fought
// @param beast_name The name of the beast
// @return The generated shinobi SVG with dynamic values including battle page
fn create_battle_svg(
    adventurer_id: u64,
    adventurer: Adventurer,
    adventurer_name: felt252,
    bag: Bag,
    beast: Beast,
    beast_name: felt252,
) -> ByteArray {
    let mut _name = Default::default();
    _name
        .append_word(
            adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into(),
        );

    let mut _beast_name = Default::default();
    _beast_name
        .append_word(beast_name, U256BytesUsedTraitImpl::bytes_used(beast_name.into()).into());

    let _level = format!("{}", (adventurer.xp / 100) + 1);
    let _str = format!("{}", adventurer.stats.strength);
    let _dex = format!("{}", adventurer.stats.dexterity);
    let _int = format!("{}", adventurer.stats.intelligence);
    let _vit = format!("{}", adventurer.stats.vitality);
    let _wis = format!("{}", adventurer.stats.wisdom);
    let _cha = format!("{}", adventurer.stats.charisma);
    let _luck = format!("{}", adventurer.stats.luck);
    let _health = format!("{}", adventurer.health);
    let _max_health = format!(
        "{}", get_max_health(adventurer.stats.vitality),
    ); // Dynamic max health based on vitality
    let _xp = format!("{}", adventurer.xp);
    let _gold = format!("{}", adventurer.gold);

    // Beast stats for battle interface
    let _beast_level = format!("{}", beast.combat_spec.level);
    let _beast_health = format!("{}", beast.starting_health);
    let _beast_max_health = format!("{}", beast.starting_health); // For display purposes
    let _beast_power = format!("{}", beast.combat_spec.level + 20); // Simulated power calculation

    // Calculate battle damage (simplified)
    let damage_dealt = if adventurer.stats.strength > 10 {
        10
    } else {
        adventurer.stats.strength.into()
    };
    let _damage = format!("{}", damage_dealt);

    // Generate equipped item names for inventory slots
    let _weapon_name = generate_item(adventurer.equipment.weapon, false);
    let _chest_name = generate_item(adventurer.equipment.chest, false);
    let _head_name = generate_item(adventurer.equipment.head, false);
    let _waist_name = generate_item(adventurer.equipment.waist, false);
    let _foot_name = generate_item(adventurer.equipment.foot, false);
    let _hand_name = generate_item(adventurer.equipment.hand, false);
    let _neck_name = generate_item(adventurer.equipment.neck, false);
    let _ring_name = generate_item(adventurer.equipment.ring, false);

    // Generate bag item names for page 2
    let _bag_item_1 = generate_item(bag.item_1, true);
    let _bag_item_2 = generate_item(bag.item_2, true);
    let _bag_item_3 = generate_item(bag.item_3, true);

    // Create the optimized 4-page SVG (based on optimized multi_page_nft.svg template)
    format!(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"550\"><defs><linearGradient id=\"border_gradient\" x1=\"200\" x2=\"200\" y1=\"20\" y2=\"530\" gradientUnits=\"userSpaceOnUse\"><stop stop-color=\"#FE9676\"/><stop offset=\"1\" stop-color=\"#58F54C\"/></linearGradient><linearGradient id=\"battle_gradient\" x1=\"0%\" x2=\"100%\" y1=\"0%\" y2=\"100%\"><stop offset=\"0%\" stop-color=\"#F44\"/><stop offset=\"100%\" stop-color=\"#800\"/></linearGradient><filter id=\"s\"><feDropShadow dx=\"0\" dy=\"10\" flood-opacity=\".3\" stdDeviation=\"10\"/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{{font-family:\"Pixelify Sans\",\"Courier New\",\"Monaco\",\"Lucida Console\",monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}}</style></defs><g id=\"slideContainer\"><g id=\"page1\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"m92 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H92zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5H94V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#78E846\" font-size=\"14\"><text x=\"130\" y=\"70\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">{}</text><text x=\"250\" y=\"70\" font-size=\"12\">LEVEL {}</text><text x=\"40\" y=\"100\">STR</text><text x=\"40\" y=\"120\" font-size=\"20\">{}</text><text x=\"40\" y=\"150\">DEX</text><text x=\"40\" y=\"170\" font-size=\"20\">{}</text><text x=\"40\" y=\"200\">INT</text><text x=\"40\" y=\"220\" font-size=\"20\">{}</text><text x=\"40\" y=\"250\">HIT</text><text x=\"40\" y=\"270\" font-size=\"20\">{}</text><text x=\"40\" y=\"300\">WIS</text><text x=\"40\" y=\"320\" font-size=\"20\">{}</text><text x=\"40\" y=\"350\">CHA</text><text x=\"40\" y=\"370\" font-size=\"20\">{}</text><text x=\"40\" y=\"400\">LUCK</text><text x=\"40\" y=\"420\" font-size=\"20\">{}</text><text x=\"90\" y=\"160\" font-size=\"12\">INVENTORY</text><text x=\"90\" y=\"135\" font-size=\"12\">{}/{} HP</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 115h200v8H90z\"/><path fill=\"#78E846\" d=\"M91 116h160v6H91z\"/><path fill=\"#E8A746\" d=\"M320 55h50v25h-50z\"/><text x=\"330\" y=\"70\" fill=\"#2C1A0A\" font-size=\"14\">{}</text><text x=\"325\" y=\"50\" fill=\"#E8A746\" font-size=\"10\">XP</text><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 180h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40zM90 250h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40z\"/><path fill=\"#78E846\" d=\"M95 190h2v20h-2m-2-20h6v4h-6zm12 0h4v4h-4zm61-20h20v15h-20zm5 15h10v8h-10zm55-5h20v15h-20m5-20h10v8h-10zm55 2h20v4h-20m5-8h2v16h-2zm8 2h4v8h-4M95 260h2v20h-2zm3 3h12v2H98zm0 10h12v2H98zm12-8h2v8h-2zm50-2h10v16h-10m2-18h6v4h-6zm53 9h8v10h-8zm12 0h8v10h-8m-12-13h20v6h-20zm63-4h14v14h-14zm-153-78h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm-180 70h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8z\"/><path fill=\"#2C1A0A\" d=\"M217 205h4v6h-4zm-54 60h4v8h-4zm119 2h6v6h-6z\"/><g fill=\"#78E846\" font-size=\"8\"><text x=\"95\" y=\"230\">{}</text><text x=\"155\" y=\"230\">{}</text><text x=\"215\" y=\"230\">{}</text><text x=\"275\" y=\"230\">{}</text><text x=\"95\" y=\"300\">{}</text><text x=\"155\" y=\"300\">{}</text><text x=\"215\" y=\"300\">{}</text><text x=\"275\" y=\"300\">{}</text></g><g font-size=\"6\"><text x=\"126\" y=\"192\">01</text><text x=\"186\" y=\"192\">02</text><text x=\"246\" y=\"192\">03</text><text x=\"306\" y=\"192\">04</text><text x=\"126\" y=\"262\">05</text><text x=\"186\" y=\"262\">06</text><text x=\"246\" y=\"262\">07</text><text x=\"306\" y=\"262\">08</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">ADVENTURER #{}</text><text x=\"50\" y=\"470\">LEVEL {} - {} XP</text></g></g><g id=\"page2\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\" transform=\"translate(400)\"/><path d=\"M430 30h340v490H430z\"/><path fill=\"#E89446\" d=\"M420 20h360v2H420zm0 508h360v2H420zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#E89446\" fill-rule=\"evenodd\" d=\"m450 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2h-17zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5h-11V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#E89446\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\" transform=\"translate(400)\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\" transform=\"translate(400)\">Item Bag</text></g><path fill=\"#2C1A0A\" stroke=\"#E89446\" d=\"M440 150h320v80H440z\"/><g fill=\"#E89446\" font-size=\"12\"><text x=\"50\" y=\"170\" transform=\"translate(400)\">INFORMATION ABOUT RUN GOES</text><text x=\"50\" y=\"190\" transform=\"translate(400)\">HERE AND HERE</text></g><path fill=\"none\" stroke=\"#663D17\" d=\"M440 250h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 65h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 65h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 65h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\"/><g fill=\"#E89446\" transform=\"translate(400)\"><circle cx=\"67\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><path d=\"M63 265h8v6h-8z\"/><path fill=\"none\" stroke=\"#E89446\" d=\"M127 270h11v14h-11z\"/><path stroke=\"#E89446\" d=\"M130 272h5m-5 4h5m-5 4h3\"/><circle cx=\"197\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><text x=\"197\" y=\"281\" font-size=\"8\" text-anchor=\"middle\">$</text></g><g fill=\"#E89446\" font-size=\"8\"><text x=\"67\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"132\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"197\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">{}</text><text x=\"262\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">EMPTY</text><text x=\"327\" y=\"295\" text-anchor=\"middle\" transform=\"translate(400)\">EMPTY</text></g><g fill=\"#E89446\" font-size=\"6\"><text x=\"47\" y=\"260\" transform=\"translate(400)\">01</text><text x=\"112\" y=\"260\" transform=\"translate(400)\">02</text><text x=\"177\" y=\"260\" transform=\"translate(400)\">03</text><text x=\"242\" y=\"260\" transform=\"translate(400)\">04</text><text x=\"307\" y=\"260\" transform=\"translate(400)\">05</text><text x=\"47\" y=\"325\" transform=\"translate(400)\">06</text><text x=\"112\" y=\"325\" transform=\"translate(400)\">07</text><text x=\"177\" y=\"325\" transform=\"translate(400)\">08</text><text x=\"242\" y=\"325\" transform=\"translate(400)\">09</text><text x=\"307\" y=\"325\" transform=\"translate(400)\">10</text><text x=\"47\" y=\"390\" transform=\"translate(400)\">11</text><text x=\"112\" y=\"390\" transform=\"translate(400)\">12</text><text x=\"177\" y=\"390\" transform=\"translate(400)\">13</text><text x=\"242\" y=\"390\" transform=\"translate(400)\">14</text><text x=\"307\" y=\"390\" transform=\"translate(400)\">15</text></g></g><g id=\"page3\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\" transform=\"translate(800)\"/><path d=\"M830 30h340v490H830z\"/><path fill=\"#77EDFF\" d=\"M820 20h360v2H820zm0 508h360v2H820zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#77EDFF\" fill-rule=\"evenodd\" d=\"m850 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2h-17zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5h-11V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#77EDFF\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\" transform=\"translate(800)\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\" transform=\"translate(800)\">Marketplace</text></g><path fill=\"none\" stroke=\"#77EDFF\" d=\"M840 100h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm-260 85h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\"/><g fill=\"#77EDFF\" transform=\"translate(800)\"><path d=\"M60 115h15v25H60z\"/><circle cx=\"132\" cy=\"127\" r=\"8\"/><path d=\"M125 135h14v8h-14zm60-15h20v15h-20z\"/><circle cx=\"257\" cy=\"127\" r=\"8\"/><path d=\"M250 135h14v8h-14zm65-15h20v15h-20z\"/><circle cx=\"67\" cy=\"212\" r=\"8\"/><path d=\"M120 200h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"212\" r=\"8\"/><path d=\"M315 205h20v15h-20z\"/><circle cx=\"67\" cy=\"297\" r=\"8\"/><path d=\"M120 285h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"297\" r=\"8\"/><path d=\"M315 290h20v15h-20z\"/><circle cx=\"67\" cy=\"382\" r=\"8\"/><path d=\"M120 370h25v20h-25zm65 5h20v15h-20z\"/><circle cx=\"257\" cy=\"382\" r=\"8\"/><path d=\"M315 375h20v15h-20z\"/></g><g fill=\"#77EDFF\" font-size=\"8\"><text x=\"67\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">FIRE</text><text x=\"67\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"132\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">HEALTH</text><text x=\"132\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"197\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">WATER</text><text x=\"197\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"170\" text-anchor=\"middle\" transform=\"translate(800)\">FIRE</text><text x=\"327\" y=\"178\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"67\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"255\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"263\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"67\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"340\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"348\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"67\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">CHARISMA</text><text x=\"67\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">RING</text><text x=\"132\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">OCEAN</text><text x=\"132\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">NECKLACE</text><text x=\"197\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"197\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text><text x=\"262\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">MAGIC</text><text x=\"262\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">POTION</text><text x=\"327\" y=\"425\" text-anchor=\"middle\" transform=\"translate(800)\">THUNDER</text><text x=\"327\" y=\"433\" text-anchor=\"middle\" transform=\"translate(800)\">SCROLL</text></g><g fill=\"#77EDFF\" font-size=\"6\"><text x=\"47\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"110\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"195\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"280\" transform=\"translate(800)\">ITEM</text><text x=\"47\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"112\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"177\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"242\" y=\"365\" transform=\"translate(800)\">ITEM</text><text x=\"307\" y=\"365\" transform=\"translate(800)\">ITEM</text></g></g><g id=\"page4\" transform=\"translate(1200)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><linearGradient id=\"page4_border\" x1=\"0\" x2=\"0\" y1=\"0\" y2=\"1\"><stop offset=\"0%\" stop-color=\"#FE9676\"/><stop offset=\"100%\" stop-color=\"#78E846\"/></linearGradient><path fill=\"url(#page4_border)\" stroke=\"url(#page4_border)\" stroke-width=\"2\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#FE9676\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50zm7 10v3h-4v-3l-1-3h5zm8 0v3h-4v-6h4zm-4 5v2h-4v-4h4zm-13 5v20h8l7 1v-5H52V71h-2zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6H59v-2h10v-5h-7z\" clip-rule=\"evenodd\"/><g fill=\"#FE9676\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}&apos;S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Current Battle</text></g><rect width=\"320\" height=\"120\" x=\"40\" y=\"110\" fill=\"#210E04\" rx=\"6\"/><rect width=\"60\" height=\"18\" x=\"55\" y=\"125\" fill=\"#FE9676\" rx=\"3\"/><text x=\"85\" y=\"138\" font-size=\"10\" text-anchor=\"middle\">{}</text><text x=\"60\" y=\"160\" fill=\"#FE9676\" font-size=\"12\">Level {}</text><text x=\"60\" y=\"180\" fill=\"#FE9676\" font-size=\"12\">Health: {}/25</text><text x=\"60\" y=\"200\" fill=\"#FE9676\" font-size=\"12\">Power: {}</text><text x=\"200\" y=\"160\" fill=\"#FE9676\" font-size=\"12\">Status: Hostile</text><text x=\"200\" y=\"180\" fill=\"#FE9676\" font-size=\"12\">Type: Magical</text><text x=\"200\" y=\"200\" fill=\"#FE9676\" font-size=\"12\">Tier: 3</text><rect width=\"320\" height=\"80\" x=\"40\" y=\"250\" fill=\"#2C1A0A\" stroke=\"#FE9676\" rx=\"6\"/><text x=\"60\" y=\"275\" fill=\"#FE9676\" font-size=\"12\">LAST ACTIVITY:</text><text x=\"60\" y=\"295\" fill=\"#FE9676\" font-size=\"11\">Troll ambushed you for 15 damage!</text><text x=\"60\" y=\"310\" fill=\"#FE9676\" font-size=\"11\">You attacked with sword for 21 damage.</text><rect width=\"320\" height=\"150\" x=\"40\" y=\"350\" fill=\"#171D10\" rx=\"6\"/><rect width=\"50\" height=\"18\" x=\"55\" y=\"365\" fill=\"#78E846\" rx=\"3\"/><text x=\"80\" y=\"378\" font-size=\"10\" text-anchor=\"middle\">YOU</text><text x=\"60\" y=\"400\" fill=\"#78E846\" font-size=\"12\">Level {}</text><text x=\"60\" y=\"420\" fill=\"#78E846\" font-size=\"12\">Health: {}/100</text><text x=\"60\" y=\"440\" fill=\"#78E846\" font-size=\"12\">Power: {}</text><text x=\"60\" y=\"460\" fill=\"#78E846\" font-size=\"12\">Dexterity: {}</text><text x=\"200\" y=\"400\" fill=\"#78E846\" font-size=\"12\">XP: 1250</text><text x=\"200\" y=\"420\" fill=\"#78E846\" font-size=\"12\">Beast Health: 10</text><text x=\"200\" y=\"440\" fill=\"#78E846\" font-size=\"12\">Weapon: Katana</text><text x=\"200\" y=\"460\" fill=\"#78E846\" font-size=\"12\">Armor: Iron</text></g><animateTransform attributeName=\"transform\" calcMode=\"spline\" dur=\"40s\" keySplines=\"0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1\" keyTimes=\"0; 0.22; 0.28; 0.47; 0.53; 0.72; 0.78; 0.97; 1\" repeatCount=\"indefinite\" type=\"translate\" values=\"0,0; 0,0; -400,0; -400,0; -800,0; -800,0; -1200,0; -1200,0; 0,0\"/></g></svg>",
        _name,
        _level,
        _str,
        _dex,
        _int,
        _vit,
        _wis,
        _cha,
        _luck,
        _health,
        _max_health,
        _xp,
        _weapon_name,
        _chest_name,
        _head_name,
        _waist_name,
        _foot_name,
        _hand_name,
        _neck_name,
        _ring_name,
        adventurer_id,
        _level,
        _xp,
        _name,
        _bag_item_1,
        _bag_item_2,
        _bag_item_3,
        _name,
        _beast_name,
        _beast_level,
        _beast_health,
        _beast_power,
        _level,
        _health,
        _str,
        _dex,
        _name,
    )
}

// @notice Generates the shinobi SVG template with dynamic substitution (modular component version)
// @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @return The generated shinobi SVG with dynamic values using modular components
fn create_shinobi_svg(
    adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag,
) -> ByteArray {
    // Use the new modular component system
    create_modular_svg_with_components(adventurer_id, adventurer, adventurer_name, bag)
}

// Legacy function kept for backward compatibility
fn create_shinobi_svg_legacy(
    adventurer_id: u64, adventurer: Adventurer, adventurer_name: felt252, bag: Bag,
) -> ByteArray {
    let mut _name = Default::default();
    _name
        .append_word(
            adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into(),
        );

    let _level = format!("{}", (adventurer.xp / 100) + 1);
    let _str = format!("{}", adventurer.stats.strength);
    let _dex = format!("{}", adventurer.stats.dexterity);
    let _int = format!("{}", adventurer.stats.intelligence);
    let _vit = format!("{}", adventurer.stats.vitality);
    let _wis = format!("{}", adventurer.stats.wisdom);
    let _cha = format!("{}", adventurer.stats.charisma);
    let _luck = format!("{}", adventurer.stats.luck);
    let _health = format!("{}", adventurer.health);
    let _max_health = format!(
        "{}", get_max_health(adventurer.stats.vitality),
    ); // Dynamic max health based on vitality
    let _xp = format!("{}", adventurer.xp);

    // Generate equipped item names for inventory slots
    let _weapon_name = generate_item(adventurer.equipment.weapon, false);
    let _chest_name = generate_item(adventurer.equipment.chest, false);
    let _head_name = generate_item(adventurer.equipment.head, false);
    let _waist_name = generate_item(adventurer.equipment.waist, false);
    let _foot_name = generate_item(adventurer.equipment.foot, false);
    let _hand_name = generate_item(adventurer.equipment.hand, false);
    let _neck_name = generate_item(adventurer.equipment.neck, false);
    let _ring_name = generate_item(adventurer.equipment.ring, false);

    // Generate bag item names for page 2
    let _bag_item_1 = generate_item(bag.item_1, true);
    let _bag_item_2 = generate_item(bag.item_2, true);
    let _bag_item_3 = generate_item(bag.item_3, true);

    // Create the optimized multi-page SVG with dynamic values
    format!(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"550\" viewBox=\"0 0 400 550\"><defs><filter id=\"s\"><feDropShadow dx=\"0\" dy=\"10\" flood-opacity=\".3\" stdDeviation=\"10\"/></filter><style>@import url(https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;700&amp;family=MedievalSharp&amp;display=swap);text{{font-family:\"Pixelify Sans\",\"Courier New\",\"Monaco\",\"Lucida Console\",monospace;font-weight:700;text-rendering:optimizeSpeed;shape-rendering:crispEdges}}</style></defs><g id=\"slideContainer\"><g id=\"page1\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#78E846\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#78E846\" fill-rule=\"evenodd\" d=\"m92 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H92v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H94V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#78E846\" font-size=\"14\"><text x=\"130\" y=\"70\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">{}</text><text x=\"250\" y=\"70\" font-size=\"12\">LEVEL {}</text><text x=\"40\" y=\"100\">STR</text><text x=\"40\" y=\"120\" font-size=\"20\">{}</text><text x=\"40\" y=\"150\">DEX</text><text x=\"40\" y=\"170\" font-size=\"20\">{}</text><text x=\"40\" y=\"200\">INT</text><text x=\"40\" y=\"220\" font-size=\"20\">{}</text><text x=\"40\" y=\"250\">HIT</text><text x=\"40\" y=\"270\" font-size=\"20\">{}</text><text x=\"40\" y=\"300\">WIS</text><text x=\"40\" y=\"320\" font-size=\"20\">{}</text><text x=\"40\" y=\"350\">CHA</text><text x=\"40\" y=\"370\" font-size=\"20\">{}</text><text x=\"40\" y=\"400\">LUCK</text><text x=\"40\" y=\"420\" font-size=\"20\">{}</text><text x=\"90\" y=\"160\" font-size=\"12\">INVENTORY</text><text x=\"90\" y=\"135\" font-size=\"12\">{}/{} HP</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 115h200v8H90z\"/><path fill=\"#78E846\" d=\"M91 116h160v6H91z\"/><path d=\"M320 55h50v25H320z\" fill=\"#E8A746\" rx=\"4\"/><text x=\"330\" y=\"70\" fill=\"#2C1A0A\" font-size=\"14\">{}</text><text x=\"325\" y=\"50\" fill=\"#E8A746\" font-size=\"10\">XP</text><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M90 180h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40zM90 250h40v40H90zm60 0h40v40h-40zm60 0h40v40h-40zm60 0h40v40h-40z\"/><path fill=\"#78E846\" d=\"M95 190h2v20h-2m-2-20h6v4h-6zm1 20h4v4h-4zm61-20h20v15h-20zm5 15h10v8h-10zm55-5h20v15h-20m5-20h10v8h-10zm55 2h20v4h-20m5-8h2v16h-2zm8 2h4v8h-4M95 260h2v20h-2zm3 3h12v2H98zm0 10h12v2H98zm12-8h2v8h-2zm50-2h10v16h-10m2-18h6v4h-6zm53 9h8v10h-8zm12 0h8v10h-8m-12-13h20v6h-20zm63-4h14v14h-14zm-153-78h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm-180 70h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8zm60 0h8v4h-8z\"/><path fill=\"#2C1A0A\" d=\"M217 205h4v6h-4zm-54 60h4v8h-4zm119 2h6v6h-6z\"/><g fill=\"#78E846\" font-size=\"8\"><text x=\"95\" y=\"230\">{}</text><text x=\"155\" y=\"230\">{}</text><text x=\"215\" y=\"230\">{}</text><text x=\"275\" y=\"230\">{}</text><text x=\"95\" y=\"300\">{}</text><text x=\"155\" y=\"300\">{}</text><text x=\"215\" y=\"300\">{}</text><text x=\"275\" y=\"300\">{}</text></g><g font-size=\"6\"><text x=\"126\" y=\"192\">01</text><text x=\"186\" y=\"192\">02</text><text x=\"246\" y=\"192\">03</text><text x=\"306\" y=\"192\">04</text><text x=\"126\" y=\"262\">05</text><text x=\"186\" y=\"262\">06</text><text x=\"246\" y=\"262\">07</text><text x=\"306\" y=\"262\">08</text></g><path fill=\"#2C1A0A\" stroke=\"#78E846\" d=\"M40 430h320v80H40z\"/><g fill=\"#78E846\" font-size=\"12\"><text x=\"50\" y=\"450\">ADVENTURER #{}</text><text x=\"50\" y=\"470\">LEVEL {} - {} XP</text></g></g><g id=\"page2\" transform=\"translate(400,0)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#E89446\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#E89446\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H52V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#E89446\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}'S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Item Bag</text></g><path d=\"M40 150h320v80H40z\" rx=\"5\" fill=\"#2C1A0A\" stroke=\"#E89446\"/><g fill=\"#E89446\" font-size=\"12\"><text x=\"50\" y=\"170\">INFORMATION ABOUT RUN GOES</text><text x=\"50\" y=\"190\">HERE AND HERE</text></g><g stroke=\"#663D17\"><path d=\"M40 250h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 315h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 380h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\" rx=\"5\" fill=\"none\"/></g><g fill=\"#E89446\"><circle cx=\"67\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><path d=\"M63 265h8v6h-8z\"/><path d=\"M127 270h11v14h-11z\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"1\"/><path d=\"M130 272h5M130 276h5M130 280h3\" stroke=\"#E89446\" stroke-width=\"1\"/><circle cx=\"197\" cy=\"277\" r=\"8\" fill=\"none\" stroke=\"#E89446\" stroke-width=\"2\"/><text x=\"197\" y=\"281\" font-size=\"8\" text-anchor=\"middle\">$</text></g><g fill=\"#E89446\" font-size=\"8\"><text x=\"67\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"67\" y=\"303\" text-anchor=\"middle\"></text><text x=\"132\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"132\" y=\"303\" text-anchor=\"middle\"></text><text x=\"197\" y=\"295\" text-anchor=\"middle\">{}</text><text x=\"197\" y=\"303\" text-anchor=\"middle\"></text><text x=\"262\" y=\"295\" text-anchor=\"middle\">EMPTY</text><text x=\"327\" y=\"295\" text-anchor=\"middle\">EMPTY</text></g><g font-size=\"6\" fill=\"#E89446\"><text x=\"47\" y=\"260\">01</text><text x=\"112\" y=\"260\">02</text><text x=\"177\" y=\"260\">03</text><text x=\"242\" y=\"260\">04</text><text x=\"307\" y=\"260\">05</text><text x=\"47\" y=\"325\">06</text><text x=\"112\" y=\"325\">07</text><text x=\"177\" y=\"325\">08</text><text x=\"242\" y=\"325\">09</text><text x=\"307\" y=\"325\">10</text><text x=\"47\" y=\"390\">11</text><text x=\"112\" y=\"390\">12</text><text x=\"177\" y=\"390\">13</text><text x=\"242\" y=\"390\">14</text><text x=\"307\" y=\"390\">15</text></g></g><g id=\"page3\" transform=\"translate(800,0)\"><path d=\"M20 20h360v510H20z\" filter=\"url(#s)\"/><path d=\"M30 30h340v490H30z\"/><path fill=\"#77EDFF\" d=\"M20 20h360v2H20zm0 508h360v2H20zm0-506h2v506h-2zm358 0h2v506h-2z\"/><path fill=\"#77EDFF\" fill-rule=\"evenodd\" d=\"m50 52-1 2h-1v15h6v2l1 3h3c5 0 5 0 5-3v-2h6V54h-1l-1-2v-2H50v2Zm7 10v3h-4v-3l-1-3h5v3Zm8 0v3h-4v-6h4v3Zm-4 5v2h-4v-4h4v2Zm-13 5v20h8l7 1v-5H52V71h-2l-2 1Zm6 4v5l1 5h10v8h-8l-9 1v4h19v-2l1-2h1v-7l1-6h-11v-2h10v-5h-7l-8 1Z\" clip-rule=\"evenodd\"/><g fill=\"#77EDFF\" font-size=\"14\"><text x=\"120\" y=\"65\" font-size=\"12\">{}'S</text><text x=\"120\" y=\"85\" font-size=\"16\" style=\"font-family:&quot;MedievalSharp&quot;,&quot;Pixelify Sans&quot;,&quot;Courier New&quot;,&quot;Monaco&quot;,&quot;Lucida Console&quot;,monospace\">Marketplace</text></g><g stroke=\"#77EDFF\" fill=\"none\"><path d=\"M40 100h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 185h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 270h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zM40 355h55v55H40zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55zm65 0h55v55h-55z\" rx=\"3\"/></g><g fill=\"#77EDFF\"><path d=\"M60 115h15v25H60z\"/><circle cx=\"132\" cy=\"127\" r=\"8\"/><path d=\"M125 135h14v8h-14z\"/><path d=\"M185 120h20v15h-20z\"/><circle cx=\"257\" cy=\"127\" r=\"8\"/><path d=\"M250 135h14v8h-14z\"/><path d=\"M315 120h20v15h-20z\"/><circle cx=\"67\" cy=\"212\" r=\"8\"/><path d=\"M120 200h25v20h-25z\"/><path d=\"M185 205h20v15h-20z\"/><circle cx=\"257\" cy=\"212\" r=\"8\"/><path d=\"M315 205h20v15h-20z\"/><circle cx=\"67\" cy=\"297\" r=\"8\"/><path d=\"M120 285h25v20h-25z\"/><path d=\"M185 290h20v15h-20z\"/><circle cx=\"257\" cy=\"297\" r=\"8\"/><path d=\"M315 290h20v15h-20z\"/><circle cx=\"67\" cy=\"382\" r=\"8\"/><path d=\"M120 370h25v20h-25z\"/><path d=\"M185 375h20v15h-20z\"/><circle cx=\"257\" cy=\"382\" r=\"8\"/><path d=\"M315 375h20v15h-20z\"/></g><g fill=\"#77EDFF\" font-size=\"8\"><text x=\"67\" y=\"170\" text-anchor=\"middle\">FIRE</text><text x=\"67\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"132\" y=\"170\" text-anchor=\"middle\">HEALTH</text><text x=\"132\" y=\"178\" text-anchor=\"middle\">POTION</text><text x=\"197\" y=\"170\" text-anchor=\"middle\">WATER</text><text x=\"197\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"170\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"178\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"170\" text-anchor=\"middle\">FIRE</text><text x=\"327\" y=\"178\" text-anchor=\"middle\">SCROLL</text><text x=\"67\" y=\"255\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"263\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"255\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"263\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"255\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"263\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"255\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"263\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"255\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"263\" text-anchor=\"middle\">RING</text><text x=\"67\" y=\"340\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"348\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"340\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"348\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"340\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"348\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"340\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"348\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"340\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"348\" text-anchor=\"middle\">SCROLL</text><text x=\"67\" y=\"425\" text-anchor=\"middle\">CHARISMA</text><text x=\"67\" y=\"433\" text-anchor=\"middle\">RING</text><text x=\"132\" y=\"425\" text-anchor=\"middle\">OCEAN</text><text x=\"132\" y=\"433\" text-anchor=\"middle\">NECKLACE</text><text x=\"197\" y=\"425\" text-anchor=\"middle\">THUNDER</text><text x=\"197\" y=\"433\" text-anchor=\"middle\">SCROLL</text><text x=\"262\" y=\"425\" text-anchor=\"middle\">MAGIC</text><text x=\"262\" y=\"433\" text-anchor=\"middle\">POTION</text><text x=\"327\" y=\"425\" text-anchor=\"middle\">THUNDER</text><text x=\"327\" y=\"433\" text-anchor=\"middle\">SCROLL</text></g><g fill=\"#77EDFF\" font-size=\"6\"><text x=\"47\" y=\"110\">ITEM</text><text x=\"112\" y=\"110\">ITEM</text><text x=\"177\" y=\"110\">ITEM</text><text x=\"242\" y=\"110\">ITEM</text><text x=\"307\" y=\"110\">ITEM</text><text x=\"47\" y=\"195\">ITEM</text><text x=\"112\" y=\"195\">ITEM</text><text x=\"177\" y=\"195\">ITEM</text><text x=\"242\" y=\"195\">ITEM</text><text x=\"307\" y=\"195\">ITEM</text><text x=\"47\" y=\"280\">ITEM</text><text x=\"112\" y=\"280\">ITEM</text><text x=\"177\" y=\"280\">ITEM</text><text x=\"242\" y=\"280\">ITEM</text><text x=\"307\" y=\"280\">ITEM</text><text x=\"47\" y=\"365\">ITEM</text><text x=\"112\" y=\"365\">ITEM</text><text x=\"177\" y=\"365\">ITEM</text><text x=\"242\" y=\"365\">ITEM</text><text x=\"307\" y=\"365\">ITEM</text></g></g><animateTransform attributeName=\"transform\" type=\"translate\" values=\"0,0; 0,0; -400,0; -400,0; -800,0; -800,0; 0,0\" keyTimes=\"0; 0.3; 0.37; 0.63; 0.7; 0.97; 1\" dur=\"30s\" calcMode=\"spline\" keySplines=\"0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1; 0.4 0 0.6 1\" repeatCount=\"indefinite\"/></g></svg>",
        _name,
        _level,
        _str,
        _dex,
        _int,
        _vit,
        _wis,
        _cha,
        _luck,
        _health,
        _max_health,
        _xp,
        _weapon_name,
        _chest_name,
        _head_name,
        _waist_name,
        _foot_name,
        _hand_name,
        _neck_name,
        _ring_name,
        adventurer_id,
        _level,
        _xp,
        _name,
        _bag_item_1,
        _bag_item_2,
        _bag_item_3,
        _name,
    )
}


// @notice Generates JSON metadata for the adventurer token uri using Shinobi template with battle
// interface @param adventurer_id The adventurer's ID
// @param adventurer The adventurer
// @param adventurer_name The adventurer's name
// @param bag The adventurer's bag
// @param beast The beast being fought
// @param beast_name The name of the beast
// @return The generated JSON metadata with battle interface
pub fn create_metadata(
    adventurer_id: u64,
    adventurer: Adventurer,
    adventurer_name: felt252,
    bag: Bag,
    beast: Beast,
    beast_name: felt252,
) -> ByteArray {
    let mut _name = Default::default();
    _name
        .append_word(
            adventurer_name, U256BytesUsedTraitImpl::bytes_used(adventurer_name.into()).into(),
        );

    let _adventurer_id = format!("{}", adventurer_id);
    let _xp = format!("{}", adventurer.xp);
    let _level = format!("{}", (adventurer.xp / 100) + 1);
    let _health = format!("{}", adventurer.health);
    let _gold = format!("{}", adventurer.gold);
    let _str = format!("{}", adventurer.stats.strength);
    let _dex = format!("{}", adventurer.stats.dexterity);
    let _int = format!("{}", adventurer.stats.intelligence);
    let _vit = format!("{}", adventurer.stats.vitality);
    let _wis = format!("{}", adventurer.stats.wisdom);
    let _cha = format!("{}", adventurer.stats.charisma);
    let _luck = format!("{}", adventurer.stats.luck);

    // Generate equipped item names
    let _equiped_weapon = generate_item(adventurer.equipment.weapon, false);
    let _equiped_chest = generate_item(adventurer.equipment.chest, false);
    let _equiped_head = generate_item(adventurer.equipment.head, false);
    let _equiped_waist = generate_item(adventurer.equipment.waist, false);
    let _equiped_foot = generate_item(adventurer.equipment.foot, false);
    let _equiped_hand = generate_item(adventurer.equipment.hand, false);
    let _equiped_neck = generate_item(adventurer.equipment.neck, false);
    let _equiped_ring = generate_item(adventurer.equipment.ring, false);

    // Beast metadata
    let mut _beast_name_str = Default::default();
    _beast_name_str
        .append_word(beast_name, U256BytesUsedTraitImpl::bytes_used(beast_name.into()).into());
    let _beast_level = format!("{}", beast.combat_spec.level);
    let _beast_health = format!("{}", beast.starting_health);

    // Generate the shinobi SVG with battle interface
    let image = create_battle_svg(
        adventurer_id, adventurer, adventurer_name, bag, beast, beast_name,
    );

    let base64_image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(image));

    // Build JSON metadata string
    let mut metadata: ByteArray = "{";
    metadata += "\"name\":\"" + _name.clone() + " #" + _adventurer_id + "\",";
    metadata +=
        "\"description\":\"A legendary adventurer NFT with on-chain metadata rendered using the Shinobi template with battle interface.\",";
    metadata += "\"image\":\"" + base64_image + "\",";
    metadata += "\"attributes\":[";
    metadata += "{\"trait_type\":\"Name\",\"value\":\"" + _name + "\"},";
    metadata += "{\"trait_type\":\"XP\",\"value\":" + _xp + "},";
    metadata += "{\"trait_type\":\"Level\",\"value\":" + _level + "},";
    metadata += "{\"trait_type\":\"Health\",\"value\":" + _health + "},";
    metadata += "{\"trait_type\":\"Gold\",\"value\":" + _gold + "},";
    metadata += "{\"trait_type\":\"Strength\",\"value\":" + _str + "},";
    metadata += "{\"trait_type\":\"Dexterity\",\"value\":" + _dex + "},";
    metadata += "{\"trait_type\":\"Intelligence\",\"value\":" + _int + "},";
    metadata += "{\"trait_type\":\"Vitality\",\"value\":" + _vit + "},";
    metadata += "{\"trait_type\":\"Wisdom\",\"value\":" + _wis + "},";
    metadata += "{\"trait_type\":\"Charisma\",\"value\":" + _cha + "},";
    metadata += "{\"trait_type\":\"Luck\",\"value\":" + _luck + "},";
    metadata += "{\"trait_type\":\"Weapon\",\"value\":\"" + _equiped_weapon + "\"},";
    metadata += "{\"trait_type\":\"Chest Armor\",\"value\":\"" + _equiped_chest + "\"},";
    metadata += "{\"trait_type\":\"Head Armor\",\"value\":\"" + _equiped_head + "\"},";
    metadata += "{\"trait_type\":\"Waist Armor\",\"value\":\"" + _equiped_waist + "\"},";
    metadata += "{\"trait_type\":\"Foot Armor\",\"value\":\"" + _equiped_foot + "\"},";
    metadata += "{\"trait_type\":\"Hand Armor\",\"value\":\"" + _equiped_hand + "\"},";
    metadata += "{\"trait_type\":\"Necklace\",\"value\":\"" + _equiped_neck + "\"},";
    metadata += "{\"trait_type\":\"Ring\",\"value\":\"" + _equiped_ring + "\"},";
    metadata += "{\"trait_type\":\"Battle Beast\",\"value\":\"" + _beast_name_str + "\"},";
    metadata += "{\"trait_type\":\"Beast Level\",\"value\":" + _beast_level + "},";
    metadata += "{\"trait_type\":\"Beast Health\",\"value\":" + _beast_health + "}";
    metadata += "]}";

    format!("data:application/json;base64,{}", bytes_base64_encode(metadata))
}


#[cfg(test)]
mod tests {
    use ls2_renderer::mocks::mock_adventurer::{Adventurer, Bag, Equipment, Stats, Item};
    use ls2_renderer::mocks::mock_beast::{Beast, CombatSpec, Tier, Type, SpecialPowers, Category};
    use super::create_metadata;

    #[test]
    fn test_metadata() {
        let _adventurer = Adventurer {
            health: 100,
            xp: 1000,
            gold: 500,
            beast_health: 50,
            stat_upgrades_available: 0,
            stats: Stats {
                strength: 10,
                dexterity: 50,
                vitality: 50,
                intelligence: 50,
                wisdom: 50,
                charisma: 50,
                luck: 100,
            },
            equipment: Equipment {
                weapon: Item { id: 42, xp: 400 },
                chest: Item { id: 49, xp: 400 },
                head: Item { id: 53, xp: 400 },
                waist: Item { id: 59, xp: 400 },
                foot: Item { id: 64, xp: 400 },
                hand: Item { id: 69, xp: 400 },
                neck: Item { id: 1, xp: 400 },
                ring: Item { id: 7, xp: 400 },
            },
            item_specials_seed: 0,
            action_count: 0,
        };

        let _bag = Bag {
            item_1: Item { id: 8, xp: 400 },
            item_2: Item { id: 40, xp: 400 },
            item_3: Item { id: 57, xp: 400 },
            item_4: Item { id: 83, xp: 400 },
            item_5: Item { id: 12, xp: 400 },
            item_6: Item { id: 77, xp: 400 },
            item_7: Item { id: 68, xp: 400 },
            item_8: Item { id: 100, xp: 400 },
            item_9: Item { id: 94, xp: 400 },
            item_10: Item { id: 54, xp: 400 },
            item_11: Item { id: 87, xp: 400 },
            item_12: Item { id: 81, xp: 400 },
            item_13: Item { id: 30, xp: 400 },
            item_14: Item { id: 11, xp: 400 },
            item_15: Item { id: 29, xp: 400 },
            mutated: false,
        };

        let _beast = Beast {
            id: 7,
            starting_health: 25,
            combat_spec: CombatSpec {
                tier: Tier::T2,
                item_type: Type::Blade_or_Hide,
                level: 5,
                specials: SpecialPowers { special1: 1, special2: 2, special3: 3 },
            },
            category: Category::Magical,
        };

        let _current_1 = create_metadata(
            1000000, _adventurer, 'testadventurer', _bag, _beast, 'testbeast',
        );

        // Test passes if no panic occurs
        assert!(true);
    }
}
