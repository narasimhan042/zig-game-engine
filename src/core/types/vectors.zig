//! ---------------------------------------
//! Core Type: Vector2
//! ---------------------------------------
//! Contents:
//! - Vector2 struct
//! - Contructors
//! ---------------------------------------

// ---------------------------------------
// Type: Vector2
// ---------------------------------------

/// Constructor
pub fn vec2Of(comptime T: type) type {
    return struct {
        x: T,
        y: T,
    };
}

pub const Vector2 = struct {
    x: f32,
    y: f32,

    pub fn add(self: *Vector2, vec: Vector2) void {
        self.x += vec.x;
        self.y += vec.y;
    }

    pub fn normalize(self: *Vector2) !void {
        const len = @abs(self.length());
        if (len <= 0.0) return error.CannotDivideByZero;

        self.x /= len;
        self.y /= len;
    }

    pub fn scale(self: *Vector2, magnitude: f32) void {
        self.x *= magnitude;
        self.y *= magnitude;
    }

    pub fn length(self: *Vector2) f32 {
        if (self.x == 0 and self.y == 0) {
            return 0.0;
        } else if (self.x == 0) {
            return self.y;
        } else if (self.y == 0) {
            return self.x;
        } else {
            return @sqrt((self.x * self.x) + (self.y * self.y));
        }
    }

    pub fn newVector2(x: f32, y: f32) Vector2 {
        return Vector2{ .x = x, .y = y };
    }

    pub fn reset(self: *Vector2) void {
        self.x = 0.0;
        self.y = 0.0;
    }
};

pub fn clamp(num: *f32, min: f32, max: f32) void {
    if (num.* < min) {
        num.* = min;
    } else if (num.* > max) {
        num.* = max;
    }
}
