module counter_reference_model #(
    parameter int unsigned WIDTH = 4
) (
    input logic sample_valid,

    input logic sampled_reset,
    input logic sampled_enable,

    output logic [WIDTH-1:0] expected_count,
    output logic [WIDTH-1:0] expected_next
);

    // Initialize reference model
    initial begin
        expected_count = '0;
    end

    // Calculate expected next value
    always_comb begin

        expected_next = expected_count;

        if (sampled_reset)
            expected_next = '0;

        else if (sampled_enable)
            expected_next = expected_count + 1'b1;

    end

    // Update reference model on each valid sample
    always @(posedge sample_valid) begin

        expected_count = expected_next;

    end

endmodule