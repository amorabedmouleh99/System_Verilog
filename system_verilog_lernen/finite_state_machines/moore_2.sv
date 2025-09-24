package state_pkg;
    typedef enum logic [1:0] { S1, S2, S3 } state_t;
    //S1 = 2'b00  // 0
    // S2 = 2'b01 // 1
    // S3 = 2'b10 // 2
    //package math_pkg;
    //parameter PI = 3.14159;
    //typedef logic [31:0] word_t;
    //function automatic int add(int a, int b);
    //  return a + b;
    //endfunction
    //endpackage

endpackage

module edge_detect_moore
import state_pkg::*; //// ← Importiert ALLES aus dem Package
(
    input logic clk, rst ,
    input logic in , 
    output logic out,
    output logic [1:0] dbg_state   // Geändert zu logic [1:0]
);

state_t state_reg, state_next;

always_ff @(posedge clk, posedge rst) begin
    if (rst)
        state_reg <= S1;
    else
        state_reg <= state_next;
end 

always_comb begin
    out = 1'b0;
    state_next = state_reg;
    unique case (state_reg)
        S1: 
            if (in) state_next = S2;
        S2: begin
            out = 1'b1;
            if (in) begin
                state_next = S3;
            end else
                state_next = S1;
        end        
        S3:
            if (~in)
                state_next = S1;
    endcase           
end

// Debug-Ausgang als logic [1:0]
assign dbg_state = state_reg;

endmodule