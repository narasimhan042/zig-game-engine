//! ---------------------------------------
//! Imports all common files
//! ---------------------------------------
//! How to use this file:
//! This file is imported instead of the core files directly
//! Import file for ease of use

// Engine and Core Systems
const init_parameters = @import("init_parameters.zig");
pub const InitParams = init_parameters.InitParameters;
pub const Scene = @import("scene.zig").Scene;
// pub const InputAction = @import("input_actions.zig").InputAction;

// Core Types
pub const color = @import("types/color.zig");
pub const vector = @import("types/vectors.zig");
pub const types = struct {
    pub const RGBraw = color.RGBraw;
    pub const Vector2 = vector.Vector2;
};

// STD
pub const std = @import("std");
pub const print = std.debug.print;

// External Libraries
pub const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("GL/glew.h");
});

pub const Event = sdl.SDL_Event;
