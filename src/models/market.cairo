// SPDX-License-Identifier: MIT
//
// @title Market Data Structures - Marketplace rendering support
// @notice Data structures for rendering marketplace items in multi-page NFTs
// @dev Compatible with Death Mountain marketplace implementation

// Market configuration constants (from death-mountain)
pub const NUMBER_OF_ITEMS_PER_LEVEL: u8 = 21;
pub const TIER_PRICE: u16 = 4;

#[derive(Copy, Drop, PartialEq, Serde, Debug)]
pub struct MarketItem {
    pub item_id: u8,
    pub tier: u8,
    pub price: u16,
    pub available: bool,
}

#[derive(Drop, Serde)]
pub struct MarketData {
    pub items: Array<u8>,
    pub adventurer_id: u64,
    pub market_seed: u64,
}

pub impl MarketDataDefault of Default<MarketData> {
    fn default() -> MarketData {
        MarketData { items: ArrayTrait::new(), adventurer_id: 0, market_seed: 0 }
    }
}
