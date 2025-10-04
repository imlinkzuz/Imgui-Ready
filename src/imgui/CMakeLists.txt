cmake_minimum_required( VERSION 3.21 FATAL_ERROR )

include(${SIDECMAKE_DIR}/SCInstall.cmake)
include(${SIDECMAKE_DIR}/SCUtilities.cmake)

# The backend to use for ImGui. Options are: WIN32, GLFW, SDL2, SDL3, SDLGPU3, SDLRENDERER2, SDLRENDERER3, VULKAN, OPENGL2, OPENGL3, DIRECTX9, DIRECTX10, DIRECTX11, DIRECTX12, APPLE, METAL
sc_global_set(SC_IMGUI_BACKEND "SDL3" "Backend" CACHE STRING GROUP "IMGUI")

file(READ "${IMGUI_DIR}/imgui.h" _imgui_h_content)
string(REGEX MATCH "#define[ \t]+IMGUI_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)" _imgui_version_match "${_imgui_h_content}")
set(IMGUI_VERSION "${CMAKE_MATCH_1}")
project(imgui
  VERSION ${IMGUI_VERSION})

set(_imgui_sources
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui.cpp
)

if (SC_WITH_EXTERNAL_FREETYPE)
  list(APPEND _imgui_sources ${IMGUI_DIR}/misc/freetype/imgui_freetype.cpp)
  list(APPEND _imgui_deps freetype)
  if (TARGET plutosvg::plutosvg) 
    list(APPEND _imgui_deps plutosvg)
  endif()
endif()

string(TOUPPER "${SC_IMGUI_BACKEND}" _GUI_BACKEND_UPPER)

if (_GUI_BACKEND_UPPER MATCHES "WIN32")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_win32.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "GLFW")
  list(APPEND _imgui_deps glfw3)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
  )
endif() 


if (_GUI_BACKEND_UPPER MATCHES "SDL2")
  list(APPEND _imgui_deps SDL2)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_sdl2.cpp
  )
endif() 


if (_GUI_BACKEND_UPPER MATCHES "SDL3")
  list(APPEND _imgui_deps SDL3)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_sdl3.cpp
  )
endif()

if (_GUI_BACKEND_UPPER MATCHES "SDLGPU3")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_sdlgpu3.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "SDLRENDERER2")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_sdlrenderer2.cpp
  )
endif() 


if (_GUI_BACKEND_UPPER MATCHES "SDLRENDERER3")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_sdlrenderer3.cpp
  )
endif() 


if (_GUI_BACKEND_UPPER MATCHES "VULKAN")
  list(APPEND _imgui_deps Vulkan)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "OPENGL2")
  list(APPEND _imgui_deps OpenGL)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_opengl2.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "OPENGL3")
  list(APPEND _imgui_deps OpenGL)
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "DIRECTX9")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_dx9.cpp
  )
endif() 
if (_GUI_BACKEND_UPPER MATCHES "DIRECTX10")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_dx10.cpp
  )
endif() 
if (_GUI_BACKEND_UPPER MATCHES "DIRECTX11")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_dx11.cpp
  )
endif() 
if (_GUI_BACKEND_UPPER MATCHES "DIRECTX12")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_dx12.cpp
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "APPLE")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_osx.mm
  )
endif()  


if (_GUI_BACKEND_UPPER MATCHES "METAL")
  list(APPEND _imgui_sources 
        ${IMGUI_DIR}/backends/imgui_impl_metal.mm
  )
endif()  


sc_install_library(
  TARGET_NAME imgui
  PROJECT_NAME imgui
  LINK_TYPE STATIC
  SYSTEM_LIBRARY TRUE
  TARGET_PROPERTIES 
    VERSION ${PROJECT_VERSION}
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
  PRIVATE_SOURCES
    ${_imgui_sources}
  PUBLIC_INCLUDE_DIRS  
    $<BUILD_INTERFACE:${IMGUI_DIR}>
    $<BUILD_INTERFACE:${IMGUI_DIR}/backends>
  PUBLIC_DEPENDENCIES
    ${_imgui_deps}  
)

if (_GUI_BACKEND_UPPER MATCHES "DIRECTX9")
  target_link_libraries(imgui PUBLIC
    d3d9.lib
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "DIRECTX10")
  target_link_libraries(imgui PUBLIC
    d3d10.lib
    d3dcompiler.lib
  )
endif() 

if (_GUI_BACKEND_UPPER MATCHES "DIRECTX11")
  target_link_libraries(imgui PUBLIC
    d3d11.lib
#   dxgi.lib
    d3dcompiler.lib
#   dxguid.lib
  )
endif() 
if (_GUI_BACKEND_UPPER MATCHES "DIRECTX12")
  target_link_libraries(imgui PUBLIC
    d3d12.lib
    dxgi.lib
    d3dcompiler.lib
  )
endif() 


if (_GUI_BACKEND_UPPER MATCHES "APPLE")
  target_link_libraries(imgui 
    PRIVATE 
      "-framework AppKit -framework QuartzCore -framework GameController"
  )
endif()

if (_GUI_BACKEND_UPPER MATCHES "METAL")
  target_link_libraries(imgui 
    PRIVATE 
      "-framework Metal -framework MetalKit"
  )
endif()


# # Disable all warnings private
# if (MSVC)
#   target_compile_options(imgui PRIVATE "/w")
# else()
#   target_compile_options(imgui PRIVATE -Wno-error) 
# endif()

# Disable all warnings when include file is used by the external
target_include_directories(imgui SYSTEM INTERFACE ${IMGUI_DIR})

target_compile_definitions(imgui 
PUBLIC 
  IMGUI_USE_WCHAR32
  IMGUI_DEFINE_MATH_OPERATORS 
)

if (SC_WITH_EXTERNAL_FREETYPE)
  target_compile_definitions(imgui 
    PUBLIC 
      IMGUI_ENABLE_FREETYPE
  )
  if (TARGET plutosvg::plutosvg) 
    target_compile_definitions(imgui 
      PUBLIC 
      IMGUI_ENABLE_FREETYPE_PLUTOSVG
    )
  endif()
endif()


#target_link_system_libraries(imgui PRIVATE sc_project_options)
#find_package(freetype REQUIRED CONFIG)
target_compile_features(imgui PUBLIC cxx_std_11)
        

sc_install_project(PROJECT_NAME imgui)

unset(_imgui_sources)
unset(_imgui_deps)
unset(_GUI_BACKEND_UPPER)