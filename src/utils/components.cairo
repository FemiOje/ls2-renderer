// Components module - showcases the modular SVG component system
use ls2_renderer::utils::renderer_utils::{
    SVGPosition, SVGSize, create_health_bar_component, create_inventory_slot_component,
    create_logo_component, create_stat_component, create_text_component, create_xp_badge_component,
    get_bag_theme, get_battle_theme, get_default_theme, get_marketplace_theme,
};

// Example usage of modular components
pub fn showcase_components() -> ByteArray {
    let theme = get_default_theme();
    let mut svg_content: ByteArray = "";

    // Logo component
    let logo_pos = SVGPosition { x: 50, y: 50 };
    svg_content += create_logo_component(logo_pos, 2, @theme);

    // Text component
    let text_pos = SVGPosition { x: 150, y: 70 };
    svg_content +=
        create_text_component("Modular Components", text_pos, 16, @theme, "start", "text-top");

    // Stat component
    let stat_pos = SVGPosition { x: 50, y: 100 };
    svg_content += create_stat_component("STR", "25", stat_pos, @theme);

    // Health bar component
    let health_pos = SVGPosition { x: 50, y: 150 };
    let health_size = SVGSize { width: 200, height: 10 };
    svg_content += create_health_bar_component(75, 100, health_pos, health_size, @theme);

    // Inventory slot component
    let slot_pos = SVGPosition { x: 50, y: 200 };
    svg_content += create_inventory_slot_component(1, "G5 Katana", slot_pos, @theme);

    // XP badge component
    let xp_pos = SVGPosition { x: 300, y: 50 };
    svg_content += create_xp_badge_component("1500", xp_pos);

    svg_content
}

// Example of using different themes
pub fn showcase_themes() -> ByteArray {
    let mut svg_content: ByteArray = "";

    // Default theme
    let default_theme = get_default_theme();
    let pos1 = SVGPosition { x: 50, y: 50 };
    svg_content +=
        create_text_component("Default Theme", pos1, 14, @default_theme, "start", "text-top");

    // Bag theme
    let bag_theme = get_bag_theme();
    let pos2 = SVGPosition { x: 50, y: 100 };
    svg_content += create_text_component("Bag Theme", pos2, 14, @bag_theme, "start", "text-top");

    // Marketplace theme
    let marketplace_theme = get_marketplace_theme();
    let pos3 = SVGPosition { x: 50, y: 150 };
    svg_content +=
        create_text_component(
            "Marketplace Theme", pos3, 14, @marketplace_theme, "start", "text-top",
        );

    // Battle theme
    let battle_theme = get_battle_theme();
    let pos4 = SVGPosition { x: 50, y: 200 };
    svg_content +=
        create_text_component("Battle Theme", pos4, 14, @battle_theme, "start", "text-top");

    svg_content
}
