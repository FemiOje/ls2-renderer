// SPDX-License-Identifier: MIT
//
// @title Page Content Generators
// @notice Functions for generating complete page content and layouts
// @dev Handles page routing, content generation, and page wrapper functionality
// @author Built for the Loot Survivor ecosystem

use death_mountain_renderer::models::models::{AdventurerVerbose};
use death_mountain_renderer::utils::string::string_utils::{felt252_to_string};

// Import UI components
use death_mountain_renderer::utils::renderer::components::ui_components::{
    generate_stats_text_with_page,
    generate_gold_display_with_page,
    generate_health_bar_with_page,
    generate_level_display_with_page,
};
use death_mountain_renderer::utils::renderer::core::text_utils::{
    generate_adventurer_name_text_with_page,
    generate_logo_with_page,
};

// Import equipment rendering functions
use death_mountain_renderer::utils::renderer::equipment::{
    slots::generate_equipment_slots,
    positioning::generate_equipment_icons,
    badges::generate_equipment_level_badges,
    names::generate_equipment_names,
};

// Import bag rendering functions
use death_mountain_renderer::utils::renderer::bag::bag_renderer::{
    generate_bag_header, generate_bag_item_slots, generate_bag_item_icons,
    generate_bag_item_level_badges, generate_bag_item_names,
};

// Import header functions
use death_mountain_renderer::utils::renderer::renderer_utils::{
    generate_inventory_header,
};

/// @notice Main page router - generates content based on page number
/// @dev Routes to appropriate page content generator based on page parameter
/// @param adventurer The adventurer data to render
/// @param page The page number (0=inventory, 1=bag, 2=battle)
/// @return Complete page content for the specified page
pub fn generate_page_content(adventurer: AdventurerVerbose, page: u8) -> ByteArray {
    match page {
        0 => generate_inventory_page_content(adventurer),
        1 => generate_item_bag_page_content(adventurer),
        2 => generate_battle_page_content(adventurer),
        _ => generate_inventory_page_content(adventurer) // Default to inventory page
    }
}

/// @notice Generate inventory page content (Page 0 - Green theme)
/// @dev Creates complete inventory page with stats, equipment slots, icons, badges, and names
/// @param adventurer The adventurer data to render
/// @return Complete SVG content for inventory page
pub fn generate_inventory_page_content(adventurer: AdventurerVerbose) -> ByteArray {
    let mut content = "";

    content += generate_stats_text_with_page(adventurer.stats, 0);
    content += generate_adventurer_name_text_with_page(felt252_to_string(adventurer.name), 0);
    content += generate_logo_with_page(0);
    content += generate_gold_display_with_page(adventurer.gold, 0);
    content += generate_level_display_with_page(adventurer.level, 0);
    content += generate_health_bar_with_page(adventurer.stats, adventurer.health, 0);
    content += generate_inventory_header();
    content += generate_equipment_slots();
    content += generate_equipment_icons();
    content += generate_equipment_level_badges(adventurer.equipment);
    content += generate_equipment_names(adventurer.equipment);

    content
}

/// @notice Generate item bag page content (Page 1 - Orange theme)
/// @dev Creates complete bag page with bag items, slots, icons, badges, and names
/// @param adventurer The adventurer data to render
/// @return Complete SVG content for bag page
pub fn generate_item_bag_page_content(adventurer: AdventurerVerbose) -> ByteArray {
    let mut content = "";

    // Copy inventory layout elements but without stats section
    content += generate_adventurer_name_text_with_page(felt252_to_string(adventurer.name), 1);
    content += generate_logo_with_page(1);
    content += generate_gold_display_with_page(adventurer.gold, 1);
    content += generate_level_display_with_page(adventurer.level, 1);
    content += generate_health_bar_with_page(adventurer.stats, adventurer.health, 1);
    content += generate_bag_header();
    content += generate_bag_item_slots();
    content += generate_bag_item_icons(adventurer.bag);
    content += generate_bag_item_level_badges(adventurer.bag);
    content += generate_bag_item_names(adventurer.bag);

    content
}

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

/// @notice Generate page wrapper with animation class and background
/// @dev Wraps page content with animation classes and background for smooth transitions
/// @param page_content The page content to wrap
/// @param border_content The border content to include
/// @return Complete wrapped page with animation support
pub fn generate_page_wrapper(page_content: ByteArray, border_content: ByteArray) -> ByteArray {
    let mut wrapper = "";
    wrapper += "<g class=\"page\" clip-path=\"url(#b)\">";
    wrapper += "<rect width=\"567\" height=\"862\" x=\"147.2\" y=\"27\" fill=\"#000\" rx=\"10\"/>";
    wrapper += page_content;
    wrapper += border_content;
    wrapper += "</g>";
    wrapper
}