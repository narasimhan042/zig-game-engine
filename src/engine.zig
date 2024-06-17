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
const mem = i.std.mem;

// Main SDL pointers
var window: ?*c.SDL_Window = undefined;
var gl_context: c.SDL_GLContext = undefined;

// Global allocators for the whole engine given by the user
pub var allocator: mem.Allocator = undefined;

// Any type of struct that implements the scene interface
// can be in this ptr. Therefore, it is stored as an integer
var current_scene_ptr: usize = 0;
// Used by the engine to abstract away the individual scenes
var current_interface: i.Scene = undefined;

// SDL uses 'event' struct to store polled inputs
var event: i.Event = undefined;

// Target physics Seconds per Frame for fixed time frame applications
var physics_frame_time: f32 = undefined;

// tracks the current fps in (ms)
var current_frametime: u64 = 0;

// Starts the engine with a user specified main scene
pub fn init(heap_allocator: mem.Allocator, p: i.InitParams, MainScene: anytype) anyerror!void {
    // Inits SDL2
    if (c.SDL_Init(p.sdl_init_flags) != 0) {
        c.SDL_Log("SDL_Init failed: ", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    errdefer deinit(MainScene); // In case sdl2 init fails at any point in this function

    // Attempts to set VSync to OFF
    if (c.SDL_FALSE == c.SDL_SetHintWithPriority(c.SDL_HINT_RENDER_VSYNC, 0, c.SDL_HINT_OVERRIDE)) return error.SetVsyncOffFailed;

    // SDL callbacks
    c.SDL_AddEventWatch(windowResizedCallback, null); // Reacts to resizing the window

    // Inits window context
    window =
        c.SDL_CreateWindow(p.title, 0, 0, p.window_width, p.window_height, p.window_flags);
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

    c.glViewport(0, 0, p.window_width, p.window_height);

    // Set the global allocator for the engine
    allocator = heap_allocator;

    // The first argument is the same as the second to bypass
    // clearing a previous scene as it doesn't exit
    // It also cannot be null
    try changeSceneTo(MainScene, MainScene);

    // Set value for the mainLoop fixed timeframe callback
    // of the physicsUpdate()
    physics_frame_time = spfFromFps(p.physics_fps);

    try mainLoop();
}

fn mainLoop() anyerror!void {
    var delta_time: f32 = 0.0; // Keeps tracks of frame time
    var start_tick: u64 = c.SDL_GetTicks64(); // Helper timestamp
    var physics_delta_time: f32 = 0.0; // Keeps track of physics fixed time step

    mainloop: while (true) {
        const end_tick = c.SDL_GetTicks64(); // Helper timestamp
        current_frametime = end_tick - start_tick;
        delta_time = @as(f32, @floatFromInt(current_frametime)) / 1000.0;
        physics_delta_time += delta_time;

        // Poll inputs
        _ = c.SDL_PollEvent(&event);

        // 3 of the interface functions can return true and quit the mainloop
        // 1. Input
        if (try current_interface.input(&event)) break :mainloop;

        // 2. Update
        if (try current_interface.update(delta_time)) break :mainloop;

        if (physics_delta_time >= physics_frame_time) {
            if (try current_interface.physicsUpdate(physics_delta_time)) break :mainloop;
            physics_delta_time = @mod(physics_delta_time, physics_frame_time);
        }

        // 3. Render
        current_interface.render();

        start_tick = end_tick; // Helper timestamp
    }
}

/// Returns the seconds per frame in respect to the input FPS
fn spfFromFps(fps: u8) f32 {
    return 1.0 / @as(f32, @floatFromInt(fps));
}

/// Always provide the type of the current scene if possible
/// If the arguments are the same, it will bypass freeing the previous scene
/// in case it is the first scene being loaded
pub fn changeSceneTo(PrevScene: anytype, NextScene: anytype) !void {
    //destroy previous scene from the heap first if it exists
    if (PrevScene != NextScene) destroyCurrentScene(PrevScene);

    // Creates an instance of the main scene on the heap
    const next_scene: *NextScene = try allocator.create(NextScene);
    current_scene_ptr = @intFromPtr(next_scene);

    // Creates a Scene interface from it
    current_interface = next_scene.createInterface();

    // Scene callbacks to process game
    try current_interface.enterTree();
}

/// window var is private by default for
pub inline fn getWindow() ?*c.SDL_Window {
    return window;
}

pub inline fn getFps() u16 {
    return @intCast(1000 / current_frametime);
}

fn windowResizedCallback(userdata: ?*anyopaque, ev: [*c]c.SDL_Event) callconv(.C) c_int {
    _ = userdata;
    if (ev.*.type == c.SDL_WINDOWEVENT) {
        if (ev.*.window.event == c.SDL_WINDOWEVENT_SIZE_CHANGED) {
            c.glViewport(0, 0, ev.*.window.data1, ev.*.window.data2);
        }
    }
    return 0;
}

/// Returns whether or not the user tried to quit
pub fn isQuitRequested() bool {
    return event.type == c.SDL_QUIT;
}

/// Takes the current scene type as a parameter and
/// returns true to break the mainloop at the top
pub fn quit(CurrentSceneType: anytype) bool {
    deinit(CurrentSceneType);
    return true;
}

/// Destroys current scene *IF* one is active
fn destroyCurrentScene(CurrentScene: anytype) void {
    if (current_scene_ptr != 0) {
        current_interface.exitTree();
        const current_scene: *CurrentScene = @ptrFromInt(current_scene_ptr);
        allocator.destroy(current_scene);
    }
}

/// deinitializes the engine
fn deinit(CurrentScene: anytype) void {
    destroyCurrentScene(CurrentScene);

    c.SDL_GL_DeleteContext(gl_context);
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}
