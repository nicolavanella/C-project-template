# C Project Template

A professional, minimal, and cross-platform template for C language development. 
It features automated building and debugging workflows using CMake, GNU Make, and Visual Studio Code configurations.

## Project Structure

```text
mio_progetto_c/
├── .vscode/
│   ├── launch.json.in   # VS Code Debugger template
│   ├── settings.json    # VS Code & CMake Tools workspace settings <-- ADDED
│   └── tasks.json       # Automation tasks (build, clean)
├── build/               # Generated build binaries (gitignored)
├── include/
│   └── main.h           # Header files
├── src/
│   └── main.c           # Source code
├── .gitignore
├── CMakeLists.txt       # Main CMake configuration
├── Makefile             # GNU Make build file (Mac/Linux)
├── project.conf         # Centralized project configuration file
└── README.md            # This documentation
```

---

## Configuration (`project.conf`)

Project details are centralized inside the `project.conf` file at the root directory. Both the `Makefile` and `CMakeLists.txt` parse this file dynamically.

```text
PROJECT_NAME := my_project
PROJECT_VER := 0.1.0
```

---

## Prerequisites

Ensure you have the following installed on your system:
* **C Compiler:** GCC (Linux), Clang (macOS), or MSVC (Windows via Visual Studio).
* **CMake:** Version 3.10 or higher.
* **VS Code Extensions:** `C/C++` and `CMake Tools` (both by Microsoft).

---

## Global Build Instructions

### Option 1: Using CMake (Recommended & Cross-Platform)
1. Navigate to the build directory (or let CMake create it):
   ```bash
   cmake -B build -S .
   ```
2. Compile the project:
   ```bash
   cmake --build build
   ```
3. Run the compiled executable:
   * **Linux/macOS:** `./build/my_project`
   * **Windows (MSVC):** `.\build\Debug\my_project.exe` (or `\Release\`)

### Option 2: Using Makefile (macOS / Linux)
1. Compile the project:
   ```bash
   make
   ```
2. Run the program:
   ```bash
   ./build/my_project
   ```
3. Clean compiled binaries:
   ```bash
   make clean
   ```

---

## VS Code Automated Workflow (Windows Focus)

The environment is fully tailored to provide a seamless **F5 (Debug)** experience in Visual Studio Code.

### 1. Initial Setup
* Open the root folder in VS Code.
* Trigger a clean configuration step by pressing `Ctrl + Shift + P` and executing **`CMake: Configure`**. This reads `project.conf` and generates the final `.vscode/launch.json` file dynamically based on your active compiler.

### 2. Building and Debugging
* **`F7`**: Compiles the project using CMake Tools.
* **`F5`**: Automatically checks for code modifications, compiles the newest changes, attaches the native debugger (`cppvsdbg` for MSVC or `cppdbg` for GCC), and starts step-by-step execution.
* **Breakpoints:** You can set breakpoints inside `src/main.c` or any other source file natively.

### 3. Cleaning the Environment
To wipe out stale cached configurations or switch securely between *Debug* and *Release* builds, use one of the following methods:
* **Command Palette:** `Ctrl + Shift + P` -> **`CMake: Clean Configure`**
* **Automated Task:** `Ctrl + Shift + P` -> `Tasks: Run Task` -> Select **`Progetto: Pulisci Build`**
