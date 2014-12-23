module uart(
   input          clk,
   input          rst_n,
   input          transmit,   // Raise to trasmit
   input    [7:0] data_tx,    // Transmit this
   input          rx,
   output         busy_tx,
   output         recieved,   // Raised when byte recieved, zero when getting
   output   [7:0] data_rx,    // This is recieved
   output         tx
);

   // Outputs
   reg         recieved;
   reg         tx;
   reg [7:0]   data_rx;  
   

   // Internal Regs
   reg [3:0]   bitcount_tx;        
   reg [3:0]   bitcount_rx;
   reg [7:0]   shifter_tx;
   reg [7:0]   shifter_rx;
   
   reg [8:0]  count;
   reg ser_clk;
 
   // Info from regs
   wire busy_tx      = |bitcount_tx[3:1];
   wire sending      = |bitcount_tx;
   wire busy_rx      = |bitcount_rx[3:1];
   wire recieving    = |bitcount_rx;
     
   // Serial clock generation - 115200 baud = 50MHz/434
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
         shifter_rx     <= 0;
         data_rx        <= 0;      
         bitcount_rx    <= 0;
         recieved       <= 0;
      end else begin
         if(ser_clk) begin
            if(!rx & ~busy_rx) begin
               shifter_rx     <= 0;       // for debugging only
               bitcount_rx    <= 8;       // Bits coming in
               recieved       <= 0;       // Busy
            end
            if(recieving) begin
               shifter_rx     <= {rx,shifter_rx[7:1]};   // Shift in bits
               bitcount_rx    <= bitcount_rx - 1;
               if(bitcount_rx == 1) begin
                  data_rx     <= {rx,shifter_rx[7:1]};   // Done
                  recieved    <= 1;
               end
            end
         end
      end
   end
  

   // UART TX
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         tx          <= 1; // Line high when nothing
         bitcount_tx <= 0;
         shifter_tx  <= 0;
      end else begin  
         if (transmit & ~busy_tx) begin   // New byte
            shifter_tx  <= data_tx[7:0];
            bitcount_tx <= 10; 
         end  
         
         if (sending & ser_clk) begin     // shift out bits
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
