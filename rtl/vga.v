module vga(
   input    wire     nReset,
   input    wire     clk,
   output   wire     r,
   output   wire     g,
   output   wire     b,
   output   wire     vs,
   output   wire     hs

);
   reg [9:0]   CounterX;
   reg [8:0]   CounterY;
   reg         vga_vs;
   reg         vga_hs;
   wire CounterXmaxed = (CounterX==767);
   
   always @(posedge clk or negedge nReset) begin
      if(!nReset) begin
         vga_hs <= (CounterX[9:4]==0);    // active for 16 clocks
         vga_vs <= (CounterY==0);         // active for 768 clocks
         if(CounterXmaxed) begin
            CounterX <= 0;
            CounterY <= CounterY + 1;
         end else begin
            CounterX <= CounterX + 1;
         end
      end else begin
         CounterX <= 0;
         CounterY <= 0;
         vga_vs <= 0;
         vga_hs <= 0;
      end
   end
   
   assign hs   = ~vga_hs;
   assign vs   = ~vga_vs;

   assign r = CounterY[3] | (CounterX==256);
   assign g = (CounterX[5] ^ CounterX[6]) | (CounterX==256);
   assign B = CounterX[4] | (CounterX==256);
endmodule
