// SPDX-License-Identifier: MIT
// Mock Adventurer contract for SVG metadata rendering

#[starknet::contract]
pub mod mock_adventurer {
    use death_mountain_renderer::interfaces::adventurer_interface::IDeathMountainSystems;
    use death_mountain_renderer::models::models::{
        Adventurer, AdventurerVerbose, BagVerbose, Equipment, EquipmentVerbose,
        Item, ItemVerbose, Slot, Stats, Tier, Type,
    };

    #[storage]
    struct Storage {}


    #[abi(embed_v0)]
    pub impl AdventurerSystemsImpl of IDeathMountainSystems<ContractState> {
        fn get_adventurer_verbose(self: @ContractState, adventurer_id: u64) -> AdventurerVerbose {
            let adventurer = self.get_adventurer_data(adventurer_id);
            let name_felt = self.get_name_felt(adventurer_id);
            let level = self.calc_level(adventurer.xp);

            // Convert felt252 name to ByteArray
            let mut name = "";
            if name_felt != 0 {
                // Convert felt252 to ByteArray (simple implementation)
                let name_u256: u256 = name_felt.into();
                let mut temp_val = name_u256;
                let mut bytes: Array<u8> = array![];

                // Extract bytes from the u256 value
                while temp_val != 0 {
                    let byte = (temp_val % 256).try_into().unwrap();
                    if byte != 0 { // Skip null bytes
                        bytes.append(byte);
                    }
                    temp_val = temp_val / 256;
                }

                // Reverse the bytes since we extracted them in reverse order
                let mut i = bytes.len();
                while i != 0 {
                    i -= 1;
                    name.append_byte(*bytes.at(i));
                }
            }

            // Convert Equipment to EquipmentVerbose
            let equipment_verbose = EquipmentVerbose {
                weapon: convert_item_to_verbose(adventurer.equipment.weapon),
                chest: convert_item_to_verbose(adventurer.equipment.chest),
                head: convert_item_to_verbose(adventurer.equipment.head),
                waist: convert_item_to_verbose(adventurer.equipment.waist),
                foot: convert_item_to_verbose(adventurer.equipment.foot),
                hand: convert_item_to_verbose(adventurer.equipment.hand),
                neck: convert_item_to_verbose(adventurer.equipment.neck),
                ring: convert_item_to_verbose(adventurer.equipment.ring),
            };

            // Create empty bag (for testing purposes)
            let empty_item = ItemVerbose {
                name: 'Empty',
                id: 0,
                xp: 0,
                tier: Tier::None,
                item_type: Type::None,
                slot: Slot::None,
            };

            let bag_verbose = BagVerbose {
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
                // mutated: false,
            };

            AdventurerVerbose {
                name,
                health: adventurer.health,
                xp: adventurer.xp,
                level,
                gold: adventurer.gold,
                beast_health: adventurer.beast_health,
                stat_upgrades_available: adventurer.stat_upgrades_available,
                stats: adventurer.stats,
                equipment: equipment_verbose,
                item_specials_seed: adventurer.item_specials_seed,
                action_count: adventurer.action_count,
                bag: bag_verbose,
            }
        }

    }

    // Helper methods for the IAdventurerSystems implementation
    #[generate_trait]
    impl HelperImpl of HelperTrait {
        fn get_adventurer_data(self: @ContractState, adventurer_id: u64) -> Adventurer {
            // Use modulo to prevent overflow for large token IDs
            let safe_id = adventurer_id % 1000000_u64; // Keep reasonable range

            Adventurer {
                health: 100_u16 + (safe_id % 50_u64).try_into().unwrap(),
                xp: ((safe_id * 7_u64) % 5000_u64).try_into().unwrap(),
                gold: ((safe_id * 13_u64) % 200_u64).try_into().unwrap(),
                beast_health: 20_u16 + (safe_id % 30_u64).try_into().unwrap(),
                stat_upgrades_available: (safe_id % 5_u64).try_into().unwrap(),
                stats: Stats {
                    strength: ((safe_id) % 10_u64).try_into().unwrap() + 1_u8,
                    dexterity: ((safe_id / 2) % 10_u64).try_into().unwrap() + 1_u8,
                    vitality: ((safe_id / 4) % 10_u64).try_into().unwrap() + 1_u8,
                    intelligence: ((safe_id / 8) % 10_u64).try_into().unwrap() + 1_u8,
                    wisdom: ((safe_id / 16) % 10_u64).try_into().unwrap() + 1_u8,
                    charisma: ((safe_id / 32) % 10_u64).try_into().unwrap() + 1_u8,
                    luck: ((safe_id / 64) % 10_u64).try_into().unwrap() + 1_u8,
                },
                equipment: Equipment {
                    weapon: Item {
                        id: get_weapon_item_id(safe_id),
                        xp: ((safe_id * 2) % 100_u64).try_into().unwrap(),
                    },
                    chest: Item {
                        id: get_chest_item_id(safe_id),
                        xp: ((safe_id * 3) % 100_u64).try_into().unwrap(),
                    },
                    head: Item {
                        id: get_head_item_id(safe_id),
                        xp: ((safe_id * 4) % 100_u64).try_into().unwrap(),
                    },
                    waist: Item {
                        id: get_waist_item_id(safe_id),
                        xp: ((safe_id * 5) % 100_u64).try_into().unwrap(),
                    },
                    foot: Item {
                        id: get_foot_item_id(safe_id),
                        xp: ((safe_id * 6) % 100_u64).try_into().unwrap(),
                    },
                    hand: Item {
                        id: get_hand_item_id(safe_id),
                        xp: ((safe_id * 7) % 100_u64).try_into().unwrap(),
                    },
                    neck: Item {
                        id: get_neck_item_id(safe_id),
                        xp: ((safe_id * 8) % 100_u64).try_into().unwrap(),
                    },
                    ring: Item {
                        id: get_ring_item_id(safe_id),
                        xp: ((safe_id * 9) % 100_u64).try_into().unwrap(),
                    },
                },
                item_specials_seed: ((safe_id * 3_u64) % 65536_u64).try_into().unwrap(),
                action_count: ((safe_id * 11_u64) % 100_u64).try_into().unwrap(),
            }
        }

        fn get_name_felt(self: @ContractState, adventurer_id: u64) -> felt252 {
            // Generate deterministic names based on adventurer ID
            let safe_id = adventurer_id % 1000000_u64; // Keep consistent with get_adventurer_data
            match safe_id % 20 {
                0 => 'Aragorn',
                1 => 'Legolas',
                2 => 'Gimli',
                3 => 'Gandalf',
                4 => 'Frodo',
                5 => 'Samwise',
                6 => 'Boromir',
                7 => 'Merlin',
                8 => 'Arthur',
                9 => 'Lancelot',
                10 => 'Galahad',
                11 => 'Percival',
                12 => 'Tristan',
                13 => 'Gareth',
                14 => 'Gawain',
                15 => 'Robin',
                16 => 'Sherlock',
                17 => 'Watson',
                18 => 'Hercules',
                _ => 'Shinobi',
            }
        }

        fn calc_level(self: @ContractState, xp: u16) -> u8 {
            // Simple level calculation: every 100 XP = 1 level, minimum level 1
            let level = (xp / 100) + 1;
            if level > 255 {
                255_u8
            } else {
                level.try_into().unwrap()
            }
        }
    }

    // Helper function to convert Item to ItemVerbose
    fn convert_item_to_verbose(item: Item) -> ItemVerbose {
        ItemVerbose {
            name: 'test',
            id: item.id,
            xp: item.xp,
            tier: match 1 {
                0 => Tier::None,
                1 => Tier::T1,
                2 => Tier::T2,
                3 => Tier::T3,
                4 => Tier::T4,
                5 => Tier::T5,
                _ => Tier::None,
            },
            item_type: match 1 {
                0 => Type::None,
                1 => Type::Magic_or_Cloth,
                2 => Type::Blade_or_Hide,
                3 => Type::Bludgeon_or_Metal,
                4 => Type::Necklace,
                5 => Type::Ring,
                _ => Type::None,
            },
            slot: match 1 {
                0 => Slot::None,
                1 => Slot::Neck,
                2 => Slot::Ring,
                3 => Slot::Weapon,
                4 => Slot::Chest,
                5 => Slot::Head,
                6 => Slot::Waist,
                7 => Slot::Foot,
                8 => Slot::Hand,
                _ => Slot::None,
            },
        }
    }

    // Helper functions for slot-based item assignment based on death-mountain logic

    // Weapon items: IDs 9-16, 42-46, 72-76
    fn get_weapon_item_id(adventurer_id: u64) -> u8 {
        let weapon_items = array![
            9, 10, 11, 12, 13, 14, 15, 16, 42, 43, 44, 45, 46, 72, 73, 74, 75, 76,
        ];
        let index = (adventurer_id % weapon_items.len().into()).try_into().unwrap();
        *weapon_items.at(index)
    }

    // Chest items: IDs 17-21, 47-51, 77-81
    fn get_chest_item_id(adventurer_id: u64) -> u8 {
        let chest_items = array![17, 18, 19, 20, 21, 47, 48, 49, 50, 51, 77, 78, 79, 80, 81];
        let index = ((adventurer_id + 1) % chest_items.len().into()).try_into().unwrap();
        *chest_items.at(index)
    }

    // Head items: IDs 22-26, 52-56, 82-86
    fn get_head_item_id(adventurer_id: u64) -> u8 {
        let head_items = array![22, 23, 24, 25, 26, 52, 53, 54, 55, 56, 82, 83, 84, 85, 86];
        let index = ((adventurer_id + 2) % head_items.len().into()).try_into().unwrap();
        *head_items.at(index)
    }

    // Waist items: IDs 27-31, 57-61, 87-91
    fn get_waist_item_id(adventurer_id: u64) -> u8 {
        let waist_items = array![27, 28, 29, 30, 31, 57, 58, 59, 60, 61, 87, 88, 89, 90, 91];
        let index = ((adventurer_id + 3) % waist_items.len().into()).try_into().unwrap();
        *waist_items.at(index)
    }

    // Foot items: IDs 32-36, 62-66, 92-96
    fn get_foot_item_id(adventurer_id: u64) -> u8 {
        let foot_items = array![32, 33, 34, 35, 36, 62, 63, 64, 65, 66, 92, 93, 94, 95, 96];
        let index = ((adventurer_id + 4) % foot_items.len().into()).try_into().unwrap();
        *foot_items.at(index)
    }

    // Hand items: IDs 37-41, 67-71, 97-101
    fn get_hand_item_id(adventurer_id: u64) -> u8 {
        let hand_items = array![37, 38, 39, 40, 41, 67, 68, 69, 70, 71, 97, 98, 99, 100, 101];
        let index = ((adventurer_id + 5) % hand_items.len().into()).try_into().unwrap();
        *hand_items.at(index)
    }

    // Neck items: IDs 1-3
    fn get_neck_item_id(adventurer_id: u64) -> u8 {
        let neck_items = array![1, 2, 3];
        let index = ((adventurer_id + 6) % neck_items.len().into()).try_into().unwrap();
        *neck_items.at(index)
    }

    // Ring items: IDs 4-8
    fn get_ring_item_id(adventurer_id: u64) -> u8 {
        let ring_items = array![4, 5, 6, 7, 8];
        let index = ((adventurer_id + 7) % ring_items.len().into()).try_into().unwrap();
        *ring_items.at(index)
    }

    // Random item for bag slots (any valid item)
    fn get_random_item_id(adventurer_id: u64, slot_offset: u64) -> u8 {
        ((adventurer_id + slot_offset) % 101_u64).try_into().unwrap() + 1_u8
    }
}

// Helper functions for testing
use death_mountain_renderer::models::models::{
    AdventurerVerbose, BagVerbose, EquipmentVerbose, ItemVerbose, Slot, Stats, Tier, Type,
};

pub fn get_simple_adventurer() -> AdventurerVerbose {
    let stats = Stats {
        strength: 12, dexterity: 10, vitality: 14, intelligence: 8, wisdom: 9, charisma: 7, luck: 5,
    };

    let weapon_item = ItemVerbose {
        id: 1,
        name: 'Dagger',
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Weapon,
        xp: 100,
    };

    let chest_item = ItemVerbose {
        id: 2,
        name: 'Leather Armor',
        tier: Tier::T1,
        item_type: Type::Blade_or_Hide,
        slot: Slot::Chest,
        xp: 50,
    };

    let equipment = EquipmentVerbose {
        weapon: weapon_item,
        chest: chest_item,
        head: ItemVerbose {
            id: 3,
            name: 'Crown',
            tier: Tier::T1,
            item_type: Type::Magic_or_Cloth,
            slot: Slot::Head,
            xp: 25,
        },
        waist: ItemVerbose {
            id: 4,
            name: 'Leather Belt',
            tier: Tier::T1,
            item_type: Type::Blade_or_Hide,
            slot: Slot::Waist,
            xp: 30,
        },
        foot: ItemVerbose {
            id: 5,
            name: 'Boots',
            tier: Tier::T1,
            item_type: Type::Blade_or_Hide,
            slot: Slot::Foot,
            xp: 40,
        },
        hand: ItemVerbose {
            id: 6,
            name: 'Gloves',
            tier: Tier::T1,
            item_type: Type::Blade_or_Hide,
            slot: Slot::Hand,
            xp: 20,
        },
        neck: ItemVerbose {
            id: 7,
            name: 'Amulet',
            tier: Tier::T1,
            item_type: Type::Necklace,
            slot: Slot::Neck,
            xp: 15,
        },
        ring: ItemVerbose {
            id: 8,
            name: 'Silver Ring',
            tier: Tier::T1,
            item_type: Type::Ring,
            slot: Slot::Ring,
            xp: 10,
        },
    };

    let _empty_item = ItemVerbose {
        id: 0, name: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None, xp: 0,
    };

    AdventurerVerbose {
        health: 250,
        level: 5,
        stats,
        equipment,
        bag: BagVerbose {
            item_1: weapon_item,
            item_2: chest_item,
            item_3: ItemVerbose {
                id: 10,
                name: 'Iron Sword',
                tier: Tier::T2,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Weapon,
                xp: 75,
            },
            item_4: ItemVerbose {
                id: 11,
                name: 'Magic Staff',
                tier: Tier::T3,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Weapon,
                xp: 120,
            },
            item_5: ItemVerbose {
                id: 12,
                name: 'Chain Mail',
                tier: Tier::T2,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
                xp: 90,
            },
            item_6: ItemVerbose {
                id: 13,
                name: 'Wizard Hat',
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Head,
                xp: 65,
            },
            item_7: ItemVerbose {
                id: 14,
                name: 'Steel Gauntlets',
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Hand,
                xp: 110,
            },
            item_8: ItemVerbose {
                id: 15,
                name: 'Leather Boots',
                tier: Tier::T1,
                item_type: Type::Blade_or_Hide,
                slot: Slot::Foot,
                xp: 45,
            },
            item_9: ItemVerbose {
                id: 16,
                name: 'Gold Ring',
                tier: Tier::T4,
                item_type: Type::Ring,
                slot: Slot::Ring,
                xp: 150,
            },
            item_10: ItemVerbose {
                id: 17,
                name: 'Silver Necklace',
                tier: Tier::T2,
                item_type: Type::Necklace,
                slot: Slot::Neck,
                xp: 80,
            },
            item_11: ItemVerbose {
                id: 18,
                name: 'War Hammer',
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Weapon,
                xp: 130,
            },
            item_12: ItemVerbose {
                id: 19,
                name: 'Plate Armor',
                tier: Tier::T4,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Chest,
                xp: 180,
            },
            item_13: ItemVerbose {
                id: 20,
                name: 'Knight Helm',
                tier: Tier::T3,
                item_type: Type::Bludgeon_or_Metal,
                slot: Slot::Head,
                xp: 125,
            },
            item_14: ItemVerbose {
                id: 21,
                name: 'Silk Belt',
                tier: Tier::T2,
                item_type: Type::Magic_or_Cloth,
                slot: Slot::Waist,
                xp: 70,
            },
            item_15: ItemVerbose {
                id: 22,
                name: 'Diamond Ring',
                tier: Tier::T5,
                item_type: Type::Ring,
                slot: Slot::Ring,
                xp: 200,
            },
        },
        name: "TestHero",
        xp: 1000,
        gold: 100,
        beast_health: 0,
        stat_upgrades_available: 0,
        item_specials_seed: 123,
        action_count: 0,
    }
}

pub fn get_adventurer_with_max_stats() -> AdventurerVerbose {
    let adventurer = get_simple_adventurer();
    AdventurerVerbose {
        health: 65535,
        level: 255,
        stats: Stats {
            strength: 255,
            dexterity: 255,
            vitality: 255,
            intelligence: 255,
            wisdom: 255,
            charisma: 255,
            luck: 255,
        },
        equipment: adventurer.equipment,
        bag: adventurer.bag,
        name: "MaxHero",
        xp: 65535,
        gold: adventurer.gold,
        beast_health: adventurer.beast_health,
        stat_upgrades_available: adventurer.stat_upgrades_available,
        item_specials_seed: adventurer.item_specials_seed,
        action_count: adventurer.action_count,
    }
}

pub fn get_adventurer_with_min_stats() -> AdventurerVerbose {
    let adventurer = get_simple_adventurer();
    AdventurerVerbose {
        health: 1,
        level: 1,
        stats: Stats {
            strength: 1,
            dexterity: 1,
            vitality: 1,
            intelligence: 1,
            wisdom: 1,
            charisma: 1,
            luck: 1,
        },
        equipment: adventurer.equipment,
        bag: adventurer.bag,
        name: "MinHero",
        xp: 0,
        gold: adventurer.gold,
        beast_health: adventurer.beast_health,
        stat_upgrades_available: adventurer.stat_upgrades_available,
        item_specials_seed: adventurer.item_specials_seed,
        action_count: adventurer.action_count,
    }
}

pub fn get_adventurer_with_long_name() -> AdventurerVerbose {
    let adventurer = get_simple_adventurer();
    AdventurerVerbose {
        health: adventurer.health,
        level: adventurer.level,
        stats: adventurer.stats,
        equipment: adventurer.equipment,
        bag: adventurer.bag,
        name: "VeryLongAdventurerNameThatExceedsNormalLengthLimits",
        xp: adventurer.xp,
        gold: adventurer.gold,
        beast_health: adventurer.beast_health,
        stat_upgrades_available: adventurer.stat_upgrades_available,
        item_specials_seed: adventurer.item_specials_seed,
        action_count: adventurer.action_count,
    }
}

pub fn create_custom_adventurer(health: u16, level: u8, vitality: u8) -> AdventurerVerbose {
    let base = get_simple_adventurer();
    AdventurerVerbose {
        health,
        level,
        stats: Stats {
            strength: base.stats.strength,
            dexterity: base.stats.dexterity,
            vitality,
            intelligence: base.stats.intelligence,
            wisdom: base.stats.wisdom,
            charisma: base.stats.charisma,
            luck: base.stats.luck,
        },
        equipment: base.equipment,
        bag: base.bag,
        name: base.name,
        xp: base.xp,
        gold: base.gold,
        beast_health: base.beast_health,
        stat_upgrades_available: base.stat_upgrades_available,
        item_specials_seed: base.item_specials_seed,
        action_count: base.action_count,
    }
}

pub fn create_custom_adventurer_with_name(name: ByteArray) -> AdventurerVerbose {
    let base = get_simple_adventurer();
    AdventurerVerbose {
        health: base.health,
        level: base.level,
        stats: Stats {
            strength: base.stats.strength,
            dexterity: base.stats.dexterity,
            vitality: base.stats.vitality,
            intelligence: base.stats.intelligence,
            wisdom: base.stats.wisdom,
            charisma: base.stats.charisma,
            luck: base.stats.luck,
        },
        equipment: base.equipment,
        bag: base.bag,
        name: name,
        xp: base.xp,
        gold: base.gold,
        beast_health: base.beast_health,
        stat_upgrades_available: base.stat_upgrades_available,
        item_specials_seed: base.item_specials_seed,
        action_count: base.action_count,
    }
}
