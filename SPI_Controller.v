timescale 1us/1us // make clk frequence 1MHZ

module spi_controller(start,clk,miso,sgl_diff,odd_sign,msb_lsb,mosi,cs,spi_clk,adc_data);
  
  input start,clk,miso,sgl_diff,odd_sign,msb_lsb;
  output reg cs;
  output bit spi_clk,mosi;
  
  output reg [11:0] adc_data;
  
  bit [3:0] count;
  bit [4:0] wait_count;
  
  typedef enum bit[2:0] {IDLE,SGL_DIFF,ODD_SIGN,MSBF,NULL,WAIT} fsm;
  fsm state;  
  
  always @(posedge clk) begin
    if(start) begin
      state <= IDLE;
      cs <= 1;
      spi_clk <= 0;
    end
    else begin
      if(count == 4'd9) begin
        spi_clk <= ~spi_clk; // spi clk = 5 KHZ
        count <= 4'd0;
       end
      count <= count + 1;
    end
  end
  
    
  
  always @(negedge spi_clk) begin
    case(state)
      IDLE: begin
          cs <= 0;
          mosi <= 1;
          state <= SGL_DIFF;
      end
      
      
      SGL_DIFF: begin
        mosi <= sgl_diff;
        state <= ODD_SIGN;
      end
      
      ODD_SIGN: begin
        mosi <= odd_sign;
        state <= MSBF;
      end
      
      MSBF: begin
        mosi <= msb_lsb;
        state <= NULL;
      end
      
      NULL: begin
        state <= WAIT;
      end
      
      WAIT: begin
        if(msb_lsb == 1) begin // for most significant bit first receiving
          if(wait_count < 5'd14) begin
            adc_data[11:0] <= {adc_data[10:0],miso};
            wait_count <= wait_count + 1;
            state <= WAIT;
          end
                     
          if(wait_count == 5'd14) begin
            wait_count <= 0;
            cs <= 1;
            state <= IDLE;
          end
        end
        else begin // for least significant bit receiving
          if(wait_count > 5'd12 && wait_count < 5'd25) begin
            adc_data[11:0] <= {miso,adc_data[11:1]};
            state <= WAIT;
          end
                            
          if(wait_count == 5'd25) begin
            wait_count <= 0;
            cs <= 1;
            state <= IDLE;
          end
          wait_count <= wait_count + 1;
        end
      end
      
    endcase
  end
endmodule
