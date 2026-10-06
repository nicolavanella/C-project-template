cmake_minimum_required(VERSION 3.10)

# 1. Legge il file project.conf
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/project.conf")
    file(READ "${CMAKE_CURRENT_SOURCE_DIR}/project.conf" CONF_CONTENT)
    
    # Estrae PROJECT_NAME tramite espressione regolare
    string(REGEX MATCH "PROJECT_NAME *:= *([^\n\r]+)" _ "${CONF_CONTENT}")
    set(CONF_NAME ${CMAKE_MATCH_1})
    
    # Estrae PROJECT_VER tramite espressione regolare
    string(REGEX MATCH "PROJECT_VER *:= *([^\n\r]+)" _ "${CONF_CONTENT}")
    set(CONF_VER ${CMAKE_MATCH_1})
else()
    message(FATAL_ERROR "File project.conf non trovato!")
endif()

# 2. Definisce il progetto usando le variabili lette
project(${CONF_NAME} VERSION ${CONF_VER} LANGUAGES C)

message(STATUS "Configurazione CMake per ${PROJECT_NAME} (Versione: ${PROJECT_VERSION})")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

file(GLOB SOURCES "src/*.c")

# Genera l'eseguibile usando il nome dinamico
add_executable(${PROJECT_NAME} ${SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE include)

# ----------------------------------------------------------------------
# Configurazione Automatica di launch.json per VS Code
# ----------------------------------------------------------------------

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

if(MSVC)
    set(DEBUGGER_TYPE "cppvsdbg")
    set(EXECUTABLE_PATH "\${workspaceFolder}/build/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.exe")
else()
    set(DEBUGGER_TYPE "cppdbg")
    # MinGW/GCC mette l'eseguibile direttamente nella radice di build/
    set(EXECUTABLE_PATH "\${workspaceFolder}/build/${PROJECT_NAME}.exe")
endif()

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/.vscode/launch.json.in"
    "${CMAKE_CURRENT_SOURCE_DIR}/.vscode/launch.json"
    @ONLY
)



