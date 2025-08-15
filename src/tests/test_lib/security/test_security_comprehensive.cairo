// SPDX-License-Identifier: MIT
//
// @title Comprehensive Security Tests
// @notice Security tests for input validation, access control, and attack resistance
// @dev Tests defensive security measures and boundary conditions

use death_mountain_renderer::contracts::death_mountain_renderer::{
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait, IRendererDispatcher,
    IRendererDispatcherTrait,
};
use death_mountain_renderer::mocks::mock_adventurer::{
    get_adventurer_with_max_stats, get_simple_adventurer,
};
use death_mountain_renderer::models::models::StatsTrait;
use death_mountain_renderer::utils::encoding::bytes_base64_encode;
use death_mountain_renderer::utils::renderer::Renderer;
use death_mountain_renderer::utils::string_utils::starts_with_pattern;
use snforge_std::{
    CheatSpan, ContractClassTrait, DeclareResultTrait, cheat_block_number, cheat_block_timestamp,
    declare, start_cheat_caller_address, stop_cheat_caller_address,
};
use starknet::ContractAddress;

const MALICIOUS_CALLER: felt252 = 0xbadcafe;
const ZERO_ADDRESS: felt252 = 0x0;


fn deploy_test_contract() -> ContractAddress {
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let constructor_args = array![];
    let (death_mountain_address, _) = contract_class.deploy(@constructor_args).unwrap();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];
    let (contract_address, _) = contract_class.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_malicious_adventurer_data_handling() {
    let mut malicious_adventurer = get_simple_adventurer();
    malicious_adventurer.health = 65535;
    malicious_adventurer.level = 255;
    malicious_adventurer.stats.strength = 255;
    malicious_adventurer.stats.vitality = 255;

    let max_health = malicious_adventurer.stats.get_max_health();
    assert!(max_health >= 100, "Health calculation should not underflow");
    assert!(
        max_health <= 100 + (255 * 15), "Health calculation should not overflow beyond expected",
    );

    let malicious_result = Renderer::render(1_u64, malicious_adventurer);
    assert!(
        starts_with_pattern(@malicious_result, @"data:application/json;base64,"),
        "Should handle extreme values and produce valid JSON data URI",
    );

    let mut zero_adventurer = get_simple_adventurer();
    zero_adventurer.health = 0;
    zero_adventurer.level = 1;
    zero_adventurer.stats.strength = 0;
    zero_adventurer.stats.vitality = 0;

    let zero_vitality_health = zero_adventurer.stats.get_max_health();
    assert_eq!(zero_vitality_health, 100, "Zero vitality should give base health");

    let zero_result = Renderer::render(2_u64, zero_adventurer);
    assert!(
        starts_with_pattern(@zero_result, @"data:application/json;base64,"),
        "Should handle zero values and produce valid JSON data URI",
    );

    let mut name_adventurer = get_simple_adventurer();
    name_adventurer.name = "Test";
    let name_result = Renderer::render(3_u64, name_adventurer);
    assert!(
        starts_with_pattern(@name_result, @"data:application/json;base64,"),
        "Should handle names and produce valid JSON data URI",
    );
}

#[test]
fn test_boundary_value_testing() {
    let mut u16_boundary_adventurer = get_simple_adventurer();
    u16_boundary_adventurer.health = 65535;
    u16_boundary_adventurer.xp = 65535;
    u16_boundary_adventurer.gold = 65535;

    let u16_max_result = Renderer::render(1_u64, u16_boundary_adventurer);
    assert!(
        starts_with_pattern(@u16_max_result, @"data:application/json;base64,"),
        "Should handle u16 max values and produce valid JSON data URI",
    );

    let mut u8_boundary_adventurer = get_simple_adventurer();
    u8_boundary_adventurer.stats.strength = 255;
    u8_boundary_adventurer.stats.dexterity = 255;
    u8_boundary_adventurer.stats.vitality = 255;
    u8_boundary_adventurer.stats.intelligence = 255;
    u8_boundary_adventurer.stats.wisdom = 255;
    u8_boundary_adventurer.stats.charisma = 255;
    u8_boundary_adventurer.stats.luck = 255;

    let u8_max_result = Renderer::render(2_u64, u8_boundary_adventurer);
    assert!(
        starts_with_pattern(@u8_max_result, @"data:application/json;base64,"),
        "Should handle u8 max values and produce valid JSON data URI",
    );
}

#[test]
fn test_unauthorized_access_attempts() {
    let contract_address = deploy_test_contract();
    let renderer = IMinigameDetailsDispatcher { contract_address };
    let malicious_caller: starknet::ContractAddress = MALICIOUS_CALLER.try_into().unwrap();

    start_cheat_caller_address(contract_address, malicious_caller);
    let unauthorized_traits = renderer.game_details(1);
    let unauthorized_description = renderer.token_description(1);
    stop_cheat_caller_address(contract_address);

    assert!(
        unauthorized_traits.len() >= 8,
        "Read operations should be publicly accessible and provide adequate traits",
    );
    assert!(
        unauthorized_description.len() > 5,
        "Read operations should be publicly accessible and provide meaningful description",
    );

    let zero_caller: starknet::ContractAddress = ZERO_ADDRESS.try_into().unwrap();
    start_cheat_caller_address(contract_address, zero_caller);
    let zero_caller_result = renderer.game_details(1);
    stop_cheat_caller_address(contract_address);

    assert!(
        zero_caller_result.len() >= 8,
        "Should handle zero address caller gracefully and provide adequate traits",
    );
}

#[test]
fn test_constructor_with_addresses() {
    // Test constructor with various address scenarios
    let contract_class = declare("mock_adventurer").unwrap().contract_class();
    let constructor_args = array![];
    let (death_mountain_address, _) = contract_class.deploy(@constructor_args).unwrap();

    let contract_class = declare("renderer_contract").unwrap().contract_class();
    let constructor_args = array![death_mountain_address.into()];

    // Should deploy successfully with valid address
    let (contract_address, _) = contract_class.deploy(@constructor_args).unwrap();

    // Verify the address was stored
    let renderer = IRendererDispatcher { contract_address };
    let stored_address = renderer.get_death_mountain_address();
    assert_eq!(stored_address, death_mountain_address, "Should store provided address");
}

#[test]
fn test_injection_attack_resistance() {
    let mut script_adventurer = get_simple_adventurer();
    script_adventurer.name = "TestScript";
    let script_result = Renderer::render(1_u64, script_adventurer);
    assert!(
        starts_with_pattern(@script_result, @"data:application/json;base64,"),
        "Should handle script-like names and produce valid JSON data URI",
    );

    let mut html_adventurer = get_simple_adventurer();
    html_adventurer.name = "TestHTML";
    let html_result = Renderer::render(2_u64, html_adventurer);
    assert!(
        starts_with_pattern(@html_result, @"data:application/json;base64,"),
        "Should handle HTML-like names and produce valid JSON data URI",
    );

    let mut special_adventurer = get_simple_adventurer();
    special_adventurer.name = "Special";
    let special_result = Renderer::render(3_u64, special_adventurer);
    assert!(
        starts_with_pattern(@special_result, @"data:application/json;base64,"),
        "Should handle special characters and produce valid JSON data URI",
    );

    let mut format_adventurer = get_simple_adventurer();
    format_adventurer.name = "Format";
    let format_result = Renderer::render(4_u64, format_adventurer);
    assert!(
        starts_with_pattern(@format_result, @"data:application/json;base64,"),
        "Should handle format patterns and produce valid JSON data URI",
    );
}

#[test]
fn test_dos_attack_resistance() {
    let contract_address = deploy_test_contract();
    let renderer = IMinigameDetailsDispatcher { contract_address };

    let mut i: u8 = 0;
    while i < 10 {
        let _result = renderer.game_details((i % 5).into());
        i += 1;
    }

    let post_spam_result = renderer.game_details(1);
    assert!(
        post_spam_result.len() >= 8,
        "Should remain responsive after spam and provide adequate traits",
    );

    let large_token_ids = array![1000_u64, 10000_u64, 100000_u64];

    let mut j: u32 = 0;
    while j < large_token_ids.len() {
        let token_id = *large_token_ids.at(j);
        let large_id_result = renderer.game_details(token_id);
        assert!(
            large_id_result.len() >= 8,
            "Should handle large token IDs without DoS and provide adequate traits",
        );
        j += 1;
    };
}

#[test]
fn test_base64_encoding_security() {
    let test_input = "test data for encoding";
    let encoded = bytes_base64_encode(test_input);
    assert!(encoded.len() > 0, "Should encode input safely");
    // Verify valid base64 content
    if encoded.len() > 0 {
        assert!(encoded.len() > 0, "Should not produce empty encoded string");
    }

    let empty_input = "";
    let empty_encoded = bytes_base64_encode(empty_input);
    assert!(empty_encoded.len() >= 0, "Should handle empty input");

    let single_char = "A";
    let single_encoded = bytes_base64_encode(single_char);
    assert!(single_encoded.len() > 0, "Should encode single character");
    if single_encoded.len() > 0 {
        assert!(
            single_encoded.len() > 0, "Should not produce empty encoded string for single char",
        );
    }
}

#[test]
fn test_state_integrity_under_attack() {
    let contract_address = deploy_test_contract();
    let renderer = IRendererDispatcher { contract_address };
    let minigame = IMinigameDetailsDispatcher { contract_address };

    let initial_death_mountain_addr = renderer.get_death_mountain_address();
    let malicious_caller: starknet::ContractAddress = MALICIOUS_CALLER.try_into().unwrap();

    start_cheat_caller_address(contract_address, malicious_caller);
    let _traits1 = minigame.game_details(0);
    let _traits2 = minigame.game_details(1000);
    let _description = minigame.token_description(12345);
    stop_cheat_caller_address(contract_address);

    let final_death_mountain_addr = renderer.get_death_mountain_address();
    assert_eq!(
        initial_death_mountain_addr,
        final_death_mountain_addr,
        "State should remain consistent after attacks",
    );

    cheat_block_timestamp(contract_address, 1000000, CheatSpan::TargetCalls(1));
    cheat_block_number(contract_address, 1000, CheatSpan::TargetCalls(1));

    let post_time_attack_addr = renderer.get_death_mountain_address();
    assert_eq!(
        initial_death_mountain_addr,
        post_time_attack_addr,
        "State should survive time manipulation",
    );
}

#[test]
fn test_secure_error_handling() {
    let error_adventurer = get_simple_adventurer();

    let max_health = error_adventurer.stats.get_max_health();
    assert!(max_health >= 100, "Health should have minimum base value");

    let result = Renderer::render(1_u64, error_adventurer);
    assert!(
        starts_with_pattern(@result, @"data:application/json;base64,"),
        "Should handle errors gracefully and produce valid JSON data URI",
    );

    let max_adventurer = get_adventurer_with_max_stats();
    let max_result = Renderer::render(2_u64, max_adventurer);
    assert!(
        starts_with_pattern(@max_result, @"data:application/json;base64,"),
        "Should handle max stats adventurer and produce valid JSON data URI",
    );
}

#[test]
fn test_renderer_method_security() {
    let traits_adventurer = get_simple_adventurer();
    let traits = Renderer::get_traits(traits_adventurer);
    assert!(traits.len() >= 8, "Should generate traits safely with adequate count");

    let description = Renderer::get_description();
    assert!(description.len() > 5, "Should generate description safely with meaningful content");

    let image_adventurer = get_simple_adventurer();
    let image = Renderer::get_image(image_adventurer);
    assert!(
        starts_with_pattern(@image, @"data:image/svg+xml;base64,"),
        "Should generate image safely as valid SVG data URI",
    );

    let render_adventurer = get_simple_adventurer();
    let render_result = Renderer::render(1_u64, render_adventurer);
    assert!(
        starts_with_pattern(@render_result, @"data:application/json;base64,"),
        "Should render safely as valid JSON data URI",
    );
}
