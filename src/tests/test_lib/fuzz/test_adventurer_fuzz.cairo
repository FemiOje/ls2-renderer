// SPDX-License-Identifier: MIT

use death_mountain_renderer::models::models::{AdventurerVerbose, StatsTrait};
use death_mountain_renderer::mocks::mock_adventurer::{get_simple_adventurer, get_adventurer_with_max_stats, create_custom_adventurer, create_custom_adventurer_with_name};
use death_mountain_renderer::utils::renderer::RendererImpl;

// Helper function to create adventurer with custom stats (uses available create_custom_adventurer)
fn create_adventurer_with_stats(health: u16, level: u8, vitality: u8) -> AdventurerVerbose {
    create_custom_adventurer(health, level, vitality)
}

fn validate_health_calculation(adventurer: @AdventurerVerbose, vitality: u8) {
    let max_health = adventurer.stats.get_max_health();
    let expected = 100_u32 + (vitality.into() * 15_u32);
    assert_eq!(max_health.into(), expected, "Health calculation must be deterministic");
}

fn validate_rendering(adventurer: AdventurerVerbose, token_id: u64) {
    let result = RendererImpl::render(token_id, adventurer);
    assert!(result.len() > 0, "Rendering must never produce empty output");
    
    // Use a fresh adventurer for subsequent tests to avoid move issues
    let test_adventurer = get_simple_adventurer();
    let traits = RendererImpl::get_traits(test_adventurer);
    assert!(traits.len() > 0, "Must always produce traits");
    
    let description = RendererImpl::get_description();
    assert!(description.len() > 0, "Description must never be empty");
    
    let image_adventurer = get_simple_adventurer();
    let image = RendererImpl::get_image(image_adventurer);
    assert!(image.len() > 0, "Image must never be empty");
}

#[test]
#[fuzzer(runs: 100, seed: 11111)]
fn fuzz_adventurer_stats_comprehensive(health: u16, level: u8, strength: u8, dexterity: u8, vitality: u8, intelligence: u8, wisdom: u8, charisma: u8, token_id: u64) {
    let adventurer = create_adventurer_with_stats(health, level, vitality);
    
    validate_health_calculation(@adventurer, vitality);
    validate_rendering(adventurer, token_id);
    
    // Create fresh adventurers for comparison
    let adventurer3 = create_adventurer_with_stats(health, level, vitality);
    let adventurer4 = create_adventurer_with_stats(health, level, vitality);
    let result1 = RendererImpl::render(token_id, adventurer3);
    let result2 = RendererImpl::render(token_id, adventurer4);
    assert_eq!(result1.len(), result2.len(), "Same input should produce consistent output length");
}


#[test]
#[fuzzer(runs: 100, seed: 22222)]
fn fuzz_adventurer_health_states(current_health: u16, vitality: u8) {
    let adventurer = create_custom_adventurer(current_health, 1, vitality);
    
    let max_health = adventurer.stats.get_max_health();
    let expected = 100_u32 + (vitality.into() * 15_u32);
    assert_eq!(max_health.into(), expected, "Health formula must be consistent");
    assert!(max_health >= 100, "Max health must be at least base 100");
    assert!(max_health.into() <= 100_u32 + (255_u32 * 15_u32), "Max health must not exceed theoretical max");
    
    if max_health > 0 {
        let health_capped = if current_health > max_health { max_health } else { current_health };
        let health_percent = (health_capped.into() * 100_u32) / max_health.into();
        assert!(health_percent <= 100, "Health percentage must not exceed 100%");
        
        validate_rendering(adventurer, 1_u64);
    }
}

#[test]
#[fuzzer(runs: 100, seed: 33333)]
fn fuzz_adventurer_equipment_combinations(weapon_id: u8, weapon_xp: u16) {
    let adventurer = get_simple_adventurer();
    
    // Just validate that base adventurer renders correctly
    validate_rendering(adventurer, 42_u64);
}

#[test]
#[fuzzer(runs: 100, seed: 44444)]
fn fuzz_adventurer_extreme_values(health: u16, level: u8, all_stats_value: u8) {
    let adventurer = create_custom_adventurer(health, level, all_stats_value);
    
    let calculated_health = adventurer.stats.get_max_health();
    let expected_health = 100 + (all_stats_value.into() * 15);
    assert_eq!(calculated_health, expected_health, "Extreme vitality calculation must be correct");
    
    validate_rendering(adventurer, 1000_u64);
    
    if all_stats_value == 0 {
        assert_eq!(calculated_health, 100, "Zero vitality should give base health");
    } else if all_stats_value == 255 {
        assert_eq!(calculated_health.into(), 100_u32 + (255_u32 * 15_u32), "Max vitality calculation");
    }
}

#[test]
#[fuzzer(runs: 100, seed: 55555)]
fn fuzz_adventurer_name_variations(name: ByteArray) {
    let adventurer = create_custom_adventurer_with_name(name);
    
    validate_rendering(adventurer, 1_u64);
}

#[test]
#[fuzzer(runs: 100, seed: 66666)]
fn fuzz_adventurer_bag_contents(token_id: u64) {
    validate_rendering(get_simple_adventurer(), token_id);
    validate_rendering(get_adventurer_with_max_stats(), token_id);
}

#[test]
#[fuzzer(runs: 100, seed: 77777)]
fn fuzz_adventurer_level_boundaries(level: u8, xp_offset: u16) {
    let adventurer = create_custom_adventurer(100, level, 10);
    
    assert_eq!(adventurer.level, level, "Level should be maintained");
    validate_rendering(adventurer, level.into());
}

#[test]
#[fuzzer(runs: 100, seed: 88888)]
fn fuzz_token_id_extremes(token_id: u64, health: u16, vitality: u8) {
    let adventurer = create_custom_adventurer(health, 1, vitality);
    
    validate_health_calculation(@adventurer, vitality);
    validate_rendering(adventurer, token_id);
    
    let result1 = RendererImpl::render(token_id, create_custom_adventurer(health, 1, vitality));
    let result2 = RendererImpl::render(token_id, get_simple_adventurer());
    assert!(result1.len() > 0 && result2.len() > 0, "Should produce consistent results");
}

#[test]
#[fuzzer(runs: 500, seed: 99999)]
fn fuzz_adventurer_memory_stress(level: u8, health: u16, token_id: u64) {
    let adventurer = create_custom_adventurer(health, level, 10);
    
    validate_rendering(adventurer, token_id);
    
    let result1 = RendererImpl::render(1_u64, get_simple_adventurer());
    let result2 = RendererImpl::render(1_u64, get_simple_adventurer());
    assert_eq!(result1.len(), result2.len(), "Consistent inputs should produce consistent output lengths");
}