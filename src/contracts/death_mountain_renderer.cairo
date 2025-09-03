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
    fn game_details_svg_page(self: @TState, token_id: u64, page: u8) -> ByteArray;
}

#[starknet::interface]
pub trait IRenderer<TState> {
    fn get_death_mountain_address(self: @TState) -> ContractAddress;
    fn set_death_mountain_address(ref self: TState, new_address: ContractAddress);
}

#[starknet::contract]
pub mod renderer_contract {
    use core::num::traits::Zero;
    use death_mountain_renderer::interfaces::adventurer_interface::{
        IDeathMountainSystemsDispatcher, IDeathMountainSystemsDispatcherTrait,
    };
    use death_mountain_renderer::models::models::{AdventurerVerbose, GameDetail};
    use death_mountain_renderer::utils::renderer::renderer::Renderer;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use openzeppelin_access::ownable::OwnableComponent;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[storage]
    pub struct Storage {
        death_mountain_dispatcher: IDeathMountainSystemsDispatcher,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        assert!(!owner.is_zero(), "owner cannot be zero");
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl MinigameImpl of super::IMinigameDetails<ContractState> {
        fn game_details(self: @ContractState, token_id: u64) -> Span<GameDetail> {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            assert!(!death_mountain_dispatcher.contract_address.is_zero(), "Death Mountain address not set");
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
            assert!(!death_mountain_dispatcher.contract_address.is_zero(), "Death Mountain address not set");
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            Renderer::get_image(adventurer_verbose)
        }

        fn game_details_svg_page(self: @ContractState, token_id: u64, page: u8) -> ByteArray {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            assert!(!death_mountain_dispatcher.contract_address.is_zero(), "Death Mountain address not set");
            let adventurer_verbose: AdventurerVerbose = death_mountain_dispatcher
                .get_adventurer_verbose(token_id);
            Renderer::get_image_page(adventurer_verbose, page)
        }
    }

    #[abi(embed_v0)]
    impl RendererImpl of super::IRenderer<ContractState> {
        fn get_death_mountain_address(self: @ContractState) -> ContractAddress {
            self.death_mountain_dispatcher.read().contract_address
        }

        fn set_death_mountain_address(ref self: ContractState, new_address: ContractAddress) {
            self.ownable.assert_only_owner();
            assert!(!new_address.is_zero(), "new address cannot be zero");
            
            let death_mountain_dispatcher = IDeathMountainSystemsDispatcher {
                contract_address: new_address,
            };
            self.death_mountain_dispatcher.write(death_mountain_dispatcher);
        }
    }

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;
}
