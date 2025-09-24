# Makefile für AI-Accelerator mit automatischer Config-Verarbeitung

# Python Script
CONFIG_CONVERTER = config_converter.py

# Dateien
CONFIG_FILE = ai_accelerator.config
DEFINES_FILE = ai_config_defines.svh
PKG_FILE = ai_accelerator_pkg.sv
MAIN_FILE = ai_accelerator.sv

# Simulation Tools
VLOG = vlog
VSIM = vsim
WORK = work

# Default Target
all: config compile

# Config Processing: .config → .svh
config: $(DEFINES_FILE)

$(DEFINES_FILE): $(CONFIG_FILE) $(CONFIG_CONVERTER)
	@echo "=== Konvertiere Config zu Defines ==="
	python3 $(CONFIG_CONVERTER)
	@echo "=== Config-Konvertierung abgeschlossen ==="

# Compilation
compile: $(DEFINES_FILE)
	@echo "=== Kompiliere SystemVerilog ==="
	@mkdir -p $(WORK)
	$(VLOG) -work $(WORK) $(PKG_FILE) $(MAIN_FILE)
	@echo "=== Kompilierung abgeschlossen ==="

# Clean
clean:
	@echo "=== Aufräumen ==="
	rm -f $(DEFINES_FILE)
	rm -rf $(WORK)
	rm -f *.wlf transcript
	@echo "=== Aufräumen abgeschlossen ==="

# Show current configuration
show-config:
	@echo "=== Aktuelle Konfiguration ==="
	@cat $(CONFIG_FILE) | grep -v '^#' | grep -v '^$$'

# Help
help:
	@echo "Verfügbare Targets:"
	@echo "  all         - Config konvertieren und kompilieren"
	@echo "  config      - Nur .config → .svh konvertieren"
	@echo "  compile     - Nur SystemVerilog kompilieren"
	@echo "  show-config - Aktuelle Konfiguration anzeigen"
	@echo "  clean       - Alle generierten Dateien löschen"

.PHONY: all config compile clean show-config help
