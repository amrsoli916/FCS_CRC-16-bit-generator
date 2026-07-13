module FCS_tb();
parameter WIDTH = 24;
reg clk, rst;
reg [WIDTH-1:0] data;
wire [WIDTH+15:0] output_FSC;

integer file;

FCS #(.WIDTH(WIDTH)) fcs_inst(.data(data), .clk(clk), .rst(rst), .output_FSC(output_FSC));

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock generation with a period of 10 time units
end

initial begin
    // Open a file to write the output
    file = $fopen("FCS_output.txt", "w"); 
    $fdisplay(file, "=============================================");
    $fdisplay(file, "Simulation Results");
    $fdisplay(file, "=============================================");

    // Test case 1
    rst = 1; data = 24'b011010100000000000000010; #10;
    rst = 0; #(10 * WIDTH); // Wait for the FCS calculation to complete

    // Write only the CRC part to the file
    $fdisplay(file, "Test case 1: data = %h, output_FSC = %h", data, output_FSC[15:0]); 
    
    // Test case 2
     data = 24'b110101010101010101010101; 
    #(10 * WIDTH); // Wait for the FCS calculation to complete

    // Write only the CRC part to the file
    $fdisplay(file, "Test case 2: data = %h, output_FSC = %h", data, output_FSC[15:0]);


    $stop; // Stop the simulation
end


endmodule