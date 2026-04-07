`timescale 1ns / 1ps
module Key_xd_tb();
       reg CLK;
       reg reset_n;
       reg key;
       wire p_signal;
       wire r_signal;
       wire xd_waveform;
Key_xd Key_xd_inst(
       .CLK(CLK),
       .reset_n(reset_n),
       .key(key),
       .p_signal(p_signal),
       .r_signal(r_signal),
       .xd_waveform(xd_waveform)
);
initial CLK=1;
always #10 CLK=~CLK;
initial begin
reset_n=0;
#201;
reset_n=1;
//第一次
key=1;  #150_000_000;

key=0;  #15_000_000;
key=1;  #2_000_000;
key=0;  #20_000_000;
key=0;  #50_000_000;

key=1;  #3_000_000;
key=0;  #4_000_000;
key=1;  #20_000_000;
key=1;  #50_000_000;
//第二次
key=1;  #150_000_000;

key=0;  #10_000_000;
key=1;  #4_000_000;
key=0;  #2_000_000;
key=1;  #3_000_000;
key=0;  #20_000_000;
key=0;  #50_000_000;

key=1;  #5_000_000;
key=0;  #2_000_000;
key=1;  #20_000_000;
key=1;  #50_000_000;

$stop;
end
endmodule
