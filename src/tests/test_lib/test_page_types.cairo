use death_mountain_renderer::models::models::{
    AdventurerVerbose, BagVerbose, EquipmentVerbose, ItemVerbose, Slot, Stats, Tier, Type,
};
use death_mountain_renderer::models::page_types::{BattleState, PageConfig, PageMode, PageType};
use death_mountain_renderer::utils::renderer::page::page_renderer::PageRendererImpl;
use death_mountain_renderer::utils::string::string_utils::starts_with_pattern;

// Helper function to create a test adventurer
fn create_test_adventurer(health: u16, beast_health: u16) -> AdventurerVerbose {
    let stats = Stats {
        strength: 10,
        dexterity: 10,
        vitality: 10,
        intelligence: 10,
        wisdom: 10,
        charisma: 10,
        luck: 10,
    };

    let empty_item = ItemVerbose {
        name: 0, id: 0, xp: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None,
    };

    let equipment = EquipmentVerbose {
        weapon: empty_item,
        chest: empty_item,
        head: empty_item,
        waist: empty_item,
        foot: empty_item,
        hand: empty_item,
        neck: empty_item,
        ring: empty_item,
    };

    let bag = BagVerbose {
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
    };

    AdventurerVerbose {
        name: 'Test Adventurer',
        health,
        xp: 100,
        level: 5,
        gold: 50,
        beast_health,
        stat_upgrades_available: 0,
        stats,
        equipment,
        item_specials_seed: 123,
        action_count: 10,
        bag,
    }
}

#[test]
fn test_page_types_enum() {
    let inventory_page = PageType::Inventory;
    let item_bag_page = PageType::ItemBag;
    let battle_page = PageType::Battle;

    assert!(inventory_page == PageType::Inventory);
    assert!(item_bag_page == PageType::ItemBag);
    assert!(battle_page == PageType::Battle);
}

#[test]
fn test_battle_state_normal() {
    let adventurer = create_test_adventurer(100, 0); // Healthy, no beast
    let battle_state = PageRendererImpl::get_battle_state(adventurer.clone());
    assert_eq!(battle_state, BattleState::Normal, "Should be Normal state");
    assert!(!PageRendererImpl::is_battle_mode(adventurer), "Should not be in battle mode");
}

#[test]
fn test_battle_state_in_combat() {
    let adventurer = create_test_adventurer(100, 50); // Healthy, fighting beast
    let battle_state = PageRendererImpl::get_battle_state(adventurer.clone());
    assert_eq!(battle_state, BattleState::InCombat, "Should be InCombat state");
    assert!(PageRendererImpl::is_battle_mode(adventurer), "Should be in battle mode");
}

#[test]
fn test_battle_state_dead() {
    let adventurer = create_test_adventurer(0, 0); // Dead, no beast
    let battle_state = PageRendererImpl::get_battle_state(adventurer.clone());
    assert_eq!(battle_state, BattleState::Dead, "Should be Dead state");
    assert!(PageRendererImpl::is_battle_mode(adventurer), "Should be in battle mode when dead");
}

#[test]
fn test_page_mode_normal() {
    let adventurer = create_test_adventurer(100, 0); // Normal state
    let page_mode = PageRendererImpl::get_page_mode(adventurer);
    match page_mode {
        PageMode::Normal(count) => assert_eq!(count, 2, "Should have 2 pages in normal mode"),
        PageMode::BattleOnly => panic(array!['Should not be BattleOnly']),
    }
}

#[test]
fn test_page_mode_battle_only() {
    let adventurer = create_test_adventurer(100, 50); // In combat
    let page_mode = PageRendererImpl::get_page_mode(adventurer);
    match page_mode {
        PageMode::BattleOnly => (), // Expected
        PageMode::Normal(_) => panic(array!['Should be BattleOnly']),
    }
}

#[test]
fn test_page_config_default() {
    let config: PageConfig = Default::default();
    assert_eq!(config.page_type, PageType::Inventory, "Default page type should be Inventory");
    assert_eq!(config.transition_duration, 500, "Default transition duration should be 500ms");
    assert!(config.auto_advance, "Default auto_advance should be true");
}

#[test]
fn test_render_animated_pages() {
    let adventurer = create_test_adventurer(100, 0);
    let result = PageRendererImpl::render_animated_pages(1, adventurer);

    // Should return a non-empty ByteArray (Base64 encoded JSON)
    assert!(result.len() > 0, "Should return non-empty result");

    // Should contain "data:application/json;base64," prefix using string utils
    let expected_prefix = "data:application/json;base64,";
    assert!(
        starts_with_pattern(@result, @expected_prefix), "Should have correct JSON data URI prefix",
    );
}
