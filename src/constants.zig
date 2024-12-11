pub const window_width = 640;
pub const window_height = 400;

pub const original_width = 32;
pub const original_height = 16;

pub const tile_width: comptime_int = window_width / original_width;
pub const tile_height: comptime_int = window_height / original_height;

pub const total_tiles = original_width * original_height;
