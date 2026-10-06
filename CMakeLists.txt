cmake_minimum_required(VERSION 3.10)

# ----------------------------------------------------------------------
# Project configuration
# ----------------------------------------------------------------------

include(${CMAKE_CURRENT_SOURCE_DIR}/project.conf)

project(
    ${PROJECT_NAME}
    VERSION ${PROJECT_VERSION}
    DESCRIPTION "${PROJECT_DESCRIPTION}"
    LANGUAGES C
)

project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES C)

message(STATUS "CMake configuration for ${PROJECT_NAME} (Ver: ${PROJECT_VERSION})")

# ----------------------------------------------------------------------
# Compiler configuration
# ----------------------------------------------------------------------

set(CMAKE_C_STANDARD ${C_STANDARD})
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# ----------------------------------------------------------------------
# Application library
# ----------------------------------------------------------------------

add_library(${PROJECT_NAME}_lib STATIC
    src/app.c
)

target_include_directories(${PROJECT_NAME}_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# ----------------------------------------------------------------------
# Application executable
# ----------------------------------------------------------------------

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)

# ----------------------------------------------------------------------
# Testing
# ----------------------------------------------------------------------

if(ENABLE_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()

# ----------------------------------------------------------------------
# VS Code Debugger configuration
# ----------------------------------------------------------------------

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

if(MSVC)
    set(DEBUGGER_TYPE "cppvsdbg")
    set(EXECUTABLE_PATH "\${workspaceFolder}/build/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.exe")
else()
    set(DEBUGGER_TYPE "cppdbg")
    set(EXECUTABLE_PATH "\${workspaceFolder}/build/${PROJECT_NAME}")
endif()

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/.vscode/launch.json.in"
    "${CMAKE_CURRENT_SOURCE_DIR}/.vscode/launch.json"
    @ONLY
)