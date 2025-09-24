`timescale 1ns/1ps

// Import des gleichen Packages wie im DUT
import state_pkg::*;

module tb_moore;
  // Takt & Reset
  logic clk = 0;
  logic rst = 1;

  // Stimulus/DUT-IOs
  logic in  = 0;
  logic out;
  // Debug - verwendet jetzt den state_t aus dem Package
  state_t dbg_state;

  // DUT
  edge_detect_moore dut (
    .clk (clk),
    .rst (rst),
    .in  (in),
    .out (out),
    .dbg_state(dbg_state)   // Jetzt kompatibel
  );

  // 100-MHz-Takt (10 ns Periode)
  always #5 clk = ~clk;

  // Optional: Konsolen-Log mit Zustandsnamen
  initial begin
    $display(" time | rst in | out | state");
    forever begin
      @(posedge clk); #1;
      $display("%4t |  %0b   %0b |  %0b  | %s",
               $time, rst, in, out, dbg_state.name());
    end
  end

  // Stimulus
  initial begin
    // Reset 2 Takte aktiv lassen
    repeat (2) @(posedge clk);
    rst = 0;

    // Folge mit mehreren 0->1-Flanken
    // Flanke #1
    @(posedge clk); in = 1;
    @(posedge clk); in = 1;
    @(posedge clk); in = 0;

    // Flanke #2
    @(posedge clk); in = 0;
    @(posedge clk); in = 1;
    @(posedge clk); in = 1;
    @(posedge clk); in = 0;

    // Muster 0 1 1 0 1 0
    @(posedge clk); in = 0;
    @(posedge clk); in = 1;
    @(posedge clk); in = 1;
    @(posedge clk); in = 0;
    @(posedge clk); in = 1;
    @(posedge clk); in = 0;

    repeat (3) @(posedge clk);
    $finish;
  end
endmodule