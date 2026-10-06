# Testing

This project uses [CTest](https://cmake.org/cmake/help/latest/manual/ctest.1.html) as its test runner.

CTest is included with CMake and does not require an additional testing framework.

## Requirements

To build and run the tests, you need:

- CMake 3.10 or newer
- A C compiler supporting C11

## Configure the project

From the project root, configure the CMake build:

```bash
cmake -B build -S .
```

This creates the `build/` directory and generates the build system.

## Build the project

Build the application and the test executable:

```bash
cmake --build build
```

If you are using a multi-configuration generator such as Visual Studio, specify the configuration:

```powershell
cmake --build build --config Debug
```

Available configurations typically include:

- `Debug`
- `Release`
- `RelWithDebInfo`
- `MinSizeRel`

## Run tests

### Single-configuration generators

For generators such as Makefiles or Ninja:

```bash
ctest --test-dir build --output-on-failure
```

### Multi-configuration generators

For Visual Studio and other multi-configuration generators, specify the configuration with `-C`:

```powershell
ctest --test-dir build -C Debug --output-on-failure
```

For a Release build:

```powershell
ctest --test-dir build -C Release --output-on-failure
```

The configuration passed to CTest must match the configuration used to build the project.

For example:

```powershell
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

## Example test

The project contains an example test:

```text
test/
├── CMakeLists.txt
└── test_app.c
```

The test verifies the behavior of the application API exposed by:

```text
include/app.h
```

The implementation is located in:

```text
src/app.c
```

The test uses the standard C `assert()` function:

```c
#include <assert.h>
```

For example:

```c
static void test_app_message(void)
{
    const char *message = app_message();

    assert(message != NULL);
    assert(strcmp(message, "Hello, World!") == 0);
}
```

If an assertion fails, the test executable returns a non-zero exit code and CTest reports the test as failed.

## Adding a new test

New tests should be placed in the `test/` directory.

For example:

```text
test/
├── CMakeLists.txt
├── test_app.c
└── test_math.c
```

Create the test executable in `test/CMakeLists.txt`:

```cmake
add_executable(${PROJECT_NAME}_math_test
    test_math.c
)

target_link_libraries(${PROJECT_NAME}_math_test
    PRIVATE
        ${PROJECT_NAME}_lib
)

target_include_directories(${PROJECT_NAME}_math_test
    PRIVATE
        ${CMAKE_SOURCE_DIR}/include
)
```

Register the executable with CTest:

```cmake
add_test(
    NAME ${PROJECT_NAME}.math
    COMMAND ${PROJECT_NAME}_math_test
)
```

After modifying the CMake configuration, reconfigure and build the project.

For a single-configuration generator:

```bash
cmake -B build -S .
cmake --build build
```

For Visual Studio:

```powershell
cmake -B build -S .
cmake --build build --config Debug
```

Then run the tests using the matching configuration:

```bash
ctest --test-dir build --output-on-failure
```

or:

```powershell
ctest --test-dir build -C Debug --output-on-failure
```

## Test naming conventions

Use the following conventions for tests:

- Test source files should start with `test_`.
- Test executables should use the project name followed by `_test`.
- CTest names should identify the component being tested.
- Each test should focus on one logical component or behavior.

For example:

```text
test/test_parser.c
```

can be registered as:

```cmake
add_test(
    NAME ${PROJECT_NAME}.parser
    COMMAND ${PROJECT_NAME}_parser_test
)
```

## Test organization

Application code should be kept separate from the test code.

The recommended structure is:

```text
src/
    app.c
    parser.c
    utils.c

include/
    app.h
    parser.h
    utils.h

test/
    test_app.c
    test_parser.c
    test_utils.c
```

The application code is compiled into the project library:

```text
${PROJECT_NAME}_lib
```

Tests link against this library instead of compiling the application sources directly.

This makes the same implementation available to both the main executable and the tests.

## Running a specific test

To list all registered tests:

```bash
ctest --test-dir build -N
```

For a multi-configuration generator:

```powershell
ctest --test-dir build -C Debug -N
```

To run a specific test:

```bash
ctest --test-dir build -R myProject.app
```

For Visual Studio:

```powershell
ctest --test-dir build -C Debug -R myProject.app
```

The `-R` option uses a regular expression to select tests.

For example:

```powershell
ctest --test-dir build -C Debug -R parser
```

runs all tests whose names contain `parser`.

## Verbose test output

To see the command executed for each test:

```bash
ctest --test-dir build -V
```

For Visual Studio:

```powershell
ctest --test-dir build -C Debug -V
```

For even more detailed output:

```powershell
ctest --test-dir build -C Debug -VV
```

This can be useful when debugging test failures.

## Running tests through Make

If GNU Make is available, the project also provides a convenience target:

```bash
make test
```

This builds and executes the example test directly.

CTest remains the recommended way to run the complete test suite.

## Clean build

To recreate the build directory from scratch:

```bash
rm -rf build
cmake -B build -S .
cmake --build build
```

On Windows PowerShell:

```powershell
Remove-Item -Recurse -Force build
cmake -B build -S .
cmake --build build --config Debug
```

Then run:

```powershell
ctest --test-dir build -C Debug --output-on-failure
```

## Typical workflow

### Linux / single-configuration generator

```bash
cmake -B build -S .
cmake --build build
ctest --test-dir build --output-on-failure
```

### Windows / Visual Studio

```powershell
cmake -B build -S .
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

For Release:

```powershell
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

## Future extensions

The current test setup intentionally uses only CTest and the standard C library.

This keeps the project lightweight and dependency-free.

If the project grows, additional testing tools can be introduced when needed, for example:

- a unit testing framework;
- mocking support;
- code coverage;
- test fixtures;
- integration tests;
- memory checking tools.

These should only be added when the complexity of the project justifies the additional dependencies.