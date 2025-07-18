// SPDX-License-Identifier: MIT
// Simple SVG Renderer for ls2-renderer
use ls2_renderer::utils::renderer_utils::create_simple_svg_metadata;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(token_id: u256) -> ByteArray;
}

pub impl RendererImpl of Renderer {
    fn render(token_id: u256) -> ByteArray {
        create_simple_svg_metadata(token_id)
    }
}
