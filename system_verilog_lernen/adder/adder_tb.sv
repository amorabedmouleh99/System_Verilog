`timescale 1ns/1ps
//10 → 10 ns Verzögerung
//#0.5 → 0,5 ns (= 500 ps). Da Auflösung 1 ps ist, bleibt es 500 ps.
//#0.49ns → 490 ps (auf 1 ps gerundet).
//#0.4ps bei timeprecision 1ps → wird zu 0 (kleiner als Auflösung).

module adder_tb;

    // Signale für Testbench
    logic [31:0] a, b;
    logic [31:0] sum;

    // Instanz vom DUT (Device Under Test)
    adder uut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    initial begin
        // Ausgabe formatieren
        $display("Zeit | a | b | sum");
        $monitor("%0t | %0d + %0d = %0d", $time, a, b, sum);

        // Testfälle
        a = 10; b = 20; #10; //10ns=1000ps wird sum beobachtbar
        a = 100; b = 50; #10;
        a = 1234; b = 4321; #10;
        a = -5; b = 15; #10;

        // Simulation beenden
        $finish;
    end

endmodule
