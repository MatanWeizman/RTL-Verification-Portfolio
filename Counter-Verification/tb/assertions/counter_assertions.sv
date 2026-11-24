module counter_assertions #(
    parameter int unsigned WIDTH = 4
) (
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] count,

    output int unsigned assertion_errors
);

    logic reset_seen = 1'b0;;

    initial begin
        assertion_errors = 0;
    end

    always_ff @(posedge clk) begin
        if (reset)
            reset_seen <= 1'b1;
    end

    // AST-001: Synchronous Reset
    property p_reset;
        @(posedge clk)
        reset |=> count == '0;
    endproperty

    assert property (p_reset)
        else begin 
            assertion_errors = assertion_errors + 1;
            $error("AST-001 FAILED: Counter did not reset");
        end

    // AST-002: Counter Increment
    property p_increment;
        @(posedge clk)
        (reset_seen && !reset && enable) |=> 
            count == ($past(count) + 1'b1);
    endproperty

    assert property (p_increment) 
        else begin
            assertion_errors = assertion_errors + 1;
            $error("AST-002 FAILED: Counter did not increment");
        end

    // AST-003: Counter Hold
    property p_hold;
        @(posedge clk)
        (reset_seen && !reset && !enable) |=> 
            count == $past(count);
    endproperty

    assert property (p_hold) 
        else begin
            assertion_errors = assertion_errors + 1;
            $error("AST-003 FAILED: Counter did not hold its value");
        end

    // AST-004: Reset Priority
    property p_reset_priority;
        @(posedge clk)
        (reset_seen && reset && enable) |=> count == '0;
    endproperty

    assert property (p_reset_priority) 
        else begin
            assertion_errors = assertion_errors + 1;
            $error("AST-004 FAILED: Reset priority is incorrect");
        end

    // AST-005: Overflow
    property p_overflow;
        @(posedge clk)
        (reset_seen && !reset && enable &&
         count == {WIDTH{1'b1}})
        |=> count == '0;
    endproperty

    assert property (p_overflow) 
        else begin
            assertion_errors = assertion_errors + 1;
            $error("AST-005 FAILED: Counter overflow is incorrect");
        end

endmodule
