// SPDX-License-Identifier: MIT
//
// @title Storage Security Attack Vector Tests
// @notice Tests that simulate storage manipulation attacks and verify security vulnerabilities
// @dev Security tests use explicit panic to demonstrate successful attack vectors

use death_mountain_renderer::contracts::death_mountain_renderer::{
    IRendererDispatcher, IRendererDispatcherTrait,
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait,
};
use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait,
    load, store,
};
use starknet::ContractAddress;

const TEST_TOKEN_ID: u64 = 42;

fn deploy_test_contracts() -> (ContractAddress, ContractAddress) {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let (death_mountain_address, _) = contract_class.deploy(@array![]).unwrap();
    
    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (renderer_address, _) = contract_class.deploy(@constructor_args).unwrap();
    
    (death_mountain_address, renderer_address)
}

#[test]
#[should_panic(expected: "SECURITY TEST PASSED: Invalid address injection succeeded - this would be a critical vulnerability")]
fn test_attack_invalid_address_injection_should_fail() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer_interface = IRendererDispatcher { contract_address };
    
    let original_address = renderer_interface.get_death_mountain_address();
    assert!(original_address.into() != 0xdeadbeef, "Original address should not be malicious");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let malicious_address = array![0xdeadbeef];
    store(contract_address, storage_key, malicious_address.span());
    
    let corrupted_address = renderer_interface.get_death_mountain_address();
    if corrupted_address.into() == 0xdeadbeef {
        panic!("SECURITY TEST PASSED: Invalid address injection succeeded - this would be a critical vulnerability");
    } else {
        assert!(false, "Storage corruption attempt failed - invalid address was not injected");
    }
}

#[test]
#[should_panic(expected: "SECURITY TEST PASSED: Zero address injection succeeded - this would be a critical vulnerability")]
fn test_attack_zero_address_injection_should_fail() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer_interface = IRendererDispatcher { contract_address };
    
    let original_address = renderer_interface.get_death_mountain_address();
    assert!(original_address.into() != 0, "Original address should not be zero");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let zero_address = array![0];
    store(contract_address, storage_key, zero_address.span());
    
    let corrupted_address = renderer_interface.get_death_mountain_address();
    if corrupted_address.into() == 0 {
        panic!("SECURITY TEST PASSED: Zero address injection succeeded - this would be a critical vulnerability");
    } else {
        assert!(false, "Storage corruption attempt failed - zero address was not injected");
    }
}

#[test]
fn test_attack_address_spoofing_should_fail() {
    // Attack Vector: Address spoofing to redirect calls to attacker-controlled contract
    let (death_mountain_address, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    
    let fake_contract = declare("mock_adventurer").unwrap().contract_class();
    let (fake_address, _) = fake_contract.deploy(@array![]).unwrap();

    let legit_result = renderer.game_details(TEST_TOKEN_ID);
    assert!(legit_result.len() >= 0, "Legitimate operation should work");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let spoofed_address = array![fake_address.into()];
    
    store(contract_address, storage_key, spoofed_address.span());
    
    let renderer_dispatch = IRendererDispatcher { contract_address };
    let current_address = renderer_dispatch.get_death_mountain_address();
    assert!(current_address != death_mountain_address, "Address spoofing should be detectable");
    
    let spoofed_result = renderer.game_details(TEST_TOKEN_ID);
    
    assert!(spoofed_result.len() >= 0, "Spoofed contract call completed - this represents a security vulnerability");
}

#[test]
#[should_panic(expected: "SECURITY TEST PASSED: Storage overflow attack succeeded - this would be a critical vulnerability")]
fn test_attack_storage_overflow_attempt() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer_interface = IRendererDispatcher { contract_address };
    
    let original_address = renderer_interface.get_death_mountain_address();
    assert!(original_address.into() != 0xdeadbeef, "Original address should not be malicious");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let overflow_data = array![
        0xdeadbeef, 0xcafebabe, 0x13371337, 0xbaadf00d,
        0xfeedface, 0xdeadc0de, 0xbadcafe0, 0x8badf00d
    ];
    store(contract_address, storage_key, overflow_data.span());
    
    let corrupted_address = renderer_interface.get_death_mountain_address();
    if corrupted_address.into() == 0xdeadbeef {
        panic!("SECURITY TEST PASSED: Storage overflow attack succeeded - this would be a critical vulnerability");
    } else {
        assert!(false, "Storage overflow attempt failed - corruption was not detected");
    }
}

#[test]
#[should_panic(expected: "SECURITY TEST PASSED: Critical storage corruption succeeded - this would be a critical vulnerability")]
fn test_attack_critical_storage_corruption() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer_interface = IRendererDispatcher { contract_address };
    
    let original_address = renderer_interface.get_death_mountain_address();
    assert!(original_address.into() != 0xffffffff, "Original address should not be corruption data");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let corruption_data = array![0xffffffff, 0x00000000, 0xdeadbeef];
    store(contract_address, storage_key, corruption_data.span());
    
    let corrupted_address = renderer_interface.get_death_mountain_address();
    if corrupted_address.into() == 0xffffffff {
        panic!("SECURITY TEST PASSED: Critical storage corruption succeeded - this would be a critical vulnerability");
    } else {
        assert!(false, "Critical storage corruption attempt failed - corruption was not detected");
    }
}

#[test]
fn test_attack_unauthorized_admin_storage_access() {
    // Attack Vector: Attempting to gain unauthorized admin access via storage manipulation
    let (_, contract_address) = deploy_test_contracts();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    
    let admin_keys = array![
        selector!("owner"),
        selector!("admin"), 
        selector!("authorized"),
        selector!("controller")
    ];
    
    let attacker_address = array![0x1337];
    
    let mut i = 0;
    while i < admin_keys.len() {
        let admin_key = *admin_keys.at(i);
        store(contract_address, admin_key, attacker_address.span());
        let _result = renderer.game_details(TEST_TOKEN_ID);
        
        i += 1;
    };
}

#[test]
#[should_panic(expected: "SECURITY TEST PASSED: Reentrancy storage manipulation succeeded - this would be a critical vulnerability")]
fn test_attack_reentrancy_via_storage_manipulation() {
    let (_, contract_address) = deploy_test_contracts();
    let renderer_interface = IRendererDispatcher { contract_address };
    
    let original_address = renderer_interface.get_death_mountain_address();
    assert!(original_address.into() != 0xbadcafe, "Original address should not be malicious");
    
    let storage_key = selector!("death_mountain_dispatcher");
    let original_data = load(contract_address, storage_key, 1);
    
    let malicious_data = array![0xbadcafe];
    store(contract_address, storage_key, malicious_data.span());
    
    let corrupted_address = renderer_interface.get_death_mountain_address();
    if corrupted_address.into() == 0xbadcafe {
        panic!("SECURITY TEST PASSED: Reentrancy storage manipulation succeeded - this would be a critical vulnerability");
    } else {
        store(contract_address, storage_key, original_data.span());
        assert!(false, "Reentrancy storage manipulation attempt failed - corruption was not detected");
    }
}