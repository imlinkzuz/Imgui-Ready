

# Done as a function so that updates to variables like
# CMAKE_CXX_FLAGS don't propagate out to other
# targets
function(myproject_setup_dependencies)
  cmake_policy(SET CMP0144 OLD)
  cmake_policy(SET CMP0072 NEW) # ENABLE  CMP0072: FindOpenGL prefers GLVND by default when available.
  # For each dependency, see if it's
  # already been provided to us by a parent project

  include(${SIDECMAKE_DIR}/SCFindPackage.cmake)

# Use sc_find_package to find and configure dependencies
# you can add your own dependencies here:

#  add_compile_definitions(SPDLOG_FMT_EXTERNAL)
#  sc_find_package(PKG_TARGET spdlog::spdlog 
#    PKG_OPTIONS 
#      REQUIRED CONFIG
#  )

  sc_find_package(PKG_TARGET fmt::fmt 
    PKG_OPTIONS 
      REQUIRED CONFIG
  )  

  add_compile_definitions(SPDLOG_FMT_EXTERNAL)
  sc_find_package(PKG_TARGET spdlog::spdlog 
    PKG_OPTIONS 
      REQUIRED CONFIG
  )

  string(TOUPPER "${SC_IMGUI_BACKEND}" _GUI_BACKEND_UPPER)

  if (_GUI_BACKEND_UPPER MATCHES "GLFW")
    if(NOT TARGET glfw)
      sc_find_package(
        PKG_PREFIX glfw3 
        PKG_TARGET glfw 
        PKG_OPTIONS 
          REQUIRED CONFIG
      )
    endif()
  endif()

  if (_GUI_BACKEND_UPPER MATCHES "SDL2") 
    if(NOT TARGET SDL2::SDL2)
      sc_find_package(PKG_TARGET SDL2::SDL2 
        PKG_OPTIONS 
          REQUIRED CONFIG
      )
    endif()  
  endif()

  if(_GUI_BACKEND_UPPER MATCHES "SDL3") 
    if(NOT TARGET SDL3::SDL3)
      sc_find_package(PKG_TARGET SDL3::SDL3 
        PKG_OPTIONS 
          REQUIRED CONFIG
      )
    endif()
  endif()

  if (_GUI_BACKEND_UPPER MATCHES "OPENGL") 

    if(NOT TARGET OpenGL::OpenGL)
    # opengl
      # sc_find_package(PKG_TARGET OpenGL 
      #   PKG_OPTIONS 
      #     REQUIRED
      # )
      find_package(OpenGL REQUIRED)
      if (OPENGL_FOUND) 
         message(STATUS "Found OpenGL")
      endif()
      if (DEFINED OpenGL::GLES2) 
        message(STATUS "  - Found GLES2")
      endif()
      if (DEFINED OpenGL::GLES3) 
        message(STATUS "  - Found GLES3")
      endif()
      if (OPENGL_LIBRARIES) 
         message(STATUS "Looking for OpenGL library: ${OPENGL_LIBRARIES} - found")
      else()
         message(WARNING "Looking for OpenGL library - not found")
      endif()
      #link_libraries(${OPENGL_LIBRARIES})
      sc_add_project_dependency("OpenGL" ${OPENGL_LIBRARIES} " " "REQUIRED")
    endif()

  endif()

  if (_GUI_BACKEND_UPPER MATCHES "VULKAN") 
    if(NOT TARGET Vulkan::Vulkan)
      sc_find_package(PKG_TARGET Vulkan::Vulkan 
        PKG_OPTIONS 
          REQUIRED
      )
    endif()  
  endif()


  sc_find_package(PKG_PREFIX freetype PKG_TARGET Freetype::Freetype 
    PKG_OPTIONS 
    CONFIG
  )
 
  if ((NOT DEFINED SC_WITH_EXTERNAL_FREETYPE) AND (TARGET Freetype::Freetype))
    option(SC_WITH_EXTERNAL_FREETYPE "Enable ImGui to use external FreeType." ON)
  endif()
  
  if (SC_WITH_EXTERNAL_FREETYPE)
    if (NOT TARGET Freetype::Freetype) 
      message(FATAL_ERROR "You set SC_WITH_EXTERNAL_FREETYPE to true byte FreeType cannot be found.")
    endif()
    sc_find_package(PKG_TARGET plutosvg::plutosvg 
      PKG_OPTIONS 
        CONFIG
    )
    if (NOT TARGET plutosvg::plutosvg)
      message(WARNING "'Plutosvg' is not available, it's recomemnted to install it when you want rendering of colored emojis in ImGui with FreeType.")
    endif()
  endif()
  include(FeatureSummary)
  add_feature_info("ImGui with External FreeType" SC_WITH_EXTERNAL_FREETYPE "")
endfunction()
