module counter_scoreboard #(
    parameter int unsigned WIDTH = 4
) (
    input logic sample_valid,

    input logic [WIDTH-1:0] expected_next,
    input logic [WIDTH-1:0] actual_count,

    output integer error_count
);

    int comparison_count;

    initial begin
        error_count = 0;
        comparison_count = 0;
    end

    always @(posedge sample_valid) begin

        comparison_count = comparison_count + 1;

        if (expected_next !== actual_count) begin

            error_count = error_count + 1;

            $error(
                "SCOREBOARD FAIL | Sample=%0d | Expected=%0d | Actual=%0d",
                comparison_count,
                expected_next,
                actual_count
            );

        end
        else begin

            $display(
                "SCOREBOARD PASS | Sample=%0d | Expected=%0d | Actual=%0d",
                comparison_count,
                expected_next,
                actual_count
            );

        end

    end

endmodule