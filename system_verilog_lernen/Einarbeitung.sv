module mux 
    (
        input logic a,b,sel,
        output logic f

    );
logic n_sel , f1 , f2 ;

and g1 ( f1 , a , n_sel ) ;//„Instanziiere ein UND-Gatter (Name g1). Sein Ausgang ist f1.Die Eingänge sind a und n_sel Funktional: f1 = a & n_sel; (bitweises UND).“
and g2 ( f2 , b , sel ) ;
or g3 (f , f1 , f2 ) ;
not g4 ( n_sel , sel ) ;

endmodule
//-----------------------------------------Logic, Variable, Wire----------------------------------------------------------------------------------
//logic data type is 4 state, 0, 1, X don't care or uninitialized, Z high impedance or flaoting value (nothing driving the wire should be avoided).
//---> x and z are only relevant for Simulation 
//tri-satet : ausgänge (0,1,Z) y=a wenn c gleich(0oder 1?) sonst y ist Z
//ein Treiber ist alles, was einen Draht/BUS/pin auf 0 oder 1 oder Z setzt-> wie der aAusgang eines Gatters/FLIP-Flops.
//the wire can be driven by multiple signals at once->useful for Moedeling tr-state gates or buses.
//inputs are inferred to wire logic and the outputs to VAriable logic
//-----------------------------------------MOdule instantiation--------------------------------------------------------------------------------
//module_name instance_name(arg1, arg2, ......)
//pass-by-position(nicht empfohlen)-->Partnames:(a,b,self, f)-> mux u_mux(X,Y,Z,Z,W)<-Signals
//pass-by-name(empfohlen), jeden Port beim namen und welches signal dort hin soll -> mux u_mux(.a(X), .b(Y), .sel(Z), .f(W))<- reihenfolge Egal;
//pass-by-name if portname=signalname logic a, b, sel, f;

                                                            mux u_mux (
                                                            .a,     // .a(a)
                                                            .b,     // .b(b)
                                                            .sel,   // .sel(sel)
                                                            .f      // .f(f)
                                                            );
                                                            
//---->use always pass-by-name
//------------------------------------------Vectors----------------------------------------------------------------
module two_bit_mux
(
input logic [1:0] a , b ,
input logic sel ,
output logic [1:0] f
);
mux mux_1 (. f ( f [0]) , . a ( a [0]) , . b ( b [0]) , . sel ) ;
mux mux_2 (. f ( f [1]) , . a ( a [1]) , . b ( b [1]) , . sel ) ;
endmodule
//logic [N-1:0]will create one of length N
//We can access the ith element by indexing into the vector at i with the [i] syntax, and we can access bit slices with [i:j] (inclusive).
//--------------------------------------------Literals--------------------------------------------------------------
Jede Zahl (Literal) hat drei Eigenschaften:

Basis  in welchem Zahlensystem steht sie?

d = dezimal, h = hex, b = binär, o = oktal

Beispiel: 8'hA5, 4'b1010, 12'd25

Breite  wie viele Bits hat sie?

Die Bitzahl steht vor dem Apostroph: 8'hFF → 8 Bit

Ohne Angabe gilt: 32 Bit (bei 5, 123 …)

Vorzeichen signed oder unsigned?

Bei Zahlen mit Basis ist der Standard unsigned
→ 8'hFF ist 255

Mit s nach dem Apostroph wird’s signed
→ 8'shFF ist 1 (8-Bit Zweierkomplement)

Zahlen ohne Basis (z. B. 5) sind 32-Bit signed
Important:
//Syntax-Muster //<Breite>'<s optional><Basis><Ziffern>
//signed : Die Zahl kann negativ oder positiv sein (Zweierkomplement).
//---------------------------------------------Parameters-------------------------------------------
Parameter 
//Kann beim Instanziieren überschrieben werden → jede Instanz kann andere feste Werte haben
module n_bit_adder #(
  parameter int N = 32        // Default-Breite
)(
  input  logic [N-1:0] a, b,
  output logic [N-1:0] sum
);
  assign sum = a + b;
endmodule
// 8-Bit-Adder
n_bit_adder #(.N(8))  u_add8  (.a(a8),  .b(b8),  .sum(s8));
// 64-Bit-Adde
n_bit_adder #(.N(64)) u_add64 (.a(a64), .b(b64), .sum(s64)); //instanziere(pass by name) n_bit_adder mit N=64(name hier ist u_add64 )

localparam
//Ebenfalls Compile-Time-Konstante, kann aber nicht von außen überschrieben werden.
module n_bit_alu #(
  parameter int N = 32
)(
  input  logic [N-1:0] x, y,
  input  logic [2:0]   opcode,
  output logic [N-1:0] s,
  output logic         cout
);
  // interne, feste Codes
  localparam logic [2:0] OP_ADD = 3'b001,
                         OP_SUB = 3'b010,
                         OP_CMPR= 3'b100;

  always_comb begin
    unique case (opcode)
      OP_ADD:  {cout, s} = x + y;
      OP_SUB:  {cout, s} = x - y;
      OP_CMPR: {cout, s} = { {(N-1){1'b0}}, (x>y) };
      default: {cout, s} = '0;
    endcase
  end
endmodule
//nicht änderbar, für interne Konstanten (Zustände, Opcodes).

//----------------------------------------Continuous Assignments-----------------------------------------
//A continuous assignment binds an expression to a signal. For example, instead
//of instantiating the primitive module for an AND gate, we could use a continuous assignment.

logic a , b , c , d , e ;
assign c = a & b
assign e = c | d
//----------------------------------------conditional operator----------------------------------------------

module mux
(
input logic a , b , sel ,
output logic f
);
assign f = sel ? b : a ; //Wenn sel 1 ist, dann f = b, sonst f = a. //assign st eine kontinuierliche Zuweisung und wird bei jeder Änderung von a, b oder sel sofort neu ausgewertet (kein Takt, keine Flops). 
endmodule
//------------------------------------------bittwise operators-----------------------------------------------
a & b abitwise and
a | b bitwise or
a ^ b bitwise xor
~ bitwise not
Notice how we can now model NAND and NOR as ~(a & b) and ~(a | b).
//--------------------------------------------logical operators-------------------------------------------
OperatorFunction
a && b alogical and
a || b logical or
! logical not
//---------------------------------------------reduction operators----------------------------------------
Reduction operators take a single multi-bit vector and output a single bit value. For example &a will
take all the bits in the vector a and pass them into a single AND gate. Thus &a will only be one if a is all ones.
SystemVerilog supports the following reduction operators.

Operator      Function
&a reduction   and
|a reduction   or
^a reduction   xor
~^a reduction   xnor
~|a reduction   nor
~&a reduction   nand
//-------------------------------------------------Arithmetic Operators----------------------------------------
Operator   Function
a + b      add
a - b      subtract  
-a         unary minus
a * b      multiply
a / b      divide
a % b      modulus
a**b       power
//------------------------------------------------COmparison operators---------------------------------------------
OperatorFunction
a == b
a != b
a < b
a <= b
a > b
a >= b
a === b a equals b including X and Z values
a !== b a not equals b including X and Z values


a ==? b equal with X and Z as “don’t cares”
a !=? b not equal with X and Z as “don’t cares”
//-----------------------------------------------Concatenate and replicate operators------------------------------------
//nkatenation – {a, b, c}

Verbindet Vektoren/Bitfelder hintereinander (links = MSB, rechts = LSB).

Die Breite ist die Summe der Breiten der Operanden.

logic [3:0] a = 4'b1010;
logic [3:0] b = 4'b0111;

logic [7:0] x = {a, b};        // x = 8'b1010_0111
logic [5:0] y = {2'b11, a};    // y = 6'b11_1010
logic [7:0] z = {a[1:0], b[2:0], 3'b000}; // z = 2+3+3 = 8 Bit

//plikation – {n{…}}

Wiederholt den (konkatenierten) Inhalt n-mal.

Die Breite ist n x(Breite des Inhalts).

In vielen Flows muss n ein Literal/konstante Zahl sein (kein Laufzeitwert).
logic [1:0] p = 2'b10;
logic [5:0] r = {3{p}};        // r = {p,p,p} = 6'b10_10_10

logic       bit1 = 1'b1;
logic [7:0] fill = {8{bit1}};  // = 8'b1111_1111

// Replikation kann auch mehrere Felder enthalten:
logic [3:0] a = 4'hA;          // 1010
logic [11:0] t = {3{a, 2'b01}}; // = {a,01, a,01, a,01}
                                //   6×2 Bit = 12 Bit
                                logic [1:0] p = 2'b10;
logic [5:0] r = {3{p}};        // r = {p,p,p} = 6'b10_10_10

logic       bit1 = 1'b1;
logic [7:0] fill = {8{bit1}};  // = 8'b1111_1111

// Replikation kann auch mehrere Felder enthalten:
logic [3:0] a = 4'hA;          // 1010
logic [11:0] t = {3{a, 2'b01}}; // = {a,01, a,01, a,01
//--------------------------------------------Generate-----------------------------------
i some cases it might be useful to instantiate a configurable number of modules where the number
is defined by a parameter. The generate statement is useful for creating this replicated structure.
It has the following general syntax. The generate statement can be used to replicate both module
instantiation and continuous assignments.

generate
genvar [ index_variables ];
    for (...; ...; ...) begin [: optional label ]
        ... c o n c u r r e n t _ c o n s t r u c t s ...;
    end
endgenerate

module eq_n #(parameter int N = 4)
(
  input  logic [N-1:0] a, b,
  output logic         eq
);
  logic [N-1:0] tmp;

  generate
    genvar i;
    for (i = 0; i < N; i++) begin : GEN_EQ
      // XNOR: 1 wenn a[i] == b[i]
      xnor u_xnor (tmp[i], a[i], b[i]);
    end
  endgenerate

  // Alle Bits müssen gleich sein → AND über tmp
  assign eq = &tmp;
endmodule
//---------------------------------------------Always block for combinational design------------------
always_comb begin
[ optional local variable declaration ]
... procedural statement ...
end
It can be thought of as continuously looping and executing the internal statements whenever any of
the input signals change
• Blocking assignment
• Non-blocking assignment (discussed in the sequential section)
• If statement
• Case statement

always_comb begin
  if (add)
    z = x + y;
  else
    z = x - y;
end

always_comb begin
  z = x - y;          // Default
  if (add)
    z = x + y;
end

always_comb begin
  z = x - y;          // Default
  if (add)
    z = x + y;
end
assign z = add ? (x + y) : (x - y);

//---------------------------------------------Blocking assignment-------------------------------------------
Syntax: x = expr;

Wirkt sofort: Die Zuweisung wird unmittelbar ausgeführt; alle folgenden Zeilen sehen den neuen Wert von x.

Das ist wie in C/Python -de Statements laufen sequenziell ab.
always_comb begin
  logic tmp;         // lokale, automatische Variable
  tmp = in << 1;     // tmp = in * 2
  tmp = tmp << 1;    // tmp = in * 4
  tmp = tmp << 2;    // tmp = in * 16  => insgesamt <<4
  out = tmp;
end

always_comb begin
  y = a & b;
  z = y ^ c;            // benutzt das NEUE y
end

assign z = (a & b) ^ c;
//--------------------------------------------case-----------------------------------------------
//unique case

Bedeutet: Fälle sind vollständig und gegenseitig exklusiv.
Simulation prüft das zur Laufzeit (Warnung/Fehler bei Lücken oder Überlappung).
Synthese darf eine parallele Struktur (z. B. Multiplexer) erzeugen statt eines Prioritätsnetzwerks.

Wenn genau ein Zweig zutreffen muss und dürfen. Typisch: Mux, sauber kodierte FSM-Zustandsdecodes, ALU-Opcode-Decodes.
Wenn du dir über Vollständigkeit nicht sicher bist, nimm ein normales case mit default:
always_comb
  case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    default: y = '0;   // schützt vor Latches
  endcase

//case … inside (Wildcards & Mengenabgleich)

Erlaubt Muster mit ? (don’t-care an einzelnen Bitpositionen).

Semantik: „Selector liegt in dieser Menge von Mustern“.

Moderner Ersatz für altes casez/casex (die mit X/Z oft gefährlich sind).


logic [3:0] op;   // 4-bit Opcode
logic act_a, act_b, act_c, act_d;

always_comb
  case (op) inside
    4'b1???:  act_a = 1;          // MSB = 1  -> A
    4'b01??:  act_b = 1;          // 01xx     -> B
    4'b001?:  act_c = 1;          // 001x     -> C
    4'b0001:  act_d = 1;          // genau 0001
    default:  {act_a,act_b,act_c,act_d} = '0;
  endcase   

  Hier brauchst du Default, sonst würden (bei manchen Pfaden) Signale undefiniert bleiben → Latchgefahr
//------------------------------------the module can be synthesized------------------------------------
„The module can be synthesized“ heißt:
Der geschriebene SystemVerilog-Code lässt sich von einem Synthese-Tool (für FPGA oder ASIC) in reale Hardware übersetzen – also in Gatter/LUTs, Flipflops, Multiplexer, usw. Das Ergebnis ist eine Netlist (für ASIC: Standardzellen; für FPGA: LUTs/FFs), die anschließend beim Place-&-Route physisch platziert und verdrahtet wird (FPGA: daraus wird der Bitstream).

Was genau ist „Synthesis“?

Eingabe: RTL-Code (z. B. assign, always_comb, always_ff).

Ausgabe: Gatter-Netlist + Berichte (Flächenbedarf, Taktfrequenz/Timing).

Ziel: Die Logik so implementieren, dass Timing-Vorgaben (Clock, Constraints) eingehalten und Ressourcen minimal bleiben.

„Synthesizable“ vs. „nur Simulation“

Synthesizable = vom Tool in Hardware umsetzbar.
Nicht synthesizable = nur im Simulator verwendbar.

//----------------------------------------Modeling Sequential Circuits----------------------------------

  
always @ (... sensitivity list ...) begin [: optional name ]
[ optional local variable declaration ];
... procedural statement ...;
end

always @ (a , b ) begin
sum = a + b ;
end

The sensitivity list is a list of signals to which the always block responds. When any of these signals
change value, the always block executes. For example, in the following code block, the value of sum is
updated whenever a or b changes.


//------------------------------------non-blocking assignment-----------------------------------------------
The syntax of the non-blocking assignment is
[ variable_name ] <= [ expression ]; // non - blocking assignment
use non-blocking assignment for sequential circuit design.
//--------------------------------------The D FF and register-------------------------------------------

module d_ff (
  input  logic clk,
  input  logic d,
  output logic q
);
  // D-Flip-Flop: übernimmt d an der steigenden Flanke von clk
  always_ff @(posedge clk)
    q <= d;              // **nicht-blockierende** Zuweisung
endmodule

Warum nicht-blockierend (<=) und nicht blockierend (=)?

In sequentieller Logik (Flip-Flops) wollen wir den neuen Zustand gleichzeitig aus dem alten Zustand bilden (alles „at once“ an der Taktflanke).

Das passiert in der Simulator-„NBA (non-blocking assignment)-Phase“:
Alle rechten Seiten werden an der Flanke ausgewertet, die linken Seiten gemeinsam am Ende des Zeitschritts aktualisiert.

//wrong
always_ff @(posedge clk) a = b;
always_ff @(posedge clk) b = a;
//right
 always_ff @(posedge clk) begin
  a <= b;
  b <= a;
end

always_ff + <= für Register/Flip-Flops.

always_comb + = (blockierend) für rein kombinatorische Logik.
//-------------------------------------Variations of the D FF----------------------------------------------------------

Speichert 1 Bit (oder N Bits, wenn als Vektor geschrieben).

Taktgesteuert: Bei der positiven Flanke (posedge clk) wird der Eingang d in den Ausgang q übernommen.

In SystemVerilog schreibt man sequenzielle Logik mit
always_ff @(posedge clk) und nicht-blockierenden Zuweisungen <=.
So wird garantiert, dass mehrere Register den Stand vor der Flanke verwenden (keine Rennbedingungen).

module d_ff (
  input  logic clk,
  input  logic d,
  output logic q
);
  always_ff @(posedge clk)
    q <= d;         // nicht-blockierend!
endmodule

//Asynchroner Reset
Wirkt sofort, unabhängig vom Takt.

Sensitivitätsliste enthält zusätzlich posedge rst (oder negedge rst_n).

Typisch in ASIC-Flows; bei FPGAs eher seltener (Board/Family-abhängig)
module d_ff_rst_async (
  input  logic clk,
  input  logic rst,     // aktiv high
  input  logic d,
  output logic q
);
  always_ff @(posedge clk or posedge rst) begin
    if (rst)  q <= '0;  // sofort zurücksetzen
    else      q <= d;
  end
endmodule
//sychroner Reset
Reset wird nur an einer Taktflanke wirksam (definiertere Timings, oft in FPGAs bevorzugt).

Sensitivitätsliste ohne Reset, Abfrage im Block.

module d_ff_rst_sync (
  input  logic clk,
  input  logic rst,     // aktiv high
  input  logic d,
  output logic q
);
  always_ff @(posedge clk) begin
    if (rst)  q <= '0;  // erst bei posedge clk
    else      q <= d;
  end
endmodule

//Vektor-Register (mehrere Bits)
module regN #(
  parameter int N = 32
) (
  input  logic         clk, rst, en,
  input  logic [N-1:0] d,
  output logic [N-1:0] q
);
  always_ff @(posedge clk) begin
    if (rst)       q <= '0;
    else if (en)   q <= d;
  end
endmodule

//------------------------------------schift register-----------------------------------------------

Auf die Clock warten (synchron):
Überall wo du @(posedge clk) (oder @(negedge clk)) benutzt, wartest du synchron auf eine Taktflanke.
Beispiel in deinem TB:
`timescale 1ns/1ps
...
always #5 clk = ~clk;
→ Zeiteinheit = 1 ns, Zeitauflösung = 1 ps.
→ #5 bedeutet 5 ns.

Bei always #D clk = ~clk; ist #D die halbe Periode (weil bei jedem Delay das Signal kippt).

Periode T = 2 * D * (Zeiteinheit)

Frequenz f = 1 / T
D = 5, Zeiteinheit = 1 ns → T = 2 * 5 * 1 ns = 10 ns

f = 1 / 10 ns = 100 MHz






















