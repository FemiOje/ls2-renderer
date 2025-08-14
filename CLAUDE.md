# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Testing
- `scarb test` - Run all tests using Starknet Foundry (snforge)
- `snforge test` - Alternative command for running tests
- `snforge test --coverage` - Run tests with coverage reporting

### Building
- `scarb build` - Build the Cairo contracts
- `scarb fmt` - Format Cairo code

### Development
- Tests are located in `src/tests/` directory
- Coverage reports are generated in the `coverage/` directory
- Test traces are saved in `snfoundry_trace/` for debugging

## Architecture

This is a **Death Mountain Renderer** system for generating dynamic SVG-based NFT metadata for Loot Survivor adventurers. The project is built in Cairo for StarkNet deployment.

### Core Components

**Main Contract (`src/contracts/death_mountain_renderer.cairo`)**
- Renderer contract that interfaces with Death Mountain Systems
- Implements `IMinigameDetails`, `IMinigameDetailsSVG`, and `IRenderer` traits
- Takes a Death Mountain address in constructor to fetch adventurer data
- Entry points: `game_details()`, `token_description()`, `game_details_svg()`

**Rendering Engine (`src/utils/renderer.cairo`)**
- Core `Renderer` trait with render logic
- Generates Base64-encoded JSON metadata containing SVG images
- Functions: `render()`, `get_traits()`, `get_description()`, `get_image()`

**SVG Generation (`src/utils/renderer_utils.cairo`)**
- Contains `generate_svg()` function for creating dynamic battle interface SVGs
- Handles adventurer stats, equipment icons, health bars, level display
- Responsive font sizing based on name length
- Health bar color coding (green/yellow/red based on health percentage)

**Base64 Encoding (`src/utils/encoding.cairo`)**
- Gas-optimized Base64 encoding for SVG and JSON data URIs
- Functions: `bytes_base64_encode()`, `get_base64_char_set()`

**Data Models (`src/models/models.cairo`)**
- `AdventurerVerbose` - Main data structure with resolved item names
- `EquipmentVerbose`, `BagVerbose`, `ItemVerbose` - Equipment and inventory
- `Stats`, `GameDetail` - Character statistics and metadata
- `StatsTrait` - Helper for health calculations (100 base + 15 per vitality)

**Mock System (`src/mocks/mock_adventurer.cairo`)**
- Mock adventurer data for testing
- Creates various test scenarios (different stats, equipment, names)

### Key Interfaces

- `IDeathMountainSystems` - External interface to fetch adventurer data
- `IMinigameDetails` - Returns trait data and descriptions  
- `IMinigameDetailsSVG` - Returns SVG image data
- `IRenderer` - Main renderer contract interface

### Testing Strategy

Tests are extensive and cover:
- Base64 encoding edge cases and performance
- SVG generation with various adventurer configurations
- Mock adventurer data generation and consistency
- Boundary conditions (max stats, empty names, zero health)
- Gas optimization tests for rendering operations

### Configuration

- Cairo edition: 2024_07
- StarkNet version: 2.11.4
- OpenZeppelin contracts for token standards
- Fork testing configured for Sepolia testnet
- Max steps increased to 500M for complex rendering tests