use death_mountain_renderer::models::models::{
    Adventurer, AdventurerVerbose, BagVerbose, Equipment, EquipmentVerbose, Item, ItemVerbose, Slot,
    Stats, StatsTrait, Tier, Type,
};

pub fn get_simple_adventurer() -> Adventurer {
    Adventurer {
        health: 100,
        xp: 1,
        stats: Stats {
            strength: 5,
            dexterity: 4,
            vitality: 3,
            intelligence: 2,
            wisdom: 1,
            charisma: 0,
            luck: 0,
        },
        gold: 40,
        equipment: Equipment {
            weapon: Item { id: 12, xp: 225 }, // Wand
            chest: Item { id: 17, xp: 100 }, // Divine Robe
            head: Item { id: 22, xp: 225 }, // Crown
            waist: Item { id: 29, xp: 225 }, // Wool Sash
            foot: Item { id: 32, xp: 40 }, // Divine Slippers
            hand: Item { id: 37, xp: 224 }, // Divine Gloves
            neck: Item { id: 3, xp: 1 }, // Amulet
            ring: Item { id: 8, xp: 1 } // Gold Ring
        },
        beast_health: 20,
        stat_upgrades_available: 0,
        item_specials_seed: 0,
        action_count: 0,
    }
}

// Helper function to convert Item to ItemVerbose
pub fn convert_item_to_verbose(item: Item) -> ItemVerbose {
    // Map item ID to name, tier, type, and slot based on death-mountain constants
    let (name, tier, item_type, slot) = match item.id {
        0 => ('Empty', Tier::None, Type::None, Slot::None),
        // Jewelry items (Neck/Ring slot)
        1 => ('Pendant', Tier::T1, Type::Necklace, Slot::Neck), // Pendant
        2 => ('Necklace', Tier::T1, Type::Necklace, Slot::Neck), // Necklace
        3 => ('Amulet', Tier::T1, Type::Necklace, Slot::Neck), // Amulet
        4 => ('Silver Ring', Tier::T2, Type::Ring, Slot::Ring), // SilverRing
        5 => ('Bronze Ring', Tier::T1, Type::Ring, Slot::Ring), // BronzeRing
        6 => ('Platinum Ring', Tier::T4, Type::Ring, Slot::Ring), // PlatinumRing
        7 => ('Titanium Ring', Tier::T5, Type::Ring, Slot::Ring), // TitaniumRing
        8 => ('Gold Ring', Tier::T3, Type::Ring, Slot::Ring), // GoldRing
        // Magic weapons (Weapon slot)
        9 => ('Ghost Wand', Tier::T2, Type::Magic_or_Cloth, Slot::Weapon), // GhostWand
        10 => ('Grave Wand', Tier::T3, Type::Magic_or_Cloth, Slot::Weapon), // GraveWand
        11 => ('Bone Wand', Tier::T1, Type::Magic_or_Cloth, Slot::Weapon), // BoneWand
        12 => ('Wand', Tier::T1, Type::Magic_or_Cloth, Slot::Weapon), // Wand
        13 => ('Grimoire', Tier::T4, Type::Magic_or_Cloth, Slot::Weapon), // Grimoire
        14 => ('Chronicle', Tier::T5, Type::Magic_or_Cloth, Slot::Weapon), // Chronicle
        15 => ('Tome', Tier::T3, Type::Magic_or_Cloth, Slot::Weapon), // Tome
        16 => ('Book', Tier::T2, Type::Magic_or_Cloth, Slot::Weapon), // Book
        // Cloth armor (Chest slot)
        17 => ('Divine Robe', Tier::T1, Type::Magic_or_Cloth, Slot::Chest), // DivineRobe
        18 => ('Silk Robe', Tier::T2, Type::Magic_or_Cloth, Slot::Chest), // SilkRobe
        19 => ('Linen Robe', Tier::T1, Type::Magic_or_Cloth, Slot::Chest), // LinenRobe
        20 => ('Robe', Tier::T1, Type::Magic_or_Cloth, Slot::Chest), // Robe
        21 => ('Shirt', Tier::T1, Type::Magic_or_Cloth, Slot::Chest), // Shirt
        // Head armor (Head slot)
        22 => ('Crown', Tier::T1, Type::Magic_or_Cloth, Slot::Head), // Crown
        23 => ('Divine Hood', Tier::T1, Type::Magic_or_Cloth, Slot::Head), // DivineHood
        24 => ('Silk Hood', Tier::T2, Type::Magic_or_Cloth, Slot::Head), // SilkHood
        25 => ('Linen Hood', Tier::T1, Type::Magic_or_Cloth, Slot::Head), // LinenHood
        26 => ('Hood', Tier::T1, Type::Magic_or_Cloth, Slot::Head), // Hood
        // Waist armor (Waist slot)
        27 => ('Brightsilk Sash', Tier::T3, Type::Magic_or_Cloth, Slot::Waist), // BrightsilkSash
        28 => ('Silk Sash', Tier::T2, Type::Magic_or_Cloth, Slot::Waist), // SilkSash
        29 => ('Wool Sash', Tier::T1, Type::Magic_or_Cloth, Slot::Waist), // WoolSash
        30 => ('Linen Sash', Tier::T1, Type::Magic_or_Cloth, Slot::Waist), // LinenSash
        31 => ('Sash', Tier::T1, Type::Magic_or_Cloth, Slot::Waist), // Sash
        // Foot armor (Foot slot)
        32 => ('Divine Slippers', Tier::T1, Type::Magic_or_Cloth, Slot::Foot), // DivineSlippers
        33 => ('Silk Slippers', Tier::T2, Type::Magic_or_Cloth, Slot::Foot), // SilkSlippers
        34 => ('Wool Shoes', Tier::T1, Type::Magic_or_Cloth, Slot::Foot), // WoolShoes
        35 => ('Linen Shoes', Tier::T1, Type::Magic_or_Cloth, Slot::Foot), // LinenShoes
        36 => ('Shoes', Tier::T1, Type::Magic_or_Cloth, Slot::Foot), // Shoes
        // Hand armor (Hand slot)
        37 => ('Divine Gloves', Tier::T1, Type::Magic_or_Cloth, Slot::Hand), // DivineGloves
        38 => ('Silk Gloves', Tier::T2, Type::Magic_or_Cloth, Slot::Hand), // SilkGloves
        39 => ('Wool Gloves', Tier::T1, Type::Magic_or_Cloth, Slot::Hand), // WoolGloves
        40 => ('Linen Gloves', Tier::T1, Type::Magic_or_Cloth, Slot::Hand), // LinenGloves
        41 => ('Gloves', Tier::T1, Type::Magic_or_Cloth, Slot::Hand), // Gloves
        // Blade weapons (Weapon slot)
        42 => ('Katana', Tier::T1, Type::Blade_or_Hide, Slot::Weapon), // Katana
        43 => ('Falchion', Tier::T2, Type::Blade_or_Hide, Slot::Weapon), // Falchion
        44 => ('Scimitar', Tier::T3, Type::Blade_or_Hide, Slot::Weapon), // Scimitar
        45 => ('Long Sword', Tier::T2, Type::Blade_or_Hide, Slot::Weapon), // LongSword
        46 => ('Short Sword', Tier::T1, Type::Blade_or_Hide, Slot::Weapon), // ShortSword
        // Hide armor (Chest slot)
        47 => ('Demon Husk', Tier::T4, Type::Blade_or_Hide, Slot::Chest), // DemonHusk
        48 => ('Dragonskin Armor', Tier::T5, Type::Blade_or_Hide, Slot::Chest), // DragonskinArmor
        49 => (
            'Studded Leather Armor', Tier::T3, Type::Blade_or_Hide, Slot::Chest,
        ), // StuddedLeatherArmor
        50 => (
            'Hard Leather Armor', Tier::T2, Type::Blade_or_Hide, Slot::Chest,
        ), // HardLeatherArmor
        51 => ('Leather Armor', Tier::T1, Type::Blade_or_Hide, Slot::Chest), // LeatherArmor
        // Head armor (Head slot)
        52 => ('Demon Crown', Tier::T4, Type::Blade_or_Hide, Slot::Head), // DemonCrown
        53 => ('Dragons Crown', Tier::T5, Type::Blade_or_Hide, Slot::Head), // DragonsCrown
        54 => ('War Cap', Tier::T3, Type::Blade_or_Hide, Slot::Head), // WarCap
        55 => ('Leather Cap', Tier::T2, Type::Blade_or_Hide, Slot::Head), // LeatherCap
        56 => ('Cap', Tier::T1, Type::Blade_or_Hide, Slot::Head), // Cap
        // Waist armor (Waist slot)
        57 => ('Demonhide Belt', Tier::T4, Type::Blade_or_Hide, Slot::Waist), // DemonhideBelt
        58 => ('Dragonskin Belt', Tier::T5, Type::Blade_or_Hide, Slot::Waist), // DragonskinBelt
        59 => (
            'Studded Leather Belt', Tier::T3, Type::Blade_or_Hide, Slot::Waist,
        ), // StuddedLeatherBelt
        60 => ('Hard Leather Belt', Tier::T2, Type::Blade_or_Hide, Slot::Waist), // HardLeatherBelt
        61 => ('Leather Belt', Tier::T1, Type::Blade_or_Hide, Slot::Waist), // LeatherBelt
        // Foot armor (Foot slot)
        62 => ('Demonhide Boots', Tier::T4, Type::Blade_or_Hide, Slot::Foot), // DemonhideBoots
        63 => ('Dragonskin Boots', Tier::T5, Type::Blade_or_Hide, Slot::Foot), // DragonskinBoots
        64 => (
            'Studded Leather Boots', Tier::T3, Type::Blade_or_Hide, Slot::Foot,
        ), // StuddedLeatherBoots
        65 => ('Hard Leather Boots', Tier::T2, Type::Blade_or_Hide, Slot::Foot), // HardLeatherBoots
        66 => ('Leather Boots', Tier::T1, Type::Blade_or_Hide, Slot::Foot), // LeatherBoots
        // Hand armor (Hand slot)
        67 => ('Demons Hands', Tier::T4, Type::Blade_or_Hide, Slot::Hand), // DemonsHands
        68 => ('Dragonskin Gloves', Tier::T5, Type::Blade_or_Hide, Slot::Hand), // DragonskinGloves
        69 => (
            'Studded Leather Gloves', Tier::T3, Type::Blade_or_Hide, Slot::Hand,
        ), // StuddedLeatherGloves
        70 => (
            'Hard Leather Gloves', Tier::T2, Type::Blade_or_Hide, Slot::Hand,
        ), // HardLeatherGloves
        71 => ('Leather Gloves', Tier::T1, Type::Blade_or_Hide, Slot::Hand), // LeatherGloves
        // Bludgeon weapons (Weapon slot)
        72 => ('Warhammer', Tier::T4, Type::Bludgeon_or_Metal, Slot::Weapon), // Warhammer
        73 => ('Quarterstaff', Tier::T2, Type::Bludgeon_or_Metal, Slot::Weapon), // Quarterstaff
        74 => ('Maul', Tier::T5, Type::Bludgeon_or_Metal, Slot::Weapon), // Maul
        75 => ('Mace', Tier::T3, Type::Bludgeon_or_Metal, Slot::Weapon), // Mace
        76 => ('Club', Tier::T1, Type::Bludgeon_or_Metal, Slot::Weapon), // Club
        // Metal armor (Chest slot)
        77 => ('Holy Chestplate', Tier::T4, Type::Bludgeon_or_Metal, Slot::Chest), // HolyChestplate
        78 => (
            'Ornate Chestplate', Tier::T5, Type::Bludgeon_or_Metal, Slot::Chest,
        ), // OrnateChestplate
        79 => ('Plate Mail', Tier::T3, Type::Bludgeon_or_Metal, Slot::Chest), // PlateMail
        80 => ('Chain Mail', Tier::T2, Type::Bludgeon_or_Metal, Slot::Chest), // ChainMail
        81 => ('Ring Mail', Tier::T1, Type::Bludgeon_or_Metal, Slot::Chest), // RingMail
        // Head armor (Head slot)
        82 => ('Ancient Helm', Tier::T4, Type::Bludgeon_or_Metal, Slot::Head), // AncientHelm
        83 => ('Ornate Helm', Tier::T5, Type::Bludgeon_or_Metal, Slot::Head), // OrnateHelm
        84 => ('Great Helm', Tier::T3, Type::Bludgeon_or_Metal, Slot::Head), // GreatHelm
        85 => ('Full Helm', Tier::T2, Type::Bludgeon_or_Metal, Slot::Head), // FullHelm
        86 => ('Helm', Tier::T1, Type::Bludgeon_or_Metal, Slot::Head), // Helm
        // Waist armor (Waist slot)
        87 => ('Ornate Belt', Tier::T5, Type::Bludgeon_or_Metal, Slot::Waist), // OrnateBelt
        88 => ('War Belt', Tier::T4, Type::Bludgeon_or_Metal, Slot::Waist), // WarBelt
        89 => ('Plated Belt', Tier::T3, Type::Bludgeon_or_Metal, Slot::Waist), // PlatedBelt
        90 => ('Mesh Belt', Tier::T2, Type::Bludgeon_or_Metal, Slot::Waist), // MeshBelt
        91 => ('Heavy Belt', Tier::T1, Type::Bludgeon_or_Metal, Slot::Waist), // HeavyBelt
        // Foot armor (Foot slot)
        92 => ('Holy Greaves', Tier::T4, Type::Bludgeon_or_Metal, Slot::Foot), // HolyGreaves
        93 => ('Ornate Greaves', Tier::T5, Type::Bludgeon_or_Metal, Slot::Foot), // OrnateGreaves
        94 => ('Greaves', Tier::T3, Type::Bludgeon_or_Metal, Slot::Foot), // Greaves
        95 => ('Chain Boots', Tier::T2, Type::Bludgeon_or_Metal, Slot::Foot), // ChainBoots
        96 => ('Heavy Boots', Tier::T1, Type::Bludgeon_or_Metal, Slot::Foot), // HeavyBoots
        // Hand armor (Hand slot)
        97 => ('Holy Gauntlets', Tier::T4, Type::Bludgeon_or_Metal, Slot::Hand), // HolyGauntlets
        98 => (
            'Ornate Gauntlets', Tier::T5, Type::Bludgeon_or_Metal, Slot::Hand,
        ), // OrnateGauntlets
        99 => ('Gauntlets', Tier::T3, Type::Bludgeon_or_Metal, Slot::Hand), // Gauntlets
        100 => ('Chain Gloves', Tier::T2, Type::Bludgeon_or_Metal, Slot::Hand), // ChainGloves
        101 => ('Heavy Gloves', Tier::T1, Type::Bludgeon_or_Metal, Slot::Hand), // HeavyGloves
        _ => ('Unknown', Tier::None, Type::None, Slot::None) // Default for unknown IDs
    };

    ItemVerbose { name, id: item.id, xp: item.xp, tier, item_type, slot }
}

pub fn get_simple_adventurer_verbose() -> AdventurerVerbose {
    create_adventurer_verbose_with_name("TestAdventurer")
}

pub fn get_max_stats_adventurer() -> AdventurerVerbose {
    let stats = Stats {
        strength: 255,
        dexterity: 255,
        vitality: 255,
        intelligence: 255,
        wisdom: 255,
        charisma: 255,
        luck: 255,
    };
    let max_health = stats.get_max_health(); // 100 + (255 * 15) = 3925
    let adventurer = Adventurer {
        health: max_health,
        xp: 25500, // Level 255
        stats,
        gold: 65535,
        equipment: Equipment {
            weapon: Item { id: 42, xp: 65535 }, // Katana
            chest: Item { id: 17, xp: 65535 }, // Divine Robe
            head: Item { id: 22, xp: 65535 }, // Crown
            waist: Item { id: 29, xp: 65535 }, // Wool Sash
            foot: Item { id: 32, xp: 65535 }, // Divine Slippers
            hand: Item { id: 37, xp: 65535 }, // Divine Gloves
            neck: Item { id: 3, xp: 65535 }, // Amulet
            ring: Item { id: 8, xp: 65535 } // Gold Ring
        },
        beast_health: 65535,
        stat_upgrades_available: 255,
        item_specials_seed: 65535,
        action_count: 65535,
    };

    let level = 255_u8;

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

    // Create empty bag
    let empty_item = ItemVerbose {
        name: 'Empty', id: 0, xp: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None,
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
        name: "MaxStatsAdventurer",
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

pub fn get_min_stats_adventurer() -> AdventurerVerbose {
    let adventurer = Adventurer {
        health: 1,
        xp: 1,
        stats: Stats {
            strength: 0,
            dexterity: 0,
            vitality: 0,
            intelligence: 0,
            wisdom: 0,
            charisma: 0,
            luck: 0,
        },
        gold: 0,
        equipment: Equipment {
            weapon: Item { id: 0, xp: 0 },
            chest: Item { id: 0, xp: 0 },
            head: Item { id: 0, xp: 0 },
            waist: Item { id: 0, xp: 0 },
            foot: Item { id: 0, xp: 0 },
            hand: Item { id: 0, xp: 0 },
            neck: Item { id: 0, xp: 0 },
            ring: Item { id: 0, xp: 0 },
        },
        beast_health: 0,
        stat_upgrades_available: 0,
        item_specials_seed: 0,
        action_count: 0,
    };

    let level = 1_u8;

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

    // Create empty bag
    let empty_item = ItemVerbose {
        name: 'Empty', id: 0, xp: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None,
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
        name: "MinStatsAdventurer",
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

pub fn create_adventurer_verbose_with_name(name: ByteArray) -> AdventurerVerbose {
    let adventurer = get_simple_adventurer();
    let level = (adventurer.xp / 100) + 1; // Simple level calculation

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
        name: 'Empty', id: 0, xp: 0, tier: Tier::None, item_type: Type::None, slot: Slot::None,
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
        level: level.try_into().unwrap(),
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
