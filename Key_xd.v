module Key_xd(
       CLK,
       reset_n,
       key,
       p_signal,
       r_signal,
       xd_waveform
);
       input CLK;
       input reset_n;
       input key;
       output reg p_signal;
       output reg r_signal;
       output reg xd_waveform;
       reg trigger0;
       reg trigger1;
       reg r_key;
       wire d_time;
       wire K_posedge;
       wire K_negedge;
       reg [1:0] state;
       reg [29:0] counter0;
       parameter MCNT0=1_000_000-1;
       //×´Ì¬»ú
       localparam IDLE=0;
       localparam P_filter=1;
       localparam wait_r=2;
       localparam r_filter=3;
       
assign d_time=counter0>=MCNT0;

//´¦ÀíÑÇÎÈÌ¬
always@(posedge CLK)
     trigger0<=key;
always@(posedge CLK)
     trigger1<=trigger0;
always@(posedge CLK)
     r_key<=trigger1;   

assign K_posedge=((r_key==0) && (trigger1==1));
assign K_negedge=((r_key==1) && (trigger1==0));

always@(posedge CLK or negedge reset_n)
       if(!reset_n)begin
           state<=IDLE;
           counter0<=0;
           p_signal<=1'd0;
           r_signal<=1'd0;
           xd_waveform<=1'd1;
       end
       else begin
          case(state)
             IDLE:
              begin
                r_signal<=1'd0;
                if(K_negedge==1)
                    state<=P_filter;
              end
             P_filter:
                if(d_time==1)begin
                    state<=wait_r;  
                    p_signal<=1'd1;
                    xd_waveform<=1'd0;
                    counter0<=0;
                end
                else if(K_posedge==1)begin
                    state<=IDLE;
                    counter0<=0;
                end
                else begin
                    state<=state;
                    counter0<=counter0+1'd1;
                end
            wait_r:
                begin
                   p_signal<=1'd0;
                   if(K_posedge==1)
                       state<=r_filter;
                end
            r_filter:
                if(d_time==1)begin
                   state<=IDLE;
                   r_signal<=1'd1;
                   xd_waveform<=1'd1;
                   counter0<=0;
                end
                else if(K_negedge==1)begin
                    state<=wait_r;
                    counter0<=0;
                end
                else begin
                    counter0<=counter0+1'd1;
                    state<=state;
                end
              default:begin
                  state<=IDLE;
                  waveform<=1'd1;
                  r_signal<=0;
                  p_signal<=0;
                  cnt<=0;
              end
            endcase
        end
endmodule
