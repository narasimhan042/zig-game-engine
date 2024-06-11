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
//! - init the engine with MainScene file
//!

// Global import
pub const import = @import("core/import.zig");
const i = import;
const c = import.sdl;
const heap = i.std.heap;

// Steam Deck preset
const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 800;

var window: ?*c.SDL_Window = undefined;
var gl_context: c.SDL_GLContext = undefined;

var gpa = heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

var current_scene_ptr: usize = 0;
var current_interface: i.Scene = undefined;
// SDL uses 'event' to poll inputs
var event: i.Event = undefined;

// Target physics Seconds per Frame
var physics_frame_time: f32 = undefined;

// control queued exit of engine at the end of mainLoop
var engine_running = true;

// Starts the engine with a user specified main scene
pub fn init(p: i.InitParams, MainScene: anytype) anyerror!void {
    // Inits SDL2
    if (c.SDL_Init(p.sdl_init_flags) != 0) {
        c.SDL_Log("SDL_Init failed: ", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    errdefer deinit(MainScene);

    // Inits window context
    window = c.SDL_CreateWindow(p.title, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, p.window_flags);
    if (window == null) {
        c.SDL_Log("SDL_CreateWindow failed.", c.SDL_GetError());
        return error.SDLWindowCreationFailed;
    }

    // Creates OpenGL context
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_RED_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_GREEN_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_BLUE_SIZE, 5);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_DEPTH_SIZE, 16);
    _ = c.SDL_GL_SetAttribute(c.SDL_GL_DOUBLEBUFFER, 1);

    gl_context = c.SDL_GL_CreateContext(window);
    if (gl_context == null) {
        c.SDL_Log("GL_CreateContext failed.", c.SDL_GetError());
        return error.SDLGLCreateContextFailed;
    }

    _ = c.SDL_GL_MakeCurrent(window, gl_context);

    // Initialization of GLEW
    const status: c.GLenum = c.glewInit();
    if (status != c.GLEW_OK) {
        c.SDL_Log("GLEW ERROR: ", c.glewGetErrorString(status));
        return error.GLEWError;
    }
    c.SDL_Log("Status: Using GLEW: %s\n", c.glewGetString(c.GLEW_VERSION));

    // The first argument is not currently necessary but it also cannot be null
    // therefore, the arguments are duplicated
    try changeSceneTo(MainScene, MainScene);

    physics_frame_time = 1.0 / @as(f32, @floatFromInt(p.physics_fps));

    try mainLoop(MainScene);
}

fn mainLoop(CurrentScene: anytype) anyerror!void {
    var delta_time: f32 = 0;
    var physics_delta_time: f32 = 0;

    while (engine_running) {
        const start_time = c.SDL_GetTicks64();
        physics_delta_time += delta_time;

        // Poll and process inputs
        _ = c.SDL_PollEvent(&event);
        try current_interface.input(&event);

        if (physics_delta_time >= physics_frame_time) {
            try current_interface.physicsProcess(physics_delta_time);
            physics_delta_time = @rem(physics_delta_time - physics_frame_time, physics_frame_time);
            // physics_delta_time = 0.0;
        }
        current_interface.process(delta_time);

        current_interface.render();

        delta_time = @as(f32, @floatFromInt(c.SDL_GetTicks64() - start_time)) / 1000.0;
    }

    current_interface.exitTree();
    deinit(CurrentScene);
}

/// Always provide a pointer to the current scene if possible
/// It will not be freed otherwise
pub fn changeSceneTo(PrevScene: anytype, NextScene: anytype) !void {
    //destroy previous scene from the heap first
    if (current_scene_ptr != 0) {
        current_interface.exitTree();
        const current_scene: *PrevScene = @ptrFromInt(current_scene_ptr);
        allocator.destroy(current_scene);
    }

    // Creates an instance of the main scene on the heap
    const next_scene: *NextScene = try allocator.create(NextScene);
    current_scene_ptr = @intFromPtr(next_scene);

    // Creates a Scene interface from it
    current_interface = next_scene.createInterface();

    // Scene callbacks to process game
    current_interface.enterTree();
}

pub fn getWindow() ?*c.SDL_Window {
    return window;
}

pub fn isQuitRequested() bool {
    return event.type == c.SDL_QUIT;
}

pub fn quit() void {
    engine_running = false;
}

fn deinit(CurrentScene: anytype) void {
    const current_scene: *CurrentScene = @ptrFromInt(current_scene_ptr);
    allocator.destroy(current_scene);

    c.SDL_GL_DeleteContext(gl_context);
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}
