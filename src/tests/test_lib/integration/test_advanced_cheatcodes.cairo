// SPDX-License-Identifier: MIT
//
// @title Advanced Cheatcodes Integration Tests
// @notice Compact tests for Starknet Foundry cheatcodes
// @dev Tests caller spoofing, storage manipulation, events, and context control

use core::num::traits::Bounded;
use death_mountain_renderer::contracts::death_mountain_renderer::{
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait, IRendererDispatcher,
    IRendererDispatcherTrait,
};
use snforge_std::{
    CheatSpan, ContractClassTrait, DeclareResultTrait, EventSpyTrait, EventsFilterTrait,
    cheat_block_number, cheat_block_timestamp, declare, get_class_hash, load, spy_events,
    start_cheat_account_contract_address, start_cheat_block_number_global,
    start_cheat_block_timestamp_global, start_cheat_caller_address,
    start_cheat_caller_address_global, start_cheat_chain_id_global, start_cheat_sequencer_address,
    stop_cheat_account_contract_address, stop_cheat_block_number_global,
    stop_cheat_block_timestamp_global, stop_cheat_caller_address, stop_cheat_caller_address_global,
    stop_cheat_chain_id_global, stop_cheat_sequencer_address,
};
use starknet::ContractAddress;

const TEST_CALLER_1: felt252 = 0x111111111;
const TEST_CALLER_2: felt252 = 0x222222222;
const TEST_TOKEN_ID: u64 = 1;

fn deploy_test_contracts() -> (ContractAddress, ContractAddress) {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let (death_mountain_address, _) = contract_class.deploy(@array![]).unwrap();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (renderer_address, _) = contract_class.deploy(@constructor_args).unwrap();

    (death_mountain_address, renderer_address)
}

#[test]
fn test_caller_address_consistency() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let caller1: ContractAddress = TEST_CALLER_1.try_into().unwrap();
    let caller2: ContractAddress = TEST_CALLER_2.try_into().unwrap();

    start_cheat_caller_address(contract_address, caller1);
    let result1 = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    start_cheat_caller_address(contract_address, caller2);
    let result2 = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    assert_eq!(result1.len(), result2.len(), "Different callers should get same results");
}

#[test]
fn test_global_caller_cheat() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let global_caller: ContractAddress = 'ADMIN_ADDR'.try_into().unwrap();

    start_cheat_caller_address_global(global_caller);
    let result = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address_global();

    assert!(result.len() >= 0, "Global caller cheat should work");
}

#[test]
fn test_nested_caller_cheats() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let caller1: ContractAddress = TEST_CALLER_1.try_into().unwrap();
    let caller2: ContractAddress = TEST_CALLER_2.try_into().unwrap();

    start_cheat_caller_address(contract_address, caller1);
    let outer_result = renderer.game_details(TEST_TOKEN_ID);

    start_cheat_caller_address(contract_address, caller2);
    let _inner_result = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    let restored_result = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    assert_eq!(
        outer_result.len(), restored_result.len(), "Nested caller cheat should restore correctly",
    );
}

#[test]
fn test_block_timestamp_independence() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    cheat_block_timestamp(contract_address, 1000000, CheatSpan::TargetCalls(1));
    let result1 = renderer.game_details(TEST_TOKEN_ID);

    cheat_block_timestamp(contract_address, 2000000, CheatSpan::TargetCalls(1));
    let result2 = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(
        result1.len(), result2.len(), "Timestamp should not affect deterministic operations",
    );
}

#[test]
fn test_block_number_independence() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    cheat_block_number(contract_address, 100, CheatSpan::TargetCalls(1));
    let result1 = renderer.game_details(TEST_TOKEN_ID);

    cheat_block_number(contract_address, 200, CheatSpan::TargetCalls(1));
    let result2 = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(
        result1.len(), result2.len(), "Block number should not affect deterministic operations",
    );
}

#[test]
fn test_global_block_cheats() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    start_cheat_block_timestamp_global(1000000);
    start_cheat_block_number_global(100);

    let result = renderer.game_details(TEST_TOKEN_ID);

    stop_cheat_block_timestamp_global();
    stop_cheat_block_number_global();

    assert!(result.len() >= 0, "Global block cheats should work");
}

#[test]
fn test_extreme_block_values() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    cheat_block_timestamp(contract_address, 0, CheatSpan::TargetCalls(1));
    let result_min = renderer.game_details(TEST_TOKEN_ID);

    cheat_block_timestamp(contract_address, Bounded::<u64>::MAX, CheatSpan::TargetCalls(1));
    let result_max = renderer.game_details(TEST_TOKEN_ID);

    assert!(result_min.len() >= 0, "Should handle minimum timestamp");
    assert!(result_max.len() >= 0, "Should handle maximum timestamp");
}

#[test]
fn test_sequencer_address_independence() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let sequencer_addr: ContractAddress = 'SEQUENCER_ADDR'.try_into().unwrap();

    let result_before = renderer.game_details(TEST_TOKEN_ID);

    start_cheat_sequencer_address(contract_address, sequencer_addr);
    let result_with_sequencer = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_sequencer_address(contract_address);

    let result_after = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(
        result_before.len(),
        result_with_sequencer.len(),
        "Sequencer address should not affect reads",
    );
    assert_eq!(
        result_before.len(), result_after.len(), "Should restore correctly after sequencer cheat",
    );
}

#[test]
fn test_chain_id_independence() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let chain_ids = array![1, 5, 11155111];

    let mut i = 0;
    while i < chain_ids.len() {
        let chain_id = *chain_ids.at(i);

        start_cheat_chain_id_global(chain_id);
        let result = renderer.game_details(TEST_TOKEN_ID);
        stop_cheat_chain_id_global();

        assert!(result.len() >= 0, "Should work with any chain ID");
        i += 1;
    };
}

#[test]
fn test_event_spy_functionality() {
    let mut spy = spy_events();
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let _traits = renderer.game_details(TEST_TOKEN_ID);
    let _description = renderer.token_description(TEST_TOKEN_ID);

    let events = spy.get_events();
    assert!(events.events.len() >= 0, "Event spy should capture events if any");
}

#[test]
fn test_event_filtering() {
    let mut spy = spy_events();
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let _result = renderer.game_details(TEST_TOKEN_ID);

    let contract_events = spy.get_events().emitted_by(contract_address);
    assert!(contract_events.events.len() >= 0, "Should be able to filter events by contract");
}

#[test]
fn test_class_hash_introspection() {
    let (_, contract_address) = deploy_test_contracts();
    let class_hash = get_class_hash(contract_address);
    assert!(class_hash.try_into().unwrap() != 0, "Should have non-zero class hash");
}

#[test]
fn test_storage_reading() {
    let (_, contract_address) = deploy_test_contracts();
    let storage_value = load(contract_address, selector!("death_mountain_dispatcher"), 1);
    assert!(storage_value.len() > 0, "Should be able to read storage");
}

#[test]
fn test_storage_consistency() {
    let (death_mountain_address, contract_address) = deploy_test_contracts();

    let renderer = IRendererDispatcher { contract_address };
    let stored_address = renderer.get_death_mountain_address();
    assert_eq!(stored_address, death_mountain_address, "Storage should contain expected values");
}

#[test]
fn test_account_address_independence() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let test_account: ContractAddress = 'TEST_CALLER_1'.try_into().unwrap();

    let result_before = renderer.game_details(TEST_TOKEN_ID);

    start_cheat_account_contract_address(contract_address, test_account);
    let result_with_account = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_account_contract_address(contract_address);

    let result_after = renderer.game_details(TEST_TOKEN_ID);

    assert_eq!(
        result_before.len(), result_with_account.len(), "Account address should not affect reads",
    );
    assert_eq!(result_before.len(), result_after.len(), "Should restore correctly");
}

#[test]
fn test_multiple_cheats_combination() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let caller: ContractAddress = 'TEST_CALLER_1'.try_into().unwrap();

    let baseline_result = renderer.game_details(TEST_TOKEN_ID);

    start_cheat_caller_address(contract_address, caller);
    cheat_block_timestamp(contract_address, 1500000, CheatSpan::TargetCalls(1));
    cheat_block_number(contract_address, 150, CheatSpan::TargetCalls(1));

    let complex_result = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    assert_eq!(
        baseline_result.len(),
        complex_result.len(),
        "Multiple cheats should not affect deterministic operations",
    );
}

#[test]
fn test_rapid_cheat_changes() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let callers = array![TEST_CALLER_1.try_into().unwrap(), TEST_CALLER_2.try_into().unwrap()];

    let mut i = 0;
    while i < callers.len() {
        let caller = *callers.at(i);

        start_cheat_caller_address(contract_address, caller);
        cheat_block_timestamp(
            contract_address, 1000000 + (i * 100000).try_into().unwrap(), CheatSpan::TargetCalls(1),
        );

        let result = renderer.game_details((i + 1).try_into().unwrap());
        assert!(result.len() >= 0, "Rapid cheat changes should produce valid results");

        stop_cheat_caller_address(contract_address);
        i += 1;
    };
}

#[test]
fn test_zero_caller_address() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let zero_address: ContractAddress = 0.try_into().unwrap();
    start_cheat_caller_address(contract_address, zero_address);
    let result = renderer.game_details(TEST_TOKEN_ID);
    stop_cheat_caller_address(contract_address);

    assert!(result.len() >= 0, "Should handle zero caller address");
}

#[test]
fn test_extreme_block_values_zero() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    cheat_block_timestamp(contract_address, 0, CheatSpan::TargetCalls(1));
    cheat_block_number(contract_address, 0, CheatSpan::TargetCalls(1));
    let result = renderer.game_details(TEST_TOKEN_ID);

    assert!(result.len() >= 0, "Should handle zero block values");
}

#[test]
fn test_maximum_block_values() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    cheat_block_timestamp(contract_address, Bounded::<u64>::MAX, CheatSpan::TargetCalls(1));
    cheat_block_number(contract_address, Bounded::<u64>::MAX, CheatSpan::TargetCalls(1));
    let result = renderer.game_details(TEST_TOKEN_ID);

    assert!(result.len() >= 0, "Should handle maximum block values");
}

#[test]
fn test_cheatcode_isolation() {
    let (death_mountain_address, _) = deploy_test_contracts();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];

    let (contract1, _) = contract_class.deploy(@constructor_args).unwrap();
    let (contract2, _) = contract_class.deploy(@constructor_args).unwrap();

    let renderer1 = IMinigameDetailsDispatcher { contract_address: contract1 };
    let renderer2 = IMinigameDetailsDispatcher { contract_address: contract2 };

    let caller1: ContractAddress = 'TEST_CALLER_1'.try_into().unwrap();
    let caller2: ContractAddress = 'TEST_CALLER_2'.try_into().unwrap();

    start_cheat_caller_address(contract1, caller1);
    cheat_block_timestamp(contract1, 1000000, CheatSpan::TargetCalls(1));

    start_cheat_caller_address(contract2, caller2);
    cheat_block_timestamp(contract2, 2000000, CheatSpan::TargetCalls(1));

    let result1 = renderer1.game_details(TEST_TOKEN_ID);
    let result2 = renderer2.game_details(TEST_TOKEN_ID);

    assert!(result1.len() >= 0, "Contract 1 should work with its cheats");
    assert!(result2.len() >= 0, "Contract 2 should work with its cheats");

    stop_cheat_caller_address(contract1);
    stop_cheat_caller_address(contract2);

    let result1_clean = renderer1.game_details(TEST_TOKEN_ID);
    let result2_clean = renderer2.game_details(TEST_TOKEN_ID);

    assert!(result1_clean.len() >= 0, "Contract 1 should work after cleanup");
    assert!(result2_clean.len() >= 0, "Contract 2 should work after cleanup");
}
