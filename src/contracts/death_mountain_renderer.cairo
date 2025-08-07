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
    fn get_adventurer_contract_address(self: @TState) -> ContractAddress;
}

#[starknet::contract]
pub mod renderer_contract {
    use death_mountain_renderer::interfaces::adventurer_interface::{
        IAdventurerSystemsDispatcher, IAdventurerSystemsDispatcherTrait,
    };
    use death_mountain_renderer::models::models::{AdventurerVerbose, GameDetail};
    use death_mountain_renderer::utils::renderer::Renderer;
    use death_mountain_renderer::utils::renderer_utils::generate_details;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use core::num::traits::Zero;

    /// @notice Contract storage structure
    #[storage]
    pub struct Storage {
        /// @notice Dispatcher for the adventurer systems contract
        /// @dev Used by the renderer to fetch adventurer stats and equipment with resolved item
        /// names
        adventurer_address: ContractAddress,
    }

    /// @notice Contract constructor
    /// @dev Initializes the NFT contract with the adventurer systems dispatcher
    /// @param adventurer_dispatcher The dispatcher for the adventurer systems contract
    #[constructor]
    fn constructor(ref self: ContractState, adventurer_address: ContractAddress) {
        assert!(!adventurer_address.is_zero(), "Adventurer address cannot be zero");
        self.adventurer_address.write(adventurer_address);
    }

    #[abi(embed_v0)]
    impl MinigameImpl of super::IMinigameDetails<ContractState> {
        fn game_details(self: @ContractState, token_id: u64) -> Span<GameDetail> {
            let adventurer_id: u64 = token_id.try_into().unwrap();
            let adventurer_address = self.adventurer_address.read();
            let adventurer_dispatcher = IAdventurerSystemsDispatcher {
                contract_address: adventurer_address,
            };

            let adventurer_verbose: AdventurerVerbose = adventurer_dispatcher
                .get_adventurer_verbose(adventurer_id);

            let game_details: Span<GameDetail> = generate_details(adventurer_verbose);
            game_details
        }

        fn token_description(self: @ContractState, token_id: u64) -> ByteArray {
            let adventurer_id: u64 = token_id.try_into().unwrap();
            let adventurer_address = self.adventurer_address.read();
            let adventurer_dispatcher = IAdventurerSystemsDispatcher {
                contract_address: adventurer_address,
            };

            let adventurer_verbose: AdventurerVerbose = adventurer_dispatcher
                .get_adventurer_verbose(adventurer_id);

            let (description, _, _) = Renderer::render(token_id.into(), adventurer_verbose);
            description
        }
    }

    #[abi(embed_v0)]
    impl MinigameDetailsImpl of super::IMinigameDetailsSVG<ContractState> {
        fn game_details_svg(self: @ContractState, token_id: u64) -> ByteArray {
            let adventurer_id: u64 = token_id.try_into().unwrap();
            let adventurer_address = self.adventurer_address.read();
            let adventurer_dispatcher = IAdventurerSystemsDispatcher {
                contract_address: adventurer_address,
            };
            let adventurer_verbose: AdventurerVerbose = adventurer_dispatcher
                .get_adventurer_verbose(adventurer_id);

            let (_, image, _) = Renderer::render(token_id.into(), adventurer_verbose);
            image
        }
    }


    #[abi(embed_v0)]
    impl RendererImpl of super::IRenderer<ContractState> {
        fn get_adventurer_contract_address(self: @ContractState) -> ContractAddress {
            self.adventurer_address.read()
        }
    }
}
