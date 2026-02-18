`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 09:15:45 PM
// Design Name: 
// Module Name: display
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

// ==========================
// File: clock_enable.v
// Creates 1 kHz enable from 100 MHz clk
// ==========================
module clock_enable #(
    parameter integer DIV = 100000  // 100_000_000 / 100_000 = 1 kHz
)(
    input  wire clk,       // 100 MHz
    input  wire reset,
    output reg  clk_en
);
    reg [31:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count  <= 0;
            clk_en <= 1'b0;
        end else if (count == DIV-1) begin
            count  <= 0;
            clk_en <= 1'b1;   // one-cycle pulse
        end else begin
            count  <= count + 1;
            clk_en <= 1'b0;
        end
    end
endmodule




// ==========================
// File: anode_driver.v
// Cycles AN[3:0] active-LOW, outputs S for digit select
// ==========================
module anode_driver(
    input  wire clk,
    input  wire reset,
    input  wire clk_en,     // ~1 kHz pulse
    output reg  [3:0] AN,   // active-LOW anodes
    output reg  [1:0] S     // selects which digit is active (0..3)
);
    // 2-bit counter advances on clk_en
    always @(posedge clk or posedge reset) begin
        if (reset) S <= 2'b00;
        else if (clk_en) S <= S + 1'b1; // 00,01,10,11,00...
    end

    // Active-LOW decode per lab table
    always @* begin
        case (S)
            2'b00: AN = 4'b1110; // digit 0 (rightmost on most Basys3 silk)
            2'b01: AN = 4'b1101; // digit 1
            2'b10: AN = 4'b1011; // digit 2
            2'b11: AN = 4'b0111; // digit 3 (leftmost)
        endcase
    end
endmodule


// ==========================
// File: mux4_1_nibble.v
// ==========================
module mux4_1(
    input  wire [3:0] dig1, dig2, dig3, dig4,  // four hex nibbles
    input  wire [1:0] sel,
    output reg  [3:0] X
);
    always @* begin
        case (sel)
            2'b00: X = dig1;
            2'b01: X = dig2;
            2'b10: X = dig3;
            2'b11: X = dig4;
        endcase
    end
endmodule




// ==========================
// File: display.v
// Top-level 4-digit hex-to-7seg controller
// Inputs d0 is rightmost, d3 is leftmost (matches AN decode shown).
// ==========================
module display  #(
    parameter integer CE_DIV = 100_000  // default for hardware
)(
    input  wire        clk,      // 100 MHz
    input  wire        reset,
    input  wire [3:0]  dig1,       // rightmost digit
    input  wire [3:0]  dig2,
    input  wire [3:0]  dig3,
    input  wire [3:0]  dig4,       // leftmost digit
    output wire [3:0]  AN,       // active-LOW anodes
    output wire [6:0]  C       // decimal point (active-LOW)
);
    // 1) clock enable (1 kHz)
    wire clk_en;
    clock_enable #(.DIV(CE_DIV)) u_ce (
        .clk(clk), .reset(reset), .clk_en(clk_en)
    );

    // 2) anode driver -> AN, S (which digit index is active)
    wire [1:0] S;
    anode_driver u_an (
        .clk(clk), .reset(reset), .clk_en(clk_en),
        .AN(AN), .S(S)
    );

    // 3) select active digit's nibble
    wire [3:0] x;
    mux4_1 u_mux (
        .dig1(dig1), .dig2(dig2), .dig3(dig3), .dig4(dig4),
        .sel(S), .X(x)
    );

    // 4) hex-to-7seg for selected nibble (active-LOW segments)
    hex2sevseg u_dec (
        .x(x), .ca(C)
    );


endmodule

