module shift_reg_exercice
                    #(parameter int N = 8)
                    (
                        input logic unsigned clk, syn_clr, rst,
                        input logic unsigned load,
                        input logic unsigned en,
                        input logic unsigned up,
                        input logic unsigned [N-1:0] d,
                        output logic unsigned [N-1:0] q 
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
                    
