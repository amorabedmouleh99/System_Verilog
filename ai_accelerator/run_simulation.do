# ModelSim Simulation Script
# Automatisches Kompilieren und Simulieren des AI-Accelerators

# Work Library erstellen
vlib work

# Config-Dateien aktualisieren
!python3 config_converter.py

# SystemVerilog Dateien kompilieren
vlog -sv ai_accelerator_pkg.sv
vlog -sv ai_accelerator.sv  
vlog -sv ai_accelerator_wave_tb.sv

# Simulation starten
vsim -gui ai_accelerator_wave_tb

# Wave-Setup laden
do wave_setup.do

# Simulation für 1000ns laufen lassen
run 1000ns

# Wave zoom auf vollständige Simulation
wave zoom full

echo "==================================="
echo "AI-Accelerator Simulation bereit!"
echo "==================================="
echo "Sie können jetzt:"
echo "1. Die Waveforms analysieren"
echo "2. 'run -all' für komplette Simulation"
echo "3. Signale hinzufügen/entfernen"
echo "==================================="
