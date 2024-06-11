//! ---------------------------------------
//! Core Type: Color
//! ---------------------------------------
//! Contents:
//! - Color structs
//! ---------------------------------------

// ---------------------------------------
// RGB Color Type
// ---------------------------------------

pub const RGB = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

/// Different representations of Color struct
pub const RGBraw = struct {
    r: f16,
    g: f16,
    b: f16,
    a: f16,
};
