// AI Accelerator Package
// Liest Parameter automatisch aus defines (generiert aus .config)

package ai_accelerator_pkg;

    // Parameter werden aus ai_config_defines.svh gelesen
    `include "ai_config_defines.svh"
    
    // Berechnete Parameter (basierend auf .config Werten)
    parameter int RESULT_WIDTH = DATA_WIDTH*2 + FILTER_SIZE; // Für Conv2D Ergebnis
    parameter int TOTAL_ELEMENTS = FILTER_SIZE * FILTER_SIZE; // 9 Elemente

endpackage
