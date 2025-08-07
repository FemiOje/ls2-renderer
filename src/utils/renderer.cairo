// SPDX-License-Identifier: MIT
//
// @title SVG Renderer for LS2 Battle Interface NFTs
// @notice Core rendering system that generates dynamic SVG-based battle interface metadata
// @dev Integrates with mock adventurer contracts to fetch data and create on-chain NFT metadata

use death_mountain_renderer::models::models::AdventurerVerbose;
use death_mountain_renderer::utils::encoding::bytes_base64_encode;
use death_mountain_renderer::utils::renderer_utils::{generate_svg, u256_to_string};

/// @title Renderer Trait - Core rendering interface for battle interface NFTs
/// @notice Defines the contract for rendering dynamic NFT metadata
/// @dev Implementations should generate complete Base64-encoded JSON metadata with embedded SVG
pub trait Renderer {
    /// @notice Renders dynamic battle interface metadata for a given token
    /// @param token_id The NFT token ID to render metadata for
    /// @param adventurer_verbose Pre-fetched adventurer data with resolved item names
    /// @return Base64-encoded JSON metadata string containing SVG battle interface
    fn render(
        token_id: u256, adventurer_verbose: AdventurerVerbose,
    ) -> (ByteArray, ByteArray, ByteArray);
}

/// @notice Default implementation of the Renderer trait
/// @dev Fetches adventurer data from mock contract and generates SVG battle interface
pub impl RendererImpl of Renderer {
    /// @notice Renders dynamic battle interface metadata for a given token
    /// @dev Orchestrates data fetching and SVG generation for complete NFT metadata
    /// @param token_id The NFT token ID (converted to adventurer_id for data lookup)
    /// @param adventurer_verbose Pre-fetched adventurer data with resolved item names
    /// @return Complete Base64-encoded JSON metadata with embedded SVG
    fn render(
        token_id: u256, adventurer_verbose: AdventurerVerbose,
    ) -> (ByteArray, ByteArray, ByteArray) {
        let description: ByteArray =
            "Loot Survivor is a verifiably random, procedurally generated dungeon crawler. Explore the endless dungeons in pursuit of mythical loot while fighting for your life against vicious beasts and treacherous obstacles.";

        // Generate SVG with dynamic stats and equipment
        let svg = generate_svg(adventurer_verbose);

        // Encode SVG to base64
        let svg_base64 = bytes_base64_encode(svg);

        // Create JSON metadata
        let mut json = "{\"name\":\"Adventurer #";
        json += u256_to_string(token_id);
        json +=
            "\",\"description\":\"Loot Survivor is a verifiably random, procedurally generated dungeon crawler. Explore the endless dungeons in pursuit of mythical loot while fighting for your life against vicious beasts and treacherous obstacles.\",\"image\":\"data:image/svg+xml;base64,";
        json += svg_base64.clone();
        json += "\"}";

        let mut image = "data:image/svg+xml;base64,";
        image += svg_base64.clone();

        // Encode JSON to base64 and return as data URI
        let json_base64 = bytes_base64_encode(json.clone());
        let mut result: ByteArray = "data:application/json;base64,";
        result += json_base64;

        (description, image, result)
    }
}
