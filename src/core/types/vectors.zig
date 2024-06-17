//! ---------------------------------------
//! Core Type: Vector2
//! ---------------------------------------
//! Contents:
//! - Vector2 struct
//! - Contructors
//! ---------------------------------------

pub const Vector2 = vec2Of(f32);
pub const Vector3 = vec3Of(f32);

// ---------------------------------------
// Type: Vector2
// ---------------------------------------

/// Vector 2 Constructor
fn vec2Of(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        pub fn add(comptime self: @This(), vec: Vector2) void {
            self.x += vec.x;
            self.y += vec.y;
        }

        pub fn normalize(comptime self: @This()) !void {
            const len = @abs(self.length());
            if (len <= 0.0) return error.CannotDivideByZero;

            self.x /= len;
            self.y /= len;
        }

        pub fn scale(comptime self: @This(), magnitude: f32) void {
            self.x *= magnitude;
            self.y *= magnitude;
        }

        pub fn length(comptime self: @This()) f32 {
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

        pub fn reset(comptime self: @This()) void {
            self.x = 0.0;
            self.y = 0.0;
        }
    };
}

// ---------------------------------------
// Type: Vector3
// ---------------------------------------

/// Vector 3 Constructor
fn vec3Of(comptime T: type) type {
    return struct {
        x: T,
        y: T,
        z: T,

        pub fn add(comptime self: @This(), vec: Vector3) void {
            self.x += vec.x;
            self.y += vec.y;
            self.z += vec.z;
        }

        pub fn normalize(comptime self: @This()) !void {
            const len = @abs(self.length());
            if (len <= 0.0) return error.CannotDivideByZero;

            self.x /= len;
            self.y /= len;
            self.z /= len;
        }

        pub fn scale(comptime self: @This(), magnitude: f32) void {
            self.x *= magnitude;
            self.y *= magnitude;
            self.z *= magnitude;
        }

        pub fn length(comptime self: @This()) f32 {
            return @sqrt((self.x * self.x) + (self.y * self.y) + (self.z * self.z));
        }

        pub fn reset(comptime self: @This()) void {
            self.x = 0;
            self.y = 0;
            self.z = 0;
        }
    };
}
