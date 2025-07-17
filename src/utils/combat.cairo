// SPDX-License-Identifier: MIT
// Combat Damage Calculation System for LS2 Renderer
// Implements comprehensive combat mechanics including elemental effectiveness, weapon bonuses, and
// critical hits

use ls2_renderer::mocks::mock_adventurer::{Adventurer, Item, Stats};
use ls2_renderer::mocks::mock_beast::{Beast, Type, Tier};
use ls2_renderer::utils::item_database::ItemDatabaseImpl;

// Combat constants
pub const STRENGTH_DAMAGE_MULTIPLIER: u16 = 10; // 10% per strength point
pub const ELEMENTAL_DAMAGE_BONUS: u16 = 50; // 50% bonus for effective elements
pub const CRITICAL_HIT_MULTIPLIER: u16 = 100; // 100% bonus for critical hits
pub const SPECIAL_DAMAGE_MULTIPLIER: u16 = 20; // 20% bonus for special abilities
pub const TIER_DAMAGE_MULTIPLIER: u16 = 5; // Base multiplier for tier damage
pub const MINIMUM_DAMAGE: u16 = 1; // Minimum damage dealt

#[derive(Copy, Drop, Serde, Debug)]
pub struct CombatResult {
    pub base_attack: u16,
    pub base_armor: u16,
    pub elemental_adjusted_damage: u16,
    pub strength_bonus: u16,
    pub critical_hit_bonus: u16,
    pub weapon_special_bonus: u16,
    pub armor_penetration: u16,
    pub total_damage: u16,
    pub is_critical: bool,
    pub elemental_effectiveness: u8 // 0=weak, 1=fair, 2=strong
}

#[derive(Copy, Drop, Serde, Debug)]
pub struct AttackSpec {
    pub tier: Tier,
    pub item_type: Type,
    pub level: u16,
    pub special1: u8,
    pub special2: u8,
    pub special3: u8,
}

#[derive(Copy, Drop, Serde, Debug)]
pub struct DefenseSpec {
    pub tier: Tier,
    pub item_type: Type,
    pub level: u16,
    pub special1: u8,
    pub special2: u8,
    pub special3: u8,
}

#[generate_trait]
pub impl CombatImpl of CombatTrait {
    /// @notice Calculate comprehensive combat damage
    /// @param attacker_spec Attack specifications (weapon/adventurer)
    /// @param defender_spec Defense specifications (armor/beast)
    /// @param attacker_stats Adventurer stats for bonuses
    /// @param luck_seed Random seed for critical hit calculation
    /// @return Complete combat calculation result
    fn calculate_damage(
        attacker_spec: AttackSpec,
        defender_spec: DefenseSpec,
        attacker_stats: Stats,
        luck_seed: u64,
    ) -> CombatResult {
        // Base attack calculation using tier and level
        let base_attack = Self::calculate_base_attack(attacker_spec.tier, attacker_spec.level);

        // Base armor calculation
        let base_armor = Self::calculate_base_armor(defender_spec.tier, defender_spec.level);

        // Elemental effectiveness calculation
        let (elemental_adjusted_damage, elemental_effectiveness) = Self::calculate_elemental_damage(
            base_attack, attacker_spec.item_type, defender_spec.item_type,
        );

        // Strength bonus calculation
        let strength_bonus = Self::calculate_strength_bonus(
            elemental_adjusted_damage, attacker_stats.strength,
        );

        // Critical hit calculation
        let (critical_hit_bonus, is_critical) = Self::calculate_critical_hit(
            elemental_adjusted_damage, attacker_stats.luck, luck_seed,
        );

        // Weapon special abilities bonus
        let weapon_special_bonus = Self::calculate_weapon_special_bonus(
            elemental_adjusted_damage, attacker_spec, defender_spec,
        );

        // Armor penetration calculation
        let armor_penetration = Self::calculate_armor_penetration(
            base_armor, attacker_spec.special1, attacker_stats.strength,
        );

        // Total damage calculation
        let total_pre_armor = elemental_adjusted_damage
            + strength_bonus
            + critical_hit_bonus
            + weapon_special_bonus;

        let effective_armor = if armor_penetration > base_armor {
            0
        } else {
            base_armor - armor_penetration
        };

        let total_damage = if total_pre_armor > effective_armor {
            total_pre_armor - effective_armor
        } else {
            MINIMUM_DAMAGE
        };

        CombatResult {
            base_attack,
            base_armor,
            elemental_adjusted_damage,
            strength_bonus,
            critical_hit_bonus,
            weapon_special_bonus,
            armor_penetration,
            total_damage,
            is_critical,
            elemental_effectiveness,
        }
    }

    /// @notice Calculate base attack damage from weapon tier and level
    fn calculate_base_attack(tier: Tier, level: u16) -> u16 {
        let tier_multiplier = match tier {
            Tier::T1 => 5,
            Tier::T2 => 4,
            Tier::T3 => 3,
            Tier::T4 => 2,
            Tier::T5 => 1,
            _ => 1,
        };

        level * tier_multiplier
    }

    /// @notice Calculate base armor protection from armor tier and level
    fn calculate_base_armor(tier: Tier, level: u16) -> u16 {
        let tier_multiplier = match tier {
            Tier::T1 => 5,
            Tier::T2 => 4,
            Tier::T3 => 3,
            Tier::T4 => 2,
            Tier::T5 => 1,
            _ => 1,
        };

        (level * tier_multiplier) / 2 // Armor is half of attack value
    }

    /// @notice Calculate elemental effectiveness damage
    fn calculate_elemental_damage(
        base_damage: u16, attacker_type: Type, defender_type: Type,
    ) -> (u16, u8) {
        let effectiveness = Self::get_elemental_effectiveness(attacker_type, defender_type);

        let adjusted_damage = match effectiveness {
            2 => base_damage + (base_damage * ELEMENTAL_DAMAGE_BONUS) / 100, // Strong (+50%)
            1 => base_damage, // Fair (no change)
            0 => base_damage - (base_damage * ELEMENTAL_DAMAGE_BONUS) / 100, // Weak (-50%)
            _ => base_damage,
        };

        (adjusted_damage, effectiveness)
    }

    /// @notice Get elemental effectiveness between two types
    fn get_elemental_effectiveness(attacker_type: Type, defender_type: Type) -> u8 {
        match (attacker_type, defender_type) {
            // Magic/Cloth is strong vs Metal, weak vs Hide
            (Type::Magic_or_Cloth, Type::Bludgeon_or_Metal) => 2, // Strong
            (Type::Magic_or_Cloth, Type::Blade_or_Hide) => 0, // Weak
            (Type::Magic_or_Cloth, Type::Magic_or_Cloth) => 1, // Fair
            // Blade/Hide is strong vs Cloth, weak vs Metal
            (Type::Blade_or_Hide, Type::Magic_or_Cloth) => 2, // Strong
            (Type::Blade_or_Hide, Type::Bludgeon_or_Metal) => 0, // Weak
            (Type::Blade_or_Hide, Type::Blade_or_Hide) => 1, // Fair
            // Bludgeon/Metal is strong vs Hide, weak vs Cloth
            (Type::Bludgeon_or_Metal, Type::Blade_or_Hide) => 2, // Strong
            (Type::Bludgeon_or_Metal, Type::Magic_or_Cloth) => 0, // Weak
            (Type::Bludgeon_or_Metal, Type::Bludgeon_or_Metal) => 1, // Fair
            // Default to fair effectiveness
            _ => 1,
        }
    }

    /// @notice Calculate strength bonus damage
    fn calculate_strength_bonus(base_damage: u16, strength: u8) -> u16 {
        (base_damage * strength.into() * STRENGTH_DAMAGE_MULTIPLIER) / 1000
    }

    /// @notice Calculate critical hit bonus
    fn calculate_critical_hit(base_damage: u16, luck: u8, luck_seed: u64) -> (u16, bool) {
        // Critical hit chance based on luck stat
        let critical_chance = luck.into() * 2; // 2% per luck point
        let random_roll: u8 = (luck_seed % 100).try_into().unwrap();

        if random_roll < critical_chance.try_into().unwrap() {
            ((base_damage * CRITICAL_HIT_MULTIPLIER) / 100, true)
        } else {
            (0, false)
        }
    }

    /// @notice Calculate weapon special abilities bonus
    fn calculate_weapon_special_bonus(
        base_damage: u16, attacker_spec: AttackSpec, defender_spec: DefenseSpec,
    ) -> u16 {
        let mut bonus = 0;

        // Special2 match: 8x base damage bonus
        if attacker_spec.special2 == defender_spec.special2 && attacker_spec.special2 > 0 {
            bonus += (base_damage * 8) / 10; // 80% bonus
        }

        // Special3 match: 2x base damage bonus
        if attacker_spec.special3 == defender_spec.special3 && attacker_spec.special3 > 0 {
            bonus += (base_damage * 2) / 10; // 20% bonus
        }

        // Basic special1 bonus
        bonus += (base_damage * attacker_spec.special1.into() * SPECIAL_DAMAGE_MULTIPLIER) / 1000;

        bonus
    }

    /// @notice Calculate armor penetration
    fn calculate_armor_penetration(base_armor: u16, weapon_special: u8, strength: u8) -> u16 {
        let penetration = (weapon_special.into() * strength.into()) / 4;
        if penetration > base_armor {
            base_armor
        } else {
            penetration
        }
    }

    /// @notice Create attack spec from adventurer weapon
    fn create_attack_spec_from_weapon(weapon: Item, level: u16) -> AttackSpec {
        let item_info = ItemDatabaseImpl::get_item_info(weapon.id);
        let tier = Self::u8_to_tier(item_info.tier);
        let item_type = Self::u8_to_type(item_info.item_type);

        AttackSpec {
            tier,
            item_type,
            level,
            special1: (weapon.xp % 20).try_into().unwrap(),
            special2: ((weapon.xp / 20) % 20).try_into().unwrap(),
            special3: ((weapon.xp / 400) % 20).try_into().unwrap(),
        }
    }

    /// @notice Create defense spec from adventurer armor
    fn create_defense_spec_from_armor(chest: Item, level: u16) -> DefenseSpec {
        let item_info = ItemDatabaseImpl::get_item_info(chest.id);
        let tier = Self::u8_to_tier(item_info.tier);
        let item_type = Self::u8_to_type(item_info.item_type);

        DefenseSpec {
            tier,
            item_type,
            level,
            special1: (chest.xp % 20).try_into().unwrap(),
            special2: ((chest.xp / 20) % 20).try_into().unwrap(),
            special3: ((chest.xp / 400) % 20).try_into().unwrap(),
        }
    }

    /// @notice Create attack spec from beast combat spec
    fn create_attack_spec_from_beast(beast: Beast) -> AttackSpec {
        AttackSpec {
            tier: beast.combat_spec.tier,
            item_type: beast.combat_spec.item_type,
            level: beast.combat_spec.level,
            special1: beast.combat_spec.specials.special1,
            special2: beast.combat_spec.specials.special2,
            special3: beast.combat_spec.specials.special3,
        }
    }

    /// @notice Create defense spec from beast combat spec
    fn create_defense_spec_from_beast(beast: Beast) -> DefenseSpec {
        DefenseSpec {
            tier: beast.combat_spec.tier,
            item_type: beast.combat_spec.item_type,
            level: beast.combat_spec.level,
            special1: beast.combat_spec.specials.special1,
            special2: beast.combat_spec.specials.special2,
            special3: beast.combat_spec.specials.special3,
        }
    }

    /// @notice Convert u8 to Tier enum
    fn u8_to_tier(value: u8) -> Tier {
        if value == 1 {
            Tier::T1
        } else if value == 2 {
            Tier::T2
        } else if value == 3 {
            Tier::T3
        } else if value == 4 {
            Tier::T4
        } else if value == 5 {
            Tier::T5
        } else {
            Tier::T5
        }
    }

    /// @notice Convert u8 to Type enum
    fn u8_to_type(value: u8) -> Type {
        if value == 1 {
            Type::Magic_or_Cloth // Jewelry
        } else if value == 2 {
            Type::Blade_or_Hide // Weapon
        } else if value == 3 {
            Type::Bludgeon_or_Metal // Armor
        } else {
            Type::None
        }
    }

    /// @notice Calculate flee attempt success
    fn calculate_flee_success(
        adventurer_level: u8, dexterity: u8, beast_level: u16, luck_seed: u64,
    ) -> bool {
        let flee_chance = (adventurer_level.into() + dexterity.into() * 2)
            * 100
            / (beast_level + 10);
        let random_roll: u8 = (luck_seed % 100).try_into().unwrap();
        random_roll < flee_chance.try_into().unwrap()
    }

    /// @notice Generate combat metadata for rendering
    fn generate_combat_metadata(
        adventurer: Adventurer, beast: Beast, combat_result: CombatResult,
    ) -> Array<felt252> {
        let mut metadata = ArrayTrait::<felt252>::new();

        // Combat header
        metadata.append('=== COMBAT RESULT ===');

        // Base stats
        metadata.append('Base Attack:');
        metadata.append(combat_result.base_attack.into());
        metadata.append('Base Armor:');
        metadata.append(combat_result.base_armor.into());

        // Damage breakdown
        metadata.append('Elemental Damage:');
        metadata.append(combat_result.elemental_adjusted_damage.into());
        metadata.append('Strength Bonus:');
        metadata.append(combat_result.strength_bonus.into());

        if combat_result.is_critical {
            metadata.append('CRITICAL HIT!');
            metadata.append(combat_result.critical_hit_bonus.into());
        }

        metadata.append('Weapon Special:');
        metadata.append(combat_result.weapon_special_bonus.into());
        metadata.append('Armor Penetration:');
        metadata.append(combat_result.armor_penetration.into());

        // Final damage
        metadata.append('Total Damage:');
        metadata.append(combat_result.total_damage.into());

        // Elemental effectiveness
        let effectiveness_text = match combat_result.elemental_effectiveness {
            2 => 'Super Effective!',
            1 => 'Normal Effectiveness',
            0 => 'Not Very Effective',
            _ => 'Unknown',
        };
        metadata.append(effectiveness_text);

        metadata
    }
}
