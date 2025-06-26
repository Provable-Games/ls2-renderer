// Pure Cairo renderer library - no Starknet dependencies
use core::array::ArrayTrait;

// Trait for rendering token metadata
pub trait Renderer {
    fn render(token_id: u256) -> ByteArray;
}

// Implementation of the renderer
pub impl RendererImpl of Renderer {
    fn render(token_id: u256) -> ByteArray {
        // Create a simple JSON-like structure for the token metadata
        let mut result: ByteArray = Default::default();
        
        // Start JSON object
        result.append_byte('{');
        result.append_byte('"');
        
        // Add name field
        append_string(ref result, "name");
        result.append_byte('"');
        result.append_byte(':');
        result.append_byte('"');
        append_string(ref result, "Token #");
        append_u256(ref result, token_id);
        result.append_byte('"');
        result.append_byte(',');
        
        // Add description field
        result.append_byte('"');
        append_string(ref result, "description");
        result.append_byte('"');
        result.append_byte(':');
        result.append_byte('"');
        append_string(ref result, "A unique NFT with ID ");
        append_u256(ref result, token_id);
        result.append_byte('"');
        result.append_byte(',');
        
        // Add attributes
        result.append_byte('"');
        append_string(ref result, "attributes");
        result.append_byte('"');
        result.append_byte(':');
        result.append_byte('[');
        
        // Add token ID attribute
        result.append_byte('{');
        result.append_byte('"');
        append_string(ref result, "trait_type");
        result.append_byte('"');
        result.append_byte(':');
        result.append_byte('"');
        append_string(ref result, "Token ID");
        result.append_byte('"');
        result.append_byte(',');
        result.append_byte('"');
        append_string(ref result, "value");
        result.append_byte('"');
        result.append_byte(':');
        result.append_byte('"');
        append_u256(ref result, token_id);
        result.append_byte('"');
        result.append_byte('}');
        
        // Close attributes array
        result.append_byte(']');
        
        // Close JSON object
        result.append_byte('}');
        
        result
    }
}

// Helper function to append a string to ByteArray
fn append_string(ref result: ByteArray, s: ByteArray) {
    let len = s.len();
    let mut i = 0;
    loop {
        if i >= len {
            break;
        }
        result.append_byte(s[i]);
        i += 1;
    };
}

// Helper function to convert and append u256 to ByteArray
fn append_u256(ref result: ByteArray, value: u256) {
    // Convert u256 to string representation
    // We'll handle both high and low parts
    if value.high == 0 {
        // If high part is 0, just convert the low part
        append_u128(ref result, value.low);
    } else {
        // Need to handle full u256
        // This is a simplified version - for production, you'd want proper decimal conversion
        append_u128(ref result, value.high);
        append_string(ref result, "_");
        append_u128(ref result, value.low);
    }
}

// Helper function to convert and append u128 to ByteArray
fn append_u128(ref result: ByteArray, mut value: u128) {
    if value == 0 {
        result.append_byte('0');
        return;
    }
    
    // Convert number to string by extracting digits
    let mut digits: Array<u8> = ArrayTrait::new();
    
    loop {
        if value == 0 {
            break;
        }
        let digit = value % 10;
        digits.append(digit.try_into().unwrap() + '0');
        value = value / 10;
    };
    
    // Append digits in reverse order
    let mut i = digits.len();
    loop {
        if i == 0 {
            break;
        }
        i -= 1;
        result.append_byte(*digits[i]);
    };
}

// Additional rendering functions for more complex metadata
pub fn render_with_image(token_id: u256, image_base_uri: ByteArray) -> ByteArray {
    let mut result: ByteArray = Default::default();
    
    // Start JSON object
    result.append_byte('{');
    
    // Add standard fields
    result.append_byte('"');
    append_string(ref result, "name");
    result.append_byte('"');
    result.append_byte(':');
    result.append_byte('"');
    append_string(ref result, "Token #");
    append_u256(ref result, token_id);
    result.append_byte('"');
    result.append_byte(',');
    
    // Add image field
    result.append_byte('"');
    append_string(ref result, "image");
    result.append_byte('"');
    result.append_byte(':');
    result.append_byte('"');
    append_string(ref result, image_base_uri);
    append_u256(ref result, token_id);
    append_string(ref result, ".png");
    result.append_byte('"');
    
    // Close JSON object
    result.append_byte('}');
    
    result
}