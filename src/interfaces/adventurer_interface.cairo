// SPDX-License-Identifier: BUSL-1.1

use death_mountain_renderer::models::models::AdventurerVerbose;

#[starknet::interface]
pub trait IAdventurerSystems<T> {
    fn get_adventurer_verbose(self: @T, adventurer_id: u64) -> AdventurerVerbose;
}
