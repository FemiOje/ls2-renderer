// SPDX-License-Identifier: MIT
//
// @title Battle Page Generator
// @notice Functions for generating complete battle page content
// @dev Handles battle page assembly with battle state display and themed styling
// @author Built for the Loot Survivor ecosystem

use death_mountain_renderer::models::models::AdventurerVerbose;

// Import UI components
use death_mountain_renderer::utils::renderer::core::text_utils::{
    generate_adventurer_name_text_with_page, generate_logo_with_page,
};
use death_mountain_renderer::utils::string::string_utils::felt252_to_string;

/// @notice Generate battle page content (Page 2 - Red theme)
/// @dev Creates battle page with adventurer info and battle state display
/// @param adventurer The adventurer data to render
/// @return Complete SVG content for battle page
pub fn generate_battle_page_content(adventurer: AdventurerVerbose) -> ByteArray {
    let mut content = "";

    // Add adventurer name with red theme (page 2 = battle)
    content += generate_adventurer_name_text_with_page(felt252_to_string(adventurer.name), 2);
    content += generate_logo_with_page(2);

    // Add page title
    content +=
        "<text x=\"339\" y=\"200\" fill=\"#FF6B6B\" class=\"s24\" text-anchor=\"left\">Current Battle</text>";
    content +=
        "<text x=\"540\" y=\"180\" fill=\"#FF6B6B\" class=\"s16\" text-anchor=\"left\">TROLL</text>";

    // Placeholder text for development
    content +=
        "<text x=\"400\" y=\"400\" fill=\"#FF6B6B\" class=\"s16\" text-anchor=\"middle\">TROLL AMBUSHED YOU FOR 10 DMG!</text>";

    content
}
