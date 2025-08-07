# LS2 Renderer - Loot Survivor 2 NFT Collection

A Cairo/Starknet smart contract project for an ERC721 NFT collection with fully on-chain SVG metadata rendering. This project generates dynamic battle interface metadata for the Loot Survivor game ecosystem, featuring adventurer stats, equipment visualization, and beast encounter data.

[![Cairo Version](https://img.shields.io/badge/Cairo-2024__07-orange)](https://book.cairo-lang.org/)
[![Starknet](https://img.shields.io/badge/Starknet-2.11.4-blue)](https://www.starknet.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎮 Overview

LS2 Renderer creates dynamic NFT battle cards that showcase adventurer statistics, equipment loadouts, and battle scenarios entirely on-chain. Each NFT represents a unique battle interface with:

- **Dynamic Adventurer Stats**: Health, XP, level, and core attributes (Strength, Dexterity, Vitality, Intelligence, Wisdom, Charisma, Luck)
- **Equipment Visualization**: Complete gear loadout with weapon, armor, and accessory icons
- **Battle Interface**: Game-ready metadata for Loot Survivor integration
- **Fully On-Chain**: All metadata and SVG graphics generated and stored on Starknet

## 🏗️ Architecture

### Core Components

```
src/
├── lib.cairo                 # Module declarations
├── nfts/
│   └── ls2_nft.cairo        # Main ERC721 contract with dynamic metadata
├── utils/
│   ├── renderer.cairo       # Core rendering logic and trait
│   ├── renderer_utils.cairo # SVG generation and metadata creation
│   ├── item_database.cairo  # Equipment database and item management
│   └── encoding.cairo       # Base64 encoding utilities
└── mocks/
    ├── mock_adventurer.cairo # Adventurer data provider
    └── mock_beast.cairo     # Beast data for battle scenarios
```

### Contract Flow

1. **Minting**: Users mint NFTs with sequential token IDs starting from 1
2. **Data Retrieval**: Contract fetches adventurer data from mock providers
3. **Rendering**: Dynamic SVG generation based on adventurer stats and equipment
4. **Metadata**: Complete JSON metadata with base64-encoded SVG returned via `token_uri()`

## 🚀 Quick Start

### Prerequisites

- **Scarb**: 2.10.1 or later
- **Starknet Foundry**: 0.45.0 or later
- **Cairo**: 2024_07 edition

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd ls2-renderer

# Install dependencies
scarb build

# Run tests
scarb test
```

### Development Commands

```bash
# Build the project
scarb build

# Run all tests
scarb test

# Run specific test
snforge test test_name

# Format code
scarb fmt

# Check compilation
scarb check
```

## 🧪 Testing

The project includes comprehensive tests covering:

- **Unit Tests**: Individual component functionality
- **Integration Tests**: Full contract deployment and interaction workflows
- **SVG Validation**: Ensuring generated SVGs are syntactically correct
- **Edge Cases**: Maximum values, error conditions, and boundary testing

```bash
# Run all tests
scarb test

# Run with coverage (if configured)
scarb test --coverage

# Run specific test module
snforge test test_renderer

# Run battle interface tests
snforge test test_battle_interface
```

## 📋 Project Structure

### Smart Contracts

#### Main NFT Contract (`src/nfts/ls2_nft.cairo`)
- **ERC721 Implementation**: Using OpenZeppelin components
- **Open Minting**: Public minting with sequential token IDs
- **Dynamic Metadata**: Overrides `token_uri()` for on-chain SVG generation
- **Mock Integration**: Connects to adventurer and beast data providers

#### Renderer System (`src/utils/`)
- **`renderer.cairo`**: Core `Renderer` trait and implementation
- **`renderer_utils.cairo`**: SVG generation, icon creation, and metadata assembly
- **`item_database.cairo`**: Equipment database with item names and tiers
- **`encoding.cairo`**: Base64 encoding for SVG data URLs

#### Mock Contracts (`src/mocks/`)
- **`mock_adventurer.cairo`**: Provides adventurer stats, equipment, and names
- **`mock_beast.cairo`**: Supplies beast data for battle scenarios

### Key Features

#### Dynamic SVG Generation
- **Equipment Icons**: Weapon, chest, head, waist, foot, hand, neck, ring visualizations
- **Stat Visualization**: Color-coded health bars and stat displays
- **Responsive Design**: SVGs scale properly across different viewing contexts
- **Modular Components**: Reusable SVG elements for gas efficiency

#### Battle Interface Metadata
```json
{
  "name": "Battle Card #1",
  "description": "Dynamic battle interface for Loot Survivor",
  "image": "data:image/svg+xml;base64,<encoded-svg>",
  "attributes": [
    {"trait_type": "Health", "value": 100},
    {"trait_type": "Level", "value": 1},
    {"trait_type": "Gold", "value": 250},
    // ... equipment and stats
  ]
}
```

#### Equipment System
- **8 Slot Types**: Complete adventurer loadout
- **Item Database**: 101 unique items across different tiers
- **Dynamic Names**: Procedural item name generation
- **XP Tracking**: Equipment experience and progression

## 🔧 Configuration

### Scarb.toml Configuration
```toml
[package]
name = "ls2_renderer"
version = "0.1.0"
edition = "2024_07"

[dependencies]
starknet = "2.11.4"
openzeppelin_introspection = "2.0.0"
openzeppelin_token = "2.0.0"
openzeppelin_access = "2.0.0"

[tool.snforge]
max_n_steps = 500000000  # Increased for complex rendering
```

### Development Dependencies
- **snforge_std**: 0.45.0 - Starknet Foundry testing framework
- **assert_macros**: 2.11.4 - Enhanced test assertions

## 🚢 Deployment

### Using Scripts
The project includes comprehensive deployment scripts in the `scripts/` directory:

```bash
# Complete deployment workflow
./scripts/full_workflow.sh

# Step-by-step deployment
./scripts/declare_mock_contracts.sh
./scripts/deploy_mock_contracts.sh
./scripts/declare_renderer_contract.sh
./scripts/deploy_renderer_contract.sh
```

### Manual Deployment
1. **Declare Contracts**: Submit contract classes to Starknet
2. **Deploy Mock Contracts**: Deploy adventurer and beast data providers
3. **Deploy NFT Contract**: Deploy main collection with mock contract addresses
4. **Verify**: Test minting and metadata generation

See [scripts/README.md](scripts/README.md) for detailed deployment instructions.

## 🎨 SVG Rendering

### Visual Components
- **Health Bar**: Dynamic color-coding (green → yellow → red)
- **Equipment Grid**: 2x4 layout with item icons
- **Stat Display**: Numerical values with visual hierarchy
- **Battle Interface**: Game-ready layout for combat scenarios

### Optimization Techniques
- **Shared Components**: Reusable SVG elements via `<defs>` and `<use>`
- **Path Optimization**: Minimized SVG path data for gas efficiency
- **Color Classes**: CSS classes over inline styles
- **Transform Usage**: Efficient positioning and scaling

### Color Palette
```css
.text-primary { fill: #FFFFFF; }    /* Primary text */
.text-secondary { fill: #A1A1AA; }  /* Secondary text */
.health-full { fill: #22C55E; }     /* Full health (green) */
.health-medium { fill: #EAB308; }   /* Medium health (yellow) */
.health-low { fill: #EF4444; }      /* Low health (red) */
.bg-primary { fill: #1F2937; }      /* Background */
.border { stroke: #374151; }        /* Borders */
```

## 🧮 Game Integration

### Battle Interface Data
- **Adventurer Stats**: All 7 core attributes (Strength, Dexterity, etc.)
- **Equipment Loadout**: Complete 8-slot gear visualization
- **Health System**: Dynamic health calculation based on vitality
- **Level Progression**: XP-based level calculation
- **Battle Context**: Integration points for beast encounters

### Data Flow
1. **Token Minting**: User mints NFT with unique token ID
2. **Data Fetching**: Contract queries mock adventurer data
3. **Stat Calculation**: Dynamic level and health computation
4. **SVG Generation**: Battle interface rendering with current stats
5. **Metadata Assembly**: Complete JSON with base64-encoded SVG

## 🔍 Testing Strategy

### Test Coverage
- **Contract Tests**: ERC721 functionality, minting, transfers
- **Renderer Tests**: SVG generation, metadata creation
- **Integration Tests**: Full deployment and interaction workflows
- **Edge Case Tests**: Maximum values, error conditions, boundaries
- **SVG Validation**: Syntax checking and visual regression testing

### Mock Data Testing
- **Deterministic Results**: Consistent test outcomes
- **Edge Cases**: Maximum stats (255), zero health scenarios
- **Equipment Variations**: All item types and combinations
- **Name Generation**: Dynamic adventurer naming system

## 📈 Performance & Gas Optimization

### On-Chain Efficiency
- **Modular SVG**: Shared components reduce storage costs
- **Efficient Encoding**: Optimized base64 implementation
- **Cairo Patterns**: Following Starknet best practices
- **Storage Layout**: Minimized storage slots and operations

### Rendering Performance
- **Lazy Evaluation**: Compute values only when needed
- **Caching Strategy**: Store computed values when beneficial
- **Path Simplification**: Reduced SVG complexity without visual loss

## 🤝 Contributing

### Development Workflow
1. **Fork & Clone**: Create your development environment
2. **Feature Branch**: Create focused feature branches
3. **Test Coverage**: Ensure all changes are tested
4. **Code Quality**: Run `scarb fmt` and `scarb build`
5. **Pull Request**: Submit with comprehensive description

### Code Standards
- **Cairo Style**: Follow official Cairo formatting guidelines
- **Documentation**: Comment complex logic and public interfaces
- **Testing**: Maintain high test coverage (90%+)
- **Gas Efficiency**: Optimize for minimal gas consumption

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Loot Survivor**: [Main Game Repository]
- **Starknet**: [https://www.starknet.io/](https://www.starknet.io/)
- **Cairo Book**: [https://book.cairo-lang.org/](https://book.cairo-lang.org/)
- **OpenZeppelin Cairo**: [https://github.com/OpenZeppelin/cairo-contracts](https://github.com/OpenZeppelin/cairo-contracts)

## 🆘 Support

For questions, issues, or contributions:
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Documentation**: Check [CLAUDE.md](CLAUDE.md) for development guidelines
- **Scripts**: See [scripts/README.md](scripts/README.md) for deployment help

---

**Built with ❤️ for the Loot Survivor ecosystem**