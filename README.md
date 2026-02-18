# Basys3 7-Segment Display Project (Vivado)

This repository contains the Verilog source code and XDC constraints for a Basys3 FPGA project using the on-board 4-digit 7-segment display.

## What this does
- Drives the Basys3 7-segment display using multiplexing (digit enable + segment lines)
- Includes a clock divider / refresh logic so the digits don’t flicker
- Uses an XDC constraints file to map top-level ports to Basys3 pins

## Repo layout
- `src/`  
  Verilog modules (top-level + helpers such as mux/anode driver/hex-to-7seg decoder)
- `constraints/`  
  `bruh.xdc` pin constraints (IOSTANDARD + PACKAGE_PIN mappings)

## Top-level I/O (edit to match your design)
Expected top module ports typically look like:
- `input  clk`
- `input  reset`
- `output [3:0] AN` (digit enables / anodes)
- `output [6:0] C`  (segments a..g) OR `[7:0]` if you include DP
- optionally other signals like `dig[4][3:0]` or per-digit values

If your port names differ, update `constraints/bruh.xdc` accordingly.

## How to build/program (Vivado)
1. Open Vivado
2. Create a new project (RTL Project)
3. Add files:
   - Add all files in `src/`
   - Add `constraints/bruh.xdc` as constraints
4. Select board/part:
   - Basys3 (Artix-7, typically `xc7a35tcpg236-1`)
5. Run:
   - Synthesis → Implementation → Generate Bitstream
6. Open Hardware Manager and program the board with the generated `.bit`

## Notes about constraints
`constraints/bruh.xdc` sets:
- `IOSTANDARD LVCMOS33` for Basys3 I/O
- `PACKAGE_PIN` mappings for:
  - 7-seg anodes (`AN[3:0]`)
  - segments (`C[...]`)
  - clock `clk`
  - reset `reset`
Make sure your top module port names match exactly what the XDC uses.

## Screenshots / Demo
(Optional) Add a photo/gif of the Basys3 running your design here.

## License
(Optional) Choose a license (MIT is common for class projects).
