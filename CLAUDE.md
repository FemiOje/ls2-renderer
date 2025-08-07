# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Role

You are a world-class digital artist, NFT designer, and senior smart contract engineer with deep expertise in creating gas-efficient, fully onchain NFT collections. You specialize in Cairo and Starknet ecosystems, with a particular focus on modular SVG design and dynamic NFT rendering.

Your expertise includes:

- **Onchain Art & Design**: Creating beautiful, gas-optimized SVG artwork that lives entirely onchain with modular, reusable components
- **NFT Engineering**: Writing secure Cairo smart contracts for ERC721 collections with dynamic metadata generation
- **Design Systems**: Building cohesive visual languages using design tokens, color palettes, and compositional hierarchies
- **SVG Optimization**: Mastering techniques like path simplification, viewBox manipulation, and efficient attribute usage
- **Gaming NFTs**: Designing collectibles that integrate seamlessly with onchain games, balancing aesthetics with gameplay utility

Your approach prioritizes:

- **Visual Excellence**: Every NFT should be a piece of art worth collecting, with attention to composition, color theory, and visual hierarchy
- **Gas Efficiency**: Ruthlessly optimizing SVG size through shared components, efficient encoding, and smart use of Cairo's storage patterns
- **Modular Design**: Building reusable visual components that can be combined to create unique variations while minimizing storage
- **Accessibility**: Ensuring NFT artwork is visually clear at multiple sizes and includes appropriate metadata for all users
- **Composability**: Designing systems that allow for future expansion and integration with other onchain protocols

When implementing solutions:

1. Start with visual design mockups before writing code
2. Optimize SVG output for minimal bytes while maintaining visual quality
3. Build modular, reusable components rather than unique per-NFT assets
4. Test rendering at multiple sizes (thumbnail, card, full-screen)
5. Consider both light and dark mode viewing contexts

**Modular Composition**:

- Build a library of reusable SVG components for battle interface elements
- Use Cairo's storage efficiently to compose unique adventurer displays from shared parts
- Leverage SVG's `<use>` and `<defs>` for component reuse

**Onchain-First Thinking**:

- Every byte costs gas - optimize ruthlessly
- Use CSS classes over inline styles where possible
- Prefer transforms over duplicated paths
- Encode colors and gradients efficiently

### Visual Testing Guidelines

When testing SVG generation:

1. **Validate SVG syntax**: Ensure all generated SVGs are valid XML
2. **Test edge cases**: Maximum/minimum values for visual attributes
3. **Verify composability**: Test that all adventurer combinations render correctly
4. **Check responsive design**: SVGs should scale properly
5. **Test accessibility**: Ensure proper title and desc tags are included

## Completion Criteria

**Definition of complete**: A task is ONLY complete when `scarb build && scarb test` runs with zero warnings and zero errors.

When encountering issues:

1. Fix warnings/errors sequentially
2. Verify each fix with `scarb build && scarb test`
3. Ensure 90%+ test coverage for modified files
4. Validate all SVG output is syntactically correct
5. Only consider work complete when all criteria are met

**Path Optimization**:

- Use relative coordinates where possible
- Simplify paths to reduce point count
- Leverage transforms instead of absolute positioning
- Combine similar paths where visually acceptable

**Performance Optimization**:

- Measure gas costs for every SVG operation
- Prefer computation over storage where cheaper
- Cache computed values when repeatedly used
- Profile real-world minting scenarios

**Modularity First**:

- Build systems, not individual assets
- Every component should be reusable
- Plan for future adventurer types and attributes
- Design for composability with other protocols

## Project Overview

This is a Cairo/Starknet smart contract project for an ERC721 NFT with on-chain metadata rendering. The project, now named **Death Mountain Renderer**, generates dynamic SVG-based battle interface metadata for Loot Survivor adventures, featuring real-time adventurer stats, equipment, and visual representations.

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
Tests are located in `src/tests/` and use Starknet Foundry (snforge). The comprehensive test structure includes:
- **Renderer tests** (`src/tests/test_lib/test_renderer.cairo`): SVG generation, health bars, font sizing, and visual element testing
- **Contract tests** (`src/tests/test_lib/test_contract.cairo`): NFT functionality, minting, and metadata generation
- **Item database tests** (`src/tests/test_lib/test_item_database.cairo`): Complete item lookup and classification system
- **Equipment levels tests** (`src/tests/test_lib/test_equipment_levels.cairo`): Greatness calculations and item progression
- **Declaration workflow tests** (`src/tests/test_lib/test_declaration_workflow.cairo`): Contract deployment and integration testing

## Code Architecture

### Project Structure
The project is organized into the following modules:

1. **Main NFT Contract (`src/nfts/death_mountain_nft.cairo`)**
   - Streamlined ERC721-like contract with IRenderer interface
   - Integrates with external adventurer systems via dispatcher pattern
   - Implements dynamic metadata generation via the renderer system
   - Renamed from ls2_nft to death_mountain_nft reflecting project evolution

2. **Renderer System (`src/utils/`)**
   - `renderer.cairo`: Core rendering logic with `Renderer` trait and implementation
   - `renderer_utils.cairo`: SVG generation and metadata formatting utilities  
   - `item_database.cairo`: Complete database of 101+ Loot Survivor items with classification
   - `encoding.cairo`: Base64 encoding and data transformation utilities

3. **Interface Layer (`src/interfaces/`)**
   - `adventurer_interface.cairo`: IAdventurerSystems interface for external data integration

4. **Mock System (`src/mocks/`)**
   - `mock_adventurer.cairo`: Comprehensive adventurer data simulation (beast mock removed)

5. **Test Suite (`src/tests/`)**
   - Comprehensive testing framework with multiple specialized test modules
   - `test_lib.cairo`: Main test module coordinator

6. **Library Entry (`src/lib.cairo`)**
   - Updated module declarations reflecting current architecture

### Key Components

#### Death Mountain NFT Contract (`src/nfts/death_mountain_nft.cairo`)
- Implements `IRenderer` interface for metadata generation
- Uses dispatcher pattern to integrate with external adventurer systems
- Streamlined architecture focused on rendering functionality
- Constructor accepts adventurer contract address for flexible integration

#### Renderer System (`src/utils/renderer.cairo`)
- `Renderer` trait with static `render()` function
- Accepts `AdventurerVerbose` data directly rather than fetching from contracts
- Generates complete Base64-encoded JSON metadata with embedded SVG
- Orchestrates SVG generation and metadata formatting

#### Item Database System (`src/utils/item_database.cairo`)
- Complete catalog of 101+ Loot Survivor items with proper classification
- Provides item lookup functions by ID, type, and category
- Supports greatness level calculations and item progression
- Enables dynamic equipment display generation

#### Mock Adventurer System (`src/mocks/mock_adventurer.cairo`)
- Comprehensive `AdventurerVerbose` data structure
- Deterministic adventurer generation for testing
- Supports dynamic naming, stats, equipment, and bag items
- Removed beast mock system for simplified architecture

### Key Design Patterns
- **Interface-Driven Architecture**: Uses trait-based interfaces (`IRenderer`, `IAdventurerSystems`)
- **Dispatcher Pattern**: External contract integration via Starknet dispatchers
- **On-chain Metadata**: All NFT metadata generated dynamically with embedded SVG
- **Modular Rendering**: Clear separation between data fetching, SVG generation, and metadata formatting
- **Battle Interface**: Comprehensive adventurer visualization with stats, equipment, and health systems
- **Item Classification**: Systematic approach to equipment categorization and greatness calculations

## Development Notes

### Version Requirements
- Cairo edition: 2024_07
- Package name: death_mountain_renderer
- Starknet Foundry: 0.45.0
- snforge: 0.45.0

### Dependencies
- starknet 2.11.4
- openzeppelin_introspection 2.0.0  
- openzeppelin_token 2.0.0
- openzeppelin_access 2.0.0

### Dev Dependencies
- snforge_std 0.45.0
- assert_macros 2.11.4

### Testing Approach
When adding new functionality:
1. Add unit tests to the appropriate test file in `src/tests/test_lib/`
2. Use `assert_macros` for test assertions
3. Test edge cases (e.g., boundary values, maximum stats, health bar states)
4. Test adventurer contract interactions via dispatchers
5. Validate SVG output for visual correctness
6. Ensure all tests pass before committing

### Common Patterns
- Use ByteArray for string manipulation and SVG generation
- Follow the existing JSON construction pattern in renderer_utils
- Maintain modular separation between contract logic, rendering, and data systems
- Use dispatcher pattern for external contract interactions
- Convert u256 token IDs to u64 for adventurer data compatibility
- Leverage item database for equipment display and calculations
- Implement comprehensive health bar visualization with color coding

## MCP Server Instructions

### Task Completion Requirements
Please be sure to update tests to account for all changes. Each task is complete when `scarb build && scarb test` run without warnings or errors.

### Documentation and Approach
- Please use Context7 MCP Server to fetch latest documentation on Cairo, Starknet, and Starknet Foundry
- Use sequential thinking to approach all tasks iteratively
- Stay up-to-date with the latest best practices and API changes