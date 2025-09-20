const std = @import("std");
const zigVulkan = @import("zigVulkan");

pub fn main() !void {
    const window = try zigVulkan.initWindow();
    _ = try zigVulkan.initVulkan();
    try zigVulkan.loop(window);
}
