use ls2_renderer::utils::encoding::{bytes_base64_encode, U256BytesUsedTraitImpl};

// Convert u256 to string for display
fn u256_to_string(value: u256) -> ByteArray {
    if value == 0 {
        return "0";
    }
    
    let mut result = "";
    let mut val = value;
    let mut digits: Array<u8> = array![];
    
    while val > 0 {
        let digit = (val % 10).try_into().unwrap();
        digits.append(digit + 48); // Convert to ASCII
        val = val / 10;
    };
    
    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    };
    
    result
}

// Generate simple SVG for token
fn generate_svg(token_id: u256) -> ByteArray {
    let mut svg = "<svg width=\"500\" height=\"500\" xmlns=\"http://www.w3.org/2000/svg\">";
    svg += "<rect width=\"100%\" height=\"100%\" fill=\"black\"/>";
    svg += "<text x=\"50%\" y=\"50%\" text-anchor=\"middle\" dominant-baseline=\"middle\" fill=\"white\" font-size=\"24\" font-family=\"Arial, sans-serif\">";
    svg += "LS2 NFT #";
    svg += u256_to_string(token_id);
    svg += "</text>";
    svg += "</svg>";
    svg
}

// Create JSON metadata with proper base64 encoding
pub fn create_simple_svg_metadata(token_id: u256) -> ByteArray {
    // Generate SVG
    let svg = generate_svg(token_id);
    
    // Encode SVG to base64
    let svg_base64 = bytes_base64_encode(svg);
    
    // Create JSON metadata
    let mut json = "{\"name\":\"LS2 NFT #";
    json += u256_to_string(token_id);
    json += "\",\"description\":\"Loot Survivor 2.0 NFT\",\"image\":\"data:image/svg+xml;base64,";
    json += svg_base64;
    json += "\"}";
    
    // Encode JSON to base64 and return as data URI
    let json_base64 = bytes_base64_encode(json);
    let mut result = "data:application/json;base64,";
    result += json_base64;
    result
}