pub mod utils {
    pub mod encoding;
    pub mod renderer;
    pub mod renderer_utils;
    pub mod string_utils;
    pub mod test_utils;
}

pub mod interfaces {
    pub mod adventurer_interface;
}

pub mod contracts {
    pub mod death_mountain_renderer;
}

pub mod mocks {
    pub mod mock_adventurer;
}

pub mod models {
    pub mod models;
}

#[cfg(test)]
pub mod tests {
    pub mod test_lib;
    pub mod test_pagination;
    pub mod test_svg_output;
}
