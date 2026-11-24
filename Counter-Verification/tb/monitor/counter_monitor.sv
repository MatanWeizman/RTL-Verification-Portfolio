module counter_monitor #(
    parameter int unsigned WIDTH = 4
) (
    input logic clk,

    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] count,

    output logic sampled_reset,
    output logic sampled_enable,
    output logic [WIDTH-1:0] sampled_count,

    output logic sample_valid
);

    // Initialize outputs
    initial begin
        sampled_reset  = 0;
        sampled_enable = 0;
        sampled_count  = '0;
        sample_valid   = 0;
    end

    // Sample DUT signals after clock update
    always @(posedge clk) begin

        // Wait for DUT nonblocking assignments
        #1;

        sampled_reset  = reset;
        sampled_enable = enable;
        sampled_count  = count;

        // Notify other verification components
        #0.1;
        sample_valid = 1;

        #0.1;
        sample_valid = 0;

    end

endmodule