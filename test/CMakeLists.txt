# ----------------------------------------------------------------------
# Test executable
# ----------------------------------------------------------------------

add_executable(${PROJECT_NAME}_test test_app.c)

target_link_libraries(${PROJECT_NAME}_test PRIVATE ${PROJECT_NAME}_lib)

target_include_directories(${PROJECT_NAME}_test PRIVATE ${CMAKE_SOURCE_DIR}/include)

# ----------------------------------------------------------------------
# CTest registration
# ----------------------------------------------------------------------

add_test(
    NAME ${PROJECT_NAME}.app
    COMMAND ${PROJECT_NAME}_test
)