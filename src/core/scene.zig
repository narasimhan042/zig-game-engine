const i = @import("import.zig");

pub const Scene = struct {
    private: struct {
        ptr: *anyopaque,

        enterTreeFn: *const fn (ptr: *anyopaque) void,
        inputFn: *const fn (ptr: *anyopaque, event: *i.Event) anyerror!void,
        physicsProcessFn: *const fn (ptr: *anyopaque, delta: f32) anyerror!void,
        processFn: *const fn (ptr: *anyopaque, delta: f32) void,
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

            pub fn input(pointer: *anyopaque, event: *i.Event) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.input, .{ self, event });
            }

            pub fn physicsProcess(pointer: *anyopaque, delta: f32) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.physicsProcess, .{ self, delta });
            }

            pub fn process(pointer: *anyopaque, delta: f32) void {
                const self: T = @ptrCast(@alignCast(pointer));
                // return ptr_info.Pointer.child.writeAll(self);
                return @call(.always_inline, ptr_info.Pointer.child.process, .{ self, delta });
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
            .private = .{
                .ptr = ptr,
                .enterTreeFn = gen.enterTree,
                .inputFn = gen.input,
                .physicsProcessFn = gen.physicsProcess,
                .processFn = gen.process,
                .renderFn = gen.render,
                .exitTreeFn = gen.exitTree,
            },
        };
    }

    pub fn enterTree(self: Scene) void {
        return self.private.enterTreeFn(self.private.ptr);
    }

    pub inline fn input(self: Scene, event: *i.Event) anyerror!void {
        return self.private.inputFn(self.private.ptr, event);
    }

    pub inline fn physicsProcess(self: Scene, delta: f32) anyerror!void {
        return try self.private.physicsProcessFn(self.private.ptr, delta);
    }

    pub inline fn process(self: Scene, delta: f32) void {
        return self.private.processFn(self.private.ptr, delta);
    }

    pub inline fn render(self: Scene) void {
        return self.private.renderFn(self.private.ptr);
    }

    pub fn exitTree(self: Scene) void {
        return self.private.exitTreeFn(self.private.ptr);
    }
};
