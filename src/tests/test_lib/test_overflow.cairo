#[cfg(test)]
mod test_overflow {
    #[test]
    fn test_max_health_calculation() {
        let vitality: u8 = 255;
        let starting_health: u16 = 100;
        let health_per_vitality: u16 = 15;

        // This should work: 255 * 15 = 3825, + 100 = 3925 (fits in u16)
        let max_health = starting_health + (vitality.into() * health_per_vitality);

        assert(max_health == 3925, 'max_health_should_be_3925');
    }
}
