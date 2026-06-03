module fir_filter #(
    parameter DATA_WIDTH = 16,
    parameter COEFF_WIDTH = 16,
    parameter OUTPUT_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,           // Active low reset
    input wire en,              // Enable signal
    input wire [DATA_WIDTH-1:0] data_in,  // Input sample
    output reg [OUTPUT_WIDTH-1:0] data_out // Filter output
);

    // ========== COEFFICIENTS (CONSTANTS - SYNTHESIZABLE) ==========
    // Low-pass filter coefficients (scaled to 16-bit fixed-point)
    localparam [COEFF_WIDTH-1:0] H0 = 16'd327;    // h[0] ≈ 0.01
    localparam [COEFF_WIDTH-1:0] H1 = 16'd1310;   // h[1] ≈ 0.04
    localparam [COEFF_WIDTH-1:0] H2 = 16'd1966;   // h[2] ≈ 0.06
    localparam [COEFF_WIDTH-1:0] H3 = 16'd1310;   // h[3] ≈ 0.04
    localparam [COEFF_WIDTH-1:0] H4 = 16'd327;    // h[4] ≈ 0.01
    localparam [COEFF_WIDTH-1:0] H5 = 16'd1310;   // h[5] ≈ 0.04
    localparam [COEFF_WIDTH-1:0] H6 = 16'd1966;   // h[6] ≈ 0.06
    localparam [COEFF_WIDTH-1:0] H7 = 16'd1310;   // h[7] ≈ 0.04
    
    // ========== DELAY LINE (Shift Register - Explicit, No Array) ==========
    reg [DATA_WIDTH-1:0] d0;  // Current input
    reg [DATA_WIDTH-1:0] d1;  // Delay 1
    reg [DATA_WIDTH-1:0] d2;  // Delay 2
    reg [DATA_WIDTH-1:0] d3;  // Delay 3
    reg [DATA_WIDTH-1:0] d4;  // Delay 4
    reg [DATA_WIDTH-1:0] d5;  // Delay 5
    reg [DATA_WIDTH-1:0] d6;  // Delay 6
    reg [DATA_WIDTH-1:0] d7;  // Delay 7
    
    // ========== MULTIPLIERS (Explicit, No Array) ==========
    reg [OUTPUT_WIDTH-1:0] p0;
    reg [OUTPUT_WIDTH-1:0] p1;
    reg [OUTPUT_WIDTH-1:0] p2;
    reg [OUTPUT_WIDTH-1:0] p3;
    reg [OUTPUT_WIDTH-1:0] p4;
    reg [OUTPUT_WIDTH-1:0] p5;
    reg [OUTPUT_WIDTH-1:0] p6;
    reg [OUTPUT_WIDTH-1:0] p7;
    
    // ========== STEP 1: SHIFT DELAY LINE (Explicit - SYNTHESIZABLE) ==========
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d0 <= 0;
            d1 <= 0;
            d2 <= 0;
            d3 <= 0;
            d4 <= 0;
            d5 <= 0;
            d6 <= 0;
            d7 <= 0;
        end else if (en) begin
            d7 <= d6;
            d6 <= d5;
            d5 <= d4;
            d4 <= d3;
            d3 <= d2;
            d2 <= d1;
            d1 <= d0;
            d0 <= data_in;
        end
    end
    
    // ========== STEP 2: MULTIPLICATION (Explicit - SYNTHESIZABLE) ==========
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p0 <= 0;
            p1 <= 0;
            p2 <= 0;
            p3 <= 0;
            p4 <= 0;
            p5 <= 0;
            p6 <= 0;
            p7 <= 0;
        end else if (en) begin
            p0 <= $signed(d0) * $signed(H0);
            p1 <= $signed(d1) * $signed(H1);
            p2 <= $signed(d2) * $signed(H2);
            p3 <= $signed(d3) * $signed(H3);
            p4 <= $signed(d4) * $signed(H4);
            p5 <= $signed(d5) * $signed(H5);
            p6 <= $signed(d6) * $signed(H6);
            p7 <= $signed(d7) * $signed(H7);
        end
    end
    
    // ========== STEP 3: ACCUMULATION (Explicit - SYNTHESIZABLE) ==========
    reg [OUTPUT_WIDTH-1:0] acc;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 0;
        end else if (en) begin
            acc <= p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7;
        end
    end
    
    // ========== STEP 4: OUTPUT REGISTER ==========
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else if (en) begin
            data_out <= acc;
        end
    end
    
endmodule

