const i = @import("import.zig");

pub const Scene = struct {
    private: struct {
        ptr: *anyopaque,

        enterTreeFn: *const fn (ptr: *anyopaque) void,
        readyFn: *const fn (ptr: *anyopaque) void,
        inputFn: *const fn (ptr: *anyopaque, event: *i.Event) anyerror!void,
        // physicsProcessFn: *const fn (ptr: *anyopaque) void,
        // processFn: *const fn (ptr: *anyopaque) void,
        renderFn: *const fn (ptr: *anyopaque) void,
        exitTreeFn: *const fn (ptr: *anyopaque) void,
    },

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

            pub inline fn input(pointer: *anyopaque, event: *i.Event) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.input, .{ self, event });
            }

            pub inline fn render(pointer: *anyopaque) void {
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

        return .{ .private = .{
            .ptr = ptr,
            .enterTreeFn = gen.enterTree,
            .readyFn = gen.ready,
            .inputFn = gen.input,
            .renderFn = gen.render,
            .exitTreeFn = gen.exitTree,
        } };
    }

    pub fn enterTree(self: Scene) void {
        return self.private.enterTreeFn(self.private.ptr);
    }

    pub fn ready(self: Scene) void {
        return self.private.readyFn(self.private.ptr);
    }

    pub inline fn input(self: Scene, event: *i.Event) anyerror!void {
        return self.private.inputFn(self.private.ptr, event);
    }

    pub inline fn render(self: Scene) void {
        return self.private.renderFn(self.private.ptr);
    }

    pub fn exitTree(self: Scene) void {
        return self.private.exitTreeFn(self.private.ptr);
    }
};
