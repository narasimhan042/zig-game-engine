//! ---------------------------------------
//! Main Engine file
//! ---------------------------------------
//! tries to init, manage the main loop and deinit the (cont.)
//! entire engine
//!
//! Contents:
//! - init and deinit engine functions
//! ---------------------------------------
//! How to use this file:
//! Remember to deinit()
//!

pub const imp = @import("import.zig");
const c = imp.sdl;
const InitParams = imp.init_params;

var window: ?*c.SDL_Window = null;
// pub var renderer: *c.SDL_Renderer = null;

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 800;

pub fn init(param: ?InitParams) !void {
    var p: InitParams = undefined;
    if (param == null) {
        p = InitParams{};
    } else {
        p = param.?;
    }

    if (c.SDL_Init(p.sdl_init_flags) != 0) {
        c.SDL_Log("SDL_Init failed: ", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }

    window = c.SDL_CreateWindow(p.title, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, p.window_flags);

    if (window == null) {
        c.SDL_Log("SDL_CreateWindow failed.", c.SDL_GetError());
        return error.SDLWindowCreationFailed;
    }
}

pub fn deinit() void {
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}

// pub fn mainloop() !void {
//     var ev: c.SDL_Event = undefined;
//     var quit = false;

//     while (!quit) {
//         _ = c.SDL_PollEvent(&ev);

//         if (ev.type == c.SDL_QUIT) {
//             quit = true;
//         }
//     }
// }
