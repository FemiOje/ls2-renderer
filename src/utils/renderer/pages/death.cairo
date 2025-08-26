// SPDX-License-Identifier: MIT
//
// @title Death Page Generator
// @notice Functions for generating the death page content with grey theme
// @dev Creates a grey-themed page similar to inventory but without equipment section
// @author Built for the Loot Survivor ecosystem

use death_mountain_renderer::models::models::AdventurerVerbose;

// Import UI components
use death_mountain_renderer::utils::renderer::components::ui_components::{
    generate_gold_display_with_page, generate_health_bar_with_page,
    generate_level_display_with_page, generate_stats_text_with_page,
};
use death_mountain_renderer::utils::renderer::core::text_utils::{
    generate_adventurer_name_text_with_page, generate_logo_with_page,
};
use death_mountain_renderer::utils::string::string_utils::felt252_to_string;

/// @notice Generate death page content (Page 3 - Grey theme)
/// @dev Creates complete death page with stats, but no equipment section
/// @param adventurer The adventurer data to render (should have health == 0)
/// @return Complete SVG content for death page with grey theme
pub fn generate_death_page_content(adventurer: AdventurerVerbose) -> ByteArray {
    let mut content = "";

    // Use page 3 for grey theme
    content += generate_stats_text_with_page(adventurer.stats, 3);
    content += generate_adventurer_name_text_with_page(felt252_to_string(adventurer.name), 3);
    content += generate_logo_with_page(3);
    content += generate_gold_display_with_page(adventurer.gold, 3);
    content += generate_level_display_with_page(adventurer.level, 3);
    content += generate_health_bar_with_page(adventurer.stats, adventurer.health, 3);
    content += generate_death_header();

    // Note: Equipment section is omitted for death page

    content
}

/// @notice Generate death section header with grey theme styling
/// @dev Creates styled "DEATH" text header with grey theme color
/// @return SVG text element for death section header
pub fn generate_death_header() -> ByteArray {
    let mut death_header = "";
    death_header += "<text x=\"286\" y=\"325\" fill=\"#888888\" class=\"s16\">";
    death_header += "DEATH";
    death_header += "</text>";
    death_header
}
