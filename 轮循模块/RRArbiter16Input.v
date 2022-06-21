
`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////
// Company:        CETC54
// Engineer:       Li Yuan
//
// Modify Date:    16:42:37 07/04/2011
// Design Name:
// Module Name:    RRArbiter8Input
// Project Name:
// Target Devices:
// Tool versions:
//
// Description:
//    Round Robin总线仲裁器，对输入的18个请求qvRequest进行轮询仲裁，给出结果qvGrant
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
//    Round Robin总线仲裁器仲裁出结果需要两个时钟周期，两次请求仲裁之间需要一个时钟周期间隔：
//    clock:             __    __    __    __    __    __    __    __    __
//                    __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__
//    qvRequest :           _____              _____
//                    _____/     \____________/     \_________________________
//                         \_____/            \_____/
//    qvGrant:                          _____
//                    _________________/     \________________________________
//                                     \_____/
//    qvGrantIndex:                     _____
//                    _________________/     \________________________________
//                                     \_____/
//
//////////////////////////////////////////////////////////////////////////////////////////////////


module RRArbiter16Input(
   input  wire       clock,
   input  wire       nReset,
   input  wire       qArbitEnable,
   input  wire [15:0] qvRequest,          //请求
   output reg  [15:0] qvGrant = 0,        //授权
   output reg  [3:0] qvGrantIndex = 0    //授权号的下标
);

   reg   [3:0] qvNextRoundStartIndex = 0;       //记录一轮仲裁起始编号

   reg   [15:0] qvGrantReg;

   always @ ( posedge clock ) begin
      if ( ~nReset ) begin
         qvGrantReg <= 0;
      end
      else begin
         case (qvNextRoundStartIndex)
           0: begin
               qvGrantReg[0] <= qArbitEnable && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:0] == 16'b1000000000000000);
               end
           1: begin
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:1] == 1'b1);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:1] == 2'b10);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:1] == 3'b100);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:1] == 4'b1000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:1] == 5'b10000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:1] == 6'b100000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:1] == 7'b1000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:1] == 8'b10000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:1] == 9'b100000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:1] == 10'b1000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:1] == 11'b10000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:1] == 12'b100000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:1] == 13'b1000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:1] == 14'b10000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:1] == 15'b100000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:1] == 15'b000000000000000) && (qvRequest[0:0] == 1'b1);
               end
           2: begin
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:2] == 1'b1);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:2] == 2'b10);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:2] == 3'b100);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:2] == 4'b1000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:2] == 5'b10000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:2] == 6'b100000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:2] == 7'b1000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:2] == 8'b10000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:2] == 9'b100000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:2] == 10'b1000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:2] == 11'b10000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:2] == 12'b100000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:2] == 13'b1000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:2] == 14'b10000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:2] == 14'b00000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:2] == 14'b00000000000000) && (qvRequest[1:0] == 2'b10);
               end
           3: begin
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:3] == 1'b1);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:3] == 2'b10);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:3] == 3'b100);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:3] == 4'b1000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:3] == 5'b10000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:3] == 6'b100000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:3] == 7'b1000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:3] == 8'b10000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:3] == 9'b100000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:3] == 10'b1000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:3] == 11'b10000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:3] == 12'b100000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:3] == 13'b1000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:3] == 13'b0000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:3] == 13'b0000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:3] == 13'b0000000000000) && (qvRequest[2:0] == 3'b100);
               end
           4: begin
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:4] == 1'b1);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:4] == 2'b10);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:4] == 3'b100);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:4] == 4'b1000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:4] == 5'b10000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:4] == 6'b100000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:4] == 7'b1000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:4] == 8'b10000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:4] == 9'b100000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:4] == 10'b1000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:4] == 11'b10000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:4] == 12'b100000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:4] == 12'b000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:4] == 12'b000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:4] == 12'b000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:4] == 12'b000000000000) && (qvRequest[3:0] == 4'b1000);
               end
           5: begin
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:5] == 1'b1);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:5] == 2'b10);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:5] == 3'b100);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:5] == 4'b1000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:5] == 5'b10000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:5] == 6'b100000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:5] == 7'b1000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:5] == 8'b10000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:5] == 9'b100000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:5] == 10'b1000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:5] == 11'b10000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:5] == 11'b00000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:5] == 11'b00000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:5] == 11'b00000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:5] == 11'b00000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:5] == 11'b00000000000) && (qvRequest[4:0] == 5'b10000);
               end
           6: begin
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:6] == 1'b1);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:6] == 2'b10);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:6] == 3'b100);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:6] == 4'b1000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:6] == 5'b10000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:6] == 6'b100000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:6] == 7'b1000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:6] == 8'b10000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:6] == 9'b100000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:6] == 10'b1000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:6] == 10'b0000000000) && (qvRequest[5:0] == 6'b100000);
               end
           7: begin
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:7] == 1'b1);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:7] == 2'b10);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:7] == 3'b100);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:7] == 4'b1000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:7] == 5'b10000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:7] == 6'b100000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:7] == 7'b1000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:7] == 8'b10000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:7] == 9'b100000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:7] == 9'b000000000) && (qvRequest[6:0] == 7'b1000000);
               end
           8: begin
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:8] == 1'b1);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:8] == 2'b10);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:8] == 3'b100);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:8] == 4'b1000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:8] == 5'b10000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:8] == 6'b100000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:8] == 7'b1000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:8] == 8'b10000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:8] == 8'b00000000) && (qvRequest[7:0] == 8'b10000000);
               end
           9: begin
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:9] == 1'b1);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:9] == 2'b10);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:9] == 3'b100);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:9] == 4'b1000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:9] == 5'b10000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:9] == 6'b100000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:9] == 7'b1000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:9] == 7'b0000000) && (qvRequest[8:0] == 9'b100000000);
               end
           10: begin
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:10] == 1'b1);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:10] == 2'b10);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:10] == 3'b100);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:10] == 4'b1000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:10] == 5'b10000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:10] == 6'b100000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:10] == 6'b000000) && (qvRequest[9:0] == 10'b1000000000);
               end
           11: begin
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:11] == 1'b1);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:11] == 2'b10);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:11] == 3'b100);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:11] == 4'b1000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:11] == 5'b10000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[15:11] == 5'b00000) && (qvRequest[10:0] == 11'b10000000000);
               end
           12: begin
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:12] == 1'b1);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:12] == 2'b10);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:12] == 3'b100);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:12] == 4'b1000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[15:12] == 4'b0000) && (qvRequest[11:0] == 12'b100000000000);
               end
           13: begin
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:13] == 1'b1);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:13] == 2'b10);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:13] == 3'b100);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[15:13] == 3'b000) && (qvRequest[12:0] == 13'b1000000000000);
               end
           14: begin
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:14] == 1'b1);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:14] == 2'b10);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[15:14] == 2'b00) && (qvRequest[13:0] == 14'b10000000000000);
               end
           default: begin
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:15] == 1'b1);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[15:15] == 1'b0) && (qvRequest[14:0] == 15'b100000000000000);
                 end
           endcase
      end
   end

   //qvNextRoundScanOrder
   always @ ( posedge clock ) begin
      if ( ~nReset ) begin
         qvNextRoundStartIndex <= 0;
      end
      else begin
         qvNextRoundStartIndex <= (qvGrantIndex == 15)? 0 : (qvGrantIndex + 1);
      end
   end


//////////////////////////////////////////////// 端口输出 ///////////////////////////////
   
   //qvGrant
   always @ ( posedge clock ) begin
      qvGrant <= qvGrantReg;
   end

   //qvGrantIndex
   always @ ( posedge clock ) begin
       case( qvGrantReg )
        16'b0000000000000001: qvGrantIndex<= 0;
        16'b0000000000000010: qvGrantIndex<= 1;
        16'b0000000000000100: qvGrantIndex<= 2;
        16'b0000000000001000: qvGrantIndex<= 3;
        16'b0000000000010000: qvGrantIndex<= 4;
        16'b0000000000100000: qvGrantIndex<= 5;
        16'b0000000001000000: qvGrantIndex<= 6;
        16'b0000000010000000: qvGrantIndex<= 7;
        16'b0000000100000000: qvGrantIndex<= 8;
        16'b0000001000000000: qvGrantIndex<= 9;
        16'b0000010000000000: qvGrantIndex<= 10;
        16'b0000100000000000: qvGrantIndex<= 11;
        16'b0001000000000000: qvGrantIndex<= 12;
        16'b0010000000000000: qvGrantIndex<= 13;
        16'b0100000000000000: qvGrantIndex<= 14;
        16'b1000000000000000: qvGrantIndex<= 15;
        default:              qvGrantIndex<= qvGrantIndex;
       endcase
   end
//////////////////////////////////////////////////////////////////////////////////////////////

endmodule

