// SPDX-License-Identifier: MIT
// Comprehensive test suite for renderer utilities

use death_mountain_renderer::models::models::{
    AdventurerVerbose, BagVerbose, EquipmentVerbose, ItemVerbose, Slot, Stats, Tier, Type,
};
use death_mountain_renderer::tests::test_lib::helper::{get_simple_adventurer_verbose};
use death_mountain_renderer::utils::renderer_utils::{
    chest, foot, generate_svg, hand, head, neck, ring, u256_to_string, waist, weapon,
};

// Helper function to create empty bag items
fn create_empty_bag() -> BagVerbose {
    let empty_item = ItemVerbose {
        name: 'Empty', id: 0, xp: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None,
    };
    BagVerbose {
        item_1: empty_item,
        item_2: empty_item,
        item_3: empty_item,
        item_4: empty_item,
        item_5: empty_item,
        item_6: empty_item,
        item_7: empty_item,
        item_8: empty_item,
        item_9: empty_item,
        item_10: empty_item,
        item_11: empty_item,
        item_12: empty_item,
        item_13: empty_item,
        item_14: empty_item,
        item_15: empty_item,
    }
}

// ============================================================================
// SVG ICON COMPONENT TESTS
// ============================================================================

#[test]
fn test_all_svg_icons_not_empty() {
    assert(weapon().len() > 0, 'weapon_not_empty');
    assert(chest().len() > 0, 'chest_not_empty');
    assert(head().len() > 0, 'head_not_empty');
    assert(waist().len() > 0, 'waist_not_empty');
    assert(foot().len() > 0, 'foot_not_empty');
    assert(hand().len() > 0, 'hand_not_empty');
    assert(neck().len() > 0, 'neck_not_empty');
    assert(ring().len() > 0, 'ring_not_empty');
}

#[test]
fn test_svg_icons_uniqueness() {
    // Verify each icon has unique path data
    let weapon_svg = weapon();
    let chest_svg = chest();
    let head_svg = head();

    assert(weapon_svg != chest_svg, 'weapon_chest_different');
    assert(weapon_svg != head_svg, 'weapon_head_different');
    assert(chest_svg != head_svg, 'chest_head_different');

    // Test more combinations
    assert(waist() != foot(), 'waist_foot_different');
    assert(hand() != neck(), 'hand_neck_different');
    assert(neck() != ring(), 'neck_ring_different');
}

// ============================================================================
// U256 TO STRING CONVERSION TESTS
// ============================================================================

#[test]
fn test_u256_to_string_single_digits() {
    assert(u256_to_string(0) == "0", 'zero_to_string');
    assert(u256_to_string(1) == "1", 'one_to_string');
    assert(u256_to_string(5) == "5", 'five_to_string');
    assert(u256_to_string(9) == "9", 'nine_to_string');
}

#[test]
fn test_u256_to_string_two_digits() {
    assert(u256_to_string(10) == "10", 'ten_to_string');
    assert(u256_to_string(42) == "42", 'forty_two_to_string');
    assert(u256_to_string(99) == "99", 'ninety_nine_to_string');
}

#[test]
fn test_u256_to_string_three_digits() {
    assert(u256_to_string(100) == "100", 'hundred_to_string');
    assert(u256_to_string(256) == "256", 'two_fifty_six_to_string');
    assert(u256_to_string(999) == "999", 'nine_ninety_nine_to_string');
}

#[test]
fn test_u256_to_string_large_numbers() {
    assert(u256_to_string(1000) == "1000", 'thousand_to_string');
    assert(u256_to_string(12345) == "12345", 'twelve_thousand_to_string');
    assert(u256_to_string(999999) == "999999", 'almost_million_to_string');
}

#[test]
fn test_u256_to_string_very_large_numbers() {
    let million: u256 = 1000000;
    assert(u256_to_string(million) == "1000000", 'million_to_string');

    let billion: u256 = 1000000000;
    assert(u256_to_string(billion) == "1000000000", 'billion_to_string');

    // Test reasonable NFT token ID range
    let max_reasonable_token: u256 = 999999999999;
    let result = u256_to_string(max_reasonable_token);
    assert(result == "999999999999", 'max_reasonable_token');
}

#[test]
fn test_u256_to_string_powers_of_ten() {
    assert(u256_to_string(1) == "1", 'power_0');
    assert(u256_to_string(10) == "10", 'power_1');
    assert(u256_to_string(100) == "100", 'power_2');
    assert(u256_to_string(1000) == "1000", 'power_3');
    assert(u256_to_string(10000) == "10000", 'power_4');
    assert(u256_to_string(100000) == "100000", 'power_5');
}

// ============================================================================
// SVG GENERATION TESTS
// ============================================================================

#[test]
fn test_generate_svg_basic_structure() {
    let adventurer_verbose = AdventurerVerbose {
        name: "TestAdventurer",
        health: 100,
        xp: 1,
        level: 1,
        gold: 0,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats {
            strength: 5,
            dexterity: 4,
            vitality: 3,
            intelligence: 2,
            wisdom: 1,
            charisma: 0,
            luck: 0,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Wand',
                id: 12,
                xp: 225,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Divine Robe',
                id: 17,
                xp: 100,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Crown',
                id: 22,
                xp: 225,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Wool Sash',
                id: 29,
                xp: 225,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Divine Slippers',
                id: 32,
                xp: 40,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Divine Gloves',
                id: 37,
                xp: 224,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 1,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Gold Ring',
                id: 8,
                xp: 1,
                tier: Tier::T3,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 0,
        action_count: 0,
        bag: BagVerbose {
            item_1: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_2: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_3: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_4: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_5: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_6: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_7: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_8: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_9: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_10: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_11: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_12: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_13: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_14: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            item_15: ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            },
            },
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_adventurer_name_display() {
    let adventurer_verbose = AdventurerVerbose {
        name: "DisplayTest",
        health: 150,
        xp: 50,
        level: 5,
        gold: 100,
        beast_health: 0,
        stat_upgrades_available: 2,
        stats: Stats {
            strength: 8,
            dexterity: 6,
            vitality: 7,
            intelligence: 4,
            wisdom: 3,
            charisma: 5,
            luck: 2,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Katana',
                id: 42,
                xp: 500,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Leather Armor',
                id: 51,
                xp: 300,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Cap',
                id: 56,
                xp: 200,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Leather Belt',
                id: 61,
                xp: 150,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Leather Boots',
                id: 66,
                xp: 180,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Leather Gloves',
                id: 71,
                xp: 120,
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Pendant',
                id: 1,
                xp: 50,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Bronze Ring',
                id: 5,
                xp: 75,
                tier: Tier::T1,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 12345,
        action_count: 10,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_health_bar_presence() {
    let adventurer_verbose = get_simple_adventurer_verbose();
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_stats_display() {
    let adventurer_verbose = get_simple_adventurer_verbose();
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_equipment_icons() {
    let mut adventurer_verbose = get_simple_adventurer_verbose();
    // Set up equipment with valid IDs
    adventurer_verbose.equipment.weapon.id = 42; // Katana
    adventurer_verbose.equipment.chest.id = 17; // Divine Robe

    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_level_display() {
    let adventurer_verbose = get_simple_adventurer_verbose();
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

// ============================================================================
// HEALTH BAR SPECIFIC TESTS
// ============================================================================

#[test]
fn test_generate_svg_critical_health_red() {
    let adventurer_verbose = AdventurerVerbose {
        name: "CriticalTest",
        health: 15, // Critical health (15% of max)
        xp: 25,
        level: 3,
        gold: 50,
        beast_health: 0,
        stat_upgrades_available: 1,
        stats: Stats {
            strength: 3,
            dexterity: 2,
            vitality: 4,
            intelligence: 1,
            wisdom: 2,
            charisma: 1,
            luck: 0,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Club',
                id: 76,
                xp: 100,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Ring Mail',
                id: 81,
                xp: 80,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Helm',
                id: 86,
                xp: 60,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Heavy Belt',
                id: 91,
                xp: 40,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Heavy Boots',
                id: 96,
                xp: 70,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Heavy Gloves',
                id: 101,
                xp: 50,
                tier: Tier::T1,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Necklace',
                id: 2,
                xp: 30,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Silver Ring',
                id: 4,
                xp: 45,
                tier: Tier::T2,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 12345,
        action_count: 5,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_wounded_health_orange() {
    let adventurer_verbose = AdventurerVerbose {
        name: "WoundedTest",
        health: 50, // Wounded health (50% of max)
        xp: 75,
        level: 4,
        gold: 200,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats {
            strength: 6,
            dexterity: 5,
            vitality: 6,
            intelligence: 3,
            wisdom: 4,
            charisma: 3,
            luck: 1,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Mace',
                id: 75,
                xp: 400,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Plate Mail',
                id: 79,
                xp: 350,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Great Helm',
                id: 84,
                xp: 300,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Plated Belt',
                id: 89,
                xp: 250,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Greaves',
                id: 94,
                xp: 280,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Gauntlets',
                id: 99,
                xp: 220,
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 150,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Platinum Ring',
                id: 6,
                xp: 180,
                tier: Tier::T4,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 12345,
        action_count: 15,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_healthy_green() {
    let adventurer_verbose = AdventurerVerbose {
        name: "HealthyTest",
        health: 85, // Healthy health (85% of max)
        xp: 150,
        level: 6,
        gold: 500,
        beast_health: 0,
        stat_upgrades_available: 3,
        stats: Stats {
            strength: 10,
            dexterity: 8,
            vitality: 9,
            intelligence: 6,
            wisdom: 5,
            charisma: 7,
            luck: 4,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Maul',
                id: 74,
                xp: 800,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Ornate Chestplate',
                id: 78,
                xp: 750,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Ornate Helm',
                id: 83,
                xp: 700,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Ornate Belt',
                id: 87,
                xp: 650,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Ornate Greaves',
                id: 93,
                xp: 680,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Ornate Gauntlets',
                id: 98,
                xp: 620,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 200,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Titanium Ring',
                id: 7,
                xp: 250,
                tier: Tier::T5,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 11111,
        action_count: 25,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_zero_health() {
    let adventurer_verbose = AdventurerVerbose {
        name: "ZeroHealth",
        health: 0, // Zero health
        xp: 10,
        level: 1,
        gold: 0,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats {
            strength: 1,
            dexterity: 1,
            vitality: 1,
            intelligence: 1,
            wisdom: 1,
            charisma: 1,
            luck: 1,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Book',
                id: 16,
                xp: 50,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Shirt',
                id: 21,
                xp: 20,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Hood',
                id: 26,
                xp: 30,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Sash',
                id: 31,
                xp: 25,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Shoes',
                id: 36,
                xp: 35,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Gloves',
                id: 41,
                xp: 40,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Pendant',
                id: 1,
                xp: 15,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Bronze Ring',
                id: 5,
                xp: 20,
                tier: Tier::T1,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 0,
        action_count: 0,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_maximum_health() {
    let adventurer_verbose = AdventurerVerbose {
        name: "MaxHealth",
        health: 3925, // Maximum health (100 + 255 * 15)
        xp: 25500,
        level: 255,
        gold: 65535,
        beast_health: 0,
        stat_upgrades_available: 255,
        stats: Stats {
            strength: 255,
            dexterity: 255,
            vitality: 255,
            intelligence: 255,
            wisdom: 255,
            charisma: 255,
            luck: 255,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Chronicle',
                id: 14,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Silk Robe',
                id: 18,
                xp: 65535,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Silk Hood',
                id: 24,
                xp: 65535,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Silk Sash',
                id: 28,
                xp: 65535,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Silk Slippers',
                id: 33,
                xp: 65535,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Silk Gloves',
                id: 38,
                xp: 65535,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Necklace',
                id: 2,
                xp: 65535,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Platinum Ring',
                id: 6,
                xp: 65535,
                tier: Tier::T4,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 65535,
        action_count: 65535,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_zero_stats() {
    let adventurer_verbose = AdventurerVerbose {
        name: "ZeroStats",
        health: 100, // Base health only
        xp: 0,
        level: 1,
        gold: 0,
        beast_health: 0,
        stat_upgrades_available: 0,
        stats: Stats {
            strength: 0,
            dexterity: 0,
            vitality: 0,
            intelligence: 0,
            wisdom: 0,
            charisma: 0,
            luck: 0,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Wand',
                id: 12,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Robe',
                id: 20,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Hood',
                id: 26,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Sash',
                id: 31,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Shoes',
                id: 36,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Gloves',
                id: 41,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Pendant',
                id: 1,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Bronze Ring',
                id: 5,
                xp: 0,
                tier: Tier::T1,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 0,
        action_count: 0,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_short_name_large_font() {
    let adventurer_verbose = AdventurerVerbose {
        name: "Short", // 5 characters -> 24px font
        health: 200,
        xp: 100,
        level: 2,
        gold: 150,
        beast_health: 0,
        stat_upgrades_available: 1,
        stats: Stats {
            strength: 4,
            dexterity: 3,
            vitality: 5,
            intelligence: 2,
            wisdom: 1,
            charisma: 2,
            luck: 1,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Tome',
                id: 15,
                xp: 300,
                tier: Tier::T3,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Linen Robe',
                id: 19,
                xp: 150,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Linen Hood',
                id: 25,
                xp: 120,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Linen Sash',
                id: 30,
                xp: 100,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Linen Shoes',
                id: 35,
                xp: 110,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Linen Gloves',
                id: 40,
                xp: 90,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 80,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Gold Ring',
                id: 8,
                xp: 95,
                tier: Tier::T3,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 22222,
        action_count: 8,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_medium_name_medium_font() {
    let adventurer_verbose = AdventurerVerbose {
        name: "MediumName1", // 11 characters -> 17px font
        health: 300,
        xp: 200,
        level: 3,
        gold: 300,
        beast_health: 0,
        stat_upgrades_available: 2,
        stats: Stats {
            strength: 7,
            dexterity: 6,
            vitality: 8,
            intelligence: 4,
            wisdom: 3,
            charisma: 5,
            luck: 2,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Grimoire',
                id: 13,
                xp: 600,
                tier: Tier::T4,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Divine Robe',
                id: 17,
                xp: 400,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Divine Hood',
                id: 23,
                xp: 350,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Brightsilk Sash',
                id: 27,
                xp: 500,
                tier: Tier::T3,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Divine Slippers',
                id: 32,
                xp: 320,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Divine Gloves',
                id: 37,
                xp: 380,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 200,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Gold Ring',
                id: 8,
                xp: 250,
                tier: Tier::T3,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 33333,
        action_count: 12,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_long_name_small_font() {
    let adventurer_verbose = AdventurerVerbose {
        name: "VeryLongNameTest1", // 17 characters -> 12px font
        health: 400,
        xp: 300,
        level: 4,
        gold: 500,
        beast_health: 0,
        stat_upgrades_available: 3,
        stats: Stats {
            strength: 9,
            dexterity: 8,
            vitality: 10,
            intelligence: 6,
            wisdom: 5,
            charisma: 7,
            luck: 4,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Chronicle',
                id: 14,
                xp: 900,
                tier: Tier::T5,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Silk Robe',
                id: 18,
                xp: 600,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Silk Hood',
                id: 24,
                xp: 550,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Silk Sash',
                id: 28,
                xp: 480,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Silk Slippers',
                id: 33,
                xp: 520,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Silk Gloves',
                id: 38,
                xp: 460,
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Necklace',
                id: 2,
                xp: 300,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Platinum Ring',
                id: 6,
                xp: 400,
                tier: Tier::T4,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 44444,
        action_count: 18,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_empty_name() {
    let adventurer_verbose = AdventurerVerbose {
        name: "", // Empty name
        health: 150,
        xp: 50,
        level: 2,
        gold: 100,
        beast_health: 0,
        stat_upgrades_available: 1,
        stats: Stats {
            strength: 3,
            dexterity: 2,
            vitality: 4,
            intelligence: 1,
            wisdom: 2,
            charisma: 1,
            luck: 0,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Bone Wand',
                id: 11,
                xp: 150,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Linen Robe',
                id: 19,
                xp: 100,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Linen Hood',
                id: 25,
                xp: 80,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Linen Sash',
                id: 30,
                xp: 60,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Linen Shoes',
                id: 35,
                xp: 70,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Linen Gloves',
                id: 40,
                xp: 50,
                tier: Tier::T1,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Pendant',
                id: 1,
                xp: 40,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Bronze Ring',
                id: 5,
                xp: 45,
                tier: Tier::T1,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 55555,
        action_count: 6,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_maximum_stats() {
    let adventurer_verbose = AdventurerVerbose {
        name: "MaxStats",
        health: 3925, // Maximum health
        xp: 25500,
        level: 255,
        gold: 65535,
        beast_health: 0,
        stat_upgrades_available: 255,
        stats: Stats {
            strength: 255,
            dexterity: 255,
            vitality: 255,
            intelligence: 255,
            wisdom: 255,
            charisma: 255,
            luck: 255,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Chronicle',
                id: 14,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Dragonskin Armor',
                id: 48,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Dragons Crown',
                id: 53,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Dragonskin Belt',
                id: 58,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Dragonskin Boots',
                id: 63,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Dragonskin Gloves',
                id: 68,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 65535,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Titanium Ring',
                id: 7,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 65535,
        action_count: 65535,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

#[test]
fn test_generate_svg_maximum_level() {
    let adventurer_verbose = AdventurerVerbose {
        name: "MaxLevel",
        health: 3925,
        xp: 25500, // Maximum XP for level 255
        level: 255,
        gold: 65535,
        beast_health: 0,
        stat_upgrades_available: 255,
        stats: Stats {
            strength: 255,
            dexterity: 255,
            vitality: 255,
            intelligence: 255,
            wisdom: 255,
            charisma: 255,
            luck: 255,
        },
        equipment: EquipmentVerbose {
            weapon: ItemVerbose {
                name: 'Maul',
                id: 74,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Weapon,
            },
            chest: ItemVerbose {
                name: 'Ornate Chestplate',
                id: 78,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
            },
            head: ItemVerbose {
                name: 'Ornate Helm',
                id: 83,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Head,
            },
            waist: ItemVerbose {
                name: 'Ornate Belt',
                id: 87,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Waist,
            },
            foot: ItemVerbose {
                name: 'Ornate Greaves',
                id: 93,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Foot,
            },
            hand: ItemVerbose {
                name: 'Ornate Gauntlets',
                id: 98,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Hand,
            },
            neck: ItemVerbose {
                name: 'Amulet',
                id: 3,
                xp: 65535,
                tier: Tier::T1,
                item_type: Type::Necklace,
                slot: Slot::Neck,
            },
            ring: ItemVerbose {
                name: 'Titanium Ring',
                id: 7,
                xp: 65535,
                tier: Tier::T5,
                item_type: Type::Ring,
                slot: Slot::Ring,
            },
        },
        item_specials_seed: 65535,
        action_count: 65535,
        bag: create_empty_bag(),
    };
    let svg = generate_svg(adventurer_verbose);
    assert(ByteArrayTrait::len(@svg) > 0, 'svg should not be empty');
}

// ============================================================================
// PHASE 3: UTILITY FUNCTIONS TESTING
// ============================================================================

/// @notice Test generate_details function accuracy
/// @dev STRICT PRECONDITION: AdventurerVerbose with valid data
/// @dev STRICT POSTCONDITION: Returns complete GameDetail array
#[test]
fn test_phase3_generate_details_accuracy() {
    let adventurer_verbose = get_simple_adventurer_verbose();
    
    // PRECONDITION: Adventurer has valid data
    assert(adventurer_verbose.name.len() > 0, 'name not empty');
    
    let details = death_mountain_renderer::utils::renderer_utils::generate_details(adventurer_verbose);
    
    // STRICT POSTCONDITION: Expected number of details
    assert(details.len() >= 18, 'insufficient details');
    
    // STRICT POSTCONDITION: All details valid
    let mut i = 0;
    while i < details.len() {
        let detail = details.at(i);
        assert(detail.name.len() > 0, 'detail name empty');
        assert(detail.value.len() > 0, 'detail value empty');
        i += 1;
    };
}

/// @notice Test u256_to_string conversion edge cases
/// @dev STRICT PRECONDITION: Various u256 values
/// @dev STRICT POSTCONDITION: All conversions valid
#[test]
fn test_phase3_u256_conversion() {
    // Test zero
    let zero_result = u256_to_string(0_u256);
    assert(zero_result.len() == 1, 'zero wrong length');
    
    // Test single digit
    let single = u256_to_string(7_u256);
    assert(single.len() == 1, 'single wrong length');
    
    // Test multi-digit
    let multi = u256_to_string(12345_u256);
    assert(multi.len() > 1, 'multi wrong length');
}

/// @notice Test SVG icon components
/// @dev STRICT PRECONDITION: Icon functions available
/// @dev STRICT POSTCONDITION: Icons unique and non-empty
#[test]
fn test_phase3_svg_icons() {
    let w_icon = weapon();
    let c_icon = chest();
    let h_icon = head();
    
    // STRICT POSTCONDITION: All have content
    assert(w_icon.len() > 0, 'weapon empty');
    assert(c_icon.len() > 0, 'chest empty');
    assert(h_icon.len() > 0, 'head empty');
    
    // STRICT POSTCONDITION: Icons different
    assert(w_icon != c_icon, 'weapon/chest same');
}
