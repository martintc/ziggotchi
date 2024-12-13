const constants = @import("constants.zig");
const std = @import("std");
const c = @cImport(@cInclude("SDL3/SDL.h"));

pub const LCD = struct {
    screen: [constants.total_tiles]u32 = [_]u32{0} ** constants.total_tiles,

    pub fn init() LCD {
        return LCD{};
    }

    pub fn put_pixel(self: *LCD, x: usize, y: usize, color: u32) void {
        const offset = (constants.original_width * y) + x;
        self.screen[offset] = color;
    }

    pub fn draw(self: LCD, renderer: *c.SDL_Renderer) void {
        for (0..constants.original_width) |i| {
            for (0..constants.original_height) |j| {
                const pixel = self.get_pixel(i, j);
                const r: u8 = @intCast((pixel & 0xFF000000) >> 24);
                const g: u8 = @intCast((pixel & 0x00FF0000) >> 16);
                const b: u8 = @intCast((pixel & 0x0000FF00) >> 8);
                const a: u8 = @intCast(pixel & 0x000000FF);
                _ = c.SDL_SetRenderDrawColor(renderer, r, g, b, a);

                const new_x = i * constants.tile_width;
                const new_y = j * constants.tile_height;

                _ = c.SDL_RenderFillRect(renderer, &c.SDL_FRect{ .x = @floatFromInt(new_x), .y = @floatFromInt(new_y), .w = @floatFromInt(constants.tile_width), .h = @floatFromInt(constants.tile_height) });
            }
        }
    }

    fn get_pixel(self: LCD, x: usize, y: usize) u32 {
        return self.screen[(constants.original_width * y) + x];
    }
};
