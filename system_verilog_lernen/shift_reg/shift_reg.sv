module shift_reg
  #(parameter int N = 8)
(
  input  logic        clk, rst, s_in,
  input  logic [1:0]  ctrl,
  input  logic [N-1:0] d,
  output logic [N-1:0] q,
  output logic        s_out
);

  // FIX 1: Range
  logic [N-1:0] r_reg, r_next;// links am FF ist der D-Eingang. Dorthin geht das, was im nächsten Takt gespeichert werden soll->r_next
                              // rechts am FF ist der Q-Ausgang. DAs ist der aktuell gespeicherte WErt->r_reg[i]


  // state register (asynchroner Reset)
  always_ff @(posedge clk, posedge rst) begin
    if (rst)
      r_reg <= '0;
    else
      // FIX 2: t_next -> r_next
      r_reg <= r_next;
  end

  // next-state logic
  always_comb begin                     // FIX 3: begin...end
    unique case (ctrl)
      2'b00: r_next = r_reg;                          // hold
      2'b01: r_next = {s_in, r_reg[N-1:1]};           // shift right, s_in rein
                                                      // r_next= 10000 s_in = 1-> warte auf eine Flanke r_reg=1000
                                                      // während nächster  Periode kamm s_in=0->r_next=01000 warte auf eine Flanke r_reg=01000
                                                      // ............




      2'b10: r_next = d;                              // parallel load
      default: r_next = r_reg;                        // defensiv
    endcase
  end

  // output logic
  assign q     = r_reg;
  assign s_out = r_reg[0];
endmodule
