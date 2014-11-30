`timescale 1ns/1ns

module tb;
    


   parameter CLK_PERIOD = 5;          // 100MHz clock - 10ns period  

   reg      nReset;
   reg      clk;
   wire     r;
   wire     g;
   wire     b;

	vga vga(
      .nReset  (nReset),
		.clk     (clk),
      .r       (r),
		.g		   (g),
		.b		   (b),
		.vs      (vs),
	   .hs      (hs)
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
		#100 nReset = 0;
		#100 nReset = 1;

      #1000
	   $finish;
	end





endmodule

