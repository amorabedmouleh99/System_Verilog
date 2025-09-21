module mux (
  input  logic a,
  input  logic b,
  input  logic sel,
  output logic f
);
  logic n_sel, f1, f2;

  not g4 (n_sel, sel);   // n_sel = ~sel
  and g1 (f1, a, n_sel); // f1   =  a & ~sel
  and g2 (f2, b, sel);   // f2   =  b &  sel
  or  g3 (f,  f1, f2);   // f    =  f1 | f2
endmodule
