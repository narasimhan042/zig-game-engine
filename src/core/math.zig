//! ---------------------------------------
//! Math functions
//! ---------------------------------------
//! Contents:
//! - clamping
//! ---------------------------------------

pub fn clamp(num: *f32, min: f32, max: f32) void {
    if (num.* < min) {
        num.* = min;
    } else if (num.* > max) {
        num.* = max;
    }
}
