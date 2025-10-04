include(${SIDECMAKE_DIR}/SystemLink.cmake)
include(${SIDECMAKE_DIR}/SCInstall.cmake)

string(TOUPPER "${SC_IMGUI_BACKEND}" _backend_upper)

list(APPEND _sources "main.cpp")

if (SC_BUILD_IMGUI_EXAMPLE)
  include("./SCExamples.cmake")
  sc_gen_examples()
  list(APPEND _sources ${_example_source})
endif()

sc_install_executable(
  TARGET_NAME imgui_example 
  OPTIONS
    WIN32 MACOSX_BUNDLE
  PRIVATE_SOURCES
    ${_sources}
  PRIVATE_DEPENDENCIES  
    imgui::imgui
    spdlog
  SHARED_DEPENDENCIES 
    ${_shared_deps}
  RESOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/images
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/avatar.jpg
  FONTS
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/fonts/Cousine-Regular.ttf  
)

unset(_shared_deps)
unset(_sources)
unset(_backend_upper)

