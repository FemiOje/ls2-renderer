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
use death_mountain_renderer::utils::renderer::components::icons::grave_icon;
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
    content += generate_grave_icon_positioned();

    // Note: Equipment section is omitted for death page

    content
}


/// @notice Generate positioned grave icon for death page
/// @dev Creates grave icon centered and enlarged to fill available space
/// @return SVG group element containing the positioned grave icon
pub fn generate_grave_icon_positioned() -> ByteArray {
    let mut positioned_icon = "";
    
    // Center the grave icon and scale it to 3.5x size to fill the available space
    // Positioned at (295, 400) to center within the content area, scaled 3.5x
    positioned_icon += "<g transform=\"translate(295, 400) scale(3.5)\" viewBox=\"0 0 80 100\">";
    positioned_icon += grave_icon();
    positioned_icon += "</g>";
    
    positioned_icon
}
