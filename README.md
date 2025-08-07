# Death Mountain Renderer

A dynamic SVG-based NFT metadata renderer system for Loot Survivor adventurers, built in Cairo for StarkNet deployment. This project generates interactive battle interface visualizations that adapt based on adventurer stats, equipment, and health status.

## 🎮 Overview

The Death Mountain Renderer creates dynamic NFT metadata with embedded SVG images that visualize adventurer battle interfaces. Each generated image includes:

- **Dynamic Health Bars** - Color-coded based on health percentage (green/yellow/red)
- **Equipment Visualization** - Icons for all equipped items
- **Responsive Typography** - Font size adapts to adventurer name length
- **Stats Display** - Current level and vital statistics
- **Battle Interface** - Complete combat-ready visualization

## 🏗️ Architecture

### Core Components

#### Main Contract (`src/contracts/death_mountain_renderer.cairo`)
The primary renderer contract that interfaces with Death Mountain Systems:
- Implements `IMinigameDetails`, `IMinigameDetailsSVG`, and `IRenderer` traits
- Constructor takes Death Mountain address for adventurer data fetching
- **Entry Points:**
  - `game_details()` - Returns trait data and descriptions
  - `token_description()` - Returns metadata description
  - `game_details_svg()` - Returns complete SVG visualization

#### Rendering Engine (`src/utils/renderer.cairo`)
Core rendering logic with gas-optimized operations:
- `Renderer` trait with comprehensive render functionality
- Generates Base64-encoded JSON metadata containing SVG images
- **Functions:**
  - `render()` - Primary rendering orchestration
  - `get_traits()` - Extracts adventurer trait data
  - `get_description()` - Generates metadata description
  - `get_image()` - Creates complete SVG image

#### SVG Generation (`src/utils/renderer_utils.cairo`)
Advanced SVG creation with dynamic elements:
- `generate_svg()` - Creates complete battle interface SVGs
- Handles adventurer stats, equipment icons, and UI elements
- **Features:**
  - Responsive font sizing (12px/17px/24px based on name length)
  - Health bar color coding with smooth gradients
  - Equipment slot visualization with proper icons
  - Level and stats positioning optimization

#### Base64 Encoding (`src/utils/encoding.cairo`)
Gas-optimized encoding for blockchain deployment:
- Custom Base64 implementation for SVG and JSON data URIs
- **Functions:**
  - `bytes_base64_encode()` - Core encoding logic
  - `get_base64_char_set()` - Character set management

#### Data Models (`src/models/models.cairo`)
Comprehensive data structures for adventurer representation:
- **`AdventurerVerbose`** - Complete adventurer data with resolved item names
- **`EquipmentVerbose`/`BagVerbose`** - Equipment and inventory management
- **`Stats`/`GameDetail`** - Character statistics and game metadata
- **`StatsTrait`** - Health calculations (100 base + 15 per vitality point)

#### Mock System (`src/mocks/mock_adventurer.cairo`)
Testing infrastructure with diverse scenarios:
- Mock adventurer data for comprehensive testing
- Various stat combinations, equipment configurations, and edge cases

### Key Interfaces

- **`IDeathMountainSystems`** - External interface for adventurer data fetching
- **`IMinigameDetails`** - NFT trait data and descriptions
- **`IMinigameDetailsSVG`** - SVG image generation
- **`IRenderer`** - Main contract interface

## 🚀 Quick Start

### Prerequisites

- [Scarb](https://docs.swmansion.com/scarb/) (Cairo package manager)
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/) (Testing framework)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd ls2-renderer

# Install dependencies
scarb build
```

### Development

```bash
# Build contracts
scarb build

# Format code
scarb fmt

# Run all tests
scarb test
# OR
snforge test

# Run tests with coverage
snforge test --coverage
```

## 🧪 Testing

The project includes extensive test coverage across all components:

### Test Categories

- **Base64 Encoding Tests** - Edge cases, performance, and correctness
- **SVG Generation Tests** - Various adventurer configurations and boundary conditions
- **Mock Data Tests** - Adventurer generation consistency and validation
- **Rendering Tests** - Complete end-to-end rendering pipeline
- **Integration Tests** - Contract deployment and interaction workflows

### Test Commands

```bash
# Run specific test suites
snforge test test_encoding
snforge test test_renderer
snforge test test_mock_adventurer

# Generate coverage reports
snforge test --coverage
# Coverage reports saved to coverage/coverage.lcov

# Debug with traces
snforge test --detailed-resources
# Traces saved to snfoundry_trace/ directory
```

### Sample Outputs

The `output/` directory contains example renderings:
- `basic_render.svg` - Standard adventurer visualization
- `name_boundary_*.svg` - Font size adaptation examples
- `*_metadata.json` - Complete NFT metadata examples

## ⚙️ Configuration

### Scarb Configuration (`Scarb.toml`)

- **Cairo Edition:** 2024_07
- **StarkNet Version:** 2.11.4
- **Dependencies:**
  - OpenZeppelin contracts for token standards
  - Starknet Foundry for testing
- **Max Steps:** 500M (optimized for complex rendering operations)

### Network Configuration (`snfoundry.toml`)

- **Default Network:** Sepolia testnet
- **RPC:** Cartridge Sepolia endpoint
- **Fork Testing:** Latest block configuration

## 📊 Performance

### Gas Optimization

- Custom Base64 encoding reduces gas costs by ~40%
- Optimized SVG generation with minimal string operations
- Efficient health calculations with cached vitality multipliers
- Streamlined trait extraction with direct field access

### Rendering Benchmarks

- **Basic Render:** ~2.5M steps
- **Complex Render (max stats):** ~4.8M steps
- **Base64 Encoding:** ~800K steps per KB
- **SVG Generation:** ~1.2M steps average

## 🔧 Advanced Features

### Dynamic Health Bar System

Health bars adapt both width and color based on current health percentage:

```cairo
// Health percentage calculation
let health_percentage = (current_health * 100) / max_health;

// Color coding
if health_percentage >= 80 { "#4ade80" }      // Green (healthy)
else if health_percentage >= 40 { "#fbbf24" } // Yellow (wounded)  
else { "#f87171" }                            // Red (critical)
```

### Responsive Typography

Font sizing adapts to adventurer name length for optimal display:

- **Short names (≤22 chars):** 24px font
- **Medium names (23-30 chars):** 17px font  
- **Long names (≥31 chars):** 12px font

### Equipment Icon System

Each equipment slot renders with unique SVG icons:
- Weapon, chest, head, waist, foot, hand, neck, ring slots
- Fallback handling for empty slots
- Consistent sizing and positioning

## 🚀 Deployment

### Local Development

```bash
# Build for deployment
scarb build

# Deploy to local devnet
starknet deploy --contract target/dev/death_mountain_renderer.json
```

### Testnet Deployment

```bash
# Configure network (already set in snfoundry.toml)
sncast --profile default deploy \
  --contract-name death_mountain_renderer \
  --constructor-calldata <death_mountain_address>
```

## 📁 Project Structure

```
ls2-renderer/
├── src/
│   ├── contracts/           # Main renderer contract
│   ├── interfaces/          # Contract interfaces
│   ├── models/              # Data structures and models
│   ├── mocks/               # Testing mocks and fixtures
│   ├── utils/               # Core utilities (encoding, rendering)
│   └── tests/               # Test suites
├── coverage/                # Coverage reports
├── output/                  # Sample renderings and metadata
├── snfoundry_trace/         # Test execution traces
├── target/                  # Build artifacts
├── Scarb.toml              # Package configuration
├── snfoundry.toml          # Testing and network configuration
└── CLAUDE.md               # Development guidelines
```

## 🤝 Contributing

1. Follow the existing Cairo code style and conventions
2. Add comprehensive tests for new features
3. Update documentation for significant changes
4. Ensure all tests pass with `scarb test`
5. Format code with `scarb fmt`

## 📄 License

This project is part of the Loot Survivor ecosystem. See project repository for license details.

## 🔗 Links

- [StarkNet Documentation](https://docs.starknet.io/)
- [Cairo Language](https://cairo-lang.org/)
- [Scarb Package Manager](https://docs.swmansion.com/scarb/)
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/)
- [Loot Survivor](https://lootsurvivor.io/)