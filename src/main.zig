const std = @import("std");
const print = std.debug.print;

const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("SDL_Init failed: ", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("SDL2 Window", 100, 100, 1280, 800, 0);

    if (window == null) {
        c.SDL_Log("SDL_CreateWindow failed.", c.SDL_GetError());
        return error.SDLWindowCreationFailed;
    }
    defer c.SDL_DestroyWindow(window);

    var ev: c.SDL_Event = undefined;
    var quit = false;

    while (!quit) {
        _ = c.SDL_PollEvent(&ev);

        if (ev.type == c.SDL_QUIT) {
            quit = true;
        }
    }
}
