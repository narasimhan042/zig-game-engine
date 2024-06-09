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

var window: ?*c.SDL_Window = undefined;
var gl_context: c.SDL_GLContext = undefined;
// pub var renderer: *c.SDL_Renderer = null;

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 800;

var engine_running = true;

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

    _ = c.SDL_GL_SetAttribute(c.SDL_GL_RED_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_GREEN_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_BLUE_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_DEPTH_SIZE, 16);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_DOUBLEBUFFER, 1);

    window = c.SDL_CreateWindow(p.title, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, p.window_flags);

    if (window == null) {
        c.SDL_Log("SDL_CreateWindow failed.", c.SDL_GetError());
        return error.SDLWindowCreationFailed;
    }

    gl_context = c.SDL_GL_CreateContext(window);
    if (gl_context == null) {
        c.SDL_Log("GL_CreateContext failed.", c.SDL_GetError());
        return error.SDLGLCreateContextFailed;
    }

    _ = c.SDL_GL_MakeCurrent(window, gl_context);

    //initialization of glew
    const status: c.GLenum = c.glewInit();
    if (status != c.GLEW_OK) {
        c.SDL_Log("GLEW ERROR: ", c.glewGetErrorString(status));
        return error.GLEWError;
    }
    c.SDL_Log("Status: Using GLEW: %s\n", c.glewGetString(c.GLEW_VERSION));
}

pub fn deinit() void {
    c.SDL_GL_DeleteContext(gl_context);
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}

pub fn pollInputEvents(event: *imp.Event) void {
    _ = c.SDL_PollEvent(event);
}

pub fn engineIsRunning() bool {
    return engine_running;
}

pub fn getWindow() ?*c.SDL_Window {
    return window;
}

pub fn shouldQuit(event: *imp.Event) bool {
    return event.type == c.SDL_QUIT;
}

pub fn quit() void {
    engine_running = false;
}
