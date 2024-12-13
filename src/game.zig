const std = @import("std");
const lcd = @import("lcd.zig");
const constants = @import("constants.zig");

const c = @cImport(@cInclude("SDL3/SDL.h"));

const cat_0 = @embedFile("assets/cat_0");

pub const Game = struct {
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    screen: lcd.LCD,

    pub fn init() Game {
        return Game{ .window = undefined, .renderer = undefined, .screen = undefined };
    }

    pub fn initialize(self: *Game) !void {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) != true) {
            c.SDL_Log("Error occure initializing SDL: %s\n", c.SDL_GetError());
            return error.SDLInitializationError;
        }

        self.window = c.SDL_CreateWindow("ziggotchi", constants.window_width, constants.window_height, 0) orelse {
            c.SDL_Log("Error occure initializing SDL: %s\n", c.SDL_GetError());
            return error.SDLInitializationError;
        };

        self.renderer = c.SDL_CreateRenderer(self.window, null) orelse {
            c.SDL_Log("Error occured initializing SDL: %s\n", c.SDL_GetError());
            return error.SDLInitializationError;
        };

        self.screen = lcd.LCD.init();
    }

    pub fn destroy(self: *Game) void {
        c.SDL_DestroyRenderer(self.renderer);
        c.SDL_DestroyWindow(self.window);
        c.SDL_Quit();
    }

    pub fn run(self: *Game) !void {
        var x: usize = 5;
        var y: usize = 1;
        for (cat_0) |j| {
            if (j == '\n') {
                y += 1;
                x = 5;
                continue;
            }

            if (j == '0') {
                self.screen.put_pixel(x, y, 0x000000FF);
                x += 1;
                continue;
            }

            self.screen.put_pixel(x, y, 0xFFFFFFFF);
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

            _ = c.SDL_SetRenderDrawColor(self.renderer, 0x00, 0x00, 0x00, 0xFF);
            _ = c.SDL_RenderClear(self.renderer);

            self.screen.draw(self.renderer);

            _ = c.SDL_RenderPresent(self.renderer);

            c.SDL_Delay(17);
        }
    }
};
