module Edge(
	input wire			nReset,                                                      // Common to all
	input wire			Clk,    
   input wire        en,
	input wire 	[7:0]	PixelIn,	
	output reg	[7:0]	PixelOut
);

	// Buffer must be equal to or larger than the width of the image
	parameter BUFF = 300;
	parameter Width = 100;

   // Buffer
	reg [5:0] 	pixelDelay	[BUFF:0];
	
  	// Pipe for pixels and extra for control lines 
	generate
		genvar j;
		for (j=0; j < BUFF; j = j + 1) begin : delay_pixel
	      always @(posedge Clk) begin
				if(en) pixelDelay[j+1] <= 	pixelDelay[j];
         end
	    end
	endgenerate

   
      
   // Accumuate templates
   reg [4:0]      horz_bottom;
   reg [5:0]      horz_middle;
   reg [4:0]      horz_top;
   
   reg [4:0]      vert_left;
   reg [5:0]      vert_middle;
   reg [4:0]      vert_right;
   
   // Point at buffer
   wire [8:0]     Width2;

   assign Width2 = Width << 1;
   
   always @ (posedge Clk) begin
      if(en) begin
         // In
         pixelDelay[0] <= PixelIn >> 2; 
         
         // horz
         if(pixelDelay[BUFF] > pixelDelay[BUFF-2])                horz_bottom <=    (pixelDelay[BUFF] - pixelDelay[BUFF-2])            >> 1; 
         else                                                     horz_bottom <=    (pixelDelay[BUFF-2] - pixelDelay[BUFF])            >> 1; 
         
         if(pixelDelay[BUFF-Width] > pixelDelay[BUFF-Width-2])    horz_middle <=    (pixelDelay[BUFF-Width] - pixelDelay[BUFF-Width-2])   >> 0; 
         else                                                     horz_middle <=    (pixelDelay[BUFF-Width-2] - pixelDelay[BUFF-Width])   >> 0; 
         
         if(pixelDelay[BUFF-Width2] > pixelDelay[BUFF-Width2-2])  horz_top <=    (pixelDelay[BUFF-Width2] - pixelDelay[BUFF-Width2-2])    >> 1; 
         else                                                     horz_top <=    (pixelDelay[BUFF-Width2-2] - pixelDelay[BUFF-Width2])    >> 1; 
         
         // vert
         if(pixelDelay[BUFF] > pixelDelay[BUFF-Width2])           vert_right <=  (pixelDelay[BUFF] - pixelDelay[BUFF-Width2])          >> 1; 
         else                                                     vert_right <=  (pixelDelay[BUFF-Width2] - pixelDelay[BUFF])          >> 1;
         
         if(pixelDelay[BUFF-1] > pixelDelay[BUFF-Width2-1])       vert_middle <=    (pixelDelay[BUFF-1] - pixelDelay[BUFF-Width2-1])      >> 0;
         else                                                     vert_middle <=    (pixelDelay[BUFF-Width2-1] - pixelDelay[BUFF-1])      >> 0;    
         
         if(pixelDelay[BUFF-2] > pixelDelay[BUFF-Width2-2])       vert_left <=   (pixelDelay[BUFF-2] - pixelDelay[BUFF-Width2-2])      >> 1; 
         else                                                     vert_left <=   (pixelDelay[BUFF-Width2-2] - pixelDelay[BUFF-2])      >> 1; 
         
         // Out
         PixelOut <= horz_bottom + horz_middle + horz_top + vert_left + vert_middle + vert_right;      
      end
   end
endmodule
