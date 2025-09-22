# =============================================================================
# Переменные

# Ассемблер
NASM = nasm -f bin

# Эмулятор
QEMU = qemu-system-i386

# Имя финального образа
IMAGE = disk.img

# =============================================================================
# Задачи

# Задача по умолчанию: просто 'make' соберет образ
all: $(IMAGE)

# Рецепт создания финального образа disk.img
# Он зависит от boot.bin и kernel.bin
$(IMAGE): .tmp/boot.bin .tmp/kernel.bin
	@echo "--- Creating final disk image: $(IMAGE) ---"
	@cat .tmp/boot.bin .tmp/kernel.bin > $(IMAGE)

# Рецепт компиляции загрузчика
.tmp/boot.bin: src/boot.asm
	@echo "Assembling bootloader..."
	@$(NASM) src/boot.asm -o .tmp/boot.bin

# Рецепт компиляции ядра
.tmp/kernel.bin: src/kernel.asm
	@echo "Assembling kernel..."
	@$(NASM) src/kernel.asm -o .tmp/kernel.bin

# Задача для запуска в QEMU
run: $(IMAGE)
	@$(QEMU) -fda $(IMAGE)

# Задача для очистки проекта от временных файлов
clean:
	@echo "Cleaning up..."
	@rm -f *.img
	@rm -rf .tmp
	@mkdir .tmp

# Специальная директива, чтобы 'make' не путал задачи с файлами
.PHONY: all run clean
