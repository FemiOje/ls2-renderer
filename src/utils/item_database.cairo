// SPDX-License-Identifier: MIT
// Complete Item Database System for LS2 Renderer
// Contains all 101 items with proper classification and lookup functions

pub mod ItemId {
    pub const Pendant: u8 = 1;
    pub const Necklace: u8 = 2;
    pub const Amulet: u8 = 3;
    pub const SilverRing: u8 = 4;
    pub const BronzeRing: u8 = 5;
    pub const PlatinumRing: u8 = 6;
    pub const TitaniumRing: u8 = 7;
    pub const GoldRing: u8 = 8;
    pub const GhostWand: u8 = 9;
    pub const GraveWand: u8 = 10;
    pub const BoneWand: u8 = 11;
    pub const Wand: u8 = 12;
    pub const Grimoire: u8 = 13;
    pub const Chronicle: u8 = 14;
    pub const Tome: u8 = 15;
    pub const Book: u8 = 16;
    pub const DivineRobe: u8 = 17;
    pub const SilkRobe: u8 = 18;
    pub const LinenRobe: u8 = 19;
    pub const Robe: u8 = 20;
    pub const Shirt: u8 = 21;
    pub const Crown: u8 = 22;
    pub const DivineHood: u8 = 23;
    pub const SilkHood: u8 = 24;
    pub const LinenHood: u8 = 25;
    pub const Hood: u8 = 26;
    pub const BrightsilkSash: u8 = 27;
    pub const SilkSash: u8 = 28;
    pub const WoolSash: u8 = 29;
    pub const LinenSash: u8 = 30;
    pub const Sash: u8 = 31;
    pub const DivineSlippers: u8 = 32;
    pub const SilkSlippers: u8 = 33;
    pub const WoolShoes: u8 = 34;
    pub const LinenShoes: u8 = 35;
    pub const Shoes: u8 = 36;
    pub const DivineGloves: u8 = 37;
    pub const SilkGloves: u8 = 38;
    pub const WoolGloves: u8 = 39;
    pub const LinenGloves: u8 = 40;
    pub const Gloves: u8 = 41;
    pub const Katana: u8 = 42;
    pub const Falchion: u8 = 43;
    pub const Scimitar: u8 = 44;
    pub const LongSword: u8 = 45;
    pub const ShortSword: u8 = 46;
    pub const DemonHusk: u8 = 47;
    pub const DragonskinArmor: u8 = 48;
    pub const StuddedLeatherArmor: u8 = 49;
    pub const HardLeatherArmor: u8 = 50;
    pub const LeatherArmor: u8 = 51;
    pub const DemonCrown: u8 = 52;
    pub const DragonsCrown: u8 = 53;
    pub const WarCap: u8 = 54;
    pub const LeatherCap: u8 = 55;
    pub const Cap: u8 = 56;
    pub const DemonhideBelt: u8 = 57;
    pub const DragonskinBelt: u8 = 58;
    pub const StuddedLeatherBelt: u8 = 59;
    pub const HardLeatherBelt: u8 = 60;
    pub const LeatherBelt: u8 = 61;
    pub const DemonhideBoots: u8 = 62;
    pub const DragonskinBoots: u8 = 63;
    pub const StuddedLeatherBoots: u8 = 64;
    pub const HardLeatherBoots: u8 = 65;
    pub const LeatherBoots: u8 = 66;
    pub const DemonsHands: u8 = 67;
    pub const DragonskinGloves: u8 = 68;
    pub const StuddedLeatherGloves: u8 = 69;
    pub const HardLeatherGloves: u8 = 70;
    pub const LeatherGloves: u8 = 71;
    pub const Warhammer: u8 = 72;
    pub const Quarterstaff: u8 = 73;
    pub const Maul: u8 = 74;
    pub const Mace: u8 = 75;
    pub const Club: u8 = 76;
    pub const HolyChestplate: u8 = 77;
    pub const OrnateChestplate: u8 = 78;
    pub const PlateMail: u8 = 79;
    pub const ChainMail: u8 = 80;
    pub const RingMail: u8 = 81;
    pub const AncientHelm: u8 = 82;
    pub const OrnateHelm: u8 = 83;
    pub const GreatHelm: u8 = 84;
    pub const FullHelm: u8 = 85;
    pub const Helm: u8 = 86;
    pub const OrnateBelt: u8 = 87;
    pub const WarBelt: u8 = 88;
    pub const PlatedBelt: u8 = 89;
    pub const MeshBelt: u8 = 90;
    pub const HeavyBelt: u8 = 91;
    pub const HolyGreaves: u8 = 92;
    pub const OrnateGreaves: u8 = 93;
    pub const Greaves: u8 = 94;
    pub const ChainBoots: u8 = 95;
    pub const HeavyBoots: u8 = 96;
    pub const HolyGauntlets: u8 = 97;
    pub const OrnateGauntlets: u8 = 98;
    pub const Gauntlets: u8 = 99;
    pub const ChainGloves: u8 = 100;
    pub const HeavyGloves: u8 = 101;
}

pub mod ItemType {
    pub const Jewelry: u8 = 1;
    pub const Weapon: u8 = 2;
    pub const Armor: u8 = 3;
}

pub mod ItemSlot {
    pub const Neck: u8 = 1;
    pub const Ring: u8 = 2;
    pub const Weapon: u8 = 3;
    pub const Chest: u8 = 4;
    pub const Head: u8 = 5;
    pub const Waist: u8 = 6;
    pub const Foot: u8 = 7;
    pub const Hand: u8 = 8;
}

pub mod ItemTier {
    pub const T1: u8 = 1;
    pub const T2: u8 = 2;
    pub const T3: u8 = 3;
    pub const T4: u8 = 4;
    pub const T5: u8 = 5;
}

pub mod ItemString {
    pub const Pendant: felt252 = 'Pendant';
    pub const Necklace: felt252 = 'Necklace';
    pub const Amulet: felt252 = 'Amulet';
    pub const SilverRing: felt252 = 'Silver Ring';
    pub const BronzeRing: felt252 = 'Bronze Ring';
    pub const PlatinumRing: felt252 = 'Platinum Ring';
    pub const TitaniumRing: felt252 = 'Titanium Ring';
    pub const GoldRing: felt252 = 'Gold Ring';
    pub const GhostWand: felt252 = 'Ghost Wand';
    pub const GraveWand: felt252 = 'Grave Wand';
    pub const BoneWand: felt252 = 'Bone Wand';
    pub const Wand: felt252 = 'Wand';
    pub const Grimoire: felt252 = 'Grimoire';
    pub const Chronicle: felt252 = 'Chronicle';
    pub const Tome: felt252 = 'Tome';
    pub const Book: felt252 = 'Book';
    pub const DivineRobe: felt252 = 'Divine Robe';
    pub const SilkRobe: felt252 = 'Silk Robe';
    pub const LinenRobe: felt252 = 'Linen Robe';
    pub const Robe: felt252 = 'Robe';
    pub const Shirt: felt252 = 'Shirt';
    pub const Crown: felt252 = 'Crown';
    pub const DivineHood: felt252 = 'Divine Hood';
    pub const SilkHood: felt252 = 'Silk Hood';
    pub const LinenHood: felt252 = 'Linen Hood';
    pub const Hood: felt252 = 'Hood';
    pub const BrightsilkSash: felt252 = 'Brightsilk Sash';
    pub const SilkSash: felt252 = 'Silk Sash';
    pub const WoolSash: felt252 = 'Wool Sash';
    pub const LinenSash: felt252 = 'Linen Sash';
    pub const Sash: felt252 = 'Sash';
    pub const DivineSlippers: felt252 = 'Divine Slippers';
    pub const SilkSlippers: felt252 = 'Silk Slippers';
    pub const WoolShoes: felt252 = 'Wool Shoes';
    pub const LinenShoes: felt252 = 'Linen Shoes';
    pub const Shoes: felt252 = 'Shoes';
    pub const DivineGloves: felt252 = 'Divine Gloves';
    pub const SilkGloves: felt252 = 'Silk Gloves';
    pub const WoolGloves: felt252 = 'Wool Gloves';
    pub const LinenGloves: felt252 = 'Linen Gloves';
    pub const Gloves: felt252 = 'Gloves';
    pub const Katana: felt252 = 'Katana';
    pub const Falchion: felt252 = 'Falchion';
    pub const Scimitar: felt252 = 'Scimitar';
    pub const LongSword: felt252 = 'Long Sword';
    pub const ShortSword: felt252 = 'Short Sword';
    pub const DemonHusk: felt252 = 'Demon Husk';
    pub const DragonskinArmor: felt252 = 'Dragonskin Armor';
    pub const StuddedLeatherArmor: felt252 = 'Studded Leather Armor';
    pub const HardLeatherArmor: felt252 = 'Hard Leather Armor';
    pub const LeatherArmor: felt252 = 'Leather Armor';
    pub const DemonCrown: felt252 = 'Demon Crown';
    pub const DragonsCrown: felt252 = 'Dragon\'s Crown';
    pub const WarCap: felt252 = 'War Cap';
    pub const LeatherCap: felt252 = 'Leather Cap';
    pub const Cap: felt252 = 'Cap';
    pub const DemonhideBelt: felt252 = 'Demonhide Belt';
    pub const DragonskinBelt: felt252 = 'Dragonskin Belt';
    pub const StuddedLeatherBelt: felt252 = 'Studded Leather Belt';
    pub const HardLeatherBelt: felt252 = 'Hard Leather Belt';
    pub const LeatherBelt: felt252 = 'Leather Belt';
    pub const DemonhideBoots: felt252 = 'Demonhide Boots';
    pub const DragonskinBoots: felt252 = 'Dragonskin Boots';
    pub const StuddedLeatherBoots: felt252 = 'Studded Leather Boots';
    pub const HardLeatherBoots: felt252 = 'Hard Leather Boots';
    pub const LeatherBoots: felt252 = 'Leather Boots';
    pub const DemonsHands: felt252 = 'Demon\'s Hands';
    pub const DragonskinGloves: felt252 = 'Dragonskin Gloves';
    pub const StuddedLeatherGloves: felt252 = 'Studded Leather Gloves';
    pub const HardLeatherGloves: felt252 = 'Hard Leather Gloves';
    pub const LeatherGloves: felt252 = 'Leather Gloves';
    pub const Warhammer: felt252 = 'Warhammer';
    pub const Quarterstaff: felt252 = 'Quarterstaff';
    pub const Maul: felt252 = 'Maul';
    pub const Mace: felt252 = 'Mace';
    pub const Club: felt252 = 'Club';
    pub const HolyChestplate: felt252 = 'Holy Chestplate';
    pub const OrnateChestplate: felt252 = 'Ornate Chestplate';
    pub const PlateMail: felt252 = 'Plate Mail';
    pub const ChainMail: felt252 = 'Chain Mail';
    pub const RingMail: felt252 = 'Ring Mail';
    pub const AncientHelm: felt252 = 'Ancient Helm';
    pub const OrnateHelm: felt252 = 'Ornate Helm';
    pub const GreatHelm: felt252 = 'Great Helm';
    pub const FullHelm: felt252 = 'Full Helm';
    pub const Helm: felt252 = 'Helm';
    pub const OrnateBelt: felt252 = 'Ornate Belt';
    pub const WarBelt: felt252 = 'War Belt';
    pub const PlatedBelt: felt252 = 'Plated Belt';
    pub const MeshBelt: felt252 = 'Mesh Belt';
    pub const HeavyBelt: felt252 = 'Heavy Belt';
    pub const HolyGreaves: felt252 = 'Holy Greaves';
    pub const OrnateGreaves: felt252 = 'Ornate Greaves';
    pub const Greaves: felt252 = 'Greaves';
    pub const ChainBoots: felt252 = 'Chain Boots';
    pub const HeavyBoots: felt252 = 'Heavy Boots';
    pub const HolyGauntlets: felt252 = 'Holy Gauntlets';
    pub const OrnateGauntlets: felt252 = 'Ornate Gauntlets';
    pub const Gauntlets: felt252 = 'Gauntlets';
    pub const ChainGloves: felt252 = 'Chain Gloves';
    pub const HeavyGloves: felt252 = 'Heavy Gloves';
}

pub const NUM_ITEMS: u8 = 101;
pub const SUFFIX_UNLOCK_GREATNESS: u8 = 15;
pub const PREFIXES_UNLOCK_GREATNESS: u8 = 19;

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct ItemInfo {
    pub id: u8,
    pub item_type: u8,
    pub slot: u8,
    pub tier: u8,
    pub name: felt252,
}

#[generate_trait]
pub impl ItemDatabaseImpl of ItemDatabaseTrait {
    fn get_item_info(item_id: u8) -> ItemInfo {
        if item_id == 1 {
            ItemInfo {
                id: 1,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Neck,
                tier: ItemTier::T1,
                name: ItemString::Pendant,
            }
        } else if item_id == 2 {
            ItemInfo {
                id: 2,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Neck,
                tier: ItemTier::T2,
                name: ItemString::Necklace,
            }
        } else if item_id == 3 {
            ItemInfo {
                id: 3,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Neck,
                tier: ItemTier::T3,
                name: ItemString::Amulet,
            }
        } else if item_id == 4 {
            ItemInfo {
                id: 4,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Ring,
                tier: ItemTier::T1,
                name: ItemString::SilverRing,
            }
        } else if item_id == 5 {
            ItemInfo {
                id: 5,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Ring,
                tier: ItemTier::T2,
                name: ItemString::BronzeRing,
            }
        } else if item_id == 6 {
            ItemInfo {
                id: 6,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Ring,
                tier: ItemTier::T3,
                name: ItemString::PlatinumRing,
            }
        } else if item_id == 7 {
            ItemInfo {
                id: 7,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Ring,
                tier: ItemTier::T4,
                name: ItemString::TitaniumRing,
            }
        } else if item_id == 8 {
            ItemInfo {
                id: 8,
                item_type: ItemType::Jewelry,
                slot: ItemSlot::Ring,
                tier: ItemTier::T5,
                name: ItemString::GoldRing,
            }
        } else if item_id == 9 {
            ItemInfo {
                id: 9,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T1,
                name: ItemString::GhostWand,
            }
        } else if item_id == 10 {
            ItemInfo {
                id: 10,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T2,
                name: ItemString::GraveWand,
            }
        } else if item_id == 11 {
            ItemInfo {
                id: 11,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T3,
                name: ItemString::BoneWand,
            }
        } else if item_id == 12 {
            ItemInfo {
                id: 12,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T4,
                name: ItemString::Wand,
            }
        } else if item_id == 13 {
            ItemInfo {
                id: 13,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T5,
                name: ItemString::Grimoire,
            }
        } else if item_id == 14 {
            ItemInfo {
                id: 14,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T1,
                name: ItemString::Chronicle,
            }
        } else if item_id == 15 {
            ItemInfo {
                id: 15,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T2,
                name: ItemString::Tome,
            }
        } else if item_id == 16 {
            ItemInfo {
                id: 16,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T3,
                name: ItemString::Book,
            }
        } else if item_id == 17 {
            ItemInfo {
                id: 17,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T1,
                name: ItemString::DivineRobe,
            }
        } else if item_id == 18 {
            ItemInfo {
                id: 18,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T2,
                name: ItemString::SilkRobe,
            }
        } else if item_id == 19 {
            ItemInfo {
                id: 19,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T3,
                name: ItemString::LinenRobe,
            }
        } else if item_id == 20 {
            ItemInfo {
                id: 20,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T4,
                name: ItemString::Robe,
            }
        } else if item_id == 21 {
            ItemInfo {
                id: 21,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T5,
                name: ItemString::Shirt,
            }
        } else if item_id == 22 {
            ItemInfo {
                id: 22,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T1,
                name: ItemString::Crown,
            }
        } else if item_id == 23 {
            ItemInfo {
                id: 23,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T1,
                name: ItemString::DivineHood,
            }
        } else if item_id == 24 {
            ItemInfo {
                id: 24,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T2,
                name: ItemString::SilkHood,
            }
        } else if item_id == 25 {
            ItemInfo {
                id: 25,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T3,
                name: ItemString::LinenHood,
            }
        } else if item_id == 26 {
            ItemInfo {
                id: 26,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T4,
                name: ItemString::Hood,
            }
        } else if item_id == 27 {
            ItemInfo {
                id: 27,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T1,
                name: ItemString::BrightsilkSash,
            }
        } else if item_id == 28 {
            ItemInfo {
                id: 28,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T2,
                name: ItemString::SilkSash,
            }
        } else if item_id == 29 {
            ItemInfo {
                id: 29,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T3,
                name: ItemString::WoolSash,
            }
        } else if item_id == 30 {
            ItemInfo {
                id: 30,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T4,
                name: ItemString::LinenSash,
            }
        } else if item_id == 31 {
            ItemInfo {
                id: 31,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T5,
                name: ItemString::Sash,
            }
        } else if item_id == 32 {
            ItemInfo {
                id: 32,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T1,
                name: ItemString::DivineSlippers,
            }
        } else if item_id == 33 {
            ItemInfo {
                id: 33,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T2,
                name: ItemString::SilkSlippers,
            }
        } else if item_id == 34 {
            ItemInfo {
                id: 34,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T3,
                name: ItemString::WoolShoes,
            }
        } else if item_id == 35 {
            ItemInfo {
                id: 35,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T4,
                name: ItemString::LinenShoes,
            }
        } else if item_id == 36 {
            ItemInfo {
                id: 36,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T5,
                name: ItemString::Shoes,
            }
        } else if item_id == 37 {
            ItemInfo {
                id: 37,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T1,
                name: ItemString::DivineGloves,
            }
        } else if item_id == 38 {
            ItemInfo {
                id: 38,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T2,
                name: ItemString::SilkGloves,
            }
        } else if item_id == 39 {
            ItemInfo {
                id: 39,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T3,
                name: ItemString::WoolGloves,
            }
        } else if item_id == 40 {
            ItemInfo {
                id: 40,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T4,
                name: ItemString::LinenGloves,
            }
        } else if item_id == 41 {
            ItemInfo {
                id: 41,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T5,
                name: ItemString::Gloves,
            }
        } else if item_id == 42 {
            ItemInfo {
                id: 42,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T1,
                name: ItemString::Katana,
            }
        } else if item_id == 43 {
            ItemInfo {
                id: 43,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T2,
                name: ItemString::Falchion,
            }
        } else if item_id == 44 {
            ItemInfo {
                id: 44,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T3,
                name: ItemString::Scimitar,
            }
        } else if item_id == 45 {
            ItemInfo {
                id: 45,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T4,
                name: ItemString::LongSword,
            }
        } else if item_id == 46 {
            ItemInfo {
                id: 46,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T5,
                name: ItemString::ShortSword,
            }
        } else if item_id == 47 {
            ItemInfo {
                id: 47,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T1,
                name: ItemString::DemonHusk,
            }
        } else if item_id == 48 {
            ItemInfo {
                id: 48,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T2,
                name: ItemString::DragonskinArmor,
            }
        } else if item_id == 49 {
            ItemInfo {
                id: 49,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T3,
                name: ItemString::StuddedLeatherArmor,
            }
        } else if item_id == 50 {
            ItemInfo {
                id: 50,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T4,
                name: ItemString::HardLeatherArmor,
            }
        } else if item_id == 51 {
            ItemInfo {
                id: 51,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T5,
                name: ItemString::LeatherArmor,
            }
        } else if item_id == 52 {
            ItemInfo {
                id: 52,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T1,
                name: ItemString::DemonCrown,
            }
        } else if item_id == 53 {
            ItemInfo {
                id: 53,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T2,
                name: ItemString::DragonsCrown,
            }
        } else if item_id == 54 {
            ItemInfo {
                id: 54,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T3,
                name: ItemString::WarCap,
            }
        } else if item_id == 55 {
            ItemInfo {
                id: 55,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T4,
                name: ItemString::LeatherCap,
            }
        } else if item_id == 56 {
            ItemInfo {
                id: 56,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T5,
                name: ItemString::Cap,
            }
        } else if item_id == 57 {
            ItemInfo {
                id: 57,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T1,
                name: ItemString::DemonhideBelt,
            }
        } else if item_id == 58 {
            ItemInfo {
                id: 58,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T2,
                name: ItemString::DragonskinBelt,
            }
        } else if item_id == 59 {
            ItemInfo {
                id: 59,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T3,
                name: ItemString::StuddedLeatherBelt,
            }
        } else if item_id == 60 {
            ItemInfo {
                id: 60,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T4,
                name: ItemString::HardLeatherBelt,
            }
        } else if item_id == 61 {
            ItemInfo {
                id: 61,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T5,
                name: ItemString::LeatherBelt,
            }
        } else if item_id == 62 {
            ItemInfo {
                id: 62,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T1,
                name: ItemString::DemonhideBoots,
            }
        } else if item_id == 63 {
            ItemInfo {
                id: 63,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T2,
                name: ItemString::DragonskinBoots,
            }
        } else if item_id == 64 {
            ItemInfo {
                id: 64,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T3,
                name: ItemString::StuddedLeatherBoots,
            }
        } else if item_id == 65 {
            ItemInfo {
                id: 65,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T4,
                name: ItemString::HardLeatherBoots,
            }
        } else if item_id == 66 {
            ItemInfo {
                id: 66,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T5,
                name: ItemString::LeatherBoots,
            }
        } else if item_id == 67 {
            ItemInfo {
                id: 67,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T1,
                name: ItemString::DemonsHands,
            }
        } else if item_id == 68 {
            ItemInfo {
                id: 68,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T2,
                name: ItemString::DragonskinGloves,
            }
        } else if item_id == 69 {
            ItemInfo {
                id: 69,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T3,
                name: ItemString::StuddedLeatherGloves,
            }
        } else if item_id == 70 {
            ItemInfo {
                id: 70,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T4,
                name: ItemString::HardLeatherGloves,
            }
        } else if item_id == 71 {
            ItemInfo {
                id: 71,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T5,
                name: ItemString::LeatherGloves,
            }
        } else if item_id == 72 {
            ItemInfo {
                id: 72,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T1,
                name: ItemString::Warhammer,
            }
        } else if item_id == 73 {
            ItemInfo {
                id: 73,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T2,
                name: ItemString::Quarterstaff,
            }
        } else if item_id == 74 {
            ItemInfo {
                id: 74,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T3,
                name: ItemString::Maul,
            }
        } else if item_id == 75 {
            ItemInfo {
                id: 75,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T4,
                name: ItemString::Mace,
            }
        } else if item_id == 76 {
            ItemInfo {
                id: 76,
                item_type: ItemType::Weapon,
                slot: ItemSlot::Weapon,
                tier: ItemTier::T5,
                name: ItemString::Club,
            }
        } else if item_id == 77 {
            ItemInfo {
                id: 77,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T1,
                name: ItemString::HolyChestplate,
            }
        } else if item_id == 78 {
            ItemInfo {
                id: 78,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T2,
                name: ItemString::OrnateChestplate,
            }
        } else if item_id == 79 {
            ItemInfo {
                id: 79,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T3,
                name: ItemString::PlateMail,
            }
        } else if item_id == 80 {
            ItemInfo {
                id: 80,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T4,
                name: ItemString::ChainMail,
            }
        } else if item_id == 81 {
            ItemInfo {
                id: 81,
                item_type: ItemType::Armor,
                slot: ItemSlot::Chest,
                tier: ItemTier::T5,
                name: ItemString::RingMail,
            }
        } else if item_id == 82 {
            ItemInfo {
                id: 82,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T1,
                name: ItemString::AncientHelm,
            }
        } else if item_id == 83 {
            ItemInfo {
                id: 83,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T2,
                name: ItemString::OrnateHelm,
            }
        } else if item_id == 84 {
            ItemInfo {
                id: 84,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T3,
                name: ItemString::GreatHelm,
            }
        } else if item_id == 85 {
            ItemInfo {
                id: 85,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T4,
                name: ItemString::FullHelm,
            }
        } else if item_id == 86 {
            ItemInfo {
                id: 86,
                item_type: ItemType::Armor,
                slot: ItemSlot::Head,
                tier: ItemTier::T5,
                name: ItemString::Helm,
            }
        } else if item_id == 87 {
            ItemInfo {
                id: 87,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T1,
                name: ItemString::OrnateBelt,
            }
        } else if item_id == 88 {
            ItemInfo {
                id: 88,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T2,
                name: ItemString::WarBelt,
            }
        } else if item_id == 89 {
            ItemInfo {
                id: 89,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T3,
                name: ItemString::PlatedBelt,
            }
        } else if item_id == 90 {
            ItemInfo {
                id: 90,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T4,
                name: ItemString::MeshBelt,
            }
        } else if item_id == 91 {
            ItemInfo {
                id: 91,
                item_type: ItemType::Armor,
                slot: ItemSlot::Waist,
                tier: ItemTier::T5,
                name: ItemString::HeavyBelt,
            }
        } else if item_id == 92 {
            ItemInfo {
                id: 92,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T1,
                name: ItemString::HolyGreaves,
            }
        } else if item_id == 93 {
            ItemInfo {
                id: 93,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T2,
                name: ItemString::OrnateGreaves,
            }
        } else if item_id == 94 {
            ItemInfo {
                id: 94,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T3,
                name: ItemString::Greaves,
            }
        } else if item_id == 95 {
            ItemInfo {
                id: 95,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T4,
                name: ItemString::ChainBoots,
            }
        } else if item_id == 96 {
            ItemInfo {
                id: 96,
                item_type: ItemType::Armor,
                slot: ItemSlot::Foot,
                tier: ItemTier::T5,
                name: ItemString::HeavyBoots,
            }
        } else if item_id == 97 {
            ItemInfo {
                id: 97,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T1,
                name: ItemString::HolyGauntlets,
            }
        } else if item_id == 98 {
            ItemInfo {
                id: 98,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T2,
                name: ItemString::OrnateGauntlets,
            }
        } else if item_id == 99 {
            ItemInfo {
                id: 99,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T3,
                name: ItemString::Gauntlets,
            }
        } else if item_id == 100 {
            ItemInfo {
                id: 100,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T4,
                name: ItemString::ChainGloves,
            }
        } else if item_id == 101 {
            ItemInfo {
                id: 101,
                item_type: ItemType::Armor,
                slot: ItemSlot::Hand,
                tier: ItemTier::T5,
                name: ItemString::HeavyGloves,
            }
        } else {
            ItemInfo { id: 0, item_type: 0, slot: 0, tier: 0, name: '' }
        }
    }

    fn get_item_name(item_id: u8) -> felt252 {
        Self::get_item_info(item_id).name
    }

    fn get_item_type(item_id: u8) -> u8 {
        Self::get_item_info(item_id).item_type
    }

    fn get_item_slot(item_id: u8) -> u8 {
        Self::get_item_info(item_id).slot
    }

    fn get_item_tier(item_id: u8) -> u8 {
        Self::get_item_info(item_id).tier
    }

    fn is_valid_item(item_id: u8) -> bool {
        item_id > 0 && item_id <= NUM_ITEMS
    }

    fn calculate_greatness(xp: u16) -> u8 {
        // Simple greatness calculation based on XP
        let greatness = xp / 10;
        if greatness > 20 {
            20_u8
        } else {
            greatness.try_into().unwrap()
        }
    }

    fn generate_item_display(item_id: u8, xp: u16) -> felt252 {
        if !Self::is_valid_item(item_id) {
            return 'None Equipped';
        }

        let _greatness = Self::calculate_greatness(xp);
        let item_name = Self::get_item_name(item_id);

        // For now, return simple format: "G{greatness} {item_name}"
        // In a full implementation, this would include prefixes and suffixes
        item_name
    }
}
