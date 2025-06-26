use ls2_renderer::renderer::{Renderer, render_with_image};

#[test]
fn test_basic_render() {
    let token_id: u256 = 42;
    let result = Renderer::render(token_id);
    
    // The result should contain JSON-like structure with token metadata
    assert(result.len() > 0, 'Result should not be empty');
    
    // Check if it contains expected content
    // Note: In a real test, you'd parse the JSON or check specific bytes
    println!("Rendered metadata: {}", result);
}

#[test]
fn test_render_with_image() {
    let token_id: u256 = 123;
    let base_uri: ByteArray = "https://example.com/images/";
    let result = render_with_image(token_id, base_uri);
    
    assert(result.len() > 0, 'Result should not be empty');
    println!("Rendered metadata with image: {}", result);
}

#[test]
fn test_large_token_id() {
    // Test with a large u256 value
    let token_id: u256 = u256 { low: 999999999999999999999999999999, high: 1 };
    let result = Renderer::render(token_id);
    
    assert(result.len() > 0, 'Result should not be empty');
    println!("Rendered metadata for large ID: {}", result);
}