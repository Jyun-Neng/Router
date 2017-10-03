/* 
    * File Name : buffer.sv
    *
    * Purpose : A FIFO buffer.
    *           
    * Creation Date : 2017/10/04
    *
    * Last Modified : 2017/10/04
    *
    * Create By : Jyun-Neng Ji
    *
*/

module buffer #(
    parameter DASize = 10,
    parameter BUFSize = 4,
    parameter ADSize = 2
)
(
    input write_en, read_en, clk, rst,
    input [DASize-1:0] buf_in,
    output logic [DASize-1:0] buf_out,
    output logic buf_empty, buf_full
);

    logic [DASize-1:0] buf_mem [BUFSize-1:0];
    logic [ADSize-1:0] write_addr, read_addr;
    logic [ADSize:0] counter;
    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i=0; i<BUFSize; i=i+1) buf_mem[i] <= 'd0;
            buf_out <= 'd0;
            write_addr <= 'd0; read_addr <= 'd0;
            counter <= 'd0;
        end
        else begin
            // check if needs to write data into buffer
            if (write_en && !buf_full) begin
                buf_mem[write_addr] <= buf_in;
                write_addr <= write_addr + 1;
                counter <= counter + 1;
            end
            // check if needs to read data from buffer 
            else if (read_en && !buf_empty) begin
                buf_out <= buf_mem[read_addr];
                read_addr <= read_addr + 1;
                counter <= counter - 1;
            end
            else begin
                buf_out <= 0;
                buf_mem[write_addr] <= buf_mem[write_addr];
                write_addr <= write_addr;
                read_addr <= read_addr;
                counter <= counter;
            end
        end
    end
    // check if buffer empty or full
    always_comb begin
        buf_empty <= (counter == 0);
        buf_full <= (counter == BUFSize);
    end
    
    
endmodule
