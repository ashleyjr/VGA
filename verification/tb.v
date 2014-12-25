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
   wire        uart;
   reg         sclk;
   reg         cs;
   reg         mosi;

   mojo_top mojo_top(
      .clk        (clk     ),
		.rst_n      (rst_n   ),
      .led        (led     ),
		.red		   (red     ),
		.green      (green   ),
		.blue       (blue    ),
	   .hsync      (hsync   ),
      .vsync      (vsync   ), 
      .uart_rx    (uart    ),
      .uart_tx    (uart    ),
      .mosi       (mosi    ),
      .miso       (miso    ),
      .sclk       (sclk    ),
      .cs         (cs      )
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
	
   reg [7:0] data;
   initial begin
		#100  rst_n = 0;
		#100  rst_n = 1;
            cs    = 1;
            sclk  = 0;
            mosi  = 0;

      
      data = 8'hAA;
      #62   cs    = 0;
            sclk  = 0;
            mosi  = data[7];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[6];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[5];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[4];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[3];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[2];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[1];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[0];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = 0;
            cs    = 1;





     #1000 
      
      data = 8'h33;
      #62   cs    = 0;
            sclk  = 0;
            mosi  = data[7];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[6];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[5];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[4];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[3];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[2];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[1];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[0];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = 0;
            cs    = 1;





      
      data = 8'hFF;
      #62   cs    = 0;
            sclk  = 0;
            mosi  = data[7];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[6];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[5];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[4];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[3];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[2];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[1];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[0];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = 0;
            cs    = 1;




      #100
      
      data = 8'h00;
      #62   cs    = 0;
            sclk  = 0;
            mosi  = data[7];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[6];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[5];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[4];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[3];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[2];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[1];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = data[0];
      #62   sclk  = 1;
      #62   sclk  = 0;
            mosi  = 0;
            cs    = 1;

      #30000
	   $finish;
	end





endmodule

