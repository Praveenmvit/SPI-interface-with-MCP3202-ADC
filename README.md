# SPI-interface-with-MCP3202-ADC
hello
https://www.edaplayground.com/x/hZj4  
Project:  
Designed an SPI controller in Verilog to interface with the MCP3202 ADC, which samples analog input signals and converts them into 12-bit digital values. The converted data is received by the FPGA through this SPI controller.  
  
![image](https://github.com/user-attachments/assets/3181e7d5-dafb-475a-9e7a-e7c38bbefc34)  

                 MCP3202  
DIN - input from spi controller(mosi).  
DOUT - output from MCP3202 ADC output given to spi controller miso pin. 
  
![image](https://github.com/user-attachments/assets/a3b844dc-694e-467d-9af2-b08a2709965b)  
  
In the above waveform after chipselect (cs)' is made zero. the configuration bits are sent from spi controller to MCP3202 after sending start bit.  
  
![image](https://github.com/user-attachments/assets/158c20ae-39dc-4072-a82e-fa706cec6286)  
  
The MSBF define whether Most significant bit need to be send first from ADC or least significant bit from ADC.  
Below is the waveform if MSBF=0 first.    
  
![image](https://github.com/user-attachments/assets/02bb8553-38f4-44f6-ae77-eb91c61f98ac)  
  
In the tb.v code this configuration are hard coded.




