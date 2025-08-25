pub mod utils {
    pub mod encoding {
        pub mod encoding;
    }
    pub mod renderer {
        pub mod page {
            pub mod page_renderer;
        }
        pub mod pages {
            pub mod battle;
            pub mod inventory;
            pub mod item_bag;
            pub mod page_generators;
        }
        pub mod renderer;
        pub mod renderer_utils;
        pub mod components {
            pub mod headers;
            pub mod icons;
            pub mod theme;
            pub mod ui_components;
        }
        pub mod core {
            pub mod math_utils;
            pub mod svg_builder;
            pub mod text_utils;
        }
        pub mod equipment {
            pub mod badges;
            pub mod names;
            pub mod positioning;
            pub mod slots;
        }
        pub mod bag {
            pub mod bag_renderer;
            pub mod bag_utils;
        }
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
    pub mod models;
    pub mod page_types;
}

#[cfg(test)]
pub mod tests {
    pub mod test_lib;
}
