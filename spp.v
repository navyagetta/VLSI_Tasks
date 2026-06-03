// ============================================================
// 4-Stage Pipelined Processor (SYNTHESIZABLE VERSION)
// Stages: IF -> ID -> EX -> WB
// Instructions: ADD, SUB, AND, LOAD, STORE, NOP
// ============================================================

module pipelined_processor (
    input wire clk,
    input wire reset,
    input wire [7:0] instr_mem_data,
    output reg [3:0] instr_mem_addr,
    output wire ie,
    
    input wire [7:0] data_mem_data,
    output reg [7:0] data_mem_addr,
    output reg [1:0] data_mem_we,
    
    output reg [7:0] reg_write_data,
    output reg [3:0] reg_write_addr,
    output reg reg_we
);

    assign ie = 1;
    
    reg [7:0] reg_file [0:15];
    reg [7:0] data_mem [0:255];
    
    reg [7:0] if_id_instr;
    reg [3:0] if_id_pc;
    
    reg [7:0] id_ex_instr;
    reg [7:0] id_ex_reg_a_data;
    reg [7:0] id_ex_reg_b_data;
    reg [3:0] id_ex_dest;
    reg [2:0] id_ex_op;
    
    reg [7:0] ex_wb_result;
    reg [3:0] ex_wb_dest;
    reg [2:0] ex_wb_op;
    
    wire [2:0] instr_op;
    wire [3:0] instr_dest;
    wire [3:0] instr_src_a;
    wire [3:0] instr_src_b;
    
    assign instr_op = if_id_instr[7:5];
    assign instr_dest = if_id_instr[4:1];
    assign instr_src_a = if_id_instr[4:2];
    assign instr_src_b = if_id_instr[3:1];
    
    wire [7:0] reg_a_read_data;
    wire [7:0] reg_b_read_data;
    
    assign reg_a_read_data = (instr_src_a < 4'd16) ? reg_file[instr_src_a] : 8'b0;
    assign reg_b_read_data = (instr_src_b < 4'd16) ? reg_file[instr_src_b] : 8'b0;
    
    reg [3:0] pc;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 4'b0000;
        else
            pc <= pc + 1;
    end
    
    always @(posedge clk) begin
        instr_mem_addr <= pc;
        if_id_instr <= instr_mem_data;
        if_id_pc <= pc;
    end
    
    always @(posedge clk) begin
        id_ex_op <= instr_op;
        id_ex_dest <= instr_dest;
        id_ex_instr <= if_id_instr;
        id_ex_reg_a_data <= reg_a_read_data;
        id_ex_reg_b_data <= reg_b_read_data;
    end
    
    always @(posedge clk) begin
        case (id_ex_op)
            3'b000: ex_wb_result <= id_ex_reg_a_data + id_ex_reg_b_data;
            3'b001: ex_wb_result <= id_ex_reg_a_data - id_ex_reg_b_data;
            3'b010: ex_wb_result <= id_ex_reg_a_data & id_ex_reg_b_data;
            3'b011: ex_wb_result <= data_mem_data;
            3'b100: ex_wb_result <= id_ex_reg_b_data;
            3'b111: ex_wb_result <= 8'b0;
            default: ex_wb_result <= 8'b0;
        endcase
        
        ex_wb_dest <= id_ex_dest;
        ex_wb_op <= id_ex_op;
    end
    
    always @(posedge clk) begin
        if (id_ex_op == 3'b011 || id_ex_op == 3'b100)
            data_mem_addr <= id_ex_reg_a_data[7:0];
    end
    
    always @(posedge clk) begin
        if (id_ex_op == 3'b100) begin
            data_mem[id_ex_reg_a_data[7:0]] <= id_ex_reg_b_data;
            data_mem_we <= 2'b01;
        end else
            data_mem_we <= 2'b00;
    end
    
    always @(posedge clk) begin
        reg_write_data <= ex_wb_result;
        reg_write_addr <= ex_wb_dest;
        
        case (ex_wb_op)
            3'b000, 3'b001, 3'b010, 3'b011: reg_we <= 1;
            default: reg_we <= 0;
        endcase
    end
    
    always @(posedge clk) begin
        if (reg_we && reg_write_addr < 4'd16)
            reg_file[reg_write_addr] <= reg_write_data;
    end
    
endmodule

