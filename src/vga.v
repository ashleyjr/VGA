module vga(
   input          clk,
   input          rst_n,
   output [4:0]   red,
   output [4:0]   green,
   output [4:0]   blue,
   output         hsync,
   output         vsync
);

   reg   [4:0] red;
   reg   [4:0] green;
   reg   [4:0] blue;
   reg         hsync;
   reg         vsync;

   always@(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         red   <= 0;
         green <= 0;
         blue  <= 0;
         hsync <= 0;
         vsync <= 0;
      end else begin
         red <= red + 1;
         green <= green + 1;
         blue <= blue + 1;
      end
   end

endmodule
