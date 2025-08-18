use death_mountain_renderer::models::models::AdventurerVerbose;
use death_mountain_renderer::utils::encoding::encoding::bytes_base64_encode;
use death_mountain_renderer::utils::renderer::renderer::Renderer;
use death_mountain_renderer::utils::renderer::renderer_utils::{
    generate_svg_with_page, u64_to_string, u8_to_string,
};

/// @title PageRenderer Trait - Paginated rendering interface for multipage NFTs
/// @notice Extends rendering capabilities to support multiple pages with transitions
/// @dev Enables creation of multipage NFT experiences with sequential page navigation
pub trait PageRenderer {
    /// @notice Renders specific page metadata for a given token
    /// @param token_id The NFT token ID to render metadata for
    /// @param adventurer_verbose Pre-fetched adventurer data with resolved item names
    /// @param page The page number to render (0-indexed)
    /// @return Base64-encoded JSON metadata string containing SVG for specified page
    fn render_page(token_id: u64, adventurer_verbose: AdventurerVerbose, page: u8) -> ByteArray;
    /// @notice Gets total number of pages available for an adventurer
    /// @param adventurer_verbose Pre-fetched adventurer data with resolved item names
    /// @return Total number of pages available
    fn get_page_count(adventurer_verbose: AdventurerVerbose) -> u8;
    /// @notice Gets SVG image data for a specific page
    /// @param adventurer_verbose Pre-fetched adventurer data with resolved item names
    /// @param page The page number to render (0-indexed)
    /// @return Base64-encoded SVG image data URI
    fn get_page_image(adventurer_verbose: AdventurerVerbose, page: u8) -> ByteArray;
}

/// @notice Implementation of the PageRenderer trait for multipage NFT support
/// @dev Extends base rendering with pagination capabilities
pub impl PageRendererImpl of PageRenderer {
    fn render_page(token_id: u64, adventurer_verbose: AdventurerVerbose, page: u8) -> ByteArray {
        // Get page count first to avoid move issues
        let page_count = Self::get_page_count(adventurer_verbose.clone());

        // Generate SVG for specific page
        let svg = generate_svg_with_page(adventurer_verbose, page);
        let svg_base64 = bytes_base64_encode(svg);

        // Create JSON metadata with pagination info
        let mut json = "{\"name\":\"Adventurer #";
        json += u64_to_string(token_id);
        json += " - Page ";
        json += u8_to_string(page + 1);
        json += "\",\"description\":\"";
        json += Renderer::get_description();
        json += "\",\"image\":\"data:image/svg+xml;base64,";
        json += svg_base64;
        json += "\",\"pages\":{\"current\":";
        json += u8_to_string(page);
        json += ",\"total\":";
        json += u8_to_string(page_count);
        json += "}}";

        // Encode JSON to base64 and return as data URI
        let json_base64 = bytes_base64_encode(json);
        let mut result: ByteArray = "data:application/json;base64,";
        result += json_base64;

        result
    }

    fn get_page_count(adventurer_verbose: AdventurerVerbose) -> u8 {
        2 // Currently support 2 pages: battle interface (0) and empty page (1)
    }

    fn get_page_image(adventurer_verbose: AdventurerVerbose, page: u8) -> ByteArray {
        // Generate SVG for specific page
        let svg = generate_svg_with_page(adventurer_verbose, page);
        let svg_base64 = bytes_base64_encode(svg);

        let image = "data:image/svg+xml;base64," + svg_base64;
        image
    }
}
