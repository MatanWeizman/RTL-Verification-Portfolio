module counter_test #(
    parameter integer WIDTH = 4
) (
    input logic clk,
    input logic [WIDTH-1:0] count,

    output logic reset,
    output logic enable,

    output logic done,
    output int unsigned test_errors
);

    localparam logic [WIDTH-1:0] MAX_COUNT = {WIDTH{1'b1}};

    logic [WIDTH-1:0] saved_count;

    // Initialize
    initial begin

        reset = 1;
        enable = 0;

        done = 0;
        test_errors = 0;

    end

    // Test A: Reset
    task automatic test_reset;

        $display("\nTEST A: Reset");

        reset = 1;
        enable = 0;

        repeat(2) @(negedge clk);

        reset = 0;

    endtask

    // Test B: Increment
    task automatic test_increment;

        $display("\nTEST B: Increment");

        enable = 1;

        repeat(5) @(negedge clk);

    endtask

    // Test C: Hold
    task automatic test_hold;

        $display("\nTEST C: Hold");

        enable = 0;

        repeat(5) @(negedge clk);

    endtask

    // Test D: Enable resumes
    task automatic test_enable_resume;

        $display("\nTEST D: Enable Resume");

        enable = 1;

        repeat(5) @(negedge clk);

    endtask

    // Test E: Reset priority
    task automatic test_reset_priority;

        $display("\nTEST E: Reset Priority");

        reset = 1;
        enable = 1;

        repeat(2) @(negedge clk);

        reset = 0;

    endtask

    // Test F: Synchronous reset
    task automatic test_synchronous_reset;

        $display("\nTEST F: Synchronous Reset");

        enable = 0;

        @(negedge clk);

        saved_count = count;

        reset = 1;

        // Check that count does not change immediately
        #1;

        if (count !== saved_count) begin

            test_errors++;

            $error("TEST FAIL: Reset changed count between clock edges");

        end

        // Check reset at next rising edge
        @(posedge clk);

        #2;

        if (count !== '0) begin

            test_errors++;

            $error("TEST FAIL: Synchronous reset did not clear count");

        end

        @(negedge clk);

        reset = 0;

    endtask

    // Test G: Enable changes between clock edges
    task automatic test_enable_timing;

        $display("\nTEST G: Enable Timing");

        reset = 1;
        enable = 0;

        @(negedge clk);

        reset = 0;
        saved_count = count;

        enable = 1;

        #1;

        if (count !== saved_count) begin

            test_errors++;

            $error("TEST FAIL: Count changed before rising clock edge");

        end

        @(posedge clk);

        #2;

        @(negedge clk);

        enable = 0;

    endtask

    // Test H: Overflow
    task automatic test_overflow;

        $display("\nTEST H: Overflow");

        reset = 1;
        enable = 0;

        @(negedge clk);

        reset = 0;
        enable = 1;

        // Perform 2**WIDTH increments
        // The counter should return to zero
        repeat (2 ** WIDTH) @(negedge clk);

        if (count !== '0) begin

            test_errors++;

            $error("TEST FAIL: Overflow did not return count to zero");

        end

    endtask

    // Test I: Hold at maximum value
    task automatic test_hold_at_max;

        $display("\nTEST I: Hold at Maximum");

        reset = 1;
        enable = 0;

        @(negedge clk);

        reset = 0;
        enable = 1;

        // Reach maximum value
        repeat ((2 ** WIDTH) - 1) @(negedge clk);

        enable = 0;

        repeat(2) @(negedge clk);

        if (count !== MAX_COUNT) begin

            test_errors++;

            $error("TEST FAIL: Counter did not hold maximum value");

        end

    endtask

    // Test J: Random stimulus
    task automatic test_random;

        $display("\nTEST J: Random Stimulus");

        repeat(100) begin

            @(negedge clk);

            reset = $urandom_range(0,1);
            enable = $urandom_range(0,1);

        end

        reset = 0;
        enable = 0;

    endtask

    // Main test sequence
    initial begin

        test_reset();

        test_increment();

        test_hold();

        test_enable_resume();

        test_reset_priority();

        test_synchronous_reset();

        test_enable_timing();

        test_overflow();

        test_hold_at_max();

        test_random();

        // Allow final clock sample to complete
        @(posedge clk);

        #2;

        done = 1;

    end

endmodule