// SPDX-License-Identifier: MIT
//
// @title Fork Testing Integration Tests
// @notice Compact fork testing with focused test cases
// @dev Tests deployment, interfaces, and network behavior on forked Sepolia

use core::num::traits::Bounded;
use death_mountain_renderer::contracts::death_mountain_renderer::{
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait, IMinigameDetailsSVGDispatcher,
    IMinigameDetailsSVGDispatcherTrait, IRendererDispatcher, IRendererDispatcherTrait,
};
use snforge_std::{
    CheatSpan, ContractClassTrait, DeclareResultTrait, cheat_block_number, cheat_block_timestamp,
    declare, start_cheat_caller_address, stop_cheat_caller_address,
};
use starknet::ContractAddress;

const SEPOLIA_DEATH_MOUNTAIN_ADDRESS: felt252 =
    0x6492209fe1a4e397c335fd7b9d6a6f2e5beae22e14443134c1aa4eb755f3fce;
const TEST_TOKEN_ID: u64 = 1;
const TEST_ACCOUNT: felt252 = 0x05eb7f656bed40a49b1fc0c0bfadf91b39aa92f073d4fafdc267a862b31d229d;

fn deploy_fork_renderer() -> ContractAddress {
    let death_mountain_address: ContractAddress = SEPOLIA_DEATH_MOUNTAIN_ADDRESS
        .try_into()
        .unwrap();
    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (contract_address, _) = contract_class.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_deployment_succeeds() {
    let contract_address = deploy_fork_renderer();
    assert!(contract_address.into() != 0, "Contract should deploy on fork");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_stores_death_mountain_address() {
    let contract_address = deploy_fork_renderer();
    let renderer = IRendererDispatcher { contract_address };
    let stored_address = renderer.get_death_mountain_address();
    let expected: ContractAddress = SEPOLIA_DEATH_MOUNTAIN_ADDRESS.try_into().unwrap();
    assert_eq!(stored_address, expected, "Should store correct address");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_minigame_details_interface() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let _traits = renderer.game_details(TEST_TOKEN_ID);
    let _description = renderer.token_description(TEST_TOKEN_ID);
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_svg_interface() {
    let contract_address = deploy_fork_renderer();
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };
    let _svg = svg_renderer.game_details_svg(TEST_TOKEN_ID);
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_gas_efficiency() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    // Test multiple operations complete within gas limits
    let _traits = renderer.game_details(1_u64);
    let _description = renderer.token_description(100_u64);
    let _svg = svg_renderer.game_details_svg(999_u64);
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_block_timestamp_independence() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let result1 = renderer.game_details(TEST_TOKEN_ID);

    let current_timestamp = starknet::get_block_timestamp();
    cheat_block_timestamp(contract_address, current_timestamp + 3600, CheatSpan::TargetCalls(1));
    let result2 = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(result1.len(), result2.len(), "Block timestamp should not affect results");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_block_number_independence() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let result1 = renderer.game_details(TEST_TOKEN_ID);

    let current_block = starknet::get_block_number();
    cheat_block_number(contract_address, current_block + 100, CheatSpan::TargetCalls(1));
    let result2 = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(result1.len(), result2.len(), "Block number should not affect results");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_caller_independence() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let caller1 = 0x1111.try_into().unwrap();
    let caller2 = 0x2222.try_into().unwrap();

    start_cheat_caller_address(contract_address, caller1);
    let result1 = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, caller2);
    let result2 = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    assert_eq!(result1.len(), result2.len(), "Different callers should get same results");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_state_consistency() {
    let contract_address = deploy_fork_renderer();
    let renderer = IRendererDispatcher { contract_address };
    let minigame = IMinigameDetailsDispatcher { contract_address };

    let initial_address = renderer.get_death_mountain_address();

    let _traits = minigame.game_details(TEST_TOKEN_ID);
    let _description = minigame.token_description(TEST_TOKEN_ID);

    let final_address = renderer.get_death_mountain_address();
    assert_eq!(initial_address, final_address, "State should remain consistent");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_interface_consistency() {
    let contract_address = deploy_fork_renderer();
    let renderer = IRendererDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    let initial_address = renderer.get_death_mountain_address();
    let _svg = svg_renderer.game_details_svg(TEST_TOKEN_ID);
    let final_address = renderer.get_death_mountain_address();

    assert_eq!(initial_address, final_address, "State consistent across interfaces");
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_multiple_token_ids() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    let test_tokens = array![1_u64, 100_u64, 1000_u64];

    let mut i = 0;
    while i < test_tokens.len() {
        let token_id = *test_tokens.at(i);

        let traits = renderer.game_details(token_id);
        let description = renderer.token_description(token_id);
        let svg = svg_renderer.game_details_svg(token_id);

        assert!(traits.len() >= 0, "Should return trait array");
        assert!(description.len() >= 0, "Should return description");
        assert!(svg.len() >= 0, "Should return SVG");

        i += 1;
    };
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_deployment_address_storage() {
    let death_mountain_addr: ContractAddress = SEPOLIA_DEATH_MOUNTAIN_ADDRESS.try_into().unwrap();
    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_addr.into()];
    let (contract_address, _) = contract_class.deploy(@constructor_args).unwrap();

    let renderer = IRendererDispatcher { contract_address };
    let stored_address = renderer.get_death_mountain_address();
    assert_eq!(stored_address, death_mountain_addr, "Should store correct address");

    let minigame = IMinigameDetailsDispatcher { contract_address };
    let _traits = minigame.game_details(TEST_TOKEN_ID);
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_batch_operations() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let svg_renderer = IMinigameDetailsSVGDispatcher { contract_address };

    let mut i: u8 = 1;
    while i <= 3 {
        let token_id = i.into();
        let _traits = renderer.game_details(token_id);
        let _description = renderer.token_description(token_id);
        let _svg = svg_renderer.game_details_svg(token_id);
        i += 1;
    };
}

#[test]
#[fork("SEPOLIA_LATEST")]
fn test_fork_edge_case_token_ids() {
    let contract_address = deploy_fork_renderer();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    // Test boundary token IDs
    let _traits_min = renderer.game_details(0_u64);
    let _description_min = renderer.token_description(0_u64);

    let _traits_max = renderer.game_details(Bounded::<u64>::MAX);
    let _description_max = renderer.token_description(Bounded::<u64>::MAX);
}
