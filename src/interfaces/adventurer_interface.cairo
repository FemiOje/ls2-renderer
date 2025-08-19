// SPDX-License-Identifier: BUSL-1.1

use death_mountain_renderer::models::models::{AdventurerEntropy, AdventurerVerbose};

#[starknet::interface]
pub trait IDeathMountainSystems<T> {
    fn get_adventurer_verbose(self: @T, adventurer_id: u64) -> AdventurerVerbose;
    fn get_adventurer_entropy(self: @T, adventurer_id: u64) -> AdventurerEntropy;
    fn get_market(self: @T, adventurer_id: u64, seed: u64) -> Array<u8>;
}
