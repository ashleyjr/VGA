module vga(
   input          clk_25,
   input          rst_n,
   output [4:0]   red,
   output [4:0]   green,
   output [4:0]   blue,
   output         hsync,
   output         vsync
);

   reg   [4:0]    red;
   reg   [4:0]    green;
   reg   [4:0]    blue;
   reg            hsync;
   reg            vsync;

   reg   [10:0]   h_count;
   reg   [10:0]   v_count;
   
   always@(posedge clk_25 or negedge rst_n) begin
      if(!rst_n) begin
         red   <= 0;
         green <= 0;
         blue  <= 0;
         hsync <= 1;
         vsync <= 1;
         h_count <= 0;
         v_count <= 0;
      end else begin

         // SYnc gerneration
         case(h_count)
            11'd660: begin
                        h_count <= h_count + 1;
                        hsync <= 0;
                     end
            11'd756: begin
                        h_count <= h_count + 1;
                        hsync <= 1;
                     end
            11'd800: begin
                        h_count <= 0;
                        if(v_count == 11'd525) begin
                           v_count <= 0;
                        end else begin
                            v_count <= v_count + 1;
                        end
                     end
            default: begin
                        h_count <= h_count + 1;
                     end
         endcase
         case(v_count)
            11'd494: vsync <= 0;
            11'd495: vsync <= 1; 
         endcase


         // Pixel generation
         red   <= red + 1;
         green <= green + 1;
         blue  <= blue + 1;
      end
   end

endmodule
