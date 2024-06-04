//! ---------------------------------------
//! Import file for ease of use
//! ---------------------------------------
//! Imports all common files
//! Contents:
//! -
//! ---------------------------------------
//! How to use this file:
//! This file is imported instead of the core files directly

// Engine and Core Systems
pub const init_params = @import("init_parameters.zig");

// STD
const std = @import("std");
const print = std.debug.print;

// External Libraries
const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
});
