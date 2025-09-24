// Import des AI Accelerator Packages
import ai_accelerator_pkg::*;

module accelerator_for_conv2d
(
    input logic clk,
    input logic rst,
    // 3x3 Matrix als 2D-Array
    input logic [DATA_WIDTH-1:0] filter_matrix [FILTER_SIZE-1:0][FILTER_SIZE-1:0],
    input logic [DATA_WIDTH-1:0] image_patch [FILTER_SIZE-1:0][FILTER_SIZE-1:0],
    output logic [RESULT_WIDTH:0] result
);

// Vektoren für die "flachen" Versionen
logic [DATA_WIDTH-1:0] filter_vector [TOTAL_ELEMENTS-1:0];  // 1x9
logic [DATA_WIDTH-1:0] image_vector [TOTAL_ELEMENTS-1:0];   // 1x9

// Matrix zu Vektor konvertieren
always_comb begin
    for (int i = 0; i < FILTER_SIZE; i++) begin
        for (int j = 0; j < FILTER_SIZE; j++) begin
            filter_vector[i*FILTER_SIZE + j] = filter_matrix[i][j];
            image_vector[i*FILTER_SIZE + j] = image_patch[i][j];
        end
    end
end

// Dot-Product berechnen (Element-weise Multiplikation und Summe)
logic [DATA_WIDTH*2-1:0] partial_products [TOTAL_ELEMENTS-1:0];
logic [RESULT_WIDTH:0] sum;

always_comb begin
    // Element-weise Multiplikation
    for (int k = 0; k < TOTAL_ELEMENTS; k++) begin
        partial_products[k] = filter_vector[k] * image_vector[k];
    end
    
    // Summe aller Produkte
    sum = 0;
    for (int k = 0; k < TOTAL_ELEMENTS; k++) begin
        sum = sum + partial_products[k];
    end
end

assign result = sum;

endmodule