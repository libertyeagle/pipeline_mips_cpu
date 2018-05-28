module reg_file(
	input clk,
	input rst_n,
	input [4:0] rAddr,
	output [31:0] rDout,
	input [4:0] rAddr2,
	output [31:0] rDout2,
	input [4:0] wAddr,
	input [31:0] wIn,
	input wEna
);
	reg [31:0] data [31:0];
	integer i;

	assign rDout = (rAddr)? data[rAddr] : 32'b0;
	assign rDout2 = (rAddr2) ? data[rAddr2] : 32'b0;
	// register 0 is always zero ($zero)
	
	always @(posedge clk or negedge rst_n)
	begin
		if (~rst_n)
		begin
			for (i = 0; i < 32; i = i + 1)
			begin
				data[i] <= 32'h00000000;
			end
		end
		else if (wEna)
		begin
			data[wAddr] <= wIn;
		end
	end

endmodule
