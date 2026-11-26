`timescale 1ns/1ps

module tb_fifo;

// ------------------------------------------------
// Parameters
// ------------------------------------------------
parameter int unsigned DATA_WIDTH = 8;
parameter int unsigned FIFO_DEPTH = 4;

// ------------------------------------------------
// DUT Signals
// ------------------------------------------------
logic                   clk;
logic                   reset; 

logic                   wr_en;
logic                   rd_en;

logic [DATA_WIDTH-1:0]  din;

logic [DATA_WIDTH-1:0]  dout;
logic                   full;
logic                   empty;

// ------------------------------------------------
// Test Counters
// ------------------------------------------------
int unsigned error_count;
int unsigned test_count;

// ------------------------------------------------
// DUT Instantiation
// ------------------------------------------------
fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
) dut (
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

// ------------------------------------------------
// Clock Generation
// ------------------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// =====================================
// Waveform
// =====================================
initial begin
    $dumpfile("simulation/wave.vcd");
    $dumpvars(0, tb_fifo);
end

// ------------------------------------------------
// Initial Values
// ------------------------------------------------
initial begin
    reset = 0;

    wr_en = 0;
    rd_en = 0;

    din = '0;

    error_count = 0;
    test_count = 0;
end

// ------------------------------------------------
// Reset Task
// ------------------------------------------------
task automatic apply_reset;
    begin
        @(negedge clk);
        reset = 1;

        repeat(2) @(negedge clk);

        if (empty != 1'b1) begin
            $error("ERROR: Empty should be 1 after reset");
            error_count++;
        end
    
        if (full != 1'b0) begin
           $error("ERROR: Full should be 0 after reset");
           error_count++;
        end

        if (dout != '0) begin
            $error("ERROR: dout should be 0 after reset");
            error_count++; 
        end

        @(negedge clk);
        reset = 0;

        $display("[%0t] Reset completed", $time);
    end
endtask

// ------------------------------------------------
// Write Task
// ------------------------------------------------
task automatic write_data(input logic [DATA_WIDTH-1:0] data);
    begin
        @(negedge clk);
        wr_en = 1;
        rd_en = 0;
        din = data;

        @(negedge clk);
        wr_en = 0;
        din = 0;
        $display("[%0t] WRITE: data = %0h", $time, data);
    end
endtask

// ------------------------------------------------
// Read Task
// ------------------------------------------------
task automatic read_data(input logic [DATA_WIDTH-1:0] expected_data);
    begin
        @(negedge clk);
        wr_en = 0;
        rd_en = 1;
        
        @(posedge clk);
        #1;
        test_count++;

        if (dout != expected_data) begin
            $display("ERROR: expected_data: %0d | dout: %0d", expected_data, dout);
            error_count++;
        end
        else 
            $display("[%0t] READ PASS: data = %0h", $time, dout);

        @(negedge clk);
        rd_en = 0;
    end
endtask

// ------------------------------------------------
// Check Full
// ------------------------------------------------
task automatic check_full(input logic expected_full);
    begin
        #1;
        test_count++;

        if (full !== expected_full) begin
            $error("ERROR: expected_full: %0b | actual_full: %0b", expected_full, full);
            error_count++;
        end
        else begin
            $display("FULL CHECK PASS: full: %0b", full);
        end
    end
endtask

// ------------------------------------------------
// Check Empty
// ------------------------------------------------
task automatic check_empty(input logic expected_empty);
    begin
        #1;
        test_count++;

        if (empty !== expected_empty) begin
            $error("ERROR: expected_empty: %0b | actual_empty: %0b", expected_empty, empty);
            error_count++;
        end
        else begin
            $display("EMPTY CHECK PASS: empty: %0b", empty);
        end
    end
endtask

// ------------------------------------------------
// Main Test Sequence
// ------------------------------------------------
initial begin

    $display("------------------------------------");
    $display(" FIFO BASIC TEST");
    $display("------------------------------------");

    // ------------------------------------------------
    // Test 1: Reset
    // ------------------------------------------------
    apply_reset();
    check_empty(1'b1);
    check_full(1'b0);

    // ------------------------------------------------
    // Test 2: Single Write / Single Read
    // ------------------------------------------------
    write_data(8'hA5);
    check_empty(1'b0);
    check_full(1'b0);

    read_data(8'hA5);
    check_empty(1'b1);

    // ------------------------------------------------
    // Test 3: Fill FIFO
    // ------------------------------------------------
    write_data(8'h11);
    write_data(8'h22);
    write_data(8'h33);
    write_data(8'h44);
    check_full(1'b1);
    check_empty(1'b0);

    // ------------------------------------------------
    // Test 4: Write While Full
    // ------------------------------------------------
    write_data(8'h55);
    check_full(1'b1);
    check_empty(1'b0);

    // ------------------------------------------------
    // Test 5: Read FIFO Contents
    // ------------------------------------------------
    read_data(8'h11);
    read_data(8'h22);
    read_data(8'h33);
    read_data(8'h44);
    check_empty(1'b1);

    // ------------------------------------------------
    // Test 6: Read While Empty
    // ------------------------------------------------
    read_data(8'h44);
    check_empty(1'b1);

    // ------------------------------------------------
    // Test 7: Reset During Active Operation
    // ------------------------------------------------
    write_data(8'haa);
    write_data(8'hbb);
    apply_reset();
    check_empty(1'b1);
    check_full(1'b0);

    // Final Report
    $display("------------------------------------");
    $display(" TEST SUMMARY");
    $display(" Tests  : %0d", test_count);
    $display(" Errors : %0d", error_count);
    $display("------------------------------------");


    if (error_count == 0)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    $finish;

end

endmodule