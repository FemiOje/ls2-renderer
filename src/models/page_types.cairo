// SPDX-License-Identifier: MIT
//
// @title Page Type Definitions - Multi-Page NFT System
// @notice Core data structures for managing multi-page SVG NFT rendering
// @dev Defines page types, battle states, and animation configurations

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum PageType {
    Stats,      // Page 0: Character stats and equipment (current battle page)
    Inventory,  // Page 1: Bag contents and detailed inventory
    Journey,    // Page 2: Adventure history and achievements
    Battle,     // Page 3: Battle-specific interface (when in combat)
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum BattleState {
    Dead,      // Adventurer health == 0
    InCombat,  // Beast health > 0
    Normal,    // Normal exploration state
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum PageMode {
    BattleOnly,     // Show only battle page
    Normal: u8,     // Normal cycling with page count
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct PageConfig {
    pub page_type: PageType,
    pub transition_duration: u16,
    pub auto_advance: bool,
}

pub impl PageConfigDefault of Default<PageConfig> {
    fn default() -> PageConfig {
        PageConfig {
            page_type: PageType::Stats,
            transition_duration: 500, // 0.5 seconds in milliseconds
            auto_advance: true,
        }
    }
}