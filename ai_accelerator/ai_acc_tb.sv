// Einfache Testbench für AI-Accelerator - Waveform-optimiert
`timescale 1ns/1ps

module ai_acc_tb;

// Import des AI Accelerator Packages
import ai_accelerator_pkg::*;

// Testbench Signale
logic clk;
logic rst;
logic [DATA_WIDTH-1:0] filter_matrix [FILTER_SIZE-1:0][FILTER_SIZE-1:0];
logic [DATA_WIDTH-1:0] image_patch [FILTER_SIZE-1:0][FILTER_SIZE-1:0];
logic [RESULT_WIDTH:0] result;

// Test control signals für Waveform
logic [2:0] test_number;
logic test_active;

// Zusätzliche Signale für bessere Waveform-Sichtbarkeit
logic [DATA_WIDTH-1:0] filter_flat [0:8]; // Flacher Filter für einfache Wave-Anzeige
logic [DATA_WIDTH-1:0] image_flat [0:8];  // Flaches Image für einfache Wave-Anzeige
logic [RESULT_WIDTH:0] expected_result; // Erwartetes Ergebnis

// Test-spezifische Signale
logic [DATA_WIDTH-1:0] f00, f01, f02, f10, f11, f12, f20, f21, f22; // Filter Matrix einzeln
logic [DATA_WIDTH-1:0] i00, i01, i02, i10, i11, i12, i20, i21, i22; // Image Matrix einzeln

// Device Under Test (DUT)
accelerator_for_conv2d dut (
    .clk(clk),
    .rst(rst),
    .filter_matrix(filter_matrix),
    .image_patch(image_patch),
    .result(result)
);

// Clock Generation (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Kontinuierliche Zuweisung für bessere Waveform-Sichtbarkeit
always_comb begin
    // Matrix zu flachen Arrays für Wave-Anzeige
    for (int k = 0; k < 9; k++) begin
        filter_flat[k] = filter_matrix[k/3][k%3];
        image_flat[k] = image_patch[k/3][k%3];
    end
    
    // Einzelne Matrix-Elemente für detaillierte Waveform-Analyse
    f00 = filter_matrix[0][0]; f01 = filter_matrix[0][1]; f02 = filter_matrix[0][2];
    f10 = filter_matrix[1][0]; f11 = filter_matrix[1][1]; f12 = filter_matrix[1][2];
    f20 = filter_matrix[2][0]; f21 = filter_matrix[2][1]; f22 = filter_matrix[2][2];
    
    i00 = image_patch[0][0]; i01 = image_patch[0][1]; i02 = image_patch[0][2];
    i10 = image_patch[1][0]; i11 = image_patch[1][1]; i12 = image_patch[1][2];
    i20 = image_patch[2][0]; i21 = image_patch[2][1]; i22 = image_patch[2][2];
end

// Berechnung des erwarteten Ergebnisses für Verifikation
always_comb begin
    case (test_number)
        1: expected_result = 9;        // Alle 1: 1×1×9 = 9
        2: expected_result = 18;       // Filter=1, Image=2: 1×2×9 = 18
        3: expected_result = 0;        // Alle 0: 0
        4: expected_result = 400;      // Edge Detection: manuell berechnet
        5: expected_result = 585225;   // Maximum: 255×255×9 = 585225
        default: expected_result = 0;
    endcase
end

// Einfacher Test ohne Console-Output
initial begin
    test_number = 0;
    test_active = 0;
    
    // Arrays initialisieren
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 0;
            image_patch[i][j] = 0;
        end
    end
    
    // Reset
    rst = 1;
    #20;
    rst = 0;
    #10;
    
    // Test 1: Alle 1en
    test_number = 1;
    test_active = 1;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 1;
            image_patch[i][j] = 1;
        end
    end
    #50; // Mehr Zeit für Waveform-Betrachtung
    test_active = 0;
    #20;
    
    // Test 2: Filter=1, Image=2
    test_number = 2;
    test_active = 1;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 1;
            image_patch[i][j] = 2;
        end
    end
    #50;
    test_active = 0;
    #20;
    
    // Test 3: Zero Test
    test_number = 3;
    test_active = 1;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 0;
            image_patch[i][j] = 0;
        end
    end
    #50;
    test_active = 0;
    #20;
    
    // Test 4: Edge Detection
    test_number = 4;
    test_active = 1;
    // Filter Matrix
    filter_matrix[0][0] = 1; filter_matrix[0][1] = 0; filter_matrix[0][2] = 1;
    filter_matrix[1][0] = 2; filter_matrix[1][1] = 0; filter_matrix[1][2] = 2;
    filter_matrix[2][0] = 1; filter_matrix[2][1] = 0; filter_matrix[2][2] = 1;
    
    // Image Matrix
    image_patch[0][0] = 10; image_patch[0][1] = 20; image_patch[0][2] = 30;
    image_patch[1][0] = 40; image_patch[1][1] = 50; image_patch[1][2] = 60;
    image_patch[2][0] = 70; image_patch[2][1] = 80; image_patch[2][2] = 90;
    #50;
    test_active = 0;
    #20;
    
    // Test 5: Maximum Values
    test_number = 5;
    test_active = 1;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 8'hFF; // 255
            image_patch[i][j] = 8'hFF;   // 255
        end
    end
    #50;
    test_active = 0;
    #20;
    
    test_number = 0;
    #100;
    
    $stop;
end

endmodule
