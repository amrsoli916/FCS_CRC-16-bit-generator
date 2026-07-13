module FCS(data,clk,rst,output_FSC);
parameter WIDTH = 64;
parameter count_width = $clog2(WIDTH+1);
input [WIDTH-1:0] data;
input clk , rst;
output reg [WIDTH+15:0] output_FSC;
reg feedback;
reg [15:0] CRC_reg, CRC_next;
reg [count_width-1:0] counter;

always @(*) begin
    feedback = data[counter] ^ CRC_reg[0];
    CRC_next[0] = CRC_reg[1];
    CRC_next[1] = CRC_reg[2];
    CRC_next[2] = CRC_reg[3];
    CRC_next[3] = CRC_reg[4] ^ feedback;
    CRC_next[4] = CRC_reg[5];
    CRC_next[5] = CRC_reg[6];
    CRC_next[6] = CRC_reg[7];
    CRC_next[7] = CRC_reg[8];
    CRC_next[8] = CRC_reg[9];
    CRC_next[9] = CRC_reg[10];
    CRC_next[10] = CRC_reg[11] ^ feedback;
    CRC_next[11] = CRC_reg[12];
    CRC_next[12] = CRC_reg[13];
    CRC_next[13] = CRC_reg[14];
    CRC_next[14] = CRC_reg[15];
    CRC_next[15] = feedback;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        CRC_reg <= 16'h0000;
        output_FSC <= 0;
    end
    else begin
        if (counter < WIDTH) begin
            CRC_reg <= CRC_next;   
        end
            if (counter == WIDTH-1) begin
                output_FSC <= {data, CRC_next}; // Concatenate data and CRC to form the output
                counter <= 0; // Reset counter for next iteration 
                CRC_reg <= 16'h0000; // Reset CRC register for next iteration           
            end
            else begin
                counter <= counter + 1; // Increment counter for next bit
            end
    end
end

endmodule