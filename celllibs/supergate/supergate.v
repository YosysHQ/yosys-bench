/********************************************/
/*                                          */
/* Supergate cell library for Bench marking */
/*                                          */
/* Symbiotic EDA GmbH / Moseley Instruments */
/* Niels A. Moseley                         */
/*                                          */
/* Process: none                            */
/*                                          */
/* Date   : 02-11-2018                      */
/* Version: 1.0                             */
/*                                          */
/********************************************/

module inv(input A, output Y);
  assign Y = ~A;
endmodule

module tri_inv(input A, input S, output reg Y);
  always@(*)
  begin
    if (S==1'b0)
      begin
        Y <= 1'bz;
      end
    else  
      begin
        Y <= ~A;
      end
  end
endmodule

module buffer(input A, output Y);
  assign Y = A;
endmodule

module nand2(input A, input B, output Y);
  assign Y = ~(A & B);
endmodule

module nor2(input A, input B, output Y);
  assign Y = ~(A | B);
endmodule

module xor2(input A, input B, output Y);
  assign Y = A ^ B;
endmodule  

module imux2(input A, input B, input S, output Y);
  assign Y = ~(S ? A : B);
endmodule

module dff(input CLK, input D, input RESET, input PRESET, output reg Q, output reg QN);
  always@(CLK or RESET or PRESET)
  begin
    if (RESET)
      begin
        Q  <= 1'b0;
        QN <= 1'b1;
      end
    else
    if (PRESET)
      begin
        Q  <= 1'b1;
        QN <= 1'b0;
      end      
    else 
    if (CLK)
      begin
        Q  <= D;
        QN <= ~D;
      end
  end      
endmodule

module latch(input G, input D, output reg Q, output reg QN);
  always@(G or D)
  begin
    if (G)
      begin
        Q  <= D;
        QN <= ~D;
      end
  end      
endmodule


module aoi211(input A, input B, input C, output Y);
  assign Y = ~((A&B)|C);
endmodule

module oai211(input A, input B, input C, output Y);
  assign Y = ~((A|B)&C);
endmodule

module halfadder(input A, input B, output C, output Y);
  assign Y = A^B;
  assign C = A&B;
endmodule

module fulladder(input A, input B, input CI, output CO, output Y);
  assign Y = (A^B)^CI;
  assign CO = ((A&B)|(B&CI))|(CI&A);
endmodule
