# Include le variabili dal file project.conf
include project.conf

CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -std=c11
SRC_DIR = src
BUILD_DIR = build

# Determina l'estensione dell'eseguibile a seconda del sistema operativo
ifeq ($(OS),Windows_NT)
    TARGET = $(BUILD_DIR)/$(PROJECT_NAME).exe
    RM = del /Q /F
    RMDIR = rmdir /S /Q
    MKDIR = if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
else
    TARGET = $(BUILD_DIR)/$(PROJECT_NAME)
    RM = rm -f
    RMDIR = rm -rf
    MKDIR = mkdir -p $(BUILD_DIR)
endif

# Trova tutti i file .c nella cartella src
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

all: $(TARGET)
	@echo "Compilazione completata con successo!"
	@echo "Eseguibile generato: $(TARGET) (v$(PROJECT_VER))"

# Link dei file oggetto per creare l'eseguibile finale
$(TARGET): $(OBJS)
	@$(MKDIR)
	$(CC) $(CFLAGS) $^ -o $@

# Compilazione dei singoli file sorgente in file oggetto
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@$(MKDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Pulisce tutti i file generati nella cartella build
clean:
	@echo "Pulizia della cartella di build in corso..."
	@$(RMDIR) $(BUILD_DIR)

.PHONY: all clean
