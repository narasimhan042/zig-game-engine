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

// STD
pub const std = @import("std");
pub const print = std.debug.print;

// External Libraries
pub const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("GL/glew.h");
});

pub const Event = sdl.SDL_Event;
