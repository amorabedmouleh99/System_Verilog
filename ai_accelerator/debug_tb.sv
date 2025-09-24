// Debug Testbench - sehr einfach
`timescale 1ns/1ps

module debug_tb;

// Import des AI Accelerator Packages
import ai_accelerator_pkg::*;

// Testbench Signale
logic clk;
logic rst;
logic [DATA_WIDTH-1:0] filter_matrix [FILTER_SIZE-1:0][FILTER_SIZE-1:0];
logic [DATA_WIDTH-1:0] image_patch [FILTER_SIZE-1:0][FILTER_SIZE-1:0];
logic [RESULT_WIDTH-1:0] result;

// Debug Signale
logic [7:0] debug_counter;
logic [DATA_WIDTH-1:0] test_filter_00, test_image_00;

// Device Under Test (DUT)
accelerator_for_conv2d dut (
    .clk(clk),
    .rst(rst),
    .filter_matrix(filter_matrix),
    .image_patch(image_patch),
    .result(result)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Debug Zuweisungen
always_comb begin
    test_filter_00 = filter_matrix[0][0];
    test_image_00 = image_patch[0][0];
end

// Sehr einfacher Test
initial begin
    debug_counter = 0;
    
    // Initialisierung - ALLE auf 0
    rst = 1;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 8'h00;
            image_patch[i][j] = 8'h00;
        end
    end
    #20;
    
    // Reset freigeben
    rst = 0;
    debug_counter = 1;
    #10;
    
    // Test 1: NUR [0][0] = 1, Rest = 0
    debug_counter = 2;
    filter_matrix[0][0] = 8'h01;  // Nur ein Element
    image_patch[0][0] = 8'h01;    // Nur ein Element
    #50;
    
    // Test 2: Alle auf 1
    debug_counter = 3;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 8'h01;
            image_patch[i][j] = 8'h01;
        end
    end
    #50;
    
    // Test 3: Filter=2, Image=3
    debug_counter = 4;
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_matrix[i][j] = 8'h02;
            image_patch[i][j] = 8'h03;
        end
    end
    #50;
    
    debug_counter = 5;
    #100;
    $stop;
end

// Erwartete Ergebnisse berechnen
logic [RESULT_WIDTH-1:0] expected;
always_comb begin
    case (debug_counter)
        1: expected = 0;        // Reset
        2: expected = 1;        // 1×1 = 1
        3: expected = 9;        // 1×1×9 = 9
        4: expected = 54;       // 2×3×9 = 54
        default: expected = 0;
    endcase
end

endmodule
