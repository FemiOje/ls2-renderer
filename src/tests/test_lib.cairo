pub mod unit {
    pub mod test_contract;
    pub mod test_encoding;
    pub mod test_models;
    pub mod test_renderer;
    pub mod test_renderer_utils;
    pub mod test_svg_content_validation;
}

pub mod integration {
    pub mod test_advanced_cheatcodes;
    pub mod test_direct_storage_access;
    pub mod test_fork_testing;
    pub mod test_storage_corruption;
}

pub mod security {
    pub mod test_security_comprehensive;
}

pub mod performance {
    pub mod test_gas_optimization;
}

pub mod fuzz {
    pub mod test_adventurer_fuzz;
    pub mod test_encoding_fuzz;
    pub mod test_invariant_testing;
    pub mod test_svg_generation_fuzz;
}
