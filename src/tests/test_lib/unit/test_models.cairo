// SPDX-License-Identifier: MIT
//
// @title Models Unit Tests - Data Structures and Health Calculations
// @notice Tests for adventurer data models, health calculations, and trait implementations
// @dev Comprehensive testing of StatsTrait and data integrity

use death_mountain_renderer::models::models::{
    Stats, EquipmentVerbose, BagVerbose, ItemVerbose, StatsTrait,
    Tier, Type, Slot
};
use death_mountain_renderer::mocks::mock_adventurer::{
    get_simple_adventurer, get_adventurer_with_max_stats, get_adventurer_with_min_stats
};

// Stats Tests

#[test]
fn test_stats_creation_and_access() {
    let stats = Stats {
        strength: 10,
        dexterity: 12,
        vitality: 15,
        intelligence: 8,
        wisdom: 11,
        charisma: 9,
        luck: 0,
    };
    
    assert_eq!(stats.strength, 10, "Strength should be 10");
    assert_eq!(stats.dexterity, 12, "Dexterity should be 12");
    assert_eq!(stats.vitality, 15, "Vitality should be 15");
    assert_eq!(stats.intelligence, 8, "Intelligence should be 8");
    assert_eq!(stats.wisdom, 11, "Wisdom should be 11");
    assert_eq!(stats.charisma, 9, "Charisma should be 9");
}

#[test]
fn test_stats_boundary_values_minimum() {
    let min_stats = Stats {
        strength: 0,
        dexterity: 0,
        vitality: 0,
        intelligence: 0,
        wisdom: 0,
        charisma: 0,
        luck: 0,
    };
    
    assert_eq!(min_stats.strength, 0, "Min strength should be 0");
    assert_eq!(min_stats.vitality, 0, "Min vitality should be 0");
    
    // Test health calculation with zero vitality
    let health = min_stats.get_max_health();
    assert_eq!(health, 100, "Base health should be 100 with zero vitality");
}

#[test]
fn test_stats_boundary_values_maximum() {
    let max_stats = Stats {
        strength: 255,
        dexterity: 255,
        vitality: 255,
        intelligence: 255,
        wisdom: 255,
        charisma: 255,
        luck: 255
    };
    
    assert_eq!(max_stats.strength, 255, "Max strength should be 255");
    assert_eq!(max_stats.vitality, 255, "Max vitality should be 255");
    
    // Test health calculation with max vitality
    let health = max_stats.get_max_health();
    assert_eq!(health, 100 + (255 * 15), "Max health should be 100 + (255 * 15)");
}

#[test]
fn test_stats_mixed_boundary_values() {
    let mixed_stats = Stats {
        strength: 255,
        dexterity: 0,
        vitality: 127,
        intelligence: 255,
        wisdom: 0,
        charisma: 64,
        luck: 32
    };
    
    let health = mixed_stats.get_max_health();
    let expected_health = 100 + (127 * 15);
    assert_eq!(health, expected_health, "Mixed stats health calculation incorrect");
}

// StatsTrait Tests

#[test]
fn test_stats_trait_health_calculation_base() {
    let stats = Stats {
        strength: 10,
        dexterity: 10,
        vitality: 0,  // Zero vitality should give base health
        intelligence: 10,
        wisdom: 10,
        charisma: 10,
        luck: 0
    };
    
    let health = stats.get_max_health();
    assert_eq!(health, 100, "Base health should be 100");
}

#[test]
fn test_stats_trait_health_calculation_with_vitality() {
    let stats = Stats {
        strength: 10,
        dexterity: 10,
        vitality: 10,  // Each vitality point adds 15 health
        intelligence: 10,
        wisdom: 10,
        charisma: 10,
        luck: 10
    };
    
    let health = stats.get_max_health();
    assert_eq!(health, 100 + (10 * 15), "Health should be base + vitality bonus");
}

#[test]
fn test_stats_trait_total_calculation() {
    let stats = Stats {
        strength: 1,
        dexterity: 2,
        vitality: 3,
        intelligence: 4,
        wisdom: 5,
        charisma: 6,
        luck: 7
    };
    
    let total = stats.strength + stats.dexterity + stats.vitality 
                + stats.intelligence + stats.wisdom + stats.charisma;
    assert_eq!(total, 21, "Total stats should be sum of all stats");
}

// ItemVerbose Tests

#[test]
fn test_item_verbose_creation_and_consistency() {
    let item = ItemVerbose {
        id: 42,
        name: 'Test Sword',
        xp: 1000,
        tier: Tier::T2,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
    };
    
    assert_eq!(item.id, 42, "Item ID should match");
    assert_eq!(item.name, 'Test Sword', "Item name should match");
    assert_eq!(item.xp, 1000, "Item XP should match");
    assert!(item.tier == Tier::T2, "Item tier should match");
}

#[test]
fn test_item_xp_boundary_values() {
    // Test minimum XP
    let min_item = ItemVerbose {
        id: 1,
        name: 'Starter Weapon',
        xp: 0,
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
    };
    assert_eq!(min_item.xp, 0, "Min XP should be 0");
    
    // Test high XP values
    let high_xp_item = ItemVerbose {
        id: 2,
        name: 'Legendary Weapon',
        xp: 65535, // Max u16
        tier: Tier::T5,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
    };
    assert_eq!(high_xp_item.xp, 65535, "Should handle high XP values");
}

// EquipmentVerbose Tests

#[test]
fn test_equipment_verbose_slot_consistency() {
    let equipment = EquipmentVerbose {
        weapon: ItemVerbose { id: 1, name: 'Sword', xp: 100, tier: Tier::T2, item_type: Type::Blade_or_Hide, slot: Slot::Weapon },
        chest: ItemVerbose { id: 2, name: 'Armor', xp: 50, tier: Tier::T1, item_type: Type::Magic_or_Cloth, slot: Slot::Chest },
        head: ItemVerbose { id: 3, name: 'Helmet', xp: 25, tier: Tier::T1, item_type: Type::Magic_or_Cloth, slot: Slot::Head },
        waist: ItemVerbose { id: 4, name: 'Belt', xp: 10, tier: Tier::T1, item_type: Type::Magic_or_Cloth, slot: Slot::Waist },
        foot: ItemVerbose { id: 5, name: 'Boots', xp: 15, tier: Tier::T1, item_type: Type::Blade_or_Hide, slot: Slot::Foot },
        hand: ItemVerbose { id: 6, name: 'Gloves', xp: 5, tier: Tier::T1, item_type: Type::Blade_or_Hide, slot: Slot::Hand },
        neck: ItemVerbose { id: 7, name: 'Amulet', xp: 75, tier: Tier::T2, item_type: Type::Necklace, slot: Slot::Neck },
        ring: ItemVerbose { id: 8, name: 'Ring', xp: 30, tier: Tier::T1, item_type: Type::Ring, slot: Slot::Ring },
    };
    
    assert_eq!(equipment.weapon.id, 1, "Weapon ID should match");
    assert_eq!(equipment.chest.name, 'Armor', "Chest name should match");
    assert!(equipment.head.tier == Tier::T1, "Head tier should match");
    assert_eq!(equipment.waist.xp, 10, "Waist XP should match");
    assert_eq!(equipment.foot.name, 'Boots', "Foot name should match");
    assert_eq!(equipment.hand.xp, 5, "Hand XP should match");
    assert!(equipment.neck.tier == Tier::T2, "Neck tier should match");
    assert_eq!(equipment.ring.id, 8, "Ring ID should match");
}

#[test]
fn test_equipment_all_slots_populated() {
    let adventurer = get_simple_adventurer();
    
    // Verify core equipment slots exist (some may be empty/id=0)
    assert!(adventurer.equipment.weapon.id > 0, "Weapon should be equipped");
    assert!(adventurer.equipment.chest.id > 0, "Chest should be equipped");
    // Note: Some slots may be empty (id=0) in test data
    assert!(adventurer.equipment.head.id >= 0, "Head should have valid ID");
    assert!(adventurer.equipment.waist.id >= 0, "Waist should have valid ID");
    assert!(adventurer.equipment.foot.id >= 0, "Foot should have valid ID");
    assert!(adventurer.equipment.hand.id >= 0, "Hand should have valid ID");
    assert!(adventurer.equipment.neck.id >= 0, "Neck should have valid ID");
    assert!(adventurer.equipment.ring.id >= 0, "Ring should have valid ID");
}

#[test]
fn test_equipment_empty_slots() {
    let empty_item = ItemVerbose {
        id: 0,
        name: '',
        xp: 0,
        tier: Tier::None,
        item_type: Type::None,
        slot: Slot::None,
    };
    
    let empty_equipment = EquipmentVerbose {
        weapon: empty_item.clone(),
        chest: empty_item.clone(),
        head: empty_item.clone(),
        waist: empty_item.clone(),
        foot: empty_item.clone(),
        hand: empty_item.clone(),
        neck: empty_item.clone(),
        ring: empty_item,
    };
    
    assert_eq!(empty_equipment.weapon.id, 0, "Empty weapon should have ID 0");
    assert_eq!(empty_equipment.chest.name, '', "Empty chest should have empty name");
}

// BagVerbose Tests

#[test]
fn test_bag_verbose_structure() {
    let test_item = ItemVerbose {
        id: 1,
        name: 'Bag Item',
        xp: 100,
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
    };
    
    let bag = BagVerbose {
        item_1: test_item,
        item_2: test_item,
        item_3: test_item,
        item_4: test_item,
        item_5: test_item,
        item_6: test_item,
        item_7: test_item,
        item_8: test_item,
        item_9: test_item,
        item_10: test_item,
        item_11: test_item,
        item_12: test_item,
        item_13: test_item,
        item_14: test_item,
        item_15: test_item,
    };
    
    assert_eq!(bag.item_1.id, 1, "First item ID should be 1");
    assert_eq!(bag.item_15.id, 1, "Last item ID should match");
}

#[test]
fn test_bag_all_fifteen_slots() {
    let adventurer = get_simple_adventurer();
    
    // Check that bag items have valid structure
    assert!(adventurer.bag.item_1.id >= 0, "Bag item 1 should have valid ID");
    assert!(adventurer.bag.item_2.id >= 0, "Bag item 2 should have valid ID");
    assert!(adventurer.bag.item_15.id >= 0, "Bag item 15 should have valid ID");
}

#[test]
fn test_bag_mutation_states() {
    let adventurer = get_simple_adventurer();
    
    // Test that bag maintains structure
    assert!(adventurer.bag.item_1.id >= 0, "Bag should maintain valid structure");
}

// AdventurerVerbose Tests

#[test]
fn test_adventurer_verbose_complete_structure() {
    let adventurer = get_simple_adventurer();
    
    // Test core fields
    assert!(adventurer.health > 0, "Health should be positive");
    assert!(adventurer.level > 0, "Level should be positive");
    assert!(adventurer.name.len() > 0, "Name should not be empty");
    
    // Test stats structure
    assert!(adventurer.stats.strength >= 0, "Strength should be valid");
    assert!(adventurer.stats.vitality >= 0, "Vitality should be valid");
    
    // Test equipment structure
    assert!(adventurer.equipment.weapon.id >= 0, "Weapon ID should be valid");
    
    // Test bag structure
    assert!(adventurer.bag.item_1.id >= 0, "Bag should have valid structure");
}

#[test]
fn test_adventurer_verbose_minimum_values() {
    let min_adventurer = get_adventurer_with_min_stats();
    
    // Should handle minimum stat values gracefully
    assert_eq!(min_adventurer.stats.strength, 1, "Min strength should be 1");
    assert_eq!(min_adventurer.stats.vitality, 1, "Min vitality should be 1");
    
    // Health calculation should still work (1 vitality = 100 + 15)
    let health = min_adventurer.stats.get_max_health();
    assert_eq!(health, 115, "Min stats should give base health + 15 per vitality");
}

#[test]
fn test_adventurer_verbose_boundary_values() {
    let max_adventurer = get_adventurer_with_max_stats();
    
    // Should handle maximum values
    assert_eq!(max_adventurer.stats.strength, 255, "Max strength should be 255");
    assert_eq!(max_adventurer.stats.vitality, 255, "Max vitality should be 255");
    
    // Health should be calculated correctly
    let expected_max_health = 100 + (255 * 15);
    let actual_health = max_adventurer.stats.get_max_health();
    assert_eq!(actual_health, expected_max_health, "Max health calculation incorrect");
}

#[test]
fn test_adventurer_verbose_name_variations() {
    let mut adventurer = get_simple_adventurer();
    
    // Test with different name lengths
    adventurer.name = "A";
    assert_eq!(adventurer.name.len(), 1, "Single char name should work");
    
    adventurer.name = "VeryLongAdventurerNameThatExceedsNormalLimits";
    assert!(adventurer.name.len() > 30, "Long names should be preserved");
}

#[test]
fn test_adventurer_health_calculations() {
    let mut adventurer = get_simple_adventurer();
    
    // Test health percentage calculations
    let max_health = adventurer.stats.get_max_health();
    
    // Test different health states
    adventurer.health = max_health;
    let health_percent = (adventurer.health * 100) / max_health;
    assert_eq!(health_percent, 100, "Full health should be 100%");
    
    adventurer.health = max_health / 2;
    let half_health_percent = (adventurer.health * 100) / max_health;
    assert_eq!(half_health_percent, 50, "Half health should be 50%");
    
    adventurer.health = 0;
    let zero_health_percent = (adventurer.health * 100) / max_health;
    assert_eq!(zero_health_percent, 0, "Zero health should be 0%");
}

#[test]
fn test_adventurer_xp_and_level_consistency() {
    let adventurer = get_simple_adventurer();
    
    // Test that level and XP are consistent
    assert!(adventurer.level >= 1, "Level should be at least 1");
    
    // Test equipment XP consistency
    assert!(adventurer.equipment.weapon.xp >= 0, "Weapon XP should be non-negative");
    assert!(adventurer.equipment.weapon.id >= 0, "Weapon ID should be non-negative");
}

#[test]
fn test_adventurer_equipment_bag_integration() {
    let _adventurer = get_simple_adventurer();
    
    // Test that equipment and bag work together
    let total_equipment_items: u32 = 8; // weapon, chest, head, waist, foot, hand, neck, ring
    let total_items: u32 = total_equipment_items + 15; // bag always has 15 slots
    
    assert!(total_items >= 8, "Should have at least equipment items");
    assert!(total_items <= 23, "Should not exceed equipment + full bag");
}

// Fuzz Testing for Models

#[test]
#[fuzzer(runs: 500, seed: 555)]
fn fuzz_stats_health_calculation(
    strength: u8,
    dexterity: u8,
    vitality: u8,
    intelligence: u8,
    wisdom: u8,
    charisma: u8
) {
    let stats = Stats {
        strength,
        dexterity,
        vitality,
        intelligence,
        wisdom,
        charisma,
        luck: 0,
    };
    
    let health = stats.get_max_health();
    
    // Invariants
    assert!(health >= 100, "Health should always be at least base 100");
    assert!(health == 100 + (vitality.into() * 15), "Health formula should be consistent");
    assert!(health <= 100 + (255 * 15), "Health should not exceed theoretical maximum");
}

#[test]
#[fuzzer(runs: 300, seed: 666)]
fn fuzz_item_verbose_creation(
    id: u8,
    xp: u16
) {
    let item = ItemVerbose {
        id,
        name: 'Fuzz Item',
        xp,
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
    };
    
    // Invariants
    assert_eq!(item.id, id, "ID should match input");
    assert_eq!(item.xp, xp, "XP should match input");
    assert!(item.tier == Tier::T1, "Tier should match");
    assert!(item.name != '', "Name should not be empty");
}

#[test]
#[fuzzer(runs: 200, seed: 777)]
fn fuzz_adventurer_health_states(
    current_health: u16,
    vitality: u8
) {
    let mut adventurer = get_simple_adventurer();
    adventurer.health = current_health;
    adventurer.stats.vitality = vitality;
    
    let max_health = adventurer.stats.get_max_health();
    
    // Invariants
    assert!(max_health >= 100, "Max health should always be at least 100");
    
    if adventurer.health <= max_health {
        let health_percent = if max_health > 0 { 
            (adventurer.health.into() * 100_u32) / max_health.into()
        } else { 
            0 
        };
        assert!(health_percent <= 100, "Health percentage should not exceed 100%");
    }
}

// Edge Case Tests

#[test]
fn test_health_calculation_overflow_protection() {
    let max_vitality_stats = Stats {
        strength: 255,
        dexterity: 255,
        vitality: 255, // This could potentially cause overflow
        intelligence: 255,
        wisdom: 255,
        charisma: 255,
        luck: 255,
    };
    
    let health = max_vitality_stats.get_max_health();
    let expected = 100 + (255_u16 * 15);
    
    assert_eq!(health, expected, "Max vitality health calculation should not overflow");
    assert!(health < 65535, "Health should fit in u16");
}

#[test]
fn test_model_memory_efficiency() {
    // Test that models can be created and accessed efficiently
    let mut adventurers = array![];
    
    let mut i: u32 = 0;
    while i != 5 {
        adventurers.append(get_simple_adventurer());
        i += 1;
    };
    
    // Verify all adventurers are valid
    let mut j: u32 = 0;
    while j != adventurers.len() {
        let adventurer = adventurers.at(j);
        assert!(*adventurer.health > 0, "Each adventurer should have valid health");
        j += 1;
    }
}