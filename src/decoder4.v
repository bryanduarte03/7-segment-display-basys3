`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 08:56:55 AM
// Design Name: 
// Module Name: decoder4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hex2sevseg(
    input  wire [3:0] x,         // hex digit
    output reg  [6:0] ca          // {CA,CB,CC,CD,CE,CF,CG}
);
    always @* begin
        case (x)
            4'h0: ca = 7'b0000001; // 0
            4'h1: ca = 7'b1001111; // 1
            4'h2: ca = 7'b0010010; // 2
            4'h3: ca = 7'b0000110; // 3
            4'h4: ca = 7'b1001100; // 4
            4'h5: ca = 7'b0100100; // 5
            4'h6: ca = 7'b0100000; // 6
            4'h7: ca = 7'b0001111; // 7
            4'h8: ca = 7'b0000000; // 8
            4'h9: ca = 7'b0000100; // 9
            4'hA: ca = 7'b0001000; // A
            4'hB: ca = 7'b1100000; // b
            4'hC: ca = 7'b0110001; // C
            4'hD: ca = 7'b1000010; // d
            4'hE: ca = 7'b0110000; // E
            4'hF: ca = 7'b0111000; // F
            default: ca = 7'b1111111; // all off
        endcase
    end
endmodule
