# ModelSim Wave Configuration Script
# Automatische Einrichtung aller wichtigen Signale für Waveform-Analyse

# Löschen aller vorherigen Wellen
delete wave *

# Grundsignale hinzufügen
add wave -noupdate /ai_accelerator_wave_tb/clk
add wave -noupdate /ai_accelerator_wave_tb/rst
add wave -noupdate -color Yellow /ai_accelerator_wave_tb/test_number
add wave -noupdate -color Yellow /ai_accelerator_wave_tb/test_active

# Ergebnis-Vergleich (wichtigste Signale)
add wave -noupdate -divider "RESULTS"
add wave -noupdate -radix decimal -color Green /ai_accelerator_wave_tb/result
add wave -noupdate -radix decimal -color Blue /ai_accelerator_wave_tb/expected_result

# Filter Matrix (einzelne Elemente)
add wave -noupdate -divider "FILTER MATRIX"
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f00
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f01
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f02
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f10
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f11
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f12
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f20
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f21
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/f22

# Image Matrix (einzelne Elemente)
add wave -noupdate -divider "IMAGE MATRIX"
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i00
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i01
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i02
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i10
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i11
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i12
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i20
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i21
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/i22

# Flache Arrays (alternative Anzeige)
add wave -noupdate -divider "FLAT ARRAYS"
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/filter_flat
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/image_flat

# Interne Signale des AI-Accelerators (falls verfügbar)
add wave -noupdate -divider "AI ACCELERATOR INTERNALS"
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/dut/sum
add wave -noupdate -radix decimal /ai_accelerator_wave_tb/dut/partial_products

# Waveform-Einstellungen
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

# Zeit-Bereich setzen
wave zoom full
