#[derive(Drop, Serde)]
pub struct GameDetail {
    pub name: ByteArray,
    pub value: ByteArray,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Item {
    pub id: u8,
    pub xp: u16,
}

#[derive(Drop, Copy, PartialEq, Serde)]
pub struct ItemVerbose {
    pub name: felt252,
    pub id: u8,
    pub xp: u16,
    pub tier: Tier,
    pub item_type: Type,
    pub slot: Slot,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Equipment {
    pub weapon: Item,
    pub chest: Item,
    pub head: Item,
    pub waist: Item,
    pub foot: Item,
    pub hand: Item,
    pub neck: Item,
    pub ring: Item,
}

/// @notice Intended for clients and onchain renderers
#[derive(Drop, Copy, Serde, PartialEq)]
pub struct EquipmentVerbose {
    pub weapon: ItemVerbose,
    pub chest: ItemVerbose,
    pub head: ItemVerbose,
    pub waist: ItemVerbose,
    pub foot: ItemVerbose,
    pub hand: ItemVerbose,
    pub neck: ItemVerbose,
    pub ring: ItemVerbose,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Adventurer {
    pub health: u16,
    pub xp: u16,
    pub gold: u16,
    pub beast_health: u16,
    pub stat_upgrades_available: u8,
    pub stats: Stats,
    pub equipment: Equipment,
    pub item_specials_seed: u16,
    pub action_count: u16,
}

#[derive(Drop, Serde)]
pub struct AdventurerVerbose {
    pub name: felt252,
    pub health: u16,
    pub xp: u16,
    pub level: u8,
    pub gold: u16,
    pub beast_health: u16,
    pub stat_upgrades_available: u8,
    pub stats: Stats,
    pub equipment: EquipmentVerbose,
    pub item_specials_seed: u16,
    pub action_count: u16,
    pub bag: BagVerbose,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Bag {
    pub item_1: Item,
    pub item_2: Item,
    pub item_3: Item,
    pub item_4: Item,
    pub item_5: Item,
    pub item_6: Item,
    pub item_7: Item,
    pub item_8: Item,
    pub item_9: Item,
    pub item_10: Item,
    pub item_11: Item,
    pub item_12: Item,
    pub item_13: Item,
    pub item_14: Item,
    pub item_15: Item,
    pub mutated: bool,
}

#[derive(Drop, Copy, Serde)]
pub struct BagVerbose {
    pub item_1: ItemVerbose,
    pub item_2: ItemVerbose,
    pub item_3: ItemVerbose,
    pub item_4: ItemVerbose,
    pub item_5: ItemVerbose,
    pub item_6: ItemVerbose,
    pub item_7: ItemVerbose,
    pub item_8: ItemVerbose,
    pub item_9: ItemVerbose,
    pub item_10: ItemVerbose,
    pub item_11: ItemVerbose,
    pub item_12: ItemVerbose,
    pub item_13: ItemVerbose,
    pub item_14: ItemVerbose,
    pub item_15: ItemVerbose,
    // pub mutated: bool,
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub enum Type {
    None,
    Magic_or_Cloth,
    Blade_or_Hide,
    Bludgeon_or_Metal,
    Necklace,
    Ring,
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub enum Tier {
    None,
    T1,
    T2,
    T3,
    T4,
    T5,
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub enum Slot {
    None,
    Weapon,
    Chest,
    Head,
    Waist,
    Foot,
    Hand,
    Neck,
    Ring,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct Stats {
    pub strength: u8,
    pub dexterity: u8,
    pub vitality: u8,
    pub intelligence: u8,
    pub wisdom: u8,
    pub charisma: u8,
    pub luck: u8,
}

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct AdventurerEntropy {
    pub entropy: u64,
    pub block_number: u64,
}

#[derive(Copy, Drop, Serde, PartialEq)]
pub enum DiscoveryType {
    Nothing: (),
    Health: u16,
    Gold: u16,
    XP: u16,
}

pub trait StatsTrait {
    fn get_max_health(self: Stats) -> u16;
}

pub impl StatsImpl of StatsTrait {
    // Calculate maximum health based on vitality (similar to death-mountain logic)
    // Starting health: 100, +15 per vitality point
    fn get_max_health(self: Stats) -> u16 {
        let starting_health = 100_u16;
        let health_per_vitality = 15_u16;
        starting_health + (self.vitality.into() * health_per_vitality)
    }
}
