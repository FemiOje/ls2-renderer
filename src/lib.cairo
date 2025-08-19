pub mod utils {
    pub mod encoding {
        pub mod encoding;
    }
    pub mod renderer {
        pub mod page {
            pub mod page_renderer;
        }
        pub mod renderer;
        pub mod renderer_utils;
    }
    pub mod string {
        pub mod string_utils;
    }

    pub mod test {
        pub mod test_utils;
    }
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
    pub mod market;
    pub mod models;
    pub mod page_types;
}

#[cfg(test)]
pub mod tests {
    pub mod test_lib;
}
