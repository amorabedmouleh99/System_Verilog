`timescale 1ns/1ps

module tb_mealy;
    // Testbench-Signale
    logic clk = 0;
    logic rst = 1;
    logic in = 0;
    logic out;
    
    // String für lesbare Zustandsanzeige
    string state_name;
    
    // DUT instanziieren
    edge_detect_mealy dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );
    
    // Zustand aus dem DUT auslesen (für Debug)
    logic current_state;
    assign current_state = dut.state_reg;
    
    // Zustand zu String konvertieren
    always_comb begin
        case (current_state)
            1'b0: state_name = "S1";
            1'b1: state_name = "S2"; 
            default: state_name = "XX";
        endcase
    end
    
    // 100-MHz-Takt (10 ns Periode)
    always #5 clk = ~clk;
    
    // Monitor für Konsolen-Ausgabe
    initial begin
        $display("Zeit | rst in | out | state");
        $monitor("%4t |  %0b   %0b |  %0b  | %s",
                 $time, rst, in, out, state_name);
    end
    
    // Stimulus
    initial begin
        // Reset für 2 Takte
        repeat (2) @(posedge clk);
        rst = 0;
        
        // Test-Sequenz: Mehrere 0→1 Flanken
        @(posedge clk); in = 0;  // Zustand: S1
        @(posedge clk); in = 1;  // Flanke! → S2, out=1
        @(posedge clk); in = 1;  // Bleiben in S2, out=0
        @(posedge clk); in = 0;  // Zurück zu S1, out=0
        
        @(posedge clk); in = 1;  // Flanke! → S2, out=1
        @(posedge clk); in = 1;  // Bleiben in S2, out=0
        @(posedge clk); in = 1;  // Bleiben in S2, out=0
        @(posedge clk); in = 0;  // Zurück zu S1, out=0
        
        // Kurze Pulse
        @(posedge clk); in = 0;  // S1
        @(posedge clk); in = 1;  // Flanke! → S2, out=1
        @(posedge clk); in = 0;  // Zurück zu S1, out=0
        @(posedge clk); in = 1;  // Flanke! → S2, out=1
        @(posedge clk); in = 0;  // Zurück zu S1, out=0
        
        repeat (3) @(posedge clk);
        $finish;
    end
    
endmodule 