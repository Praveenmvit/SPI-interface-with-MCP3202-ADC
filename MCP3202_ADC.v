module mcp3202_slave(spi_clk,cs,din,dout);
  
  input spi_clk,cs,din;
  output reg dout;
  bit [4:0] count;  
  bit sgl_diff,odd_sign,msbf;
  
  reg [11:0] adc_data = 12'haaf; // adc data need to send to spi controller
  
  typedef enum bit[1:0] {IDLE, CONFIG, SEND} fsm;
  fsm state;
  
  always @(negedge spi_clk) begin
    
    case(state) 
      IDLE: begin
        if(cs == 0 && count ==0) begin
          state <= CONFIG;
          count <= count + 1;
        end
        else
          state <= IDLE;
      end
      CONFIG: begin
        if(count == 5'd1) 
          sgl_diff <= din;
        else if(count == 5'd2) 
          odd_sign <= din;
        else if(count == 5'd3)
          msbf <= din;
        else begin
          state <= SEND;
          dout <= 0;
        end
        count <= count + 1;
      end
      
      SEND: begin
        if(count < 5'd17) begin // sending msb
          dout <= adc_data[11-(count-5)];
          state <= SEND;
          count <= count + 1;
        end
        else if(msbf == 0 && count > 5'd16 && count <5'd28) begin // sending lsb
          dout <= adc_data[count-16];
           state <= SEND;
           count <= count + 1;
        end
        else begin
          state <= IDLE;
          count <= 0;
        end
      end
      
    endcase
  end
endmodule
