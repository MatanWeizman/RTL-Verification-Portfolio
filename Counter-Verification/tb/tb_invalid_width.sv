module tb_invalid_width;

    logic clk;
    logic reset;
    logic enable;

    logic [0:0] count;

    counter #(
        .WIDTH(0)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    initial begin

        clk = 0;
        reset = 0;
        enable = 0;

        #1;

        // Reaching this point means validation failed
        $fatal(1, "TEST FAILED: WIDTH=0 was accepted");

    end

endmodule