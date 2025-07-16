use ls2_renderer::utils::item_database::{ItemDatabaseTrait, ItemType, ItemSlot, ItemTier, ItemId};

#[test]
fn test_basic_item_database_functionality() {
    // Test pendant (ID 1) - should be jewelry, neck, T1
    let pendant_info = ItemDatabaseTrait::get_item_info(ItemId::Pendant);
    assert(pendant_info.id == ItemId::Pendant, 'Wrong pendant ID');
    assert(pendant_info.item_type == ItemType::Jewelry, 'Wrong pendant type');
    assert(pendant_info.slot == ItemSlot::Neck, 'Wrong pendant slot');
    assert(pendant_info.tier == ItemTier::T1, 'Wrong pendant tier');
    assert(pendant_info.name == 'Pendant', 'Wrong pendant name');
    
    // Test gold ring (ID 8) - should be jewelry, ring, T5
    let gold_ring_info = ItemDatabaseTrait::get_item_info(ItemId::GoldRing);
    assert(gold_ring_info.id == ItemId::GoldRing, 'Wrong gold ring ID');
    assert(gold_ring_info.item_type == ItemType::Jewelry, 'Wrong gold ring type');
    assert(gold_ring_info.slot == ItemSlot::Ring, 'Wrong gold ring slot');
    assert(gold_ring_info.tier == ItemTier::T5, 'Wrong gold ring tier');
    assert(gold_ring_info.name == 'Gold Ring', 'Wrong gold ring name');
    
    // Test katana (ID 42) - should be weapon, weapon, T1
    let katana_info = ItemDatabaseTrait::get_item_info(ItemId::Katana);
    assert(katana_info.id == ItemId::Katana, 'Wrong katana ID');
    assert(katana_info.item_type == ItemType::Weapon, 'Wrong katana type');
    assert(katana_info.slot == ItemSlot::Weapon, 'Wrong katana slot');
    assert(katana_info.tier == ItemTier::T1, 'Wrong katana tier');
    assert(katana_info.name == 'Katana', 'Wrong katana name');
    
    // Test divine robe (ID 17) - should be armor, chest, T1
    let divine_robe_info = ItemDatabaseTrait::get_item_info(ItemId::DivineRobe);
    assert(divine_robe_info.id == ItemId::DivineRobe, 'Wrong divine robe ID');
    assert(divine_robe_info.item_type == ItemType::Armor, 'Wrong divine robe type');
    assert(divine_robe_info.slot == ItemSlot::Chest, 'Wrong divine robe slot');
    assert(divine_robe_info.tier == ItemTier::T1, 'Wrong divine robe tier');
    assert(divine_robe_info.name == 'Divine Robe', 'Wrong divine robe name');
}

#[test]
fn test_item_lookup_functions() {
    // Test individual lookup functions with katana
    let item_id = ItemId::Katana;
    
    assert(ItemDatabaseTrait::get_item_name(item_id) == 'Katana', 'Wrong katana name');
    assert(ItemDatabaseTrait::get_item_type(item_id) == ItemType::Weapon, 'Wrong katana type');
    assert(ItemDatabaseTrait::get_item_slot(item_id) == ItemSlot::Weapon, 'Wrong katana slot');
    assert(ItemDatabaseTrait::get_item_tier(item_id) == ItemTier::T1, 'Wrong katana tier');
}

#[test]
fn test_item_display_generation() {
    // Test display generation - currently just returns item name
    let item_id = ItemId::Katana;
    
    let display = ItemDatabaseTrait::generate_item_display(item_id, 15);
    assert(display == 'Katana', 'Wrong display generation');
}

#[test]
fn test_all_item_ids_valid() {
    // Test that all item IDs from 1 to 101 are valid and return proper info
    let mut id: u8 = 1;
    loop {
        if id > 101 {
            break;
        }
        
        let info = ItemDatabaseTrait::get_item_info(id);
        assert(info.id == id, 'ID mismatch');
        assert(info.name != 0, 'Item name should not be empty');
        assert(info.item_type >= 1 && info.item_type <= 3, 'Invalid item type');
        assert(info.slot >= 1 && info.slot <= 8, 'Invalid slot');
        assert(info.tier >= 1 && info.tier <= 5, 'Invalid tier');
        
        id += 1;
    };
}

#[test]
fn test_item_counts() {
    // Test that we have the correct number of items in each category
    let mut jewelry_count = 0;
    let mut weapon_count = 0;
    let mut armor_count = 0;
    
    let mut id: u8 = 1;
    loop {
        if id > 101 {
            break;
        }
        
        let info = ItemDatabaseTrait::get_item_info(id);
        
        if info.item_type == ItemType::Jewelry {
            jewelry_count += 1;
        } else if info.item_type == ItemType::Weapon {
            weapon_count += 1;
        } else if info.item_type == ItemType::Armor {
            armor_count += 1;
        }
        
        id += 1;
    };
    
    // Verify counts match the requirements
    assert(jewelry_count == 8, 'Should have 8 jewelry items');
    assert(weapon_count == 18, 'Should have 18 weapon items');
    assert(armor_count == 75, 'Should have 75 armor items');
    
    // Total should be 101
    assert(jewelry_count + weapon_count + armor_count == 101, 'Total should be 101 items');
}

#[test]
fn test_invalid_item_handling() {
    // Test that invalid IDs return empty info (no panic)
    let invalid_info = ItemDatabaseTrait::get_item_info(0);
    assert(invalid_info.name == 0, 'Invalid ID empty name');
    
    let invalid_info_high = ItemDatabaseTrait::get_item_info(102);
    assert(invalid_info_high.name == 0, 'Invalid ID empty name');
    
    // Test display generation for invalid IDs  
    let invalid_display = ItemDatabaseTrait::generate_item_display(0, 15);
    assert(invalid_display != 'Katana', 'Invalid ID not Katana');
    
    let invalid_display_high = ItemDatabaseTrait::generate_item_display(102, 15);
    assert(invalid_display_high != 'Katana', 'Invalid ID not Katana');
}