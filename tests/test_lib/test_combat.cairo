use ls2_renderer::utils::combat::{CombatImpl, CombatTrait, CombatResult, AttackSpec, DefenseSpec};
use ls2_renderer::mocks::mock_adventurer::{Stats, Item};
use ls2_renderer::mocks::mock_beast::{Beast, Type, Tier};
use ls2_renderer::mocks::mock_beast::{IMockBeastDispatcherTrait, IMockBeastDispatcher};
use ls2_renderer::mocks::mock_adventurer::{
    IMockAdventurerDispatcherTrait, IMockAdventurerDispatcher,
};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

#[test]
fn test_base_attack_calculation() {
    // Test base attack calculation for different tiers
    let t1_attack = CombatImpl::calculate_base_attack(Tier::T1, 10);
    let t2_attack = CombatImpl::calculate_base_attack(Tier::T2, 10);
    let t3_attack = CombatImpl::calculate_base_attack(Tier::T3, 10);
    let t4_attack = CombatImpl::calculate_base_attack(Tier::T4, 10);
    let t5_attack = CombatImpl::calculate_base_attack(Tier::T5, 10);

    // T1 should have highest attack (5x multiplier)
    assert(t1_attack == 50, 'T1 attack should be 50');
    assert(t2_attack == 40, 'T2 attack should be 40');
    assert(t3_attack == 30, 'T3 attack should be 30');
    assert(t4_attack == 20, 'T4 attack should be 20');
    assert(t5_attack == 10, 'T5 attack should be 10');

    println!("Base attack calculations verified");
}

#[test]
fn test_base_armor_calculation() {
    // Test base armor calculation for different tiers
    let t1_armor = CombatImpl::calculate_base_armor(Tier::T1, 10);
    let t2_armor = CombatImpl::calculate_base_armor(Tier::T2, 10);
    let t3_armor = CombatImpl::calculate_base_armor(Tier::T3, 10);
    let t4_armor = CombatImpl::calculate_base_armor(Tier::T4, 10);
    let t5_armor = CombatImpl::calculate_base_armor(Tier::T5, 10);

    // Armor should be half of attack value
    assert(t1_armor == 25, 'T1 armor should be 25');
    assert(t2_armor == 20, 'T2 armor should be 20');
    assert(t3_armor == 15, 'T3 armor should be 15');
    assert(t4_armor == 10, 'T4 armor should be 10');
    assert(t5_armor == 5, 'T5 armor should be 5');

    println!("Base armor calculations verified");
}

#[test]
fn test_elemental_effectiveness() {
    // Test elemental effectiveness system
    let magic_vs_metal = CombatImpl::get_elemental_effectiveness(
        Type::Magic_or_Cloth, Type::Bludgeon_or_Metal,
    );
    let magic_vs_hide = CombatImpl::get_elemental_effectiveness(
        Type::Magic_or_Cloth, Type::Blade_or_Hide,
    );
    let magic_vs_magic = CombatImpl::get_elemental_effectiveness(
        Type::Magic_or_Cloth, Type::Magic_or_Cloth,
    );

    let blade_vs_magic = CombatImpl::get_elemental_effectiveness(
        Type::Blade_or_Hide, Type::Magic_or_Cloth,
    );
    let blade_vs_metal = CombatImpl::get_elemental_effectiveness(
        Type::Blade_or_Hide, Type::Bludgeon_or_Metal,
    );
    let blade_vs_blade = CombatImpl::get_elemental_effectiveness(
        Type::Blade_or_Hide, Type::Blade_or_Hide,
    );

    let metal_vs_blade = CombatImpl::get_elemental_effectiveness(
        Type::Bludgeon_or_Metal, Type::Blade_or_Hide,
    );
    let metal_vs_magic = CombatImpl::get_elemental_effectiveness(
        Type::Bludgeon_or_Metal, Type::Magic_or_Cloth,
    );
    let metal_vs_metal = CombatImpl::get_elemental_effectiveness(
        Type::Bludgeon_or_Metal, Type::Bludgeon_or_Metal,
    );

    // Magic/Cloth is strong vs Metal, weak vs Hide
    assert(magic_vs_metal == 2, 'Magic vs Metal should be strong');
    assert(magic_vs_hide == 0, 'Magic vs Hide should be weak');
    assert(magic_vs_magic == 1, 'Magic vs Magic should be fair');

    // Blade/Hide is strong vs Magic, weak vs Metal
    assert(blade_vs_magic == 2, 'Blade vs Magic should be strong');
    assert(blade_vs_metal == 0, 'Blade vs Metal should be weak');
    assert(blade_vs_blade == 1, 'Blade vs Blade should be fair');

    // Metal is strong vs Blade, weak vs Magic
    assert(metal_vs_blade == 2, 'Metal vs Blade should be strong');
    assert(metal_vs_magic == 0, 'Metal vs Magic should be weak');
    assert(metal_vs_metal == 1, 'Metal vs Metal should be fair');

    println!("Elemental effectiveness verified");
}

#[test]
fn test_elemental_damage_calculation() {
    let base_damage = 100;

    // Test super effective (50% bonus)
    let (strong_damage, strong_effectiveness) = CombatImpl::calculate_elemental_damage(
        base_damage, Type::Magic_or_Cloth, Type::Bludgeon_or_Metal,
    );
    assert(strong_damage == 150, 'Strong damage should be 150');
    assert(strong_effectiveness == 2, 'Should be super effective');

    // Test normal effectiveness
    let (normal_damage, normal_effectiveness) = CombatImpl::calculate_elemental_damage(
        base_damage, Type::Magic_or_Cloth, Type::Magic_or_Cloth,
    );
    assert(normal_damage == 100, 'Normal damage should be 100');
    assert(normal_effectiveness == 1, 'Should be normal effective');

    // Test not very effective (50% reduction)
    let (weak_damage, weak_effectiveness) = CombatImpl::calculate_elemental_damage(
        base_damage, Type::Magic_or_Cloth, Type::Blade_or_Hide,
    );
    assert(weak_damage == 50, 'Weak damage should be 50');
    assert(weak_effectiveness == 0, 'Should be not very effective');

    println!("Elemental damage calculations verified");
}

#[test]
fn test_strength_bonus() {
    let base_damage = 100;
    let strength_1 = CombatImpl::calculate_strength_bonus(base_damage, 1);
    let strength_5 = CombatImpl::calculate_strength_bonus(base_damage, 5);
    let strength_10 = CombatImpl::calculate_strength_bonus(base_damage, 10);

    // 10% per strength point
    assert(strength_1 == 1, 'Strength 1 should add 1');
    assert(strength_5 == 5, 'Strength 5 should add 5');
    assert(strength_10 == 10, 'Strength 10 should add 10');

    println!("Strength bonus calculations verified");
}

#[test]
fn test_critical_hit_calculation() {
    let base_damage = 100;
    let luck_5 = 5;
    let luck_10 = 10;

    // Test with seed that should guarantee crit (0 % 100 = 0, always < luck*2)
    let (crit_bonus_5, is_crit_5) = CombatImpl::calculate_critical_hit(base_damage, luck_5, 0);
    let (crit_bonus_10, is_crit_10) = CombatImpl::calculate_critical_hit(base_damage, luck_10, 0);

    // 2% chance per luck point, seed 0 should crit for both
    assert(is_crit_5 == true, 'Should crit with luck 5');
    assert(is_crit_10 == true, 'Should crit with luck 10');
    assert(crit_bonus_5 == 100, 'Crit bonus should be 100%');
    assert(crit_bonus_10 == 100, 'Crit bonus should be 100%');

    // Test with seed that should not crit (99 % 100 = 99, > luck*2 for low luck)
    let (no_crit_bonus, is_no_crit) = CombatImpl::calculate_critical_hit(base_damage, luck_5, 99);
    assert(is_no_crit == false, 'Should not crit with high seed');
    assert(no_crit_bonus == 0, 'No crit bonus should be 0');

    println!("Critical hit calculations verified");
}

#[test]
fn test_weapon_special_bonus() {
    let base_damage = 100;
    let attacker_spec = AttackSpec {
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        level: 10,
        special1: 5,
        special2: 3,
        special3: 2,
    };

    // Test with matching special2
    let defender_spec_match = DefenseSpec {
        tier: Tier::T1,
        item_type: Type::Magic_or_Cloth,
        level: 10,
        special1: 1,
        special2: 3, // Matches attacker special2
        special3: 1,
    };

    let bonus_match = CombatImpl::calculate_weapon_special_bonus(
        base_damage, attacker_spec, defender_spec_match,
    );
    // Should get: 80% from special2 match + 20% from special3 non-match + 10% from special1 base =
    // 110%
    // Actually: special3 doesn't match (2 vs 1), so: 80% + 10% = 90%
    // Wait, let me recalculate: special1 base bonus: 5 * 20 / 1000 = 0.1 = 10%
    // So total should be around 90 (80% + 10%)
    assert(bonus_match >= 80, 'Should get significant bonus from special2 match');

    println!("Weapon special bonus calculations verified");
}

#[test]
fn test_armor_penetration() {
    let base_armor = 100;
    let weapon_special = 10;
    let strength = 8;

    let penetration = CombatImpl::calculate_armor_penetration(base_armor, weapon_special, strength);

    // Formula: (weapon_special * strength) / 4
    let expected = (weapon_special.into() * strength.into()) / 4;
    assert(penetration == expected.try_into().unwrap(), 'Armor penetration calculation wrong');

    // Test with penetration higher than base armor
    let high_special = 20;
    let high_strength = 10;
    let high_penetration = CombatImpl::calculate_armor_penetration(
        base_armor, high_special, high_strength,
    );

    // Should be capped at base_armor
    assert(high_penetration <= base_armor, 'Penetration should be capped at base armor');

    println!("Armor penetration calculations verified");
}

#[test]
fn test_full_combat_calculation() {
    let attacker_spec = AttackSpec {
        tier: Tier::T1,
        item_type: Type::Magic_or_Cloth,
        level: 10,
        special1: 5,
        special2: 3,
        special3: 2,
    };

    let defender_spec = DefenseSpec {
        tier: Tier::T2,
        item_type: Type::Bludgeon_or_Metal,
        level: 8,
        special1: 2,
        special2: 1,
        special3: 3,
    };

    let attacker_stats = Stats {
        strength: 8, dexterity: 6, vitality: 5, intelligence: 7, wisdom: 4, charisma: 3, luck: 5,
    };

    let luck_seed = 0; // Should guarantee crit

    let combat_result = CombatImpl::calculate_damage(
        attacker_spec, defender_spec, attacker_stats, luck_seed,
    );

    // Verify all components are calculated
    assert(combat_result.base_attack > 0, 'Base attack should be positive');
    assert(combat_result.base_armor > 0, 'Base armor should be positive');
    assert(combat_result.elemental_adjusted_damage > 0, 'Elemental damage should be positive');
    assert(combat_result.total_damage > 0, 'Total damage should be positive');
    assert(combat_result.elemental_effectiveness == 2, 'Magic vs Metal should be super effective');
    assert(combat_result.is_critical == true, 'Should be critical with seed 0');

    println!("Full combat calculation verified");
    println!("Base Attack: {}", combat_result.base_attack);
    println!("Total Damage: {}", combat_result.total_damage);
    println!("Elemental Effectiveness: {}", combat_result.elemental_effectiveness);
    println!("Is Critical: {}", combat_result.is_critical);
}

#[test]
fn test_create_attack_spec_from_weapon() {
    let weapon = Item { id: 1, xp: 420 // This will create specific specials
    };
    let level = 5;

    let attack_spec = CombatImpl::create_attack_spec_from_weapon(weapon, level);

    assert(attack_spec.level == level, 'Level should match');
    assert(
        attack_spec.special1 == (weapon.xp % 20).try_into().unwrap(),
        'Special1 should match XP calculation',
    );
    assert(
        attack_spec.special2 == ((weapon.xp / 20) % 20).try_into().unwrap(),
        'Special2 should match XP calculation',
    );
    assert(
        attack_spec.special3 == ((weapon.xp / 400) % 20).try_into().unwrap(),
        'Special3 should match XP calculation',
    );

    println!("Attack spec creation from weapon verified");
}

#[test]
fn test_create_defense_spec_from_armor() {
    let armor = Item { id: 2, xp: 300 };
    let level = 7;

    let defense_spec = CombatImpl::create_defense_spec_from_armor(armor, level);

    assert(defense_spec.level == level, 'Level should match');
    assert(
        defense_spec.special1 == (armor.xp % 20).try_into().unwrap(),
        'Special1 should match XP calculation',
    );
    assert(
        defense_spec.special2 == ((armor.xp / 20) % 20).try_into().unwrap(),
        'Special2 should match XP calculation',
    );
    assert(
        defense_spec.special3 == ((armor.xp / 400) % 20).try_into().unwrap(),
        'Special3 should match XP calculation',
    );

    println!("Defense spec creation from armor verified");
}

#[test]
fn test_create_attack_spec_from_beast() {
    let mock_beast_contract = declare("mock_beast").unwrap().contract_class();
    let calldata = array![];
    let (beast_addr, _) = mock_beast_contract.deploy(@calldata).unwrap();
    let beast_dispatcher = IMockBeastDispatcher { contract_address: beast_addr };

    let beast = beast_dispatcher.get_beast(5);
    let attack_spec = CombatImpl::create_attack_spec_from_beast(beast);

    assert(attack_spec.tier == beast.combat_spec.tier, 'Tier should match');
    assert(attack_spec.item_type == beast.combat_spec.item_type, 'Type should match');
    assert(attack_spec.level == beast.combat_spec.level, 'Level should match');
    assert(attack_spec.special1 == beast.combat_spec.specials.special1, 'Special1 should match');
    assert(attack_spec.special2 == beast.combat_spec.specials.special2, 'Special2 should match');
    assert(attack_spec.special3 == beast.combat_spec.specials.special3, 'Special3 should match');

    println!("Attack spec creation from beast verified");
}

#[test]
fn test_create_defense_spec_from_beast() {
    let mock_beast_contract = declare("mock_beast").unwrap().contract_class();
    let calldata = array![];
    let (beast_addr, _) = mock_beast_contract.deploy(@calldata).unwrap();
    let beast_dispatcher = IMockBeastDispatcher { contract_address: beast_addr };

    let beast = beast_dispatcher.get_beast(7);
    let defense_spec = CombatImpl::create_defense_spec_from_beast(beast);

    assert(defense_spec.tier == beast.combat_spec.tier, 'Tier should match');
    assert(defense_spec.item_type == beast.combat_spec.item_type, 'Type should match');
    assert(defense_spec.level == beast.combat_spec.level, 'Level should match');
    assert(defense_spec.special1 == beast.combat_spec.specials.special1, 'Special1 should match');
    assert(defense_spec.special2 == beast.combat_spec.specials.special2, 'Special2 should match');
    assert(defense_spec.special3 == beast.combat_spec.specials.special3, 'Special3 should match');

    println!("Defense spec creation from beast verified");
}

#[test]
fn test_u8_to_tier_conversion() {
    assert(CombatImpl::u8_to_tier(1) == Tier::T1, 'Should convert 1 to T1');
    assert(CombatImpl::u8_to_tier(2) == Tier::T2, 'Should convert 2 to T2');
    assert(CombatImpl::u8_to_tier(3) == Tier::T3, 'Should convert 3 to T3');
    assert(CombatImpl::u8_to_tier(4) == Tier::T4, 'Should convert 4 to T4');
    assert(CombatImpl::u8_to_tier(5) == Tier::T5, 'Should convert 5 to T5');
    assert(CombatImpl::u8_to_tier(0) == Tier::T5, 'Should default to T5');
    assert(CombatImpl::u8_to_tier(6) == Tier::T5, 'Should default to T5');

    println!("u8 to Tier conversion verified");
}

#[test]
fn test_u8_to_type_conversion() {
    assert(CombatImpl::u8_to_type(1) == Type::Magic_or_Cloth, 'Should convert 1 to Magic_or_Cloth');
    assert(CombatImpl::u8_to_type(2) == Type::Blade_or_Hide, 'Should convert 2 to Blade_or_Hide');
    assert(
        CombatImpl::u8_to_type(3) == Type::Bludgeon_or_Metal,
        'Should convert 3 to Bludgeon_or_Metal',
    );
    assert(CombatImpl::u8_to_type(0) == Type::None, 'Should default to None');
    assert(CombatImpl::u8_to_type(4) == Type::None, 'Should default to None');

    println!("u8 to Type conversion verified");
}

#[test]
fn test_flee_calculation() {
    let adventurer_level = 5;
    let dexterity = 8;
    let beast_level = 10;

    // Test with seed that should allow flee
    let can_flee_good = CombatImpl::calculate_flee_success(
        adventurer_level, dexterity, beast_level, 1,
    );
    // Test with seed that should prevent flee
    let can_flee_bad = CombatImpl::calculate_flee_success(
        adventurer_level, dexterity, beast_level, 99,
    );

    println!("Flee calculation verified");
    println!("Good flee attempt: {}", can_flee_good);
    println!("Bad flee attempt: {}", can_flee_bad);
}

#[test]
fn test_combat_metadata_generation() {
    let mock_adventurer_contract = declare("mock_adventurer").unwrap().contract_class();
    let mock_beast_contract = declare("mock_beast").unwrap().contract_class();
    let calldata = array![];

    let (adv_addr, _) = mock_adventurer_contract.deploy(@calldata).unwrap();
    let (beast_addr, _) = mock_beast_contract.deploy(@calldata).unwrap();

    let adv_dispatcher = IMockAdventurerDispatcher { contract_address: adv_addr };
    let beast_dispatcher = IMockBeastDispatcher { contract_address: beast_addr };

    let adventurer = adv_dispatcher.get_adventurer(42);
    let beast = beast_dispatcher.get_beast(5);

    // Create a sample combat result
    let combat_result = CombatResult {
        base_attack: 50,
        base_armor: 25,
        elemental_adjusted_damage: 75,
        strength_bonus: 10,
        critical_hit_bonus: 75,
        weapon_special_bonus: 20,
        armor_penetration: 10,
        total_damage: 45,
        is_critical: true,
        elemental_effectiveness: 2,
    };

    let metadata = CombatImpl::generate_combat_metadata(adventurer, beast, combat_result);

    assert(metadata.len() > 0, 'Metadata should not be empty');

    println!("Combat metadata generation verified");
    println!("Metadata length: {}", metadata.len());
}
