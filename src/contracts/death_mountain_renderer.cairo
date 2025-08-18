// SPDX-License-Identifier: MIT

use death_mountain_renderer::models::models::GameDetail;
use death_mountain_renderer::models::page_types::{BattleState, PageMode};
use starknet::ContractAddress;

#[starknet::interface]
pub trait IMinigameDetails<TState> {
    fn game_details(self: @TState, token_id: u64) -> Span<GameDetail>;
    fn token_description(self: @TState, token_id: u64) -> ByteArray;
}

#[starknet::interface]
pub trait IMinigameDetailsSVG<TState> {
    fn game_details_svg(self: @TState, token_id: u64) -> ByteArray;
    fn game_details_svg_page(self: @TState, token_id: u64, page: u8) -> ByteArray;
}

#[starknet::interface]
pub trait IMinigameDetailsPaginated<TState> {
    fn game_details_page(self: @TState, token_id: u64, page: u8) -> ByteArray;
    fn get_page_count(self: @TState, token_id: u64) -> u8;
    fn get_page_image(self: @TState, token_id: u64, page: u8) -> ByteArray;
    fn render_animated_pages(self: @TState, token_id: u64) -> ByteArray;
    fn get_battle_state(self: @TState, token_id: u64) -> BattleState;
    fn is_battle_mode(self: @TState, token_id: u64) -> bool;
    fn get_page_mode(self: @TState, token_id: u64) -> PageMode;
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
    use death_mountain_renderer::models::page_types::{BattleState, PageMode};
    use death_mountain_renderer::utils::renderer::page::page_renderer::PageRenderer;
    use death_mountain_renderer::utils::renderer::renderer::Renderer;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        death_mountain_dispatcher: IDeathMountainSystemsDispatcher,
    }

    #[constructor]
    fn constructor(ref self: ContractState, death_mountain_address: ContractAddress) {
        assert!(!death_mountain_address.is_zero(), "address cannot be zero");
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

        fn game_details_svg_page(self: @ContractState, token_id: u64, page: u8) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            Renderer::get_image_page(adventurer_verbose, page)
        }
    }


    #[abi(embed_v0)]
    impl MinigamePaginatedImpl of super::IMinigameDetailsPaginated<ContractState> {
        fn game_details_page(self: @ContractState, token_id: u64, page: u8) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::render_page(token_id, adventurer_verbose, page)
        }

        fn get_page_count(self: @ContractState, token_id: u64) -> u8 {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::get_page_count(adventurer_verbose)
        }

        fn get_page_image(self: @ContractState, token_id: u64, page: u8) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::get_page_image(adventurer_verbose, page)
        }

        fn render_animated_pages(self: @ContractState, token_id: u64) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::render_animated_pages(token_id, adventurer_verbose)
        }

        fn get_battle_state(self: @ContractState, token_id: u64) -> BattleState {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::get_battle_state(adventurer_verbose)
        }

        fn is_battle_mode(self: @ContractState, token_id: u64) -> bool {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::is_battle_mode(adventurer_verbose)
        }

        fn get_page_mode(self: @ContractState, token_id: u64) -> PageMode {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            PageRenderer::get_page_mode(adventurer_verbose)
        }
    }

    #[abi(embed_v0)]
    impl RendererImpl of super::IRenderer<ContractState> {
        fn get_death_mountain_address(self: @ContractState) -> ContractAddress {
            self.death_mountain_dispatcher.read().contract_address
        }
    }
}
