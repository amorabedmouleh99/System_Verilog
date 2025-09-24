`timescale 1ns/1ps

module tb_moore;
  // Takt & Reset
  logic clk = 0;
  logic rst = 1;

  // Stimulus/DUT-IOs
  logic in  = 0;
  logic out;
  // Debug - einfach als logic [1:0]
  logic [1:0] dbg_state;
  
  // String für lesbare Zustandsanzeige
  string state_name;

  // DUT
  edge_detect_moore dut (
    .clk (clk),
    .rst (rst),
    .in  (in),
    .out (out),
    .dbg_state(dbg_state)
  );

  // Zustand zu String konvertieren
  always_comb begin
    case (dbg_state)
      2'b00: state_name = "S1";
      2'b01: state_name = "S2"; 
      2'b10: state_name = "S3";
      default: state_name = "XX";
    endcase
  end

  // 100-MHz-Takt (10 ns Periode)
  always #5 clk = ~clk;

  // Einfacher Monitor
  initial begin
    $display(" time | rst in | out | state");
    $monitor("%4t |  %0b   %0b |  %0b  | %s",
             $time, rst, in, out, state_name);
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