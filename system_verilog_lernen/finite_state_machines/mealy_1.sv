module edge_detect_mealy(
    input logic clk,
    input logic rst,
    input logic in,
    output logic out
);

typedef enum logic {s1, s2} state_t;
state_t state_reg, state_next;

// Sequential Logic - Zustandsregister
always_ff @(posedge clk, posedge rst) begin
    if (rst)
        state_reg <= s1;
    else
        state_reg <= state_next;
end

// Combinational Logic - Zustandsübergänge UND Ausgabe (Mealy!)
always_comb begin
    // Default-Werte
    state_next = state_reg;
    out = 1'b0;
    
    unique case (state_reg)
        s1: begin
            if (in) begin
                state_next = s2;
                out = 1'b1;
            end else begin              // ← FEHLER BEHOBEN: 'end' hinzugefügt
                state_next = s1;
                out = 1'b0;         
            end
        end                             // ← FEHLER BEHOBEN: 'end' hinzugefügt
        
        s2: begin                       // ← FEHLER BEHOBEN: 'begin' hinzugefügt
            if (~in) begin
                state_next = s1;
                out = 1'b0; 
            end else begin              // ← FEHLER BEHOBEN: 'end else begin' hinzugefügt
                state_next = s2;
                out = 1'b0;    
            end
        end                             // ← FEHLER BEHOBEN: 'end' hinzugefügt
    endcase
end
endmodule 
