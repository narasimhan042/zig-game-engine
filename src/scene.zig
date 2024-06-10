const i = @import("import.zig");

pub const Scene = struct {
    ptr: *anyopaque,

    enterTreeFn: *const fn (ptr: *anyopaque) void,
    readyFn: *const fn (ptr: *anyopaque) void,
    inputFn: *const fn (ptr: *anyopaque, event: *i.Event) void,
    // physicsProcessFn: *const fn (ptr: *anyopaque) void,
    // processFn: *const fn (ptr: *anyopaque) void,
    renderFn: *const fn (ptr: *anyopaque) void,
    exitTreeFn: *const fn (ptr: *anyopaque) void,

    pub fn init(ptr: anytype) Scene {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);

        if (ptr_info != .Pointer) @compileError("ptr must be a pointer");
        if (ptr_info.Pointer.size != .One) @compileError("ptr must be a single item pointer");

        const gen = struct {
            pub fn enterTree(pointer: *anyopaque) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.enterTree, .{self});
            }

            pub fn ready(pointer: *anyopaque) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.ready, .{self});
            }

            pub fn input(pointer: *anyopaque, event: *i.Event) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.input, .{ self, event });
            }

            pub fn render(pointer: *anyopaque) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.render, .{self});
            }

            pub fn exitTree(pointer: *anyopaque) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.exitTree, .{self});
            }
        };

        return .{
            .ptr = ptr,
            .enterTreeFn = gen.enterTree,
            .readyFn = gen.ready,
            .inputFn = gen.input,
            .renderFn = gen.render,
            .exitTreeFn = gen.exitTree,
        };
    }

    pub fn enterTree(self: Scene) void {
        return self.enterTreeFn(self.ptr);
    }

    pub fn ready(self: Scene) void {
        return self.readyFn(self.ptr);
    }

    pub fn input(self: Scene, event: *i.Event) void {
        return self.inputFn(self.ptr, event);
    }

    pub fn render(self: Scene) void {
        return self.renderFn(self.ptr);
    }

    pub fn exitTree(self: Scene) void {
        return self.exitTreeFn(self.ptr);
    }
};
