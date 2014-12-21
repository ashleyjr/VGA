module uart(
   input          clk,
   input          rst_n,
   input          transmit,   // Raise to trasmit
   input    [7:0] data_tx,    // Transmit this
   input          rx,
   output   [7:0] data_rx,    // This is recieved
   output         tx
);

    
   reg         tx;
   reg [7:0]   data_rx;  

   reg [3:0]   bitcount_tx;
   reg [3:0]   bitcount_rx;
   reg [7:0]   shifter_tx;
   reg [7:0]   shifter_rx;
   
  
   wire busy_tx      = |bitcount_tx[3:1];
   wire sending      = |bitcount_tx;
   wire busy_rx      = |bitcount_rx[3:1];
   wire recieving    = |bitcount_rx;
    
   reg [9:0]  count;
   reg ser_clk;
  

   // Serial clock generation
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

   //UART RX 
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         shifter_rx  <= 0;
         data_rx     <= 0;      
         bitcount_rx  <= 0;
      end else begin
         if(ser_clk) begin
            if(!rx & ~busy_rx) begin
               shifter_rx <= 0;        // for debugging only
               bitcount_rx <= 8;    
            end
            if(recieving) begin
               shifter_rx  <= {rx,shifter_rx[7:1]};
               bitcount_rx <= bitcount_rx - 1;
               if(bitcount_rx == 1) begin
                  data_rx <= {rx,shifter_rx[7:1]};
               end
            end
         end
      end
   end
   
   // UART TX
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         tx <= 1;
         bitcount_tx <= 0;
         shifter_tx <= 0;
      end else begin
         // just got a new byte
         if (transmit & ~busy_tx) begin
            shifter_tx <= data_tx[7:0];
            bitcount_tx <= 10;
         end
   
         if (sending & ser_clk) begin
            if(bitcount_tx == 10) begin    
               tx <= 0;
            end else begin                    
               { shifter_tx, tx } <= { 1'h1, shifter_tx };
            end
            bitcount_tx <= bitcount_tx - 1;
         end
      end
   end
endmodule
