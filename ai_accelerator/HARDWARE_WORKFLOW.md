# Hardware Synthesis Workflow
# ================================

# Schritt 1: Development (auf PC)
make config     # .config → .svh (mit Python)
make compile    # Check SystemVerilog Syntax

# Schritt 2: Synthesis (für Hardware) 
# Nur diese Dateien werden verwendet:
# - ai_accelerator.sv
# - ai_accelerator_pkg.sv  
# - ai_config_defines.svh
#
# Python Script wird NICHT synthetisiert!

# Schritt 3: Hardware Deployment
# Nur die synthetisierten Gatter laufen auf FPGA/ASIC
