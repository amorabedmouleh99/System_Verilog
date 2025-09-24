#!/usr/bin/env python3
"""
Config-zu-SystemVerilog Defines Converter
Liest .config Datei und generiert .svh Defines-Datei
"""

import re
import sys

def parse_config(config_file):
    """Parse .config Datei und extrahiere Parameter"""
    parameters = {}
    
    try:
        with open(config_file, 'r') as f:
            for line_num, line in enumerate(f, 1):
                # Remove comments and whitespace
                line = line.split('#')[0].strip()
                
                if not line:  # Skip empty lines
                    continue
                    
                # Parse parameter lines (NAME = VALUE)
                match = re.match(r'(\w+)\s*=\s*(\w+)', line)
                if match:
                    param_name = match.group(1)
                    param_value = match.group(2)
                    parameters[param_name] = param_value
                    print(f"Parsed: {param_name} = {param_value}")
                else:
                    print(f"Warning: Unbekannte Zeile {line_num}: {line}")
                    
    except FileNotFoundError:
        print(f"Error: {config_file} nicht gefunden!")
        sys.exit(1)
        
    return parameters

def generate_defines_file(parameters, output_file):
    """Generiere SystemVerilog .svh Defines Datei"""
    
    with open(output_file, 'w') as f:
        f.write("// Automatisch generierte Defines aus .config Datei\n")
        f.write("// NICHT MANUELL BEARBEITEN!\n")
        f.write(f"// Generiert am: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # Write defines
        for param_name, param_value in parameters.items():
            f.write(f"`define {param_name} {param_value}\n")
        
        f.write("\n// Parameter als SystemVerilog Parameter\n")
        for param_name, param_value in parameters.items():
            f.write(f"parameter int {param_name} = `{param_name};\n")

def main():
    config_file = "ai_accelerator.config"
    output_file = "ai_config_defines.svh"
    
    print("=== Config-zu-Defines Converter ===")
    print(f"Lese: {config_file}")
    print(f"Schreibe: {output_file}")
    
    # Parse config file
    parameters = parse_config(config_file)
    
    if not parameters:
        print("Keine Parameter gefunden!")
        sys.exit(1)
    
    # Generate defines file
    generate_defines_file(parameters, output_file)
    
    print(f"\n✓ {output_file} erfolgreich generiert!")
    print(f"  {len(parameters)} Parameter konvertiert")

if __name__ == "__main__":
    main()
