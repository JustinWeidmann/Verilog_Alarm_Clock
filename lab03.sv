module lab03(
    input logic rst,
    input logic clk,

    input logic timeSet,
    input logic upHour,
    input logic upMin,

    output logic secBlink,
    input logic debug,

	input logic alarmSet,
    output logic alarmLED,
    input logic alarmClear,

    output logic [6:0] hex0,
    output logic [6:0] hex1,
    output logic [6:0] hex2,
    output logic [6:0] hex3
);
    logic [26:0] count50;
	logic [26:0] countFast;
    logic [5:0] countMin;
    logic onceler;
    logic oneMin;
    logic oneHour;
	logic [7:0] timeMin;
	logic [7:0] timeHour;
	 
	logic incMin;
	logic incHour;
	 
	logic incAlarmMin;
	logic incAlarmHour;
	 
	logic alarmOn;
	logic wasAlarm;
	logic [7:0] alarmMin;
	logic [7:0] alarmHour;
	 
	logic [6:0] clockHex0;
    logic [6:0] clockHex1;
    logic [6:0] clockHex2;
    logic [6:0] clockHex3;
	 
	logic [6:0] alarmHex0;
    logic [6:0] alarmHex1;
    logic [6:0] alarmHex2;
    logic [6:0] alarmHex3;

	 // Clock
	 counter13 #(100_000) fastCount(.clk, .rst(!rst), .inc(1'b1), .dec(1'b0), .cnt(countFast));
    counter13 #(50_000_000) bigCout50(.clk, .rst(!rst), .inc(1'b1), .dec(1'b0), .cnt(count50));
	 assign onceler = debug? (countFast=='0):(count50=='0);

    counter13 #(60) minCount(.clk, .rst(!rst), .inc(onceler), .dec(1'b0), .cnt(countMin));
    assign oneMin = (countMin==5'd59);
    assign oneHour = ((timeMin==7'd59) && oneMin);
	 
	 // Set Time
	 assign incMin = ((!timeSet && oneMin) || (timeSet && !upMin && upHour));
	 assign incHour = ((!timeSet && oneHour) || (timeSet && !upHour && upMin));

    timePiece #(59) min(.clk, .rst, .onceler, .inc(incMin), .dec(1'b0), .hex0(clockHex0), .hex1(clockHex1), .masterCout(timeMin));
    timePiece #(24) hour(.clk, .rst, .onceler, .inc(incHour), .dec(1'b0), .hex0(clockHex2), .hex1(clockHex3), .masterCout(timeHour));
	 
	 assign secBlink = ((countMin%2) == 0);
	 
	 // Alarm Time
	 assign incAlarmMin = (alarmSet && !upMin && upHour);
	 assign incAlarmHour = (alarmSet && !upHour && upMin);
	 
	 timePiece #(59) alarmTimeMin(.clk, .rst, .onceler, .inc(incAlarmMin), .dec(1'b0), .hex0(alarmHex0), .hex1(alarmHex1), .masterCout(alarmMin));
    timePiece #(24) alarmTimeHour(.clk, .rst, .onceler, .inc(incAlarmHour), .dec(1'b0), .hex0(alarmHex2), .hex1(alarmHex3), .masterCout(alarmHour));
	 
	 // Switch Display Modes
	 assign hex0 = alarmSet? alarmHex0:clockHex0;
	 assign hex1 = alarmSet? alarmHex1:clockHex1;
	 assign hex2 = alarmSet? alarmHex2:clockHex2;
	 assign hex3 = alarmSet? alarmHex3:clockHex3;
	  
	 // Alarm
	 mydff #(1) keepAlarmOn(.clk, .rst(!rst), .en(1'b1), .d(alarmOn), .q(wasAlarm));
	 assign alarmOn = ((timeMin == alarmMin) && (timeHour == alarmHour) || (wasAlarm && alarmClear));
	 assign alarmLED = (secBlink && alarmOn);

endmodule