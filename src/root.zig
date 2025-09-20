const std = @import("std");
const c = @cImport({
    @cDefine("GLFW_INCLUDE_NONE", {});
    @cInclude("GLFW/glfw3.h");
});

const GLFWError = error{
    WindowInitFailed,
};

pub fn initWindow() !*c.struct_GLFWwindow {
    if (c.glfwInit() != c.GLFW_TRUE) return error.GlfwInitFailed;

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);
    const window = c.glfwCreateWindow(
        @intCast(800),
        @intCast(600),
        "zigVulkan",
        null,
        null,
    ) orelse return GLFWError.WindowInitFailed;

    return window;
}

pub fn loop(window: *c.struct_GLFWwindow) !void {
    defer c.glfwDestroyWindow(window);
    defer c.glfwTerminate();

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glfwPollEvents();
    }
}
