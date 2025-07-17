use ls2_renderer::utils::marketplace::{MarketplaceImpl, MARKETPLACE_ITEMS_PER_LEVEL};
use ls2_renderer::utils::item_database::NUM_ITEMS;

#[test]
fn test_marketplace_items_generation() {
    let adventurer_level = 5;
    let adventurer_seed = 12345;

    let items = MarketplaceImpl::generate_marketplace_items(adventurer_level, adventurer_seed);

    // Should generate exactly 21 items
    assert!(items.len() == MARKETPLACE_ITEMS_PER_LEVEL.into(), "Should generate 21 items");

    // All items should be valid (1-101)
    let mut i = 0;
    loop {
        if i >= items.len() {
            break;
        }
        let item_id = *items.at(i);
        assert!(item_id >= 1 && item_id <= NUM_ITEMS, "Item ID should be between 1 and 101");
        i += 1;
    };
}

#[test]
fn test_marketplace_deterministic() {
    let adventurer_level = 3;
    let adventurer_seed = 54321;

    let items1 = MarketplaceImpl::generate_marketplace_items(adventurer_level, adventurer_seed);
    let items2 = MarketplaceImpl::generate_marketplace_items(adventurer_level, adventurer_seed);

    // Same inputs should produce same results
    assert!(items1.len() == items2.len(), "Should produce same number of items");

    let mut i = 0;
    loop {
        if i >= items1.len() {
            break;
        }
        assert!(*items1.at(i) == *items2.at(i), "Items should be deterministic");
        i += 1;
    };
}

#[test]
fn test_marketplace_no_duplicates() {
    let adventurer_level = 10;
    let adventurer_seed = 98765;

    let items = MarketplaceImpl::generate_marketplace_items(adventurer_level, adventurer_seed);

    // Check for duplicates
    let mut i = 0;
    loop {
        if i >= items.len() {
            break;
        }
        let item_id = *items.at(i);

        // Check against all other items
        let mut j = i + 1;
        loop {
            if j >= items.len() {
                break;
            }
            let other_item_id = *items.at(j);
            assert!(item_id != other_item_id, "No duplicate items should exist");
            j += 1;
        };
        i += 1;
    };
}

#[test]
fn test_marketplace_different_levels() {
    let adventurer_seed = 11111;

    let items_level_1 = MarketplaceImpl::generate_marketplace_items(1, adventurer_seed);
    let items_level_2 = MarketplaceImpl::generate_marketplace_items(2, adventurer_seed);

    // Different levels should produce different marketplaces
    let mut different = false;
    let mut i = 0;
    loop {
        if i >= items_level_1.len() {
            break;
        }
        if *items_level_1.at(i) != *items_level_2.at(i) {
            different = true;
            break;
        }
        i += 1;
    };

    assert!(different, "Different levels should produce different marketplaces");
}

#[test]
fn test_marketplace_seed_variation() {
    let adventurer_level = 5;

    let items_seed_1 = MarketplaceImpl::generate_marketplace_items(adventurer_level, 1000);
    let items_seed_2 = MarketplaceImpl::generate_marketplace_items(adventurer_level, 2000);

    // Different seeds should produce different marketplaces
    let mut different = false;
    let mut i = 0;
    loop {
        if i >= items_seed_1.len() {
            break;
        }
        if *items_seed_1.at(i) != *items_seed_2.at(i) {
            different = true;
            break;
        }
        i += 1;
    };

    assert!(different, "Different seeds should produce different marketplaces");
}

#[test]
fn test_marketplace_item_availability() {
    let adventurer_level = 7;
    let adventurer_seed = 77777;

    let items = MarketplaceImpl::generate_marketplace_items(adventurer_level, adventurer_seed);

    // Test that an item from the marketplace is available
    let first_item = *items.at(0);
    assert!(MarketplaceImpl::is_item_available(@items, first_item), "Item should be available");

    // Test that an item not in the marketplace is not available
    let mut unavailable_item = 1;
    loop {
        if unavailable_item > NUM_ITEMS {
            break; // All items are in marketplace (shouldn't happen for 21 items)
        }
        if !MarketplaceImpl::is_item_available(@items, unavailable_item) {
            break;
        }
        unavailable_item += 1;
    };

    if unavailable_item <= NUM_ITEMS {
        assert!(
            !MarketplaceImpl::is_item_available(@items, unavailable_item),
            "Item should not be available",
        );
    }
}

#[test]
fn test_marketplace_get_all_items() {
    let all_items = MarketplaceImpl::get_all_items();

    // Should contain all 101 items
    assert!(all_items.len() == NUM_ITEMS.into(), "Should contain all 101 items");

    // Should be sequential from 1 to 101
    let mut i = 0;
    loop {
        if i >= all_items.len() {
            break;
        }
        let expected_item_id = (i + 1).try_into().unwrap();
        assert!(*all_items.at(i) == expected_item_id, "Items should be sequential");
        i += 1;
    };
}

#[test]
fn test_marketplace_size() {
    let size = MarketplaceImpl::get_marketplace_size();
    assert!(size == MARKETPLACE_ITEMS_PER_LEVEL, "Marketplace size should be 21");
}

#[test]
fn test_marketplace_metadata_generation() {
    let adventurer_level = 8;
    let adventurer_seed = 88888;

    let metadata = MarketplaceImpl::generate_marketplace_metadata(
        adventurer_level, adventurer_seed,
    );

    // Should contain at least the header items
    assert!(metadata.len() >= 3, "Should contain header metadata");

    // Check first few elements contain expected headers
    assert!(*metadata.at(0) == 'Marketplace Level ', "First element should be marketplace label");
    assert!(*metadata.at(1) == adventurer_level.into(), "Second element should be level");
    assert!(*metadata.at(2) == ' Items:', "Third element should be items label");
}
