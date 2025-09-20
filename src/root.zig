const std = @import("std");
const c = @cImport({
    @cDefine("GLFW_INCLUDE_NONE", {});
    @cInclude("GLFW/glfw3.h");
    @cInclude("vulkan/vulkan.h");
});

const GLFWError = error{
    WindowInitFailed,
};

const VulkanError = error{
    InitFailed,
};

pub fn initWindow() !*c.struct_GLFWwindow {
    if (c.glfwInit() != c.GLFW_TRUE) return error.GlfwInitFailed;

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);
    const window = c.glfwCreateWindow(
        @intCast(800),
        @intCast(600),
        "Zulkan",
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

pub fn initVulkan() VulkanError!c.VkInstance {
    const info = c.VkApplicationInfo{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Zulkan",
        .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = c.VK_API_VERSION_1_0,
    };

    var glfw_extension_count: u32 = 0;
    const glfwExtensions: [*c][*c]const u8 = c.glfwGetRequiredInstanceExtensions(&glfw_extension_count);

    const create_info = c.VkInstanceCreateInfo{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &info,
        .enabledExtensionCount = glfw_extension_count,
        .ppEnabledExtensionNames = glfwExtensions,
        .enabledLayerCount = 0,
    };

    var instance: c.VkInstance = undefined;
    const result: c.VkResult = c.vkCreateInstance(&create_info, null, &instance);

    if (result != c.VK_SUCCESS) {
        return VulkanError.InitFailed;
    }

    return instance;
}
