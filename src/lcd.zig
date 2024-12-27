const colors = @import("colors.zig");
const constants = @import("constants.zig");
const std = @import("std");
const c = @cImport(@cInclude("SDL3/SDL.h"));

pub const LCD = struct {
    screen: [constants.total_tiles]u8 = [_]u8{0} ** constants.total_tiles,

    pub fn init() LCD {
        return LCD{};
    }

    pub fn put_pixel(self: *LCD, x: usize, y: usize, color: u8) void {
        const offset = (constants.original_width * y) + x;
        self.screen[offset] = color;
    }

    pub fn clear_screen(self: *LCD) void {
        @memset(self.screen, 0);
    }

    pub fn draw(self: LCD, renderer: *c.SDL_Renderer) void {
        for (0..constants.original_width) |i| {
            for (0..constants.original_height) |j| {
                const pixel = self.get_pixel(i, j);
                const color: colors.Color = switch (pixel) {
                    0 => colors.Green0,
                    1 => colors.Green1,
                    2 => colors.Green2,
                    3 => colors.Green3,
                    else => colors.Green0,
                };
                _ = c.SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);

                const new_x = i * constants.tile_width;
                const new_y = j * constants.tile_height;

                _ = c.SDL_RenderFillRect(renderer, &c.SDL_FRect{ .x = @floatFromInt(new_x), .y = @floatFromInt(new_y), .w = @floatFromInt(constants.tile_width), .h = @floatFromInt(constants.tile_height) });
            }
        }
    }

    fn get_pixel(self: LCD, x: usize, y: usize) u8 {
        return self.screen[(constants.original_width * y) + x];
    }
};
