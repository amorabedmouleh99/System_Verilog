module adder (
    input  logic [31:0] a, 
    input  logic [31:0] b,
    output logic [31:0] sum
);

    // einfache Addition
    assign sum = a + b;

endmodule
// a=2 ->  a= 00000000000000000000000000000010

