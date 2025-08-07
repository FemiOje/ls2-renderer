// SPDX-License-Identifier: MIT

use death_mountain_renderer::models::models::GameDetail;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IMinigameDetails<TState> {
    fn game_details(self: @TState, token_id: u64) -> Span<GameDetail>;
    fn token_description(self: @TState, token_id: u64) -> ByteArray;
}

#[starknet::interface]
pub trait IMinigameDetailsSVG<TState> {
    fn game_details_svg(self: @TState, token_id: u64) -> ByteArray;
}

#[starknet::interface]
pub trait IRenderer<TState> {
    fn get_death_mountain_address(self: @TState) -> ContractAddress;
}

#[starknet::contract]
pub mod renderer_contract {
    use core::num::traits::Zero;
    use death_mountain_renderer::interfaces::adventurer_interface::{
        IDeathMountainSystemsDispatcher, IDeathMountainSystemsDispatcherTrait,
    };
    use death_mountain_renderer::models::models::{AdventurerVerbose, GameDetail};
    use death_mountain_renderer::utils::renderer::Renderer;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        death_mountain_dispatcher: IDeathMountainSystemsDispatcher,
    }

    #[constructor]
    fn constructor(ref self: ContractState, death_mountain_address: ContractAddress) {
        assert!(!death_mountain_address.is_zero(), "Death Mountain address cannot be zero");
        let death_mountain_dispatcher = IDeathMountainSystemsDispatcher {
            contract_address: death_mountain_address,
        };
        self.death_mountain_dispatcher.write(death_mountain_dispatcher);
    }

    #[abi(embed_v0)]
    impl MinigameImpl of super::IMinigameDetails<ContractState> {
        fn game_details(self: @ContractState, token_id: u64) -> Span<GameDetail> {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            Renderer::get_traits(adventurer_verbose)
        }

        fn token_description(self: @ContractState, token_id: u64) -> ByteArray {
            Renderer::get_description()
        }
    }

    #[abi(embed_v0)]
    impl MinigameDetailsImpl of super::IMinigameDetailsSVG<ContractState> {
        fn game_details_svg(self: @ContractState, token_id: u64) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            Renderer::get_image(adventurer_verbose)
        }
    }


    #[abi(embed_v0)]
    impl RendererImpl of super::IRenderer<ContractState> {
        fn get_death_mountain_address(self: @ContractState) -> ContractAddress {
            self.death_mountain_dispatcher.read().contract_address
        }
    }
}
