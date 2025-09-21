`timescale 1ns/1ps
module shift_reg_exercice_tb;
    // Signale für Testbench
    localparam int N = 8;
    logic clk = 0;          // Taktsignal, startet mit 0
    logic syn_clr = 0;      // Synchrones Clear Signal
    logic rst = 0;          // Reset Signal
    logic load = 0;         // Load Signal zum Laden von Daten
    logic en = 0;           // Enable Signal für Zählfunktion
    logic up = 1;           // Richtung: 1=hoch, 0=runter
    logic [N-1:0] d = '0;   // Dateneingänge (8-Bit)
    logic [N-1:0] q;        // Datenausgänge (8-Bit)
    
    // Instanziierung des Device Under Test (DUT)
    shift_reg_exercice #(8) uut (
        .clk(clk),
        .syn_clr(syn_clr),
        .rst(rst),
        .load(load),
        .en(en),
        .up(up),
        .d(d),
        .q(q)
    );
    
    // 100 MHz Takt generieren (Periode = 10ns, halbe Periode = 5ns)
    always #5 clk = ~clk;
    
    // Optionale Konsolen-Ausgabe für bessere Übersicht
    initial begin
        $display("Zeit | rst syn_clr load en up | d      | q");
        $monitor("%4t |  %0b     %0b      %0b   %0b  %0b | 0x%0h | 0x%0h",
        $time, rst, syn_clr, load, en, up, d, q);
    end

    // Haupttest-Stimulus
    initial begin
        // ========== 1) SYNCHRONER RESET FÜR 2 TAKTE ==========
        // Ziel: Register komplett zurücksetzen und sicherstellen, dass q = 0x00
        rst = 1;                    // Reset aktivieren
        repeat (2) @(posedge clk);  // 2 Taktzyklen warten (Reset bleibt aktiv)
        rst = 0;                    // Reset deaktivieren
        @(posedge clk);             // 1 zusätzlichen Takt für Stabilisierung warten
        // Erwartetes Ergebnis: q = 0x00

        // ========== 2) LOAD OPERATION: q := 0xA5 ==========
        // Ziel: Den Wert 0xA5 (165 dezimal) in das Register laden
        d = 8'hA5;                  // Dateneingänge auf 0xA5 setzen
        load = 1;                   // Load-Signal aktivieren
        @(posedge clk);             // 1 Takt warten → Wert wird geladen
        load = 0;                   // Load-Signal deaktivieren
        // Erwartetes Ergebnis: q = 0xA5 (165)

        // ========== 3) 3× NACH OBEN ZÄHLEN ==========
        // Ziel: Von 0xA5 ausgehend 3x hochzählen
        en = 1;                     // Zählen aktivieren
        up = 1;                     // Richtung: nach oben
        repeat (3) @(posedge clk);  // 3 Taktzyklen warten
        // Erwartetes Ergebnis: q = 0xA5 → 0xA6 → 0xA7 → 0xA8 (165→166→167→168)

        // ========== 4) PAUSE (ZÄHLEN DEAKTIVIERT) ==========
        // Ziel: Zählfunktion pausieren, Wert soll konstant bleiben
        en = 0;                     // Zählen deaktivieren
        repeat (2) @(posedge clk);  // 2 Taktzyklen warten
        // Erwartetes Ergebnis: q bleibt bei 0xA8 (168)

        // ========== 5) 2× NACH UNTEN ZÄHLEN ==========
        // Ziel: Von aktuellem Wert 2x herunterzählen
        en = 1;                     // Zählen wieder aktivieren
        up = 0;                     // Richtung: nach unten
        repeat (2) @(posedge clk);  // 2 Taktzyklen warten
        en = 0;                     // Zählen wieder deaktivieren
        // Erwartetes Ergebnis: q = 0xA8 → 0xA7 → 0xA6 (168→167→166)

        // ========== 6) SYNCHRONES CLEAR ==========
        // Ziel: Register synchron löschen (q = 0x00)
        syn_clr = 1;                // Synchrones Clear aktivieren
        @(posedge clk);             // 1 Takt warten → Register wird gelöscht
        syn_clr = 0;                // Synchrones Clear deaktivieren
        // Erwartetes Ergebnis: q = 0x00

        // ========== 7) ERNEUTES LADEN UND 2× HOCHZÄHLEN ==========
        // Ziel: Neuen Wert 0x3C laden und dann 2x hochzählen
        d = 8'h3C;                  // Neue Daten: 0x3C (60 dezimal)
        load = 1;                   // Load aktivieren
        @(posedge clk);             // 1 Takt warten → Wert wird geladen
        load = 0;                   // Load deaktivieren
        // Nach Load: q = 0x3C (60)
        
        en = 1;                     // Zählen aktivieren
        up = 1;                     // Richtung: nach oben
        repeat (2) @(posedge clk);  // 2x hochzählen
        en = 0;                     // Zählen deaktivieren
        // Erwartetes Endergebnis: q = 0x3C → 0x3D → 0x3E (60→61→62)

        // ========== SIMULATION BEENDEN ==========
        #10 $finish;                // 10ns warten und Simulation beenden
    end
endmodule