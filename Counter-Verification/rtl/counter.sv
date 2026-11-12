module counter #(
    parameter integer WIDTH = 4
) (
    input  logic clk,
    input  logic reset,
    input  logic enable,

    output logic [((WIDTH >= 1) ? WIDTH : 1)-1:0] count
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) begin
            $fatal(1, "ERROR: WIDTH must be >= 1. Received WIDTH=%0d", WIDTH);
        end
    end

    // Counter functionality
    always_ff @(posedge clk) begin

        if (reset)
            count <= '0;

        else if (enable)
            count <= count + 1'b1;

    end

endmodule