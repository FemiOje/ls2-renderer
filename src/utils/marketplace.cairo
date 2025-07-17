// SPDX-License-Identifier: MIT
// Marketplace Item Generation System for LS2 Renderer
// Creates deterministic marketplace that generates 21 items per level from 101-item pool

// use core::integer::u64_safe_divmod;
use ls2_renderer::utils::item_database::{NUM_ITEMS, ItemDatabaseImpl};

// Constants for marketplace generation
pub const MARKETPLACE_ITEMS_PER_LEVEL: u8 = 21;
pub const NUM_ITEMS_NZ_MINUS_ONE: u64 = 100; // NUM_ITEMS - 1 for safe division

#[derive(Copy, Drop, Serde)]
pub struct MarketplaceItem {
    pub item_id: u8,
    pub available: bool,
}

#[generate_trait]
pub impl MarketplaceImpl of MarketplaceTrait {
    /// @notice Generates 21 unique items for the marketplace based on adventurer level and seed
    /// @param adventurer_level The current level of the adventurer
    /// @param adventurer_seed Deterministic seed based on adventurer data
    /// @return Array of 21 unique item IDs available in the marketplace
    fn generate_marketplace_items(adventurer_level: u8, adventurer_seed: u64) -> Array<u8> {
        // Create combined seed from level and adventurer data
        let market_seed = Self::create_market_seed(adventurer_level, adventurer_seed);

        // Generate 21 unique items from the 101-item pool
        Self::get_unique_items(market_seed, MARKETPLACE_ITEMS_PER_LEVEL)
    }

    /// @notice Creates a deterministic seed for marketplace generation
    /// @param adventurer_level The current level of the adventurer
    /// @param adventurer_seed Seed based on adventurer data
    /// @return Combined seed for marketplace generation
    fn create_market_seed(adventurer_level: u8, adventurer_seed: u64) -> u64 {
        // Combine level and adventurer seed for deterministic marketplace
        let level_multiplier: u64 = adventurer_level.into() * 1000;
        adventurer_seed + level_multiplier
    }

    /// @notice Generates unique item IDs from the item pool
    /// @param seed The seed for randomization
    /// @param count Number of items to generate
    /// @return Array of unique item IDs
    fn get_unique_items(seed: u64, count: u8) -> Array<u8> {
        if count >= NUM_ITEMS {
            return Self::get_all_items();
        }

        let (market_seed, offset) = Self::get_market_seed_and_offset(seed);
        let mut items = ArrayTrait::<u8>::new();
        let mut item_count: u16 = 0;

        loop {
            if item_count == count.into() {
                break;
            }

            let item_id = Self::get_item_id(market_seed + (offset.into() * item_count).into());

            // Check for duplicates before adding
            if !Self::array_contains(@items, item_id) {
                items.append(item_id);
                item_count += 1;
            } else {
                // If duplicate found, increment seed and try again
                let new_seed = market_seed + (offset.into() * item_count).into() + 1;
                let new_item_id = Self::get_item_id(new_seed);
                if !Self::array_contains(@items, new_item_id) {
                    items.append(new_item_id);
                    item_count += 1;
                } else {
                    // Skip this iteration and try with next multiplier
                    item_count += 1;
                }
            }
        };

        items
    }

    /// @notice Converts seed to valid item ID (1-101)
    /// @param seed The seed value
    /// @return Valid item ID between 1 and 101
    fn get_item_id(seed: u64) -> u8 {
        (seed % NUM_ITEMS.into()).try_into().unwrap() + 1
    }

    /// @notice Checks if array contains a specific item
    /// @param array The array to check
    /// @param item The item to find
    /// @return True if item exists in array
    fn array_contains(array: @Array<u8>, item: u8) -> bool {
        let mut i = 0;
        let len = array.len();

        loop {
            if i >= len {
                break false;
            }

            if *array.at(i) == item {
                break true;
            }

            i += 1;
        }
    }

    /// @notice Gets market seed and offset for item generation
    /// @param seed The input seed
    /// @return Tuple of (market_seed, offset)
    fn get_market_seed_and_offset(seed: u64) -> (u64, u8) {
        // Use simple modulo for now, can be optimized later
        let market_seed = seed / NUM_ITEMS_NZ_MINUS_ONE;
        let offset = seed % NUM_ITEMS_NZ_MINUS_ONE;
        (market_seed, 1 + offset.try_into().unwrap())
    }

    /// @notice Returns all 101 items (fallback when requesting >= 101 items)
    /// @return Array containing all item IDs from 1 to 101
    fn get_all_items() -> Array<u8> {
        let mut all_items = ArrayTrait::<u8>::new();
        let mut i: u8 = 1;

        loop {
            if i > NUM_ITEMS {
                break;
            }
            all_items.append(i);
            i += 1;
        };

        all_items
    }

    /// @notice Checks if an item is available in the marketplace
    /// @param marketplace_items Array of available items
    /// @param item_id The item ID to check
    /// @return True if item is available
    fn is_item_available(marketplace_items: @Array<u8>, item_id: u8) -> bool {
        Self::array_contains(marketplace_items, item_id)
    }

    /// @notice Gets marketplace size (always 21 items per level)
    /// @return The number of items per marketplace level
    fn get_marketplace_size() -> u8 {
        MARKETPLACE_ITEMS_PER_LEVEL
    }

    /// @notice Generates marketplace metadata for rendering
    /// @param adventurer_level The current level of the adventurer
    /// @param adventurer_seed Deterministic seed based on adventurer data
    /// @return Formatted marketplace data for UI display
    fn generate_marketplace_metadata(adventurer_level: u8, adventurer_seed: u64) -> Array<felt252> {
        let items = Self::generate_marketplace_items(adventurer_level, adventurer_seed);
        let mut metadata = ArrayTrait::<felt252>::new();

        // Add marketplace header
        metadata.append('Marketplace Level ');
        metadata.append(adventurer_level.into());
        metadata.append(' Items:');

        // Add item names
        let mut i = 0;
        loop {
            if i >= items.len() {
                break;
            }

            let item_id = *items.at(i);
            let item_name = ItemDatabaseImpl::get_item_name(item_id);
            metadata.append(item_name);

            i += 1;
        };

        metadata
    }
}
