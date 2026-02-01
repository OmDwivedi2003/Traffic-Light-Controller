`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 22:12:01
// Design Name: 
// Module Name: traffic_light_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module traffic_light_controller(clk,reset,sensor,light_HW,light_FM);

    input clk,reset,sensor; // three inputs 
    output reg [2:0] light_HW,light_FM; // Signals at both highway and Farm
                                    // Highway     Farm
    parameter HGRN_FRED = 2'b00;    //  Green      Red   This is the default state
    parameter HYEL_FRED = 2'b01;    //  Yellow     Red        
    parameter HRED_FGRN = 2'b10;    //  Red        Green 
    parameter HRED_FYEL = 2'b11;    //  Red        Yellow
    
    reg [1:0] present_state,next_state;
    
    // Timer Enable Signals
    reg yel_count1_en, yel_count2_en, red_count_en;
    
    reg [3:0] count_3s1,count_3s2;
    reg [4:0] count_10s;
    
    // delays for both 3seconds and 10seconds
    wire delay3s1, delay3s2, delay10s;
    
    // State register (sequential logic) 
    always @(posedge clk or negedge reset) begin
        if(!reset) present_state<=HGRN_FRED; // if my reset is going from high to low then my Present state will be default state
        else present_state<=next_state; 
        end
    
    always @(*) begin
    next_state = present_state;
    light_HW = 3'b100; // highway in green signal
    light_FM = 3'b001; // farm in red signal
    
    yel_count1_en=0; // yellow counter 1 is enable signal
    yel_count2_en=0; // yellow counter 2 is enable signal
    red_count_en=0; // red counter enable signal
    
    case(present_state)
    
    HGRN_FRED: begin 
                light_HW=3'b100;
                light_FM=3'b001;
                if(sensor) next_state=HYEL_FRED;
                else next_state=HGRN_FRED;
               end
    
    HYEL_FRED: begin
                light_HW=3'b010;
                light_FM=3'b001;
                yel_count1_en=1;
                if(delay3s1) next_state=HRED_FGRN;
                else next_state=HYEL_FRED;
               end
    
    HRED_FGRN: begin
                light_HW=3'b001;
                light_FM=3'b100;
                red_count_en=1;
                if(delay10s) next_state=HRED_FYEL;
                else next_state=HRED_FGRN;
               end

    HRED_FYEL: begin
                light_HW=3'b001;
                light_FM=3'b010;
                yel_count2_en=1;
                if(delay3s2) next_state=HGRN_FRED;
                else next_state=HRED_FYEL;
               end
    
    default: next_state=HGRN_FRED; 
        
    endcase
    end
    
    // 3 seconds timer for 1st yellow signal: 
    always @(posedge clk or negedge reset) begin
        if(!reset) count_3s1<=0;
        else if(yel_count1_en) count_3s1<=count_3s1 + 1;
        else count_3s1<=0;
        end
        
        assign delay3s1 = (count_3s1==4'd5); // 3 seconds
        
    // 3 seconds timer for 2nd yellow signal: 
    always @(posedge clk or negedge reset) begin
        if(!reset) count_3s2<=0;
        else if(yel_count2_en) count_3s2<=count_3s2 + 1;
        else count_3s2<=0;
        end
        
        assign delay3s2 = (count_3s2==4'd3); // 3 seconds
        
    // 10 seconds timer for red signal: 
    always @(posedge clk or negedge reset) begin
        if(!reset) count_10s<=0;
        else if(red_count_en) count_10s<=count_10s + 1;
        else count_10s<=0;
        end
        
        assign delay10s = (count_10s==5'd10); // 10s seconds
        
endmodule

// Testbench for the traffic light controller 

module tb_traffic_light_controller();
    reg clk,reset,sensor;
    wire [2:0] light_HW,light_FM;
    

traffic_light_controller dut(.clk(clk),.reset(reset),.sensor(sensor),.light_HW(light_HW),.light_FM(light_FM));
   
   initial
   clk=0;
   always #1 clk=~clk; 
   
   initial begin 
   
   reset=0;sensor=0;
   
   //hold reset for some time
   #1;
   reset=1;
   
   // wait and observe default state
   #2;
   
   // Vehicle arrives at farm road 
   sensor=1;
   #1;
   sensor=0;
   
   // let full trafic cycle complete 
   // eniugh time to see yello + green + yellow
   #45; 
   
   // another vehicle arrives 
   sensor = 1;
   #1;
   sensor =0;
   // run simulation longer 
   #50;
   $stop;
   
   end
    
endmodule

