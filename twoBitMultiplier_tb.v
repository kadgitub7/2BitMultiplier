`timescale 1ns / 1ps

module twoBitMultiplier_tb();

    reg A0,A1,B0,B1;
    wire P0,P1,P2,P3,c1,c2;
    
    twoBitMultiplier utt(A0,A1,B0,B1,P0,P1,P2,P3);
    integer k;
    integer j;
    
    initial begin
        for(k=0;k<4;k=k+1)begin
            for(j=0;j<4;j=j+1)begin
                {A1,A0} = k;
                {B1,B0} = j;
                #10 $display("A = %b, B = %b, P = %b", {A1,A0}, {B1,B0}, {P3,P2,P1,P0});
            end 
        end
    end
        
endmodule
