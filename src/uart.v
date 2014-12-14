module uart(
   input       clk,
   input       rst_n,
   input       transmit,   // Raise to trasmit
   input [7:0] data,       // Transmit this
   input       rx,
   output      tx
);

   reg [3:0] bitcount;
   reg [8:0] shifter;
   reg tx;
   
   wire busy = |bitcount[3:1];
   wire sending = |bitcount;
   
   reg [9:0]  count;
   reg ser_clk;

   always @(posedge clk) begin
      if(!rst_n) begin
         ser_clk  <= 0;
         count    <= 0;
      end else begin
         count    <= count + 1;
         ser_clk  <= 0;
         if(count == 9'd434) begin
            count    <= 0;
            ser_clk  <= 1;
         end
      end
   end

   always @(posedge clk) begin
      if (!rst_n) begin
         tx <= 1;
         bitcount <= 0;
         shifter <= 0;
      end else begin
         // just got a new byte
         if (transmit & ~busy) begin
            shifter <= { data[7:0], 1'h0 };
            bitcount <= (1 + 8 + 2);
         end
   
         if (sending & ser_clk) begin
            { shifter, tx } <= { 1'h1, shifter };
            bitcount <= bitcount - 1;
         end
      end
   end
endmodule
