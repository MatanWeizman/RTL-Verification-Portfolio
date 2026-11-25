module fifo #(
    parameter int unsigned DATA_WIDTH = 8,
    parameter int unsigned FIFO_DEPTH = 16
)(
    input   logic                   clk,
    input   logic                   reset, 

    input   logic                   wr_en,
    input   logic                   rd_en,

    input   logic [DATA_WIDTH-1:0]  din,

    output  logic [DATA_WIDTH-1:0]  dout,
    output  logic                   full,
    output  logic                   empty
);

    // ------------------------------------------------
    // Internal Parameters
    // ------------------------------------------------
    localparam int PTR_WIDTH = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH);
    localparam int COUNT_WIDTH = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH + 1);

    // ------------------------------------------------
    // Internal Storage
    // ------------------------------------------------
    logic [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // ------------------------------------------------
    // Internal Pointers and Occupancy Counter
    // ------------------------------------------------
    logic [PTR_WIDTH-1:0] write_ptr;
    logic [PTR_WIDTH-1:0] read_ptr;
    logic [COUNT_WIDTH-1:0] count;

    // ------------------------------------------------
    // Accepted Operations
    // ------------------------------------------------
    logic do_write;
    logic do_read;

    // ------------------------------------------------
    // Status Flags
    // ------------------------------------------------
    assign empty = (count == '0);
    assign full = (count == COUNT_WIDTH'(FIFO_DEPTH));

    // ------------------------------------------------
    // Operation Acceptance
    // ------------------------------------------------
    assign do_write = wr_en && !full;
    assign do_read = rd_en && !empty;

    // ------------------------------------------------
    // Sequential Logic
    // ------------------------------------------------
    always_ff @(posedge clk) begin

        // --------------------------------------------
        // Synchronous Reset
        // --------------------------------------------
        if (reset) begin
            write_ptr <= '0;
            read_ptr <= '0;
            count <= '0;
            dout <= '0;
        end
        
        else begin  

            // ----------------------------------------
            // Write Operation
            // ----------------------------------------
            if (do_write) begin
                mem[write_ptr] <= din;

                if (write_ptr == PTR_WIDTH'(FIFO_DEPTH - 1))
                     write_ptr <= '0;   // wrap-around
                else
                    write_ptr <= write_ptr + 1'b1;
            end

            // ----------------------------------------
            // Read Operation
            // ----------------------------------------
            if (do_read) begin
                dout <= mem[read_ptr];

                if (read_ptr == PTR_WIDTH'(FIFO_DEPTH - 1))
                    read_ptr <= '0;     // wrap-around
                else
                    read_ptr <= read_ptr + 1'b1;               
            end

            // ----------------------------------------
            // Occupancy Counter Update
            // ----------------------------------------
            case ({do_write, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count; 
            endcase
        end
    end

endmodule