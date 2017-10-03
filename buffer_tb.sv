/* 
    * File Name : 
    *
    * Purpose :
    *           
    * Creation Date : 
    *
    * Last Modified : 
    *
    * Create By : Jyun-Neng Ji
    *
*/
`timescale 1ns/10ps
`include "buffer.sv"

`define PERIOD 20

module buffer_tb;
    parameter DASize = 10;
    parameter BUFSize = 4;
    logic write_en, read_en, clk, rst, buf_empty, buf_full;
    logic [DASize-1:0] buf_in, buf_out;

    integer i;

    buffer b1 (.rst(rst), .clk(clk), .write_en(write_en), .read_en(read_en), .buf_in(buf_in),
                .buf_out(buf_out), .buf_empty(buf_empty), .buf_full(buf_full));

    initial $monitor($time, " rst=%b, write_en=%b, read_en=%b, in=%d, out=%d, full=%b, empty=%b", 
                    rst, write_en, read_en, buf_in, buf_out, buf_full, buf_empty);
    always #(`PERIOD/2) clk = ~clk;

    initial begin
        rst = 'b1; clk = 'b0;
        #(`PERIOD) rst = 'b0; read_en = 'b1;
        #(`PERIOD) read_en = 'b0; write_en = 'b1; buf_in = 'd10;
        #(`PERIOD) read_en = 'b0; write_en = 'b1; buf_in = 'd11;
        #(`PERIOD) read_en = 'b0; write_en = 'b1; buf_in = 'd12;
        #(`PERIOD) read_en = 'b0; write_en = 'b1; buf_in = 'd13;
        #(`PERIOD) read_en = 'b0; write_en = 'b1; buf_in = 'd15;
        #(`PERIOD) read_en = 'b1; write_en = 'b0; buf_in = 'd20;

        #(`PERIOD) $finish;
     end 

    initial begin
        $fsdbDumpfile ("buffer.sv");
        $fsdbDumpvars;
    end

endmodule
