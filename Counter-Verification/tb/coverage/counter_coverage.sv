
module counter_coverage (
    input logic       sample_valid,
    input logic       sampled_reset,
    input logic       sampled_enable,
    input logic [3:0] sampled_count
);

    // Functional Coverage Group
    covergroup counter_cg;

        // --------------------------------
        // CP-001: Reset Coverage
        // --------------------------------
        cp_reset: coverpoint sampled_reset {
            bins reset_asserted   = {1'b1};
            bins reset_deasserted = {1'b0};
        }

        // --------------------------------
        // CP-002: Enable Coverage
        // --------------------------------
        cp_enable: coverpoint sampled_enable {
            bins enable_on  = {1'b1};
            bins enable_off = {1'b0};
        }

        // --------------------------------
        // CP-003: Counter Value Coverage
        // --------------------------------
        cp_count: coverpoint sampled_count {

            bins zero        = {4'd0};
            bins low_values  = {[4'd1:4'd3]};
            bins mid_values  = {[4'd4:4'd11]};
            bins high_values = {[4'd12:4'd14]};
            bins maximum     = {4'd15};

        }

        // --------------------------------
        // CP-004: Reset x Enable
        // --------------------------------
        cp_reset_enable: cross cp_reset, cp_enable;

        // --------------------------------
        // CP-005: Counter Transition Coverage
        // --------------------------------
        cp_transitions: coverpoint sampled_count {

            // First increment
            bins zero_to_one =
                (4'd0 => 4'd1)
                iff (!sampled_reset && sampled_enable);

            // Overflow
            bins overflow =
                (4'd15 => 4'd0)
                iff (!sampled_reset && sampled_enable);

            // Reset to zero
            bins reset_to_zero =
                ([4'd1:4'd15] => 4'd0)
                iff (sampled_reset);

        }

    endgroup


    // Create Coverage Group Instance
    counter_cg cg = new();


    // Sample after Monitor finishes sampling
    always @(posedge sample_valid) begin
        cg.sample();
    end


    // Coverage Report
    task automatic report();

        $display("\n========== FUNCTIONAL COVERAGE ==========");

        $display("Overall Coverage: %0.2f%%",
                 cg.get_coverage());

        $display("Reset Coverage: %0.2f%%",
                 cg.cp_reset.get_coverage());

        $display("Enable Coverage: %0.2f%%",
                 cg.cp_enable.get_coverage());

        $display("Count Coverage: %0.2f%%",
                 cg.cp_count.get_coverage());

        $display("Reset x Enable Coverage: %0.2f%%",
                 cg.cp_reset_enable.get_coverage());

        $display("Transition Coverage: %0.2f%%",
                 cg.cp_transitions.get_coverage());

        $display("=========================================\n");

    endtask

endmodule
