// const i = @import("import.zig");

// pub const InputAction = struct {
//     private: struct {
//         ptr: *anyopaque,

//         isPressedFn: *const fn (ptr: *anyopaque, event: *i.Event) bool,
//     },

//     pub fn init(ptr: anytype) InputAction {
//         const T = @TypeOf(ptr);
//         const ptr_info = @typeInfo(T);

//         if (ptr_info != .Pointer) @compileError("ptr must be a pointer");
//         if (ptr_info.Pointer.size != .One) @compileError("ptr must be a single item pointer");

//         const gen = struct {
//             pub fn isPressed(pointer: *anyopaque, event: *i.Event) bool {
//                 const self: T = @ptrCast(@alignCast(pointer));
//                 return @call(.always_inline, ptr_info.Pointer.child.isPressed, .{ self, event });
//             }
//         };

//         return .{ .private = .{
//             .ptr = ptr,
//             .isPressedFn = gen.isPressed,
//         } };
//     }

//     pub fn isPressed(self: InputAction, event: *i.Event) void {
//         return self.private.isPressedFn(self.private.ptr, event);
//     }
// };

// *******************************************
// EXAMPLE INTERFACE USAGE FOR INPUT ACTIONS *
// NOT CURRENTLY FUNCTIONAL                  *
// *******************************************
//
// pub const Red = struct {
//     pub fn createInterface(self: *Red) i.InputAction {
//         return i.InputAction.init(self);
//     }

//     pub fn isPressed(ptr: *anyopaque, event: *i.Event) bool {
//         _ = ptr;
//         // const self: *Red = @ptrCast(@alignCast(ptr));
//         return if (event.key.keysym.scancode == c.SDL_SCANCODE_A) true else false;
//     }
// };
