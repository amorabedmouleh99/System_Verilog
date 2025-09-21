`timescale 1ns/1ps

module mux_tb;

  // DUT-Signale
  logic a, b, sel;
  logic f;

  // DUT
  mux dut (.a(a), .b(b), .sel(sel), .f(f));

  initial begin
    // Ausgabe formatieren (optional – nur Konsole)
    $display("Zeit | sel | a | b | f");
    $monitor("%0t |  %0b  | %0b | %0b | %0b", $time, sel, a, b, f);

    // -------- Testfälle (jeweils #10 ns warten) --------
    sel=0; a=0; b=0; #10;  // f = a
    sel=0; a=1; b=0; #10;  // f = a
    sel=0; a=0; b=1; #10;  // f = a
    sel=0; a=1; b=1; #10;  // f = a

    sel=1; a=0; b=0; #10;  // f = b
    sel=1; a=1; b=0; #10;  // f = b
    sel=1; a=0; b=1; #10;  // f = b
    sel=1; a=1; b=1; #10;  // f = b

    $finish;
  end

endmodule
