// SPDX-License-Identifier: MIT
// Mock Beast contract for battle interface rendering

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum Type {
    None,
    Magic_or_Cloth,
    Blade_or_Hide,
    Bludgeon_or_Metal,
    Necklace,
    Ring,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum Category {
    None,
    Magical,
    Hunter,
    Brute,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub enum Tier {
    None,
    T1,
    T2,
    T3,
    T4,
    T5,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct SpecialPowers {
    pub special1: u8,
    pub special2: u8,
    pub special3: u8,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct CombatSpec {
    pub tier: Tier,
    pub item_type: Type,
    pub level: u16,
    pub specials: SpecialPowers,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Beast {
    pub id: u8,
    pub starting_health: u16,
    pub combat_spec: CombatSpec,
    pub category: Category,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct CombatResult {
    pub base_attack: u16,
    pub base_armor: u16,
    pub elemental_adjusted_damage: u16,
    pub strength_bonus: u16,
    pub critical_hit_bonus: u16,
    pub weapon_special_bonus: u16,
    pub total_damage: u16,
}

#[starknet::interface]
pub trait IMockBeast<T> {
    fn get_beast(self: @T, beast_id: u8) -> Beast;
    fn get_beast_name(self: @T, beast_id: u8) -> felt252;
    fn get_beast_category(self: @T, beast_id: u8) -> Category;
    fn calculate_damage(
        self: @T, attacker_spec: CombatSpec, defender_spec: CombatSpec, strength: u8, luck: u8,
    ) -> CombatResult;
    fn attempt_flee(self: @T, adventurer_level: u8, adventurer_dexterity: u8, rnd: u8) -> bool;
}

#[starknet::contract]
pub mod mock_beast {
    use super::{Beast, Category, CombatResult, CombatSpec, IMockBeast, SpecialPowers, Tier, Type};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl MockBeastImpl of IMockBeast<ContractState> {
        fn get_beast(self: @ContractState, beast_id: u8) -> Beast {
            let adjusted_id = if beast_id == 0 {
                1
            } else {
                ((beast_id - 1) % 75) + 1
            };

            // Determine category and tier based on beast ID
            let (category, tier, item_type) = get_beast_properties(adjusted_id);

            // Calculate health based on tier
            let base_health = match tier {
                Tier::T1 => 50_u16,
                Tier::T2 => 40_u16,
                Tier::T3 => 30_u16,
                Tier::T4 => 20_u16,
                Tier::T5 => 15_u16,
                _ => 20_u16,
            };

            // Calculate level based on tier
            let level = match tier {
                Tier::T1 => 20_u16 + (adjusted_id.into() % 10_u16),
                Tier::T2 => 15_u16 + (adjusted_id.into() % 8_u16),
                Tier::T3 => 10_u16 + (adjusted_id.into() % 6_u16),
                Tier::T4 => 5_u16 + (adjusted_id.into() % 4_u16),
                Tier::T5 => 1_u16 + (adjusted_id.into() % 3_u16),
                _ => 10_u16,
            };

            Beast {
                id: adjusted_id,
                starting_health: base_health + (adjusted_id.into() % 20_u16),
                combat_spec: CombatSpec {
                    tier,
                    item_type,
                    level,
                    specials: SpecialPowers {
                        special1: adjusted_id % 20,
                        special2: (adjusted_id * 2) % 20,
                        special3: (adjusted_id * 3) % 20,
                    },
                },
                category,
            }
        }

        fn get_beast_name(self: @ContractState, beast_id: u8) -> felt252 {
            let adjusted_id = if beast_id == 0 {
                1
            } else {
                ((beast_id - 1) % 75) + 1
            };

            // Return beast names based on ID (1-75)
            if adjusted_id == 1 {
                'Warlock'
            } else if adjusted_id == 2 {
                'Typhon'
            } else if adjusted_id == 3 {
                'Jiangshi'
            } else if adjusted_id == 4 {
                'Anansi'
            } else if adjusted_id == 5 {
                'Basilisk'
            } else if adjusted_id == 6 {
                'Gorgon'
            } else if adjusted_id == 7 {
                'Kitsune'
            } else if adjusted_id == 8 {
                'Lich'
            } else if adjusted_id == 9 {
                'Chimera'
            } else if adjusted_id == 10 {
                'Wendigo'
            } else if adjusted_id == 11 {
                'Rakshasa'
            } else if adjusted_id == 12 {
                'Werewolf'
            } else if adjusted_id == 13 {
                'Banshee'
            } else if adjusted_id == 14 {
                'Draugr'
            } else if adjusted_id == 15 {
                'Vampire'
            } else if adjusted_id == 16 {
                'Goblin'
            } else if adjusted_id == 17 {
                'Ghoul'
            } else if adjusted_id == 18 {
                'Wraith'
            } else if adjusted_id == 19 {
                'Sprite'
            } else if adjusted_id == 20 {
                'Kappa'
            } else if adjusted_id == 21 {
                'Fairy'
            } else if adjusted_id == 22 {
                'Leprechaun'
            } else if adjusted_id == 23 {
                'Kelpie'
            } else if adjusted_id == 24 {
                'Pixie'
            } else if adjusted_id == 25 {
                'Gnome'
            } else if adjusted_id == 26 {
                'Griffin'
            } else if adjusted_id == 27 {
                'Manticore'
            } else if adjusted_id == 28 {
                'Phoenix'
            } else if adjusted_id == 29 {
                'Dragon'
            } else if adjusted_id == 30 {
                'Minotaur'
            } else if adjusted_id == 31 {
                'Qilin'
            } else if adjusted_id == 32 {
                'Ammit'
            } else if adjusted_id == 33 {
                'Nue'
            } else if adjusted_id == 34 {
                'Skinwalker'
            } else if adjusted_id == 35 {
                'Chupacabra'
            } else if adjusted_id == 36 {
                'Weretiger'
            } else if adjusted_id == 37 {
                'Wyvern'
            } else if adjusted_id == 38 {
                'Roc'
            } else if adjusted_id == 39 {
                'Harpy'
            } else if adjusted_id == 40 {
                'Pegasus'
            } else if adjusted_id == 41 {
                'Hippogriff'
            } else if adjusted_id == 42 {
                'Fenrir'
            } else if adjusted_id == 43 {
                'Jaguar'
            } else if adjusted_id == 44 {
                'Satori'
            } else if adjusted_id == 45 {
                'DireWolf'
            } else if adjusted_id == 46 {
                'Bear'
            } else if adjusted_id == 47 {
                'Wolf'
            } else if adjusted_id == 48 {
                'Mantis'
            } else if adjusted_id == 49 {
                'Spider'
            } else if adjusted_id == 50 {
                'Rat'
            } else if adjusted_id == 51 {
                'Kraken'
            } else if adjusted_id == 52 {
                'Colossus'
            } else if adjusted_id == 53 {
                'Balrog'
            } else if adjusted_id == 54 {
                'Leviathan'
            } else if adjusted_id == 55 {
                'Tarrasque'
            } else if adjusted_id == 56 {
                'Titan'
            } else if adjusted_id == 57 {
                'Nephilim'
            } else if adjusted_id == 58 {
                'Behemoth'
            } else if adjusted_id == 59 {
                'Hydra'
            } else if adjusted_id == 60 {
                'Juggernaut'
            } else if adjusted_id == 61 {
                'Oni'
            } else if adjusted_id == 62 {
                'Jotunn'
            } else if adjusted_id == 63 {
                'Ettin'
            } else if adjusted_id == 64 {
                'Cyclops'
            } else if adjusted_id == 65 {
                'Giant'
            } else if adjusted_id == 66 {
                'NemeanLion'
            } else if adjusted_id == 67 {
                'Berserker'
            } else if adjusted_id == 68 {
                'Yeti'
            } else if adjusted_id == 69 {
                'Golem'
            } else if adjusted_id == 70 {
                'Ent'
            } else if adjusted_id == 71 {
                'Troll'
            } else if adjusted_id == 72 {
                'Bigfoot'
            } else if adjusted_id == 73 {
                'Ogre'
            } else if adjusted_id == 74 {
                'Orc'
            } else if adjusted_id == 75 {
                'Skeleton'
            } else {
                'Unknown'
            }
        }

        fn get_beast_category(self: @ContractState, beast_id: u8) -> Category {
            get_beast_category_helper(beast_id)
        }

        fn calculate_damage(
            self: @ContractState,
            attacker_spec: CombatSpec,
            defender_spec: CombatSpec,
            strength: u8,
            luck: u8,
        ) -> CombatResult {
            let base_attack = attacker_spec.level;
            let base_armor = defender_spec.level / 2;

            // Calculate elemental effectiveness
            let elemental_multiplier = match (attacker_spec.item_type, defender_spec.item_type) {
                (Type::Magic_or_Cloth, Type::Bludgeon_or_Metal) => 150_u16, // 1.5x
                (Type::Blade_or_Hide, Type::Magic_or_Cloth) => 150_u16, // 1.5x
                (Type::Bludgeon_or_Metal, Type::Blade_or_Hide) => 150_u16, // 1.5x
                _ => 100_u16 // 1.0x
            };

            let elemental_adjusted_damage = (base_attack * elemental_multiplier) / 100;
            let strength_bonus = strength.into() / 2;

            // Critical hit check (simplified)
            let critical_hit_bonus = if luck > 15 {
                elemental_adjusted_damage / 2
            } else {
                0
            };

            let weapon_special_bonus = attacker_spec.specials.special1.into() / 4;

            let total_damage = elemental_adjusted_damage
                + strength_bonus
                + critical_hit_bonus
                + weapon_special_bonus
                - base_armor;

            CombatResult {
                base_attack,
                base_armor,
                elemental_adjusted_damage,
                strength_bonus,
                critical_hit_bonus,
                weapon_special_bonus,
                total_damage: if total_damage > 65535 {
                    1
                } else {
                    total_damage
                },
            }
        }

        fn attempt_flee(
            self: @ContractState, adventurer_level: u8, adventurer_dexterity: u8, rnd: u8,
        ) -> bool {
            // Simple flee calculation: higher level and dex = better chance
            let flee_chance = (adventurer_level + adventurer_dexterity) * 2;
            rnd < flee_chance
        }
    }

    fn get_beast_category_helper(beast_id: u8) -> Category {
        let adjusted_id = if beast_id == 0 {
            1
        } else {
            ((beast_id - 1) % 75) + 1
        };

        if adjusted_id >= 1 && adjusted_id <= 25 {
            Category::Magical
        } else if adjusted_id >= 26 && adjusted_id <= 50 {
            Category::Hunter
        } else if adjusted_id >= 51 && adjusted_id <= 75 {
            Category::Brute
        } else {
            Category::None
        }
    }

    fn get_beast_properties(beast_id: u8) -> (Category, Tier, Type) {
        let category = get_beast_category_helper(beast_id);

        // Determine tier based on beast ID within each category
        let tier = if (beast_id >= 1 && beast_id <= 5)
            || (beast_id >= 26 && beast_id <= 30)
            || (beast_id >= 51 && beast_id <= 55) {
            Tier::T1
        } else if (beast_id >= 6 && beast_id <= 10)
            || (beast_id >= 31 && beast_id <= 35)
            || (beast_id >= 56 && beast_id <= 60) {
            Tier::T2
        } else if (beast_id >= 11 && beast_id <= 15)
            || (beast_id >= 36 && beast_id <= 40)
            || (beast_id >= 61 && beast_id <= 65) {
            Tier::T3
        } else if (beast_id >= 16 && beast_id <= 20)
            || (beast_id >= 41 && beast_id <= 45)
            || (beast_id >= 66 && beast_id <= 70) {
            Tier::T4
        } else {
            Tier::T5
        };

        // Determine item type based on category
        let item_type = match category {
            Category::Magical => Type::Magic_or_Cloth,
            Category::Hunter => Type::Blade_or_Hide,
            Category::Brute => Type::Bludgeon_or_Metal,
            _ => Type::None,
        };

        (category, tier, item_type)
    }
}
