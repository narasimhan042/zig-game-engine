//! ---------------------------------------
//! Imports all common files
//! ---------------------------------------
//! How to use this file:
//! This file is imported instead of the core files directly
//! Import file for ease of use

// Engine and Core Systems
pub const InitParams = @import("init_parameters.zig").InitParameters;
pub const Scene = @import("scene.zig").Scene;

// STD
const std = @import("std");
pub const print = std.debug.print;

// External Libraries
pub const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("GL/glew.h");
});

pub const Event = sdl.SDL_Event;
