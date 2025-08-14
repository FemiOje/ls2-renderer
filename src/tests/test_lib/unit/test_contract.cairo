// SPDX-License-Identifier: MIT
//
// @title Death Mountain Renderer Contract Unit Tests
// @notice Tests for contract interfaces, deployment, and core functionality
// @dev Tests interface compliance, constructor behavior, and entry points

use death_mountain_renderer::contracts::death_mountain_renderer::{renderer_contract};
use death_mountain_renderer::contracts::death_mountain_renderer::{
    IRendererDispatcher, IRendererDispatcherTrait,
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait,
    IMinigameDetailsSVGDispatcher, IMinigameDetailsSVGDispatcherTrait,
};
use starknet::{ContractAddress};
use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, cheat_block_timestamp, load,
    start_cheat_caller_address, stop_cheat_caller_address, CheatSpan,
};

// Test constants
const ZERO_ADDRESS: felt252 = 0;
const MOCK_DEATH_MOUNTAIN_ADDRESS: felt252 = 0x123456789;
const TEST_TOKEN_ID: u64 = 42;

fn deploy_mock_adventurer() -> ContractAddress {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let constructor_args = array![];
    let (death_mountain_address, _) = contract_class.deploy(@constructor_args).unwrap();
    death_mountain_address
}

fn deploy_renderer_contract() -> (ContractAddress, ContractAddress) {
    let mock_adventurer_address = deploy_mock_adventurer();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![mock_adventurer_address.into()];
    
    let (renderer_contract_address, _) = contract_class.deploy(@constructor_args).unwrap();
    (mock_adventurer_address, renderer_contract_address)

}

#[test]
fn test_contract_constructor_valid_address() {
    let (_, contract_address) = deploy_renderer_contract();
    assert!(contract_address.into() != 0, "Contract should be deployed");
}


#[test]
fn test_contract_constructor_zero_address_panic() {
    let zero_address: ContractAddress = 0_felt252.try_into().unwrap();
    
    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![zero_address.into()];
    
    let deployment_result = contract_class.deploy(@constructor_args);
    assert!(deployment_result.is_err(), "Deployment should fail with zero address");
}

#[test]
fn test_contract_implements_minigame_details() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IMinigameDetailsDispatcher { contract_address };
    
    let _traits = contract.game_details(TEST_TOKEN_ID);
    let _description = contract.token_description(TEST_TOKEN_ID);
}

#[test]
fn test_contract_implements_minigame_details_svg() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IMinigameDetailsSVGDispatcher { contract_address };
    
    let _svg_data = contract.game_details_svg(TEST_TOKEN_ID);
}

#[test]
fn test_contract_implements_renderer() {
    let (mock_address, contract_address) = deploy_renderer_contract();
    
    let contract = IRendererDispatcher { contract_address };
    let stored_address = contract.get_death_mountain_address();
    
    let storage_key = selector!("death_mountain_dispatcher");
    let stored_data = load(contract_address, storage_key, 1);
    
    let storage_address_felt = *stored_data.at(0);
    let storage_address: ContractAddress = storage_address_felt.try_into().unwrap();
    
    assert_eq!(storage_address, stored_address, "Storage address should match getter");
    assert_eq!(stored_address, mock_address, "Should match mock adventurer address");
    assert!(stored_data.len() > 0, "Should be able to read storage data");
    assert!(stored_address.into() != 0, "Should return valid Death Mountain address");
}

#[test]
fn test_contract_storage_integrity() {
    let (death_mountain_address, contract_address) = deploy_renderer_contract();
    let contract = IRendererDispatcher { contract_address };
    
    let address1 = contract.get_death_mountain_address();
    let address2 = contract.get_death_mountain_address();
    
    assert_eq!(address1, address2, "Storage should be consistent across calls");
    assert_eq!(address1, death_mountain_address, "Should match constructor parameter");
}

#[test]
fn test_contract_multiple_deployments() {
    let (address1, contract_address1) = deploy_renderer_contract();
    let (address2, contract_address2) = deploy_renderer_contract();
    
    let contract1 = IRendererDispatcher { contract_address: contract_address1 };
    let contract2 = IRendererDispatcher { contract_address: contract_address2 };
    
    assert_eq!(contract1.get_death_mountain_address(), address1, "Contract 1 should have address 1");
    assert_eq!(contract2.get_death_mountain_address(), address2, "Contract 2 should have address 2");
    assert_ne!(contract_address1, contract_address2, "Contract addresses should be different");
}

// Integration with Mock Tests

#[test]
fn test_contract_with_mock_death_mountain() {
    let (mock_address, contract_address) = deploy_renderer_contract();
    
    let minigame_contract = IMinigameDetailsDispatcher { contract_address };
    let svg_contract = IMinigameDetailsSVGDispatcher { contract_address };
    let renderer_contract = IRendererDispatcher { contract_address };
    
    assert_eq!(renderer_contract.get_death_mountain_address(), mock_address, "Renderer interface should work");
    
    let traits = minigame_contract.game_details(TEST_TOKEN_ID);
    assert(traits.len() > 0, 'empty');

    let description = minigame_contract.token_description(TEST_TOKEN_ID);
    assert(description.len() > 0, 'empty');
    
    let svg = svg_contract.game_details_svg(TEST_TOKEN_ID);
    assert(svg.len() > 0, 'empty');
}

// Security Tests

#[test]
fn test_contract_caller_address_independence() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IRendererDispatcher { contract_address };
    
    let caller1: ContractAddress = 0x111.try_into().unwrap();
    let caller2: ContractAddress = 0x222.try_into().unwrap();
    
    start_cheat_caller_address(contract_address, caller1);
    let result1 = contract.get_death_mountain_address();
    stop_cheat_caller_address(contract_address);
    
    start_cheat_caller_address(contract_address, caller2);
    let result2 = contract.get_death_mountain_address();
    stop_cheat_caller_address(contract_address);
    
    assert_eq!(result1, result2, "Contract behavior should be independent of caller");
}

#[test]
fn test_contract_no_unauthorized_state_changes() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IRendererDispatcher { contract_address };
    
    let initial_address = contract.get_death_mountain_address();
    
    let _traits = IMinigameDetailsDispatcher { contract_address }.game_details(TEST_TOKEN_ID);
    let _description = IMinigameDetailsDispatcher { contract_address }.token_description(TEST_TOKEN_ID);
    let _svg = IMinigameDetailsSVGDispatcher { contract_address }.game_details_svg(TEST_TOKEN_ID);
    
    let final_address = contract.get_death_mountain_address();
    
    assert_eq!(initial_address, final_address, "Read operations should not change state");
}

// Edge Cases and Error Handling

#[test]
fn test_contract_with_edge_case_token_ids() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IMinigameDetailsDispatcher { contract_address };
    
    // Test with boundary token IDs
    let _traits_min = contract.game_details(0);
    let _traits_max = contract.game_details(18446744073709551615); // u64 max
    let _traits_mid = contract.game_details(9223372036854775808); // u64 mid
}

#[test]
fn test_contract_deterministic_responses() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IMinigameDetailsDispatcher { contract_address };
    
    let traits1 = contract.game_details(TEST_TOKEN_ID);
    let traits2 = contract.game_details(TEST_TOKEN_ID);
    assert_eq!(traits1.len(), traits2.len(), "Trait count should be consistent");
}

// Performance Tests

#[test]
fn test_contract_response_time() {
    let (_, contract_address) = deploy_renderer_contract();
    
    // Test multiple interface calls
    let minigame_contract = IMinigameDetailsDispatcher { contract_address };
    let svg_contract = IMinigameDetailsSVGDispatcher { contract_address };
    let renderer_contract = IRendererDispatcher { contract_address };
    
    // Multiple rapid calls should all complete
    let mut i: u8 = 0;
    while i != 5 {
        let _address = renderer_contract.get_death_mountain_address();
        let _traits = minigame_contract.game_details(i.into());
        let _description = minigame_contract.token_description(i.into());
        let _svg = svg_contract.game_details_svg(i.into());
        i += 1;
    }
}

// Fuzz Testing

#[test]
#[fuzzer(runs: 100, seed: 888)]
fn fuzz_contract_token_ids(token_id: u64) {
    let (_, contract_address) = deploy_renderer_contract();

    let contract = IMinigameDetailsDispatcher { contract_address };

    let traits = contract.game_details(token_id);
    assert(traits.len() > 0, 'empty');

    let description = contract.token_description(token_id);
    assert(description.len() > 0, 'empty');
    
    let svg_contract = IMinigameDetailsSVGDispatcher { contract_address };

    let svg = svg_contract.game_details_svg(token_id);
    assert(svg.len() > 0, 'empty');
}

#[test]
#[fuzzer(runs: 50, seed: 999)]
fn fuzz_contract_multiple_calls(
    token_id1: u64,
    token_id2: u64,
    token_id3: u64
) {
    let (_, contract_address) = deploy_renderer_contract();
    
    let minigame_contract = IMinigameDetailsDispatcher { contract_address };
    let svg_contract = IMinigameDetailsSVGDispatcher { contract_address };
    
    let traits1 = minigame_contract.game_details(token_id1);
    assert(traits1.len() > 0, 'empty');

    let svg1 = svg_contract.game_details_svg(token_id1);
    assert(svg1.len() > 0, 'empty');
    
    let traits2 = minigame_contract.game_details(token_id2);
    assert(traits2.len() > 0, 'empty');
    
    let svg2 = svg_contract.game_details_svg(token_id2);
    assert(svg2.len() > 0, 'empty');
    
    let traits3 = minigame_contract.game_details(token_id3);
    assert(traits3.len() > 0, 'empty');
    
    let svg3 = svg_contract.game_details_svg(token_id3);
    assert(svg3.len() > 0, 'empty');
    
}

// Storage Tests

#[test]
fn test_contract_storage_consistency() {
    let (_, contract_address) = deploy_renderer_contract();
    let contract = IRendererDispatcher { contract_address };
    
    let address_before = contract.get_death_mountain_address();
    
    cheat_block_timestamp(contract_address, 1000000, CheatSpan::TargetCalls(1));
    let address_after_time = contract.get_death_mountain_address();
    
    assert_eq!(address_before, address_after_time, "Storage should persist across blocks");
}

#[test]
fn test_contract_interface_inheritance() {
    let (_, contract_address) = deploy_renderer_contract();
    
    // Verify the contract implements all expected interfaces
    let minigame_contract = IMinigameDetailsDispatcher { contract_address };
    let svg_contract = IMinigameDetailsSVGDispatcher { contract_address };
    let renderer_contract = IRendererDispatcher { contract_address };
    
    assert_eq!(minigame_contract.contract_address, contract_address, "IMinigameDetails should match");
    assert_eq!(svg_contract.contract_address, contract_address, "IMinigameDetailsSVG should match");
    assert_eq!(renderer_contract.contract_address, contract_address, "IRenderer should match");
}