module tb_counter;

    parameter int unsigned TB_WIDTH = 4;

    // Signals
    logic clk;
    logic reset;
    logic enable;

    logic [TB_WIDTH-1:0] count;

    // Monitor signals
    logic sampled_reset;
    logic sampled_enable;
    logic [TB_WIDTH-1:0] sampled_count;

    logic sample_valid;

    // Reference Model signals
    logic [TB_WIDTH-1:0] expected_count;
    logic [TB_WIDTH-1:0] expected_next;

    // Status signals
    logic done;
    logic coverage_pass;

    int unsigned scoreboard_errors;
    int unsigned assertion_errors;
    int unsigned test_errors;
  
    // =====================================
    // DUT
    // =====================================
    counter #(
        .WIDTH(TB_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    // =====================================
    // Monitor
    // =====================================
    counter_monitor #(
        .WIDTH(TB_WIDTH)
    ) monitor_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count),
        .sampled_reset(sampled_reset),
        .sampled_enable(sampled_enable),
        .sampled_count(sampled_count),
        .sample_valid(sample_valid)
    );

    // =====================================
    // Reference Model
    // =====================================
    counter_reference_model #(
        .WIDTH(TB_WIDTH)
    ) reference_model_inst (
        .sample_valid(sample_valid),
        .sampled_reset(sampled_reset),
        .sampled_enable(sampled_enable),
        .expected_count(expected_count),
        .expected_next(expected_next)
    );

    // =====================================
    // Scoreboard
    // =====================================
    counter_scoreboard #(
        .WIDTH(TB_WIDTH)
    ) scoreboard_inst (
        .sample_valid(sample_valid),
        .expected_next(expected_next),
        .actual_count(sampled_count),
        .error_count(scoreboard_errors)
    );

    // =====================================
    // Assertions
    // =====================================
    counter_assertions #(
        .WIDTH(TB_WIDTH)
    ) assertions_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count),
        .assertion_errors(assertion_errors)
    );

    // =====================================
    // Coverage
    // =====================================
    /*counter_coverage coverage_inst (
        .sample_valid(sample_valid),
        .sampled_reset(sampled_reset),
        .sampled_enable(sampled_enable),
        .sampled_count(sampled_count)
    );*/

    // =====================================
    // Test
    // =====================================
    counter_test #(
        .WIDTH(TB_WIDTH)
    ) test_inst (
        .clk(clk),
        .count(count),
        .reset(reset),
        .enable(enable),
        .done(done),
        .test_errors(test_errors)
    );    
  
    // =====================================
    // Clock Generation
    // =====================================
    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    // =====================================
    // Waveform
    // =====================================
    initial begin

        $dumpfile("simulation/wave.vcd");

        $dumpvars(0, tb_counter);

    end
  
    // =====================================
    // Final Report
    // =====================================
    initial begin

        wait(done);

        // Allow all final updates to complete
        #1;

        //coverage_inst.report();

        $display("\n======================================");
        $display("       COUNTER VERIFICATION REPORT");
        $display("======================================");

        $display("WIDTH:             %0d", TB_WIDTH);

        $display("Scoreboard Errors: %0d", scoreboard_errors);
        $display("Assertion Errors:  %0d", assertion_errors);
        $display("Test Errors:       %0d", test_errors);

        //$display("Coverage Complete: %0b", coverage_pass);

        if (scoreboard_errors == 0 &&
            assertion_errors == 0 &&
            test_errors == 0 /*&&
            coverage_pass*/) begin

            $display("\nFINAL RESULT: PASS");

        end
        else begin

            $display("\nFINAL RESULT: FAIL");

            $fatal(1, "Counter Verification Failed");

        end

        $display("======================================\n");

        $finish;

    end
  
endmodule