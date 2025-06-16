module tb;
  
  bit start,clk,sgl_diff,odd_sign,msb_lsb;
  wire dout_miso,chipselect,mosi_din,spi_clk;
  wire [11:0] adc_data;
  
  spi_controller master(start,clk,dout_miso,sgl_diff,odd_sign,msb_lsb,mosi_din,chipselect,spi_clk,adc_data);
  
  mcp3202_slave peripheral_interface(spi_clk,chipselect,mosi_din,dout_miso);
  
  always #5 clk=~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
  initial
    begin
      #3 start =1;
      #6 start = 0;
      sgl_diff = 0;
      odd_sign = 1;
      msb_lsb = 1;
      #300;
      @(master.cs);
      $stop;
    end
  
endmodule
