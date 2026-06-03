// Synchronous RAM Module with Read and Write Operations
// 8-bit data width, 16-word depth (4-bit address)

module synchronous_ram (
    input wire clk,           // Clock signal
    input wire we,            // Write enable (1 = write, 0 = read)
    input wire [3:0] addr,    // Address bus (4 bits = 16 locations)
    input wire [7:0] wdata,   // Write data (8 bits)
    output reg [7:0] rdata    // Read data (8 bits)
);

    // RAM memory array: 16 locations, 8 bits each
    reg [7:0] ram [0:15];
    
    // Synchronous read and write operation on rising clock edge
    always @(posedge clk) begin
        if (we) begin
            // Write operation: store wdata at addr
            ram[addr] <= wdata;
        end
        // Read operation: output data at addr (always on clock edge)
        rdata <= ram[addr];
    end
    
endmodule
