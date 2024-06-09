pub const Scene = struct {
    ptr: *anyopaque,
    enterTreeFn: *const fn (ptr: *anyopaque) void,

    pub fn enterTree(self: Scene) void {
        return self.enterTreeFn(self.ptr);
    }

    // pub fn init(ptr: anytype) Scene {
    //     const T = @TypeOf(ptr);
    //     const ptr_info = @typeInfo(T);

    //     const gen = struct {
    //         pub fn enterTree(pointer: *anyopaque) void {
    //             const self: T = @ptrCast(@alignCast(pointer));
    //             return ptr_info.Pointer.child.enterTree(self);
    //         }
    //     };

    //     return .{
    //         .ptr = ptr,
    //         .enterTreeFn = gen.enterTree,
    //     };
    // }
};
