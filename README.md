
# Imgui-Ready

## What the Project Does

**Imgui-Ready** helps developers run [Dear ImGui](https://github.com/ocornut/imgui) examples easily across many platforms and graphics backends. Exploring ImGui examples with different backends is a common pain point for developers—this project aims to simplify that process by automating backend selection, build configuration, and resource management.

Unlike many projects, you do **not** need to add ImGui as a submodule. Imgui-Ready can dynamically fetch ImGui example code for the specified backend and compile it. The project supports **any version of ImGui**—all you need to do is specify the `SC_IMGUI_BACKEND` variable and point to your ImGui source.

This project relies on [SideCMake](https://github.com/imlinkzuz/SideCMake), a powerful CMake extension, to manage the build process. For more advanced usage and integration patterns, see [SideCMakeExamples](https://github.com/imlinkzuz/SideCMakeExamples).

## Supported Backends

Set the CMake variable `SC_IMGUI_BACKEND` to select your backend:

- SDL3
  - OpenGL3
  - Vulkan
  - SDLGPU3
  - SDLRenderer3
- SDL2
  - OpenGL2
  - OpenGL3
  - DirectX11
  - SDLRenderer2
  - Vulkan
- GLFW
  - OpenGL2
  - OpenGL3
  - Vulkan
- WIN32
  - DIRECTX9
  - DIRECTX10
  - DIRECTX11
  - DIRECTX12
  - OPENGL3
  - Vulkan
- APPLE
  - METAL
  - OpenGL2
- NULL  

Other backends will be added in the future.

## Why the Project is Useful

- **Multi-backend support:** Run ImGui examples on your preferred platform and graphics API.
- **No submodules required:** Dynamically fetch and build ImGui examples for any backend.
- **Supports any ImGui version:** Just point to your ImGui source and set the backend.
- **Easy setup:** No manual configuration—just select your backend and build.
- **Modern CMake integration:** Uses [SideCMake](https://github.com/imlinkzuz/SideCMake) for robust, extensible builds.
- **Resource management:** Fonts, images, and assets are included and installed automatically.
- **Extensible:** Build your own ImGui project with minimal effort.

## How Users Can Get Started

### Prerequisites

- CMake >= 3.28
- C++ compiler (MSVC, Clang, GCC, Xcode)
- [SideCMake](https://github.com/imlinkzuz/SideCMake)
- [Dear ImGui](https://github.com/ocornut/imgui) 

### Installation

Clone this repository and its dependencies:

```sh
git clone https://github.com/imlinkzuz/Imgui-Ready.git
# Clone SideCMake if not present
git clone https://github.com/imlinkzuz/SideCMake.git
# Clone ImGui if not preset
git clone https://github.com/ocornut/imgui
# Create a local configurations file `LocalPresets.json`
cd /path/to/Imgui-Ready
touch LocalPresets.json
```
Copy following contents to `LocalPresets.json` and change variables:
- SC_IMGUI_BACKEND
  - SDL3_OpenGL3
  - SDL3_Vulkan
  - SDL3_SDLGPU3
  - SDL3_SDLRenderer3
  - SDL2_OpenGL2
  - SDL2_OpenGL3
  - SDL2_DirectX11
  - SDL2_SDLRenderer2
  - SDL2_Vulkan
  - GLFW_OpenGL2
  - GLFW_OpenGL3
  - GLFW_VULKAN
  - WIN32_DIRECTX9
  - WIN32_DIRECTX10
  - WIN32_DIRECTX11
  - WIN32_DIRECTX12
  - WIN32_OpenGL3
  - WIN32_VULKAN
  - APPLE_METAL
  - APPLE_OpenGL2
- IMGUI_DIR
  - set to the directory to your imgui source.
- SIDECMAKE_DIR
  - path to the directory to your SideCMake source.
- SC_BUILD_IMGUI_EXAMPLE
- CMAKE_TOOLCHAIN_FILE
    - If you are using VCPkg for local package management, please consult the VCPkg documentation and set this variable accordingly.
```json

{
    "version": 5,
    "cmakeMinimumRequired": {
        "major": 3,
        "minor": 21,
        "patch": 0
    },
    "configurePresets": [
        {
            "name": "conf-local",
            "hidden": true,
            "vendor": {
            },
            "cacheVariables": {
                "SC_BUILD_IMGUI_EXAMPLE" : true,
                "SIDECMAKE_DIR": "/path/to/SideCMake",
                "IMGUI_DIR" : "/path/to/imgui",
                "SC_IMGUI_BACKEND" : "APPLE_METAL",
                "CMAKE_TOOLCHAIN_FILE" : "/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake"

            },
            "environment": {
            }
        }
    ]
}
```

For more advanced configuration and integration, see [SideCMakeExamples](https://github.com/imlinkzuz/SideCMakeExamples).

### Usage Example

```sh
cmake /path/to/Imgui-Ready --preset default
cd /path/to/SideCMakeExamples/ShowTime/_build/default
# For release
cmake --build . --target install --config Release
# For debug
cmake --build . --target install --config Debug 
```
> [!TIP]
> For simplity, you can open Imgui-Ready with CMake-Friendly IDE like Visual Studio Code to build and run.

## Where Users Can Get Help

- [SideCMake documentation](https://github.com/imlinkzuz/SideCMake)
- [SideCMakeExamples](https://github.com/imlinkzuz/SideCMakeExamples)
- [Dear ImGui documentation](https://github.com/ocornut/imgui)
- Project issues: [../../issues](../../issues)
- For contributing, see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

## Who Maintains and Contributes

- Maintainer: [Your Name](mailto:me@sample.com)

---

For license details, see [LICENSE](LICENSE).

---

*This README was generated by [create-readme.prompt.md](.github/prompts/create-readme.prompt.md)*
