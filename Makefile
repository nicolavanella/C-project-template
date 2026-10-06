include project.conf

CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -std=c11

SRC_DIR = src
TEST_DIR = test
BUILD_DIR = build

ifeq ($(OS),Windows_NT)
    TARGET = $(BUILD_DIR)/$(PROJECT_NAME).exe
    TEST_TARGET = $(BUILD_DIR)/$(PROJECT_NAME)_test.exe

    RM = del /Q /F
    RMDIR = rmdir /S /Q
    MKDIR = if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
else
    TARGET = $(BUILD_DIR)/$(PROJECT_NAME)
    TEST_TARGET = $(BUILD_DIR)/$(PROJECT_NAME)_test

    RM = rm -f
    RMDIR = rm -rf
    MKDIR = mkdir -p $(BUILD_DIR)
endif

SRCS = $(wildcard $(SRC_DIR)/*.c)
APP_SRCS = $(filter-out $(SRC_DIR)/main.c,$(SRCS))
APP_OBJS = $(APP_SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
MAIN_OBJ = $(BUILD_DIR)/main.o
TEST_OBJ = $(BUILD_DIR)/test_app.o

# ----------------------------------------------------------------------
# Default target
# ----------------------------------------------------------------------

all: $(TARGET)

# ----------------------------------------------------------------------
# Application
# ----------------------------------------------------------------------

$(TARGET): $(APP_OBJS) $(MAIN_OBJ)
	@$(MKDIR)
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.c
	@$(MKDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@$(MKDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------

test: $(TEST_TARGET)
	@$(TEST_TARGET)

$(TEST_TARGET): $(APP_OBJS) $(TEST_OBJ)
	@$(MKDIR)
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/test_app.o: $(TEST_DIR)/test_app.c
	@$(MKDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------

clean:
	@echo "Pulizia della cartella di build in corso..."
	@$(RMDIR) $(BUILD_DIR)

.PHONY: all test clean