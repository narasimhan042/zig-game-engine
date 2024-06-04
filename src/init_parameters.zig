//! ---------------------------------------
//! A format for Project Configuration
//! ---------------------------------------
//!
//! Contents:
//! - project config struct
//! - default app config
//! - 3 sets of various SDL init flags
//! ---------------------------------------
//! How to Use:
//! - Use struct to init engine

// Imports
const imp = @import("import.zig");
const c = imp.sdl;

pub const InitParameters = struct {
    /// Name of the app. It will be used as the Window Title
    title: []const u8 = "SDL2 Window",

    sdl_init_flags: u32 = c.SDL_INIT_VIDEO,
    window_flags: u32 = c.SDL_WINDOW_OPENGL | c.SDL_WINDOW_SHOWN,
    renderer_flags: u32 = c.SDL_RENDERER_ACCELERATED | c.SDL_RENDERER_TARGETTEXTURE,
};

// ---------------------------------------
// Various SDL Init Flags
// ---------------------------------------

/// flags for SDLInitSubSystem();
/// https://wiki.libsdl.org/SDL_Init
pub const SDL_INIT_TIMER: u32 = 0x00000001;
pub const SDL_INIT_AUDIO: u32 = 0x00000010;
pub const SDL_INIT_VIDEO: u32 = 0x00000020;
pub const SDL_INIT_JOYSTICK: u32 = 0x00000200;
pub const SDL_INIT_HAPTIC: u32 = 0x00001000;
pub const SDL_INIT_GAMECONTROLLER: u32 = 0x00002000;
pub const SDL_INIT_EVENTS: u32 = 0x00004000;
pub const SDL_INIT_SENSOR: u32 = 0x00008000;
/// Prevents SDL from catching fatal signals
pub const SDL_INIT_NOPARACHUTE: u32 = 0x00100000;
pub const SDL_INIT_EVERYTHING: u32 =
    SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS |
    SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR;

/// for setting SDL_WINDOWPOS
/// https://wiki.libsdl.org/SDL_Init
pub const SDL_WINDOWPOS_CENTERED: c_int = 0x2FFF0000;
pub const SDL_WINDOWPOS_UNDEFINED: c_int = 0x1FFF0000;

/// flags for SDL_CreateWindow();
/// https://wiki.libsdl.org/SDL_CreateWindow
pub const SDL_WINDOW_FULLSCREEN: u32 = 0x00000001; // /**< fullscreen window */
pub const SDL_WINDOW_OPENGL: u32 = 0x00000002; // /**< window usable with OpenGL context */
pub const SDL_WINDOW_SHOWN: u32 = 0x00000004; // /**< window is visible */
pub const SDL_WINDOW_HIDDEN: u32 = 0x00000008; // /**< window is not visible */
pub const SDL_WINDOW_BORDERLESS: u32 = 0x00000010; // /**< no window decoration */
pub const SDL_WINDOW_RESIZABLE: u32 = 0x00000020; // /**< window can be resized */
pub const SDL_WINDOW_MINIMIZED: u32 = 0x00000040; // /**< window is minimized */
pub const SDL_WINDOW_MAXIMIZED: u32 = 0x00000080; // /**< window is maximized */
pub const SDL_WINDOW_MOUSE_GRABBED: u32 = 0x00000100; // /**< window has grabbed mouse input */
pub const SDL_WINDOW_INPUT_FOCUS: u32 = 0x00000200; // /**< window has input focus */
pub const SDL_WINDOW_MOUSE_FOCUS: u32 = 0x00000400; // /**< window has mouse focus */
pub const SDL_WINDOW_FULLSCREEN_DESKTOP: u32 = (SDL_WINDOW_FULLSCREEN | 0x00001000);
pub const SDL_WINDOW_FOREIGN: u32 = 0x00000800; // /**< window not created by SDL */
pub const SDL_WINDOW_ALLOW_HIGHDPI: u32 = 0x00002000; // /**< window should be created in high-DPI mode if supported.
//  On macOS NSHighResolutionCapable must be set true in the
//  application's Info.plist for this to have any effect. */
pub const SDL_WINDOW_MOUSE_CAPTURE: u32 = 0x00004000; // /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
pub const SDL_WINDOW_ALWAYS_ON_TOP: u32 = 0x00008000; // /**< window should always be above others */
pub const SDL_WINDOW_SKIP_TASKBAR: u32 = 0x00010000; // /**< window should not be added to the taskbar */
pub const SDL_WINDOW_UTILITY: u32 = 0x00020000; // /**< window should be treated as a utility window */
pub const SDL_WINDOW_TOOLTIP: u32 = 0x00040000; // /**< window should be treated as a tooltip */
pub const SDL_WINDOW_POPUP_MENU: u32 = 0x00080000; // /**< window should be treated as a popup menu */
pub const SDL_WINDOW_KEYBOARD_GRABBED: u32 = 0x00100000; // /**< window has grabbed keyboard input */
pub const SDL_WINDOW_VULKAN: u32 = 0x10000000; // /**< window usable for Vulkan surface */
pub const SDL_WINDOW_METAL: u32 = 0x20000000; // /**< window usable for Metal view */

pub const SDL_WINDOW_INPUT_GRABBED: u32 = SDL_WINDOW_MOUSE_GRABBED; // /**< equivalent to SDL_WINDOW_MOUSE_GRABBED for compatibility */

/// Renderer Flags
/// https://wiki.libsdl.org/SDL_CreateRenderer
pub const SDL_RENDERER_SOFTWARE: u32 = 0x00000001; // Software fallback
pub const SDL_RENDERER_ACCELERATED: u32 = 0x00000002; // Hardware accelerated
pub const SDL_RENDERER_PRESENTVSYNC: u32 = 0x00000004; // Synchronized refresh rate
pub const SDL_RENDERER_TARGETTEXTURE: u32 = 0x00000008; // Supports rendering to textures
