# Makefile — tema testi.
# Değişken atamaları, otomatik değişkenler, fonksiyonlar ve koşullar.

.DEFAULT_GOAL := yardim
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:

VERSION      := 0.2.1
BANNER       := Yazılım Yolu
SRC_DIR      := samples
OUT_DIR      ?= dist
THEMES        = themes/yazilim-yolu-dark-color-theme.json \
                themes/yazilim-yolu-light-color-theme.json
VSIX         := $(OUT_DIR)/yazilim-yolu-theme-$(VERSION).vsix
SOURCES      := $(wildcard $(SRC_DIR)/*.ts $(SRC_DIR)/*.py $(SRC_DIR)/*.rs)
OBJECTS      := $(patsubst $(SRC_DIR)/%.c,$(OUT_DIR)/%.o,$(wildcard $(SRC_DIR)/*.c))
CFLAGS       += -std=c17 -Wall -Wextra -Werror -O2
NPM          := $(shell command -v npm 2>/dev/null)
GIT_SHA      := $(shell git rev-parse --short HEAD 2>/dev/null || echo "bilinmiyor")
TIMESTAMP    != date -u +%Y-%m-%dT%H:%M:%SZ

export NODE_ENV := production

ifeq ($(OS),Windows_NT)
  RM    := del /Q
  MKDIR := mkdir
else
  RM    := rm -rf
  MKDIR := mkdir -p
endif

ifdef DEBUG
  CFLAGS := $(filter-out -O2,$(CFLAGS)) -O0 -g3
endif

ifneq ($(strip $(NPM)),)
  PACKAGER := $(NPM) exec -- vsce
else
  $(warning npm bulunamadı — paketleme atlanacak)
  PACKAGER := true
endif

define banner_yaz
	@printf '\033[38;5;99m%s\033[0m v%s (%s)\n' "$(BANNER)" "$(VERSION)" "$(1)"
endef

.PHONY: yardim tumu paket dogrula temizle kur test istatistik

yardim: ## Bu yardımı göster
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN { FS = ":.*?## " } { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }'

tumu: dogrula paket ## Doğrula ve paketle

$(OUT_DIR):
	$(MKDIR) $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c | $(OUT_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(VSIX): $(THEMES) package.json | $(OUT_DIR)
	$(call banner_yaz,paketleniyor)
	$(PACKAGER) package --out $@

paket: $(VSIX) ## VSIX üret

dogrula: $(THEMES) ## Tema JSON'larını doğrula
	@for f in $^; do \
		python -c "import json,io,sys; json.load(io.open(sys.argv[1],encoding='utf-8'))" "$$f" && \
		echo "  ✓ $$f"; \
	done

kur: $(VSIX) ## Yerel VS Code'a kur
	code --install-extension $< --force

test: $(OBJECTS) ## Örnek C dosyalarını derle
	@echo "$(words $(SOURCES)) kaynak, $(words $(OBJECTS)) nesne"

istatistik: ## Örnek dosya sayıları
	@echo "sha:    $(GIT_SHA)"
	@echo "zaman:  $(TIMESTAMP)"
	@echo "diller: $(sort $(suffix $(wildcard $(SRC_DIR)/*)))"
	@echo "üst:    $(notdir $(basename $(firstword $(SOURCES))))"

temizle: ## Çıktıları sil
	-$(RM) $(OUT_DIR)
	@echo "temizlendi"

-include local.mk
