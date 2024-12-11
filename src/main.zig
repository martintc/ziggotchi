//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const c = @cImport(@cInclude("SDL3/SDL.h"));
const constants = @import("constants.zig");
const lcd = @import("lcd.zig");

const cat_0 = @embedFile("cat_0");

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != true) {
        c.SDL_Log("An error occured: %s\n", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("Ziggotchi", constants.window_width, constants.window_height, 0) orelse {
        c.SDL_Log("An error occured: %s\n", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    defer c.SDL_DestroyWindow(window);

    const renderer = c.SDL_CreateRenderer(window, null) orelse {
        c.SDL_Log("An error occured: %s\n", c.SDL_GetError());
        return error.SDLInitializationError;
    };

    defer c.SDL_DestroyRenderer(renderer);

    var screen = lcd.LCD.init();

    var x: usize = 5;
    var y: usize = 1;
    for (cat_0) |j| {
        if (j == '\n') {
            y += 1;
            x = 5;
            continue;
        }

        if (j == '0') {
            screen.put_pixel(x, y, 0x000000FF);
            x += 1;
            continue;
        }

        screen.put_pixel(x, y, 0xFFFFFFFF);
        x += 1;
    }

    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != false) {
            switch (event.type) {
                c.SDL_EVENT_QUIT => quit = true,
                else => {},
            }
        }

        _ = c.SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0xFF);

        _ = c.SDL_RenderClear(renderer);

        // Draw Logic
        screen.draw(renderer);

        _ = c.SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0xFF);

        _ = c.SDL_RenderPresent(renderer);

        c.SDL_Delay(17);
    }
}
