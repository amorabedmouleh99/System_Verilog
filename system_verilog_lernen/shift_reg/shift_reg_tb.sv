`timescale 1ns/1ps

module shift_reg_tb;
  localparam int N = 8;

  // TB-Signale
  logic             clk = 0;
  logic             rst = 1;     // Start im Reset (asynchron, aktiv High)
  logic             s_in;
  logic [1:0]       ctrl;
  logic [N-1:0]     d;
  logic [N-1:0]     q;
  logic             s_out;

  // DUT
  shift_reg #(.N(N)) dut (
    .clk, .rst, .s_in, .ctrl, .d,
    .q, .s_out
  );

  // 100 MHz Takt
  always #5 clk = ~clk;

  // Referenzmodell im TB
  logic [N-1:0] ref_q;

  // Hilfstask: Eingaben setzen -> Taktflanke -> Erwartung berechnen & prüfen
  task automatic apply_and_tick(input logic [1:0] t_ctrl,
                                input logic       t_sin,
                                input logic [N-1:0] t_d);
    begin
      ctrl = t_ctrl; s_in = t_sin; d = t_d;
      @(posedge clk);

      // Referenz-Next-State (entspricht der DUT-Logik)
      unique case (t_ctrl)
        2'b00: ref_q = ref_q;
        2'b01: ref_q = {t_sin, ref_q[N-1:1]};
        2'b10: ref_q = t_d;
        default: ref_q = ref_q;
      endcase

      // kurze Propagation
      #1;

      // Checks
      assert (q == ref_q)
        else $fatal(1, "[%0t] Q mismatch exp=%0h got=%0h", $time, ref_q, q);

      assert (s_out == ref_q[0])
        else $fatal(1, "[%0t] s_out mismatch exp=%0b got=%0b", $time, ref_q[0], s_out);
    end
  endtask

  // Stimulus
  initial begin
    // Init
    ctrl = 2'b00; s_in = 0; d = '0; ref_q = '0;

    // Reset für 2 Flanken halten und freigeben
    repeat (2) @(posedge clk);
    rst = 0;
    @(posedge clk);

    // 1) Hold
    apply_and_tick(2'b00, 0, '0);

    // 2) Parallel laden
    apply_and_tick(2'b10, 0, 8'hA5);

    // 3) Viermal shiften mit verschiedenen s_in
    apply_and_tick(2'b01, 1, '0);
    apply_and_tick(2'b01, 0, '0);
    apply_and_tick(2'b01, 1, '0);
    apply_and_tick(2'b01, 1, '0);

    // 4) Noch einmal load, danach 2× halten
    apply_and_tick(2'b10, 0, 8'h3C);
    apply_and_tick(2'b00, 0, '0);
    apply_and_tick(2'b00, 0, '0);

    $display("[%0t] TB finished OK", $time);
    $finish;
  end
endmodule
