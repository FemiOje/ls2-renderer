# LS2 Renderer Meta Plan

## Project Context
- **Project**: Loot Survivor 2 NFT Renderer
- **Language**: Cairo/Starknet
- **Type**: ERC721 Smart Contract with On-chain Metadata Rendering

## Project Overview

This project acts as an NFT renderer, where the `token_uri` function returns a token URI that is decoded to render the user's/player's NFT as a dynamic multi-page SVG in their wallet and on block explorers. The `token_uri()` function is called with a token ID that is unique to each different adventurer in the @death-mountain repo.

## Pre-Development Checklist

### Environment Setup
- [ ] Cairo edition: 2024_07
- [ ] Scarb: 2.10.1
- [ ] Starknet Foundry: 0.45.0
- [ ] snforge: 0.45.0

### Dependencies Verification
- [ ] starknet 2.10.1
- [ ] openzeppelin_introspection 1.0.0
- [ ] openzeppelin_token 1.0.0
- [ ] openzeppelin_access 1.0.0
- [ ] snforge_std 0.45.0 (dev)
- [ ] assert_macros 2.10.1 (dev)

## Multi-Page SVG Structure

### Page 1: Character Stats & Equipment

**Color Scheme**: `#78E846` (green)

**Template Location**: `/workspace/ls2-renderer/src/utils/renderer_utils.cairo` (create_battle_svg function, lines 209-215)

**Static Elements**:

- SVG structure and layout framework
- Equipment slot icons (weapon, chest, head, waist, foot, hand, neck, ring)
- Text labels ("STR", "DEX", "INT", "HIT", "WIS", "CHA", "LUCK", "INVENTORY", "HP", "XP")
- Equipment slot numbers (01-08)
- Border and frame graphics with #78E846 stroke
- LS logo graphic (top left)

**Dynamic Data** (23 total placeholders):

1. `_name` (adventurer name) - from `adventurer_name` parameter
2. `_level` (adventurer level) - calculated: `(adventurer.xp / 100) + 1`
3. `_str` (strength) - from `adventurer.stats.strength`
4. `_dex` (dexterity) - from `adventurer.stats.dexterity`
5. `_int` (intelligence) - from `adventurer.stats.intelligence`
6. `_vit` (vitality) - from `adventurer.stats.vitality`
7. `_wis` (wisdom) - from `adventurer.stats.wisdom`
8. `_cha` (charisma) - from `adventurer.stats.charisma`
9. `_luck` (luck) - from `adventurer.stats.luck`
10. `_health` (current health) - from `adventurer.health`
11. `_max_health` (max health) - hardcoded as 100
12. `_xp` (experience points) - from `adventurer.xp`
13. `adventurer_id` (adventurer ID) - from `adventurer_id` parameter

**Equipment Inventory** (8 dynamic slots):

- `_weapon_name` (weapon equipment) - from `adventurer.equipment.weapon`
- `_chest_name` (chest equipment) - from `adventurer.equipment.chest`
- `_head_name` (head equipment) - from `adventurer.equipment.head`
- `_waist_name` (waist equipment) - from `adventurer.equipment.waist`
- `_foot_name` (foot equipment) - from `adventurer.equipment.foot`
- `_hand_name` (hand equipment) - from `adventurer.equipment.hand`
- `_neck_name` (neck equipment) - from `adventurer.equipment.neck`
- `_ring_name` (ring equipment) - from `adventurer.equipment.ring`

**Equipment Display System**:

- Each equipment slot shows greatness level and item name via `generate_item()` function
- Greatness calculated as `item.xp / 10`
- Empty slots display "None Equipped"
- Item format: "G{greatness} Item{id}"

**Dynamic Enhancements Opportunities**:

- Health bar visualization (proportional scaling)
- Level-based visual styling
- Stat-based highlighting for exceptional values (>80)
- XP progress bar to next level
- Equipment rarity-based colors/effects

### Page 2: Item Bag

**Color Scheme**: `#E89446` (orange/amber)
**Layout**: 15 inventory slots in a 5×3 grid

**Template Location**: `/workspace/ls2-renderer/src/utils/renderer_utils.cairo` (lines 400-438)

**Display Elements**:

- Header: "{adventurer_name}'S Item Bag"
- Content: Actual bag items (`_bag_item_1`, `_bag_item_2`, `_bag_item_3`, etc.)
- Item Display: Each item shows greatness level and name (e.g., "G1 Item8")

**Dynamic Item Categories** (101 total items):

1. **Jewelry** (8 items):

   - Rings: Silver, Bronze, Platinum, Titanium, Gold (5 types)
   - Necklaces: Pendant, Necklace, Amulet (3 types)

2. **Weapons** (18 items):

   - Blades: Katana, Falchion, Scimitar, Long Sword, Short Sword (5 types)
   - Bludgeons: Warhammer, Quarterstaff, Maul, Mace, Club (5 types)
   - Magic: Ghost Wand, Grave Wand, Bone Wand, Wand, Grimoire, Chronicle, Tome, Book (8 types)

3. **Armor Sets** (75 items):
   - Chest: Divine Robe, Silk Robe, Linen Robe, Demon Husk, Dragonskin Armor, etc. (15 types)
   - Head: Ancient Helm, Ornate Helm, Demon Crown, Dragon's Crown, etc. (15 types)
   - Waist: Ornate Belt, War Belt, Demonhide Belt, Brightsilk Sash, etc. (15 types)
   - Foot: Holy Greaves, Demonhide Boots, Divine Slippers, etc. (15 types)
   - Hand: Holy Gauntlets, Demon's Hands, Divine Gloves, etc. (15 types)

**Dynamic Item Properties**:

- Item ID: 1-101 (unique identifier)
- XP: Variable experience points for item progression
- Greatness: Calculated from XP (sqrt formula)
- Specials: Unlocked at greatness ≥15 (suffixes like "of Power", "of Titans")
- Prefixes: Unlocked at greatness ≥19 (e.g., "Agony", "Dragon", "Phoenix")

**Bag Constraints**:

- Capacity: 15 items maximum
- Storage: Fixed slots (item_1 through item_15)
- Special Properties: Items with greatness ≥15 provide stat boosts
- Jewelry Focus: Separate tracking for jewelry items and their combined greatness

### Page 3: Marketplace

**Color Scheme**: `#77EDFF` (light blue)
**Layout**: 20 item slots in a 4×5 grid

**Template Location**: `/workspace/ls2-renderer/src/utils/renderer_utils.cairo`

**Display Elements**:

- Header: "{adventurer_name}'S Marketplace"
- Visual Style: Clean grid layout with item graphics (circles, rectangles, paths)
- Content: Marketplace items available for purchase

**Market System Configuration**:

- Market Size: 21 items per level (`NUMBER_OF_ITEMS_PER_LEVEL`)
- Total Item Pool: 101 unique items (`NUM_LOOT_ITEMS`)
- Randomization: Deterministic marketplace based on seed
- Tier Pricing: Dynamic pricing using `TIER_PRICE = 4` multiplier

**Available Items**:

1. **All 101 Item Types** (same as bag contents):

   - Jewelry: Rings (5 types), Necklaces (3 types)
   - Weapons: Blades (5), Bludgeons (5), Magic items (8)
   - Armor: Chest (15), Head (15), Waist (15), Foot (15), Hand (15)

2. **Special Items**:
   - Health Potions: Price = `max(1, level - (charisma * 2))`
   - Upgrade Items: Various tiers available for purchase

**Pricing Structure** (Tier-Based):

- T1 Items: 20 gold (5 × TIER_PRICE)
- T2 Items: 16 gold (4 × TIER_PRICE)
- T3 Items: 12 gold (3 × TIER_PRICE)
- T4 Items: 8 gold (2 × TIER_PRICE)
- T5 Items: 4 gold (1 × TIER_PRICE)

**Market Features**:

- Shopping Cart: Tracks potions and items to purchase
- Filters: Slot-based and type-based filtering
- Real-time Updates: Inventory changes based on adventurer level
- Purchase Flow: Items can be equipped immediately upon purchase
- Seed-Based Generation: Market items change based on game state
- No Duplicates: Each market session has unique item selection
- Availability Checking: Prevents purchasing unavailable items
- Charisma Bonus: Reduces potion prices based on adventurer charisma

### Page 4: Current Battle

**Color Scheme**: `#FE9676` (coral/peach) with **gradient border**
**Border**: Coral-to-green gradient (`#FE9676` → `#78E846`)

- **Start Color**: `#FE9676` (Coral/Peach - RGB: 254, 150, 118)
- **End Color**: `#78E846` (Bright Green - RGB: 120, 232, 70)
- **Direction**: Vertical gradient from coral at top to bright green at bottom

**Template Location**: `/workspace/ls2-renderer/src/utils/renderer_utils.cairo` (create_battle_svg function)

**Display Elements**:

- Header: "{adventurer_name}'S Current Battle"
- Visual Style: Battle-focused interface with real-time combat data
- Content: Current beast encounter and battle statistics

**Dynamic Beast System**:

1. **75 Beast Types** across three categories:

   - **Magical Beasts** (25): Warlock, Typhon, Jiangshi, Anansi, Basilisk, Gorgon, Kitsune, Lich, Chimera, Wendigo, Rakshasa, Werewolf, Banshee, Draugr, Vampire, Goblin, Ghoul, Wraith, Sprite, Kappa, Fairy, Leprechaun, Kelpie, Pixie, Gnome
   - **Hunter Beasts** (25): Griffin, Manticore, Phoenix, Dragon, Minotaur, Qilin, Ammit, Nue, Skinwalker, Chupacabra, Weretiger, Wyvern, Roc, Harpy, Pegasus, Hippogriff, Fenrir, Jaguar, Satori, Direwolf, Bear, Wolf, Mantis, Spider, Rat
   - **Brute Beasts** (25): Kraken, Colossus, Balrog, Leviathan, Tarrasque, Titan, Nephilim, Behemoth, Hydra, Juggernaut, Oni, Jotunn, Ettin, Cyclops, Giant, Nemeanlion, Berserker, Yeti, Golem, Ent, Troll, Bigfoot, Ogre, Orc, Skeleton

2. **Dynamic Beast Properties**:

   - **Special Names**: 69 prefixes (Agony, Apocalypse, Armageddon, etc.) + 18 suffixes (Bane, Root, Bite, etc.) unlock at level 19
   - **Combat Stats**: Dynamic health (3-1023), level-based scaling, tier classifications (T1-T5)
   - **Special Powers**: Three-tier special ability system with combat bonuses

3. **Combat System Data**:

   - **Damage Calculations**: Base attack, elemental effectiveness, strength bonuses, critical hits, weapon specials
   - **Battle Results**: Total damage, armor penetration, combat effectiveness ratings
   - **Flee Mechanics**: Level and dexterity-based escape chance calculations

4. **Adventurer Battle Stats**:

   - **Dynamic Names**: 50 unique adventurer names based on token ID
   - **Combat Attributes**: Health, strength, dexterity, level (XP-based calculation)
   - **Equipment Effects**: Weapon and armor combat specifications with tier bonuses
   - **Battle Status**: Current health, maximum health, active combat bonuses

5. **Real-time Battle Data**:
   - **Current Encounter**: Active beast opponent with full stat display
   - **Battle Log**: Recent combat actions, damage dealt/received, special ability activations
   - **Combat Effectiveness**: Elemental matchups, weapon vs armor comparisons
   - **Victory Conditions**: XP and gold reward calculations based on beast tier and combat performance

## Development Workflow

### Phase 1: Planning & Analysis
- [ ] Define requirements and scope
- [ ] Identify affected components:
  - [ ] Main NFT Contract (`src/nfts/ls2_nft.cairo`)
  - [ ] Renderer System (`src/utils/renderer.cairo`)
  - [ ] Renderer Utils (`src/utils/renderer_utils.cairo`)
  - [ ] Encoding Utils (`src/utils/encoding.cairo`)
  - [ ] Mock Contracts (`src/mocks/`)
  - [ ] Library Entry (`src/lib.cairo`)
- [ ] Review existing test coverage
- [ ] Plan test strategy

### Phase 2: Implementation
- [ ] Code changes following existing patterns:
  - [ ] Use ByteArray for string manipulation
  - [ ] Follow JSON construction pattern in renderer_utils
  - [ ] Maintain modular separation
  - [ ] Use dispatcher pattern for mock contracts
  - [ ] Convert u256 token IDs to u64 for compatibility
- [ ] Implement core functionality
- [ ] Add error handling and edge cases

### Phase 3: Testing
- [ ] Unit tests in `tests/test_lib/`:
  - [ ] `test_renderer.cairo` - Renderer logic
  - [ ] `test_contract.cairo` - Integration tests
  - [ ] `test_battle_interface.cairo` - Battle interface tests
- [ ] Test scenarios:
  - [ ] Happy path functionality
  - [ ] Edge cases (non-existent tokens, boundary values)
  - [ ] Mock contract interactions
  - [ ] Error conditions
- [ ] Use assert_macros for test assertions

### Phase 4: Quality Assurance
- [ ] Code formatting: `scarb fmt`
- [ ] Compilation check: `scarb check`
- [ ] Build verification: `scarb build`
- [ ] Test execution: `scarb test`
- [ ] All tests pass without warnings/errors

## Component-Specific Guidelines

### NFT Contract (`src/nfts/ls2_nft.cairo`)
- [ ] Uses OpenZeppelin components (ERC721Component, SRC5Component)
- [ ] Implements IOpenMint for public minting
- [ ] Sequential token IDs starting from 1
- [ ] Dynamic metadata via renderer integration
- [ ] Mock contract address storage

### Renderer System (`src/utils/renderer.cairo`)
- [ ] Implements Renderer trait with render() function
- [ ] Fetches adventurer/beast data from mock contracts
- [ ] Generates battle interface metadata
- [ ] Handles dynamic naming system

### Mock Data System (`src/mocks/`)
- [ ] Provides test data for adventurers and beasts
- [ ] Supports dynamic name generation
- [ ] Enables battle scenario simulation

## Technical Requirements

### Design Principles:

- **Dynamic Pages**: The design should make it easy to add additional pages
- **Modular SVG**: Use reusable components for maximum efficiency
- **Responsive Layout**: Clean grid layouts that work across different display contexts

### Art Assets Needed:

**Minimum Requirements**:

- Weapon icons
- Armor slot icons
- Necklace icons
- Jewelry icons

### Implementation Notes:

- The marketplace dynamically generates 21 items from the 101-item pool using deterministic randomization
- All pages display items with tier-based pricing and filtering capabilities
- The Item Bag displays any combination of the 101 item types with current greatness levels and full names (including prefixes/suffixes when unlocked)

## Testing Strategy

### Test Categories
- [ ] **Unit Tests**: Individual component functionality
- [ ] **Integration Tests**: Component interactions
- [ ] **Edge Case Tests**: Boundary conditions and error states
- [ ] **Mock Contract Tests**: Data fetching and processing

### Test Requirements
- [ ] All new functionality has corresponding tests
- [ ] Existing tests still pass
- [ ] Code coverage for critical paths
- [ ] Performance considerations for on-chain operations

## Completion Criteria
- [ ] All planned functionality implemented
- [ ] `scarb build` completes without warnings/errors
- [ ] `scarb test` passes all tests
- [ ] Code follows project conventions
- [ ] Documentation updated if needed
- [ ] CLAUDE.md updated with any new patterns/requirements

## Common Patterns Reference

### Data Handling
- Use ByteArray for string manipulation
- Convert u256 token IDs to u64 for mock compatibility
- Follow existing JSON construction patterns

### Architecture
- Maintain modular separation between contract logic and rendering
- Use dispatcher pattern for mock contract interactions
- Follow OpenZeppelin component architecture

### Error Handling
- Test non-existent tokens
- Handle boundary values appropriately
- Validate mock contract interactions

## MCP Server Guidelines
- Use Context7 MCP Server for latest Cairo/Starknet documentation
- Apply sequential thinking approach
- Stay current with best practices and API changes
- Complete tasks only when all tests pass

## Notes
- Project generates battle interface metadata for Loot Survivor game
- Features dynamic adventurer and beast data visualization
- All NFT metadata is generated dynamically on-chain
- Focus on game interface rendering requirements