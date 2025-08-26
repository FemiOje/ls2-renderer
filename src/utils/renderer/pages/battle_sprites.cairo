// SPDX-License-Identifier: MIT
//
// @title Battle Sprite Components
// @notice Reusable character sprite components for battle interface
// @dev Provides modular sprite generation for troll and player characters
// @author Built for the Loot Survivor ecosystem

/// @notice Generate troll sprite component
/// @dev Creates pixelated troll sprite for battle interface
/// @param x X position for the sprite
/// @param y Y position for the sprite
/// @return SVG content for troll sprite
pub fn generate_troll_sprite(x: u32, y: u32) -> ByteArray {
    let mut sprite = "";
    
    // Troll sprite container
    sprite += "<g transform=\"translate(";
    sprite += format!("{}", x);
    sprite += ",";
    sprite += format!("{}", y);
    sprite += ")\">";
    
    // Troll sprite - simplified pixelated design
    // Main body (red/pink theme)
    sprite += "<rect x=\"0\" y=\"20\" width=\"40\" height=\"60\" fill=\"#8B4513\" rx=\"4\"/>";
    
    // Head
    sprite += "<rect x=\"5\" y=\"0\" width=\"30\" height=\"25\" fill=\"#8B4513\" rx=\"6\"/>";
    
    // Eyes
    sprite += "<rect x=\"10\" y=\"8\" width=\"4\" height=\"4\" fill=\"#FF0000\"/>";
    sprite += "<rect x=\"26\" y=\"8\" width=\"4\" height=\"4\" fill=\"#FF0000\"/>";
    
    // Mouth/teeth
    sprite += "<rect x=\"15\" y=\"16\" width=\"10\" height=\"3\" fill=\"#000\"/>";
    sprite += "<rect x=\"17\" y=\"14\" width=\"2\" height=\"4\" fill=\"#FFF\"/>";
    sprite += "<rect x=\"21\" y=\"14\" width=\"2\" height=\"4\" fill=\"#FFF\"/>";
    
    // Arms
    sprite += "<rect x=\"-8\" y=\"30\" width=\"16\" height=\"8\" fill=\"#8B4513\" rx=\"4\"/>";
    sprite += "<rect x=\"32\" y=\"30\" width=\"16\" height=\"8\" fill=\"#8B4513\" rx=\"4\"/>";
    
    // Legs  
    sprite += "<rect x=\"8\" y=\"75\" width=\"8\" height=\"20\" fill=\"#654321\" rx=\"4\"/>";
    sprite += "<rect x=\"24\" y=\"75\" width=\"8\" height=\"20\" fill=\"#654321\" rx=\"4\"/>";
    
    // Weapon (club)
    sprite += "<rect x=\"45\" y=\"15\" width=\"4\" height=\"25\" fill=\"#8B4513\"/>";
    sprite += "<rect x=\"43\" y=\"15\" width=\"8\" height=\"8\" fill=\"#654321\" rx=\"2\"/>";
    
    sprite += "</g>";
    
    sprite
}

/// @notice Generate player sprite component
/// @dev Creates adventurer sprite for battle interface based on equipment
/// @param x X position for the sprite
/// @param y Y position for the sprite
/// @param has_weapon Whether player has a weapon equipped
/// @return SVG content for player sprite
pub fn generate_player_sprite(x: u32, y: u32, has_weapon: bool) -> ByteArray {
    let mut sprite = "";
    
    // Player sprite container
    sprite += "<g transform=\"translate(";
    sprite += format!("{}", x);
    sprite += ",";
    sprite += format!("{}", y);
    sprite += ")\">";
    
    // Player sprite - adventurer design (green theme)
    // Main body
    sprite += "<rect x=\"0\" y=\"20\" width=\"40\" height=\"60\" fill=\"#228B22\" rx=\"4\"/>";
    
    // Head
    sprite += "<rect x=\"5\" y=\"0\" width=\"30\" height=\"25\" fill=\"#FDBCB4\" rx=\"6\"/>";
    
    // Eyes
    sprite += "<rect x=\"12\" y=\"8\" width=\"3\" height=\"3\" fill=\"#000\"/>";
    sprite += "<rect x=\"25\" y=\"8\" width=\"3\" height=\"3\" fill=\"#000\"/>";
    
    // Hair
    sprite += "<rect x=\"5\" y=\"0\" width=\"30\" height=\"8\" fill=\"#8B4513\" rx=\"6\"/>";
    
    // Arms
    sprite += "<rect x=\"-6\" y=\"30\" width=\"14\" height=\"8\" fill=\"#FDBCB4\" rx=\"4\"/>";
    sprite += "<rect x=\"32\" y=\"30\" width=\"14\" height=\"8\" fill=\"#FDBCB4\" rx=\"4\"/>";
    
    // Legs
    sprite += "<rect x=\"8\" y=\"75\" width=\"8\" height=\"20\" fill=\"#4169E1\" rx=\"4\"/>";
    sprite += "<rect x=\"24\" y=\"75\" width=\"8\" height=\"20\" fill=\"#4169E1\" rx=\"4\"/>";
    
    // Equipment - weapon if equipped
    if has_weapon {
        sprite += "<rect x=\"-12\" y=\"20\" width=\"6\" height=\"35\" fill=\"#C0C0C0\"/>";
        sprite += "<rect x=\"-14\" y=\"20\" width=\"10\" height=\"6\" fill=\"#FFD700\" rx=\"2\"/>";
    }
    
    // Shield
    sprite += "<rect x=\"42\" y=\"25\" width=\"8\" height=\"15\" fill=\"#8B4513\" rx=\"4\"/>";
    sprite += "<rect x=\"44\" y=\"27\" width=\"4\" height=\"11\" fill=\"#B8860B\" rx=\"2\"/>";
    
    sprite += "</g>";
    
    sprite
}

/// @notice Generate character equipment icons
/// @dev Creates small icons for displaying character equipment
/// @param x X position for the icon
/// @param y Y position for the icon  
/// @param equipment_type Type of equipment (weapon, armor, etc.)
/// @param color Color theme for the icon
/// @return SVG content for equipment icon
pub fn generate_equipment_icon(x: u32, y: u32, equipment_type: ByteArray, color: ByteArray) -> ByteArray {
    let mut icon = "";
    
    icon += "<g transform=\"translate(";
    icon += format!("{}", x);
    icon += ",";
    icon += format!("{}", y);
    icon += ")\">";
    
    // Base icon background
    icon += "<rect x=\"0\" y=\"0\" width=\"16\" height=\"16\" fill=\"";
    icon += color.clone();
    icon += "\" rx=\"2\" stroke=\"#000\" stroke-width=\"1\"/>";
    
    // Icon content based on equipment type
    if equipment_type == "weapon" {
        // Sword icon
        icon += "<rect x=\"7\" y=\"2\" width=\"2\" height=\"10\" fill=\"#C0C0C0\"/>";
        icon += "<rect x=\"5\" y=\"12\" width=\"6\" height=\"2\" fill=\"#8B4513\"/>";
    } else if equipment_type == "armor" {
        // Chest armor icon
        icon += "<rect x=\"4\" y=\"3\" width=\"8\" height=\"10\" fill=\"#654321\" rx=\"1\"/>";
        icon += "<rect x=\"6\" y=\"5\" width=\"4\" height=\"6\" fill=\"#8B4513\"/>";
    } else if equipment_type == "helmet" {
        // Helmet icon
        icon += "<rect x=\"3\" y=\"3\" width=\"10\" height=\"8\" fill=\"#696969\" rx=\"2\"/>";
        icon += "<rect x=\"5\" y=\"5\" width=\"6\" height=\"4\" fill=\"#000\"/>";
    } else {
        // Generic equipment icon
        icon += "<rect x=\"4\" y=\"4\" width=\"8\" height=\"8\" fill=\"#444\" rx=\"1\"/>";
    }
    
    icon += "</g>";
    
    icon
}

/// @notice Generate stat display component
/// @dev Creates formatted stat display with label and value
/// @param x X position for stat display
/// @param y Y position for stat display
/// @param label Stat label (e.g., "STR", "DEX")
/// @param value Stat value to display
/// @param color Color theme for the text
/// @return SVG content for stat display
pub fn generate_stat_display(x: u32, y: u32, label: ByteArray, value: u64, color: ByteArray) -> ByteArray {
    let mut stat = "";
    
    // Stat label
    stat += "<text x=\"";
    stat += format!("{}", x);
    stat += "\" y=\"";
    stat += format!("{}", y);
    stat += "\" fill=\"";
    stat += color.clone();
    stat += "\" class=\"s10\" text-anchor=\"middle\">";
    stat += label;
    stat += "</text>";
    
    // Stat value
    stat += "<text x=\"";
    stat += format!("{}", x);
    stat += "\" y=\"";
    stat += format!("{}", y + 16);
    stat += "\" fill=\"";
    stat += color;
    stat += "\" class=\"s16\" text-anchor=\"middle\">";
    stat += format!("{}", value);
    stat += "</text>";
    
    stat
}