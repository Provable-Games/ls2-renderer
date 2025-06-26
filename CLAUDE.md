# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Cairo/Starknet smart contract project for an ERC721 NFT with on-chain metadata rendering. The project uses OpenZeppelin components and includes a pure Cairo renderer for generating NFT metadata dynamically.

## Essential Commands

### Development
```bash
# Build the project
scarb build

# Run all tests
scarb test

# Run a specific test
snforge test test_name

# Format code
scarb fmt

# Check for compilation errors
scarb check

# Clean build artifacts
scarb clean
```

### Testing
Tests are located in `/tests/` and use Starknet Foundry (snforge). The test structure includes:
- Unit tests for the renderer in `tests/test_lib/test_renderer.cairo`
- Integration tests for the contract in `tests/test_lib/test_contract.cairo`

## Code Architecture

### Contract Structure
The project consists of two main components:

1. **Main Contract (`src/lib.cairo`)**
   - ERC721Upgradeable implementation using OpenZeppelin
   - Open minting (no access control)
   - Sequential token IDs starting from 1
   - Integrates with the renderer for dynamic metadata

2. **Renderer (`src/renderer.cairo`)**
   - Pure Cairo implementation for JSON metadata generation
   - `render()`: Basic metadata (name, description, attributes)
   - `render_with_image()`: Metadata with image URIs
   - Helper functions for JSON construction and number conversion

### Key Design Patterns
- **Component Architecture**: Uses OpenZeppelin's component system for upgradeable contracts
- **On-chain Metadata**: All NFT metadata is generated dynamically on-chain
- **Modular Design**: Renderer is separated from the main contract for reusability

## Development Notes

### Version Requirements
- Cairo edition: 2024_07
- Scarb: 2.10.1
- Starknet Foundry: 0.45.0
- snforge: 0.44.0

### Dependencies
- starknet 2.10.1
- openzeppelin_introspection 1.0.0
- openzeppelin_token 1.0.0

### Testing Approach
When adding new functionality:
1. Add unit tests to the appropriate test file
2. Use `assert_macros` for test assertions
3. Test edge cases (e.g., non-existent tokens, boundary values)
4. Ensure all tests pass before committing

### Common Patterns
- Use ByteArray for string manipulation
- Follow the existing JSON construction pattern in the renderer
- Maintain the modular separation between contract logic and rendering