package state_pkg;
    typedef enum logic [1:0] { S1, S2, S3 } state_t;
endpackage

module edge_detect_moore
import state_pkg::*;
(
    input logic clk, rst ,
    input logic in , 
    output logic out,
    output state_t dbg_state   // Jetzt funktioniert es
);

state_t state_reg, state_next;

always_ff @(posedge clk, posedge rst) begin
    if (rst)
        state_reg <= S1;    // Großbuchstaben verwenden
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

// Debug-Ausgang
assign dbg_state = state_reg;

endmodule