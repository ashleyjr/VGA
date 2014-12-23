module ram(
   input                clk,
   input       [7:0]    address_in,
   input       [7:0]    data_in, 
   input                write_enable,
   input       [7:0]    address_out,
   output      [7:0]    data_out
);
   reg [7:0] memory [0:255];
   
   always @(posedge clk) begin
      if (write_enable) begin
         memory[address_in] <= data_in;
      end
   end
   
   assign data_out = memory[address_out];

endmodule
