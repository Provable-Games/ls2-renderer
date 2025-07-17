# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Cairo/Starknet smart contract project for an ERC721 NFT with on-chain metadata rendering. The project generates battle interface metadata for the Loot Survivor game, featuring dynamic adventurer and beast data visualization.

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
- Battle interface tests in `tests/test_lib/test_battle_interface.cairo`

## Code Architecture

### Project Structure
The project is organized into the following modules:

1. **Main Contract (`src/nfts/ls2_nft.cairo`)**
   - ERC721 implementation using OpenZeppelin components
   - Open minting with sequential token IDs starting from 1
   - Integrates with mock contracts for adventurer and beast data
   - Implements dynamic metadata generation via the renderer

2. **Renderer System (`src/utils/`)**
   - `renderer.cairo`: Core rendering logic with `Renderer` trait
   - `renderer_utils.cairo`: Utility functions for metadata creation
   - `encoding.cairo`: Helper functions for data encoding

3. **Mock Contracts (`src/mocks/`)**
   - `mock_adventurer.cairo`: Mock adventurer data for testing
   - `mock_beast.cairo`: Mock beast data for battle scenarios

4. **Library Entry (`src/lib.cairo`)**
   - Module declarations and organization

### Key Components

#### NFT Contract (`src/nfts/ls2_nft.cairo`)
- Uses OpenZeppelin's ERC721Component and SRC5Component
- Stores mock contract addresses for adventurer and beast data
- Implements `IOpenMint` for public minting
- Overrides `token_uri()` to return dynamically generated battle metadata

#### Renderer (`src/utils/renderer.cairo`)
- `Renderer` trait with `render()` function
- Fetches adventurer and beast data from mock contracts
- Generates battle interface metadata including:
  - Adventurer stats, equipment, and bag items
  - Beast information for battle scenarios
  - Dynamic naming system

#### Mock Data System
- Provides test data for adventurers and beasts
- Supports dynamic name generation
- Enables battle scenario simulation

### Key Design Patterns
- **Component Architecture**: Uses OpenZeppelin's component system
- **On-chain Metadata**: All NFT metadata is generated dynamically on-chain
- **Modular Design**: Clear separation between contract logic, rendering, and mock data
- **Battle Interface**: Structured metadata for game interface rendering

## Development Notes

### Version Requirements
- Cairo edition: 2024_07
- Scarb: 2.10.1
- Starknet Foundry: 0.45.0
- snforge: 0.45.0

### Dependencies
- starknet 2.10.1
- openzeppelin_introspection 1.0.0
- openzeppelin_token 1.0.0
- openzeppelin_access 1.0.0

### Dev Dependencies
- snforge_std 0.45.0
- assert_macros 2.10.1

### Testing Approach
When adding new functionality:
1. Add unit tests to the appropriate test file in `tests/test_lib/`
2. Use `assert_macros` for test assertions
3. Test edge cases (e.g., non-existent tokens, boundary values)
4. Test mock contract interactions
5. Ensure all tests pass before committing

### Common Patterns
- Use ByteArray for string manipulation
- Follow the existing JSON construction pattern in renderer_utils
- Maintain the modular separation between contract logic and rendering
- Use dispatcher pattern for mock contract interactions
- Convert u256 token IDs to u64 for mock data compatibility

## MCP Server Instructions

### Task Completion Requirements
Please be sure to update tests to account for all changes. Each task is complete when `scarb build && scarb test` run without warnings or errors.

### Documentation and Approach
- Please use Context7 MCP Server to fetch latest documentation on Cairo, Starknet, and Starknet Foundry
- Use sequential thinking to approach all tasks iteratively
- Stay up-to-date with the latest best practices and API changes