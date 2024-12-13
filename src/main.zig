//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const game = @import("game.zig");

pub fn main() !void {
    var g = game.Game.init();
    try g.initialize();
    defer g.destroy();
    try g.run();
}
