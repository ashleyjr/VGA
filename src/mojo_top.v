module mojo_top(
   input          clk,              // 50 MHz clock input 
   input          rst_n,            // Input from reset button (active low)         
   input          cclk,             // cclk input from AVR, high when AVR is ready
   output   [7:0] led,              // Outputs to the 8 onboard LEDs
   output         spi_miso,         // AVR SPI coneections
   input          spi_ss,
   input          spi_mosi,
   input          spi_sck, 
   output   [3:0] spi_channel,      // AVR ADC channel select
                                    // AVR Serial       
   input          avr_tx,           // AVR Tx => FPGA Rx
   output         avr_rx,           // AVR Rx => FPGA Tx
   input          avr_rx_busy,      // AVR Rx buffer full


                                    // Custom
   
   output   [4:0] red,           // VGA
   output   [4:0] green,
   output   [4:0] blue,
   output         hsync,
   output         vsync,
   
   input          uart_rx,       // UART
   output         uart_tx

);

   // these signals should be high-z when not used
   assign spi_miso = 1'bz;
   assign avr_rx = 1'bz;
   assign spi_channel = 4'bzzzz;
   
   assign led = 8'b0;

   reg   [20:0]   delay;
   reg   [7:0]    count;
   reg            send;
   reg            clk_25;

   // Divide clock by 2
   always@(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         clk_25 <= 0;
      end else begin
         clk_25 <= ~clk_25;
      end
   end

   vga vga(
      .clk_25     (clk_25  ),
      .rst_n      (rst_n   ),
      .red        (red     ),
      .green      (green   ),
      .blue       (blue    ),
      .hsync      (hsync   ),
      .vsync      (vsync   )  
   );

   uart uart(
      .clk        (clk     ),
      .rst_n      (rst_n   ),
      .transmit   (send    ),
      .data       (count   ),
      .rx         (uart_rx ),
      .tx         (uart_tx )
   );
   
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         count <= 0;
         delay <= 0;
         send  <= 0; 
      end else begin
         if(delay == 20'd10000) begin
            count <= count + 1;
            delay <= 0;
            send <= 1;
         end else begin
            delay <= delay + 1;
            send <= 0;
         end
      end   
   end

endmodule
