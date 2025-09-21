module shift_reg_exercice
                    #(parameter N=8)
                    (
                        input logic clk, syn_clr, rst,
                        input logic load,
                        input logic en,
                        input logic up,
                        output logic [N-1] d,
                        output logic [N-1] q 
                    );


always_ff @(posedge clk) begin
    if (rst)
        q <='0;
    else 
        if (syn_clr)
            q <= '0;
        else
            if (load)
                q<=d; 
            else
                if (en)
                    if (up)
                        q<=q+1;
                    else
                        q<=q-1;
                else
                    q<=q;

end
endmodule
                    
