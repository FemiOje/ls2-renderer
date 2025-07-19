// SPDX-License-Identifier: MIT
// Simple SVG Renderer for ls2-renderer
use ls2_renderer::utils::renderer_utils::create_simple_svg_metadata;
use ls2_renderer::mocks::mock_adventurer::{IMockAdventurerDispatcher, IMockAdventurerDispatcherTrait};
use starknet::ContractAddress;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(token_id: u256) -> ByteArray;
    fn render_with_adventurer(token_id: u256, adventurer_contract: ContractAddress) -> ByteArray;
}

pub impl RendererImpl of Renderer {
    fn render(token_id: u256) -> ByteArray {
        // For simple rendering without dynamic data, use default values
        create_simple_svg_metadata(token_id, 250_u16, 18_u8)
    }

    fn render_with_adventurer(token_id: u256, adventurer_contract: ContractAddress) -> ByteArray {
        // Get adventurer data from the mock contract
        let adventurer_dispatcher = IMockAdventurerDispatcher { contract_address: adventurer_contract };
        let adventurer_id: u64 = token_id.try_into().unwrap();
        let adventurer = adventurer_dispatcher.get_adventurer(adventurer_id);
        
        // Calculate level from XP using the mock contract's level calculation
        let level = adventurer_dispatcher.get_level(adventurer.xp);
        
        // Use the dynamic gold and level values from adventurer data
        create_simple_svg_metadata(token_id, adventurer.gold, level)
    }
}
