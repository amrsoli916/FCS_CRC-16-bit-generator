module FCS_tb();
parameter WIDTH = 24;
reg clk, rst;
reg [WIDTH-1:0] data;
reg [15:0] expected_crc;
reg [WIDTH-1:0] golden_data;
wire [WIDTH+15:0] output_FSC;

integer pass, fail, status;
integer file,file_out;

FCS #(.WIDTH(WIDTH)) fcs_inst(.data(data), .clk(clk), .rst(rst), .output_FSC(output_FSC));

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock generation with a period of 10 time units
end

initial begin

    pass = 0;
    fail = 0;

    file = $fopen("golden_vectors.txt","r");

    if(file == 0) begin
        $display("Cannot open file.");
        $stop;
    end
    // Open a file to write the output
    file_out = $fopen("FCS_output.txt", "w"); 
    $fdisplay(file_out, "=============================================");
    $fdisplay(file_out, "Simulation Results");
    $fdisplay(file_out, "=============================================");

    rst = 1;
    data = 0;
    #10;
    rst = 0; 

    while(!$feof(file)) begin 

        status = $fscanf(file,"%h %h\n", golden_data, expected_crc);

        if(status != 2) begin
            $display("ERROR reading file.");
            $stop;       // stop in donot read to value from file 
        end

        // Compare the output of the FCS module with the expected CRC value
        data = golden_data; 
        #(10 * WIDTH); // Wait for the FCS calculation to complete

        if(output_FSC[15:0] == expected_crc) begin
            pass = pass + 1;
            $fdisplay(file_out, "Test case %0d: PASS : Data = %h CRC = %h",
                        pass + fail, golden_data, output_FSC[15:0]);                // Log the result to the output file
        end 

        else begin
            fail = fail + 1;
            $fdisplay(file_out, "Test case %0d: FAIL : Data=%h Expected=%h Got=%h", 
                        pass + fail, golden_data, expected_crc, output_FSC[15:0]);  // Log the result to the output file
        end
    end

    $fdisplay(file_out, "=============================================");
    $fdisplay(file_out, "Total Test Cases: %0d", pass + fail);
    $fdisplay(file_out, "Passed: %0d", pass);
    $fdisplay(file_out, "Failed: %0d", fail);
    $fdisplay(file_out, "=============================================");

    $fclose(file);
    $fclose(file_out);

     $stop; // Stop the simulation
end 

endmodule