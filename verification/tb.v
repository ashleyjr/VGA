`timescale 1ns/1ns

module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  

   reg         clk;
   reg         rst_n;
   wire  [7:0] led;
   wire  [4:0] red;
   wire  [4:0] green;
   wire  [4:0] blue;
   wire        hsync;
   wire        vsync;
   
   mojo_top mojo_top(
      .clk        (clk     ),
		.rst_n      (rst_n   ),
      .led        (led     ),
		.red		   (red     ),
		.green      (green   ),
		.blue       (blue    ),
	   .hsync      (hsync   ),
      .vsync      (vsync   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("TB.vcd");
      $dumpvars(0,tb);
   end
	
   initial begin
		#100 rst_n = 0;
		#100 rst_n = 1;

      #30000000
	   $finish;
	end





endmodule

