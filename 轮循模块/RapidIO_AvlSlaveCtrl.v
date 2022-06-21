/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Monday, the 21 of October, 2019  17:35:13
*Design Name   :
*Module Name   : RapidIO_AvlSlaveCtrl.v
*Project Name  :
*Target Devices: C5
*Tool versions : Quartus II 17.1
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module RapidIO_AvlSlaveCtrl #(
    parameter
    VUHFN12_DEV_ID = 8'd11,
    VUHFN34_DEV_ID = 8'd12,
    JIDS_DEV_ID    = 8'd13,
    KSAT_DEV_ID    = 8'd14,
    APM_DEV_ID     = 8'd18,
    VUHFN12_DRB_DATA = 16'h0003,
    VUHFN34_DRB_DATA = 16'h0004,
    JIDS_DRB_DATA   = 16'h0005,
    KSAT_DRB_DATA   = 16'h0006,
    APM_DRB_DATA    = 16'h0007,
    VUHFN12_BASE_ADDR = 32'h7000_0000,
    VUHFN34_BASE_ADDR = 32'h8000_0000,
    JIDS_BASE_ADDR    = 32'h9000_0000,
    KSAT_BASE_ADDR    = 32'ha000_0000,
    APM_BASE_ADDR     = 32'hb000_0000  
  )(
    input wire RstSys_n,
    input wire SysClk,
    input wire [4:0] CpuPortEn,
    output wire [4:0] Rp_PortEn,
    //Port0  VUHFN_1_2
    input  wire RdQueDFifoEmpty0,
    output wire RdQueDFifoEn0,
    input  wire [65:0] RdQueDFifoData0,
    input  wire RdQueCFifoEmpty0,
    output reg  RdQueCFifoEn0,
    input  wire [31:0] RdQueCFifoData0,
    //Port1  VUHFN_3_4
    input  wire RdQueDFifoEmpty1,
    output wire RdQueDFifoEn1,
    input  wire [65:0] RdQueDFifoData1,
    input  wire RdQueCFifoEmpty1,
    output reg  RdQueCFifoEn1,
    input  wire [31:0] RdQueCFifoData1,
    //Port2  JIDS
    input  wire RdQueDFifoEmpty2,
    output wire RdQueDFifoEn2,
    input  wire [65:0] RdQueDFifoData2,
    input  wire RdQueCFifoEmpty2,
    output reg  RdQueCFifoEn2,
    input  wire [31:0] RdQueCFifoData2,
    //Port3  KSAT
    input  wire RdQueDFifoEmpty3,
    output wire RdQueDFifoEn3,
    input  wire [65:0] RdQueDFifoData3,
    input  wire RdQueCFifoEmpty3,
    output reg  RdQueCFifoEn3,
    input  wire [31:0] RdQueCFifoData3,
    //Port4  APM
    input  wire RdQueDFifoEmpty4,
    output wire RdQueDFifoEn4,
    input  wire [65:0] RdQueDFifoData4,
    input  wire RdQueCFifoEmpty4,
    output reg  RdQueCFifoEn4,
    input  wire [31:0] RdQueCFifoData4,
    
    //Rapid IO Slave Ifc
   output  wire         Rp_s_wr_chipselect,    //       io_write_slave.chipselect
	 output  wire         Rp_s_wr_write,         //                     .write
	 output  wire [29:0]  Rp_s_wr_address,       //                     .address
	 output  reg  [31:0]  Rp_s_wr_writedata,     //                     .writedata
	 output  wire [3:0]   Rp_s_wr_byteenable,    //                     .byteenable
	 output  reg  [6:0]   Rp_s_wr_burstcount,    //                     .burstcount
	 input   wire         Rp_s_wr_waitrequest,   //                     .waitrequest
		 
   input  wire         Rp_s_rd_readerror,     
   output wire         Rp_s_rd_chipselect,    
   output wire         Rp_s_rd_read,          
	 output wire [29:0]  Rp_s_rd_address,       
	 input wire          Rp_s_rd_waitrequest,   
	 input wire          Rp_s_rd_readdatavalid, 
	 output  wire [6:0]  Rp_s_rd_burstcount,    
	 input wire [31:0]   Rp_s_rd_readdata, 
	 //Send Drb
	 output   wire Drbell_TxReq,
   output   reg  [7:0]  Drbell_TxId,
   output   reg  [15:0] Drbell_TxData,
   input    wire Drbell_TxWaitReq,    
   //Status
   input wire CntClr,
   output reg [15:0] VUHFN12_DropCnt,
   output reg [15:0] VUHFN34_DropCnt,
   output reg [15:0] JIDS_DropCnt,
   output reg [15:0] KSAT_DropCnt,
   output reg [15:0] APM_DropCnt
);

///////////////////////////////Signal Define/////////////////////////////////
   localparam  DST_DEV_BUSY = 32'haaaa_aaaa;
   localparam  DST_DEV_NORM = 32'h5555_5555; 
   
   localparam INFO_MAX_LEN = 2000;
   localparam INFO_MIN_LEN = 1;

   localparam IDLE   = 0;
   localparam ARBIT  = 1;
   localparam FETCH  = 2;
   localparam RP_RQUEST   = 3;
   localparam RP_NRD      = 4;
   localparam RP_NRD_WAIT = 5;
   localparam RP_WR_LEN   = 6;
   localparam RP_WR_S     = 7;
   localparam RP_WR_NOP   = 8;
   //localparam RP_WR_FILL  = 9;
   localparam RP_DRB_WAIT = 9;
   localparam DROP_S      = 10;
   localparam NOP_S       = 11;
   
   reg [11:0] CurState;
   reg [11:0] NextState;  
   wire qArbitEnable;
   wire [7:0] qvRequest;
   wire [7:0] qvGrant;
   wire [2:0] qvGrantIndex;
   reg  [7:0] qvGrantLck;
   reg  [2:0] qvGrantIndexLck;
   reg  [15:0] InfoLen;
   reg  [15:0] PkgWordLen;
   reg  [65:0] RdQueueData;
   wire InfoLenErr;
   //wire  [4:0] Rp_PortEn;
   reg  Rp_PortActive; 
   reg  [4:0] CpuPortEnDly;
   reg  [7:0] qWordCnt;
   wire DropEn;
   wire Rp_WrEn;
   reg [31:0] RdQueCFifoDataLck0;
   reg [31:0] RdQueCFifoDataLck1;
   reg [31:0] RdQueCFifoDataLck2;
   reg [31:0] RdQueCFifoDataLck3;
   reg [31:0] RdQueCFifoDataLck4;
   reg [15:0] qBustWdCnt;
   wire [15:0] PkgLeftWdCnt;
   reg [3:0] RpRdErrCnt[0:4];
   reg [31:0] RpRdAddr;
   reg [31:0] RpWrAddr;
   reg [1:0]  qWrStCnt;
/////////////////////////////////////////////////////////////////////////////   
  RRArbiter8Input RRArbiter8Input_Inst(
    .clock(SysClk),
    .nReset(RstSys_n),
    .qArbitEnable(qArbitEnable),
    .qvRequest(qvRequest),          //请求
    .qvGrant(qvGrant),        //授权
    .qvGrantIndex(qvGrantIndex)    //授权号的下标
 );
 
  assign qArbitEnable = CurState[IDLE];
  assign qvRequest[0] = ((~RdQueDFifoEmpty0) && (~RdQueCFifoEmpty0));
  assign qvRequest[1] = ((~RdQueDFifoEmpty1) && (~RdQueCFifoEmpty1));
  assign qvRequest[2] = ((~RdQueDFifoEmpty2) && (~RdQueCFifoEmpty2));
  assign qvRequest[3] = ((~RdQueDFifoEmpty3) && (~RdQueCFifoEmpty3));
  assign qvRequest[4] = ((~RdQueDFifoEmpty4) && (~RdQueCFifoEmpty4));
  assign qvRequest[7:5] = 0;
  
/////////////////////////////////////////////////////////////////////////////
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n) begin
  	   CurState<= 0;
  	   CurState[IDLE]<= 1;
  	 end
  	else
  	   CurState<= NextState;
  end
  
  
  always@* begin
  	NextState = 0;
  	
  	case(1'b1)
  	 CurState[IDLE]: begin
  	 	  if(|qvRequest)
  	 	    NextState[ARBIT] = 1;
  	 	  else
  	 	    NextState[IDLE] = 1;
  	 	end
  	 	
  	 CurState[ARBIT]: begin
  	  	NextState[FETCH] = 1;
  	 end	
  	
  	 CurState[FETCH]: begin
  		 NextState[RP_RQUEST] = 1; 		
  	 end
  	 
  	 CurState[RP_RQUEST]: begin
  		if(InfoLenErr || (~Rp_PortActive))
  		  NextState[DROP_S] = 1;
  		else 
  		  NextState[RP_NRD] = 1; 
  	 end
  	
  	 CurState[RP_NRD]: begin
  		if(~Rp_s_rd_waitrequest)
  		  NextState[RP_NRD_WAIT] = 1;
  		else
  		  NextState[RP_NRD] = 1;
  	 end
  	
  	 CurState[RP_NRD_WAIT]: begin
  		if(Rp_s_rd_readdatavalid) begin
  		  if(Rp_s_rd_readerror) 
  		   NextState[RP_RQUEST] = 1;
  		  else begin
  		  	 if(Rp_s_rd_readdata == DST_DEV_BUSY)
  		       NextState[IDLE] = 1;
  		     else
  		       NextState[RP_WR_LEN] = 1;
  		   end
  		 end
  		else
  		   NextState[RP_NRD_WAIT] = 1;
  	 end
  	
  	 CurState[RP_WR_LEN]: begin
  		if((qWrStCnt == 2'b01) && (~Rp_s_wr_waitrequest))
  		  NextState[RP_WR_S] = 1;
  		else
  		  NextState[RP_WR_LEN] = 1;
  	 end
  	
  	 CurState[RP_WR_S]: begin
  		  if(qWordCnt[0] && RdQueueData[64] && (~Rp_s_wr_waitrequest)) begin
  		      //if(qBustWdCnt[0])
  		       //NextState[RP_WR_FILL] = 1; 
  		      //else
  		       NextState[RP_DRB_WAIT] = 1;
  		    end 
  		  else if(qWordCnt[0] && (qWordCnt[7:0] >= 63) && (~Rp_s_wr_waitrequest))
  		    NextState[RP_WR_NOP] = 1;
  		  else
  		    NextState[RP_WR_S] = 1;
  		end
  		
  	 CurState[RP_WR_NOP]: begin
       NextState[RP_WR_S] = 1; 		
  	 end
  	 
  	 //CurState[RP_WR_FILL]: begin
  	 	 //NextState[RP_DRB_WAIT] = 1; 	
  	 //end
  	
  	 CurState[RP_DRB_WAIT]: begin
  		if(~Drbell_TxWaitReq)
  		  NextState[NOP_S] = 1;
  		else
  		  NextState[RP_DRB_WAIT] = 1; 
  	 end
  	
  	 CurState[DROP_S]: begin
  		if(RdQueueData[64])
  		  NextState[NOP_S] = 1;
  		else
  		  NextState[DROP_S] = 1;
  	 end
  	
  	 default: begin
  		   	NextState[IDLE] = 1;	
  	 end
  	
  	endcase
  	
  end
////////////////////////////////////////////////////////////////////////////
//qvGrantLck
//qvGrantIndexLck
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n) begin
  	   qvGrantLck<=8'h0;
  	   CpuPortEnDly<= 5'h0;
  	   qvGrantIndexLck<= 3'b000;
  	   RdQueCFifoDataLck0<=  0;
       RdQueCFifoDataLck1<=  0;
       RdQueCFifoDataLck2<=  0;
       RdQueCFifoDataLck3<=  0;
       RdQueCFifoDataLck4<=  0;
       qWordCnt<=8'h00;
       qWrStCnt<=2'b00;
  	 end
  	else begin
  		 CpuPortEnDly<= CpuPortEn;
  	   qvGrantLck<=(CurState[FETCH])? qvGrant : qvGrantLck;
  	   qvGrantIndexLck<=(CurState[FETCH])?   qvGrantIndex : qvGrantIndexLck;
  	   RdQueCFifoDataLck0<=(CurState[IDLE])? RdQueCFifoData0 : RdQueCFifoDataLck0;
       RdQueCFifoDataLck1<=(CurState[IDLE])? RdQueCFifoData1 : RdQueCFifoDataLck1;
       RdQueCFifoDataLck2<=(CurState[IDLE])? RdQueCFifoData2 : RdQueCFifoDataLck2;
       RdQueCFifoDataLck3<=(CurState[IDLE])? RdQueCFifoData3 : RdQueCFifoDataLck3;
       RdQueCFifoDataLck4<=(CurState[IDLE])? RdQueCFifoData4 : RdQueCFifoDataLck4;
       qWordCnt <=(CurState[RP_WR_S])  ? ((~Rp_s_wr_waitrequest)?   (qWordCnt + 1'b1) : qWordCnt) : 8'h00; 
       qWrStCnt <=(CurState[RP_WR_LEN])? ((~Rp_s_wr_waitrequest)?   (qWrStCnt + 1'b1) : qWrStCnt) : 2'b00;
       /*if(CurState[RP_WR_S]) begin
           if(~Rp_s_wr_waitrequest)
             qWordCnt<=(qWordCnt>=63)? 0 : (qWordCnt + 1'b1);
           else
             qWordCnt<=qWordCnt;
        end
       else
         qWordCnt<=8'h00;*/ 
         
  	end
  end
//////////////////////////////////////////////////////////////////////////////
  always@* begin
  	case(qvGrantIndexLck)
  	  0: begin
  	      InfoLen       = RdQueCFifoDataLck0[15:0];
  	      PkgWordLen    = RdQueCFifoDataLck0[31:16];
          Rp_PortActive = (CpuPortEnDly[0])? Rp_PortEn[0] : 1'b0;
         end
         
  	  1: begin
 	         InfoLen       = RdQueCFifoDataLck1[15:0];
  	       PkgWordLen    = RdQueCFifoDataLck1[31:16];
  	       Rp_PortActive = (CpuPortEnDly[1])? Rp_PortEn[1] : 1'b0;
  	     end
  	     
  	  2: begin
  	       InfoLen       = RdQueCFifoDataLck2[15:0];
  	       PkgWordLen    = RdQueCFifoDataLck2[31:16];
  	       Rp_PortActive = (CpuPortEnDly[2])? Rp_PortEn[2] : 1'b0;
  	     end
  	     
  	  3: begin
  	     InfoLen       = RdQueCFifoDataLck3[15:0];
  	     PkgWordLen    = RdQueCFifoDataLck3[31:16];
  	     Rp_PortActive = (CpuPortEnDly[3])? Rp_PortEn[3] : 1'b0;
  	  end
  	     
  	  4: begin
  	      InfoLen       = RdQueCFifoDataLck4[15:0];
  	      PkgWordLen    = RdQueCFifoDataLck4[31:16];
  	      Rp_PortActive = (CpuPortEnDly[4])? Rp_PortEn[4] : 1'b0;
  	     end
  	  default: begin
  	           InfoLen = 16'h0;
  	           PkgWordLen = 16'h0;
  	           Rp_PortActive = 1'b0;
  	        end
    endcase
  end
/////////////////////////////////////////////////////////////////////////////
  always@* begin
  	case(qvGrantIndexLck)
  	  0: RdQueueData = RdQueDFifoData0;
  	  1: RdQueueData = RdQueDFifoData1;
  	  2: RdQueueData = RdQueDFifoData2;
  	  3: RdQueueData = RdQueDFifoData3;
  	  4: RdQueueData = RdQueDFifoData4;
  	  default: RdQueueData = 66'h0;
  	endcase
  end
  
  assign InfoLenErr = (InfoLen<INFO_MIN_LEN) || (InfoLen>=INFO_MAX_LEN);
///////////////////////////////////////////////////////////////////////////////
//Read Fifo
  
  assign RdQueDFifoEn0 = (((CurState[RP_WR_S] && (~Rp_s_wr_waitrequest) && qWordCnt[0]) || CurState[DROP_S]) && qvGrantLck[0]);
  assign RdQueDFifoEn1 = (((CurState[RP_WR_S] && (~Rp_s_wr_waitrequest) && qWordCnt[0]) || CurState[DROP_S]) && qvGrantLck[1]);
  assign RdQueDFifoEn2 = (((CurState[RP_WR_S] && (~Rp_s_wr_waitrequest) && qWordCnt[0]) || CurState[DROP_S]) && qvGrantLck[2]);
  assign RdQueDFifoEn3 = (((CurState[RP_WR_S] && (~Rp_s_wr_waitrequest) && qWordCnt[0]) || CurState[DROP_S]) && qvGrantLck[3]);
  assign RdQueDFifoEn4 = (((CurState[RP_WR_S] && (~Rp_s_wr_waitrequest) && qWordCnt[0]) || CurState[DROP_S]) && qvGrantLck[4]);
  
  assign DropEn  = (CurState[RP_RQUEST] && NextState[DROP_S]);
  assign Rp_WrEn = (CurState[RP_NRD_WAIT] && NextState[RP_WR_LEN]);
  
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n) begin
  	   RdQueCFifoEn0<= 1'b0;
       RdQueCFifoEn1<= 1'b0;
       RdQueCFifoEn2<= 1'b0;
       RdQueCFifoEn3<= 1'b0;
       RdQueCFifoEn4<= 1'b0;
  	 end
  	else begin
  	   RdQueCFifoEn0<=(DropEn || Rp_WrEn) && qvGrantLck[0];
  	   RdQueCFifoEn1<=(DropEn || Rp_WrEn) && qvGrantLck[1];
  	   RdQueCFifoEn2<=(DropEn || Rp_WrEn) && qvGrantLck[2];
  	   RdQueCFifoEn3<=(DropEn || Rp_WrEn) && qvGrantLck[3];
  	   RdQueCFifoEn4<=(DropEn || Rp_WrEn) && qvGrantLck[4];
  	end
  end

//////////////////////////////////////////////////////////////////////////////
//Gnerate BustCnt
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n)
      qBustWdCnt<= 16'h0;
  	else
  	  if(CurState[RP_NRD_WAIT])
  	    qBustWdCnt<= PkgWordLen;
  	  else if(CurState[RP_WR_NOP])
  	  //else if(CurState[RP_WR_S] && (qWordCnt == 63))
  	    qBustWdCnt<= qBustWdCnt - 64;
  end
  
  assign PkgLeftWdCnt = qBustWdCnt - 64;
//////////////////////////////////////////////////////////////////////////////
//Gnerate Read Err Cnt
 genvar i; 
  
 generate 
 
 	 for(i=0; i<5; i=i+1) begin: ReadCntLoop
 	 
 	  always@(negedge RstSys_n or posedge SysClk) begin
      if(~RstSys_n)
        RpRdErrCnt[i] <= 4'h0;
      else
        if(~CpuPortEnDly[i])
          RpRdErrCnt[i] <= 4'h0;
      	else if(CurState[RP_NRD_WAIT] && Rp_s_rd_readdatavalid && Rp_s_rd_readerror && qvGrantLck[i])
      	  RpRdErrCnt[i] <=(RpRdErrCnt[i]>=3)? RpRdErrCnt[i] : (RpRdErrCnt[i] + 1'b1);
    end
    
    assign Rp_PortEn[i] = (RpRdErrCnt[i] < 3);
    
   end
 
 endgenerate
  
//////////////////////////////////////////////////////////////////////////////////
//Generate Slave Read Signal    
  
  assign Rp_s_rd_burstcount = 1;
  assign Rp_s_rd_chipselect = CurState[RP_NRD];
  assign Rp_s_rd_read       = CurState[RP_NRD];

  always@* begin
  	case(qvGrantIndexLck)
  		0:RpRdAddr = VUHFN12_BASE_ADDR + 32'h4;
  		1:RpRdAddr = VUHFN34_BASE_ADDR + 32'h4;
  		2:RpRdAddr = JIDS_BASE_ADDR + 32'h4;
  		3:RpRdAddr = KSAT_BASE_ADDR + 32'h4;
  		4:RpRdAddr = APM_BASE_ADDR + 32'h4;
  		default:RpRdAddr =32'h0; 
  	endcase
  end
  
  assign Rp_s_rd_address = RpRdAddr[31:2];
//////////////////////////////////////////////////////////////////////////////////
//Generate Slave Write Signal 
  assign Rp_s_wr_chipselect = (CurState[RP_WR_S] | CurState[RP_WR_LEN]); 
  assign Rp_s_wr_write      = (CurState[RP_WR_S] | CurState[RP_WR_LEN]);
  assign Rp_s_wr_byteenable = 4'hf;
  //assign Rp_s_wr_writedata  = (CurState[RP_WR_LEN])? ((qWrStCnt[1])? ({16'h0, InfoLen} + 6) : 32'haaaa_aaaa) : RdQueueData[31:0];
  assign Rp_s_wr_address    = RpWrAddr[31:2];
  
  always@* begin
  	if(CurState[RP_WR_LEN])
  	  Rp_s_wr_writedata= (qWrStCnt[0])? ({16'h0, InfoLen} + 6) : 32'haaaa_aaaa; 	
  	else
  	  Rp_s_wr_writedata= (~qWordCnt[0])? RdQueueData[31:0] : RdQueueData[63:32];
  end
  
  
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n)
  	  RpWrAddr<= 32'h0;
  	else
  	  if(CurState[RP_RQUEST]) begin
  	    case(qvGrantIndexLck)
  	     0: RpWrAddr<= VUHFN12_BASE_ADDR;
  	     1: RpWrAddr<= VUHFN34_BASE_ADDR; 
  	     2: RpWrAddr<= JIDS_BASE_ADDR;
  	     3: RpWrAddr<= KSAT_BASE_ADDR;
  	     4: RpWrAddr<= APM_BASE_ADDR;
  	     default: RpWrAddr<= 32'h0;
  	    endcase 
  	   end
  	  else if(CurState[RP_WR_LEN] && NextState[RP_WR_S])
  	    RpWrAddr<= RpWrAddr + 32;
  	  else if(CurState[RP_WR_NOP])  
  	  //else if(CurState[RP_WR_S] && (qWordCnt == 63))
  	    RpWrAddr<= RpWrAddr + 256;
  end
  
  always@(negedge RstSys_n or posedge SysClk) begin
  	if(~RstSys_n)
  	  Rp_s_wr_burstcount<=7'h0;
  	else
      if(CurState[RP_NRD_WAIT] && NextState[RP_WR_LEN])
        Rp_s_wr_burstcount<= 2;
  	  else if(CurState[RP_WR_LEN] && NextState[RP_WR_S])
  	   // Rp_s_wr_burstcount<=(qBustWdCnt<64)? (qBustWdCnt[6:0] + {6'h0, qBustWdCnt[0]}) : 64;
  	   Rp_s_wr_burstcount<= (qBustWdCnt<64)?  qBustWdCnt[6:0] : 64;
  	  else if(CurState[RP_WR_NOP])
  	    Rp_s_wr_burstcount<=(PkgLeftWdCnt<64)? PkgLeftWdCnt[6:0] : 64;
  end
/////////////////////////////////////////////////////////////////////////////////////
//Drbell_TxReq Drbell_TxId Drbell_TxData
  assign Drbell_TxReq = CurState[RP_DRB_WAIT];
  
  always@* begin
  	case(qvGrantIndexLck)
  	  0: begin
  	  	   Drbell_TxId   = VUHFN12_DEV_ID;
  	  	   Drbell_TxData = VUHFN12_DRB_DATA;
  	  	 end
  	  
  	  1: begin
  	       Drbell_TxId   = VUHFN34_DEV_ID;
  	  	   Drbell_TxData = VUHFN34_DRB_DATA;
  	     end
  	     
  	  2: begin
  	       Drbell_TxId   = JIDS_DEV_ID;
  	  	   Drbell_TxData = JIDS_DRB_DATA;
  	     end
  	  
  	  3: begin
  	       Drbell_TxId   = KSAT_DEV_ID;
  	  	   Drbell_TxData = KSAT_DRB_DATA;
  	     end
  	  
  	  4: begin
  	       Drbell_TxId   = APM_DEV_ID;
  	  	   Drbell_TxData = APM_DRB_DATA;
  	     end
  	  
  	  default: begin
  	       Drbell_TxId   = 0;
  	  	   Drbell_TxData = 0;
  	     end
    endcase
  end
 
/////////////////////////////////////////////////////////////////////////////////////
  always@(negedge RstSys_n or posedge CntClr or posedge SysClk) begin
  	if((~RstSys_n) || CntClr) begin
  	  VUHFN12_DropCnt <= 16'h0;
      VUHFN34_DropCnt <= 16'h0;
      JIDS_DropCnt    <= 16'h0;
      KSAT_DropCnt    <= 16'h0;
      APM_DropCnt     <= 16'h0;
  	 end
  	else begin
  	  VUHFN12_DropCnt <= (CurState[RP_RQUEST] && NextState[DROP_S] && qvGrantLck[0])? (VUHFN12_DropCnt + 1'b1) : VUHFN12_DropCnt;
      VUHFN34_DropCnt <= (CurState[RP_RQUEST] && NextState[DROP_S] && qvGrantLck[1])? (VUHFN34_DropCnt + 1'b1) : VUHFN34_DropCnt;
      JIDS_DropCnt    <= (CurState[RP_RQUEST] && NextState[DROP_S] && qvGrantLck[2])? (JIDS_DropCnt + 1'b1) : JIDS_DropCnt;
      KSAT_DropCnt    <= (CurState[RP_RQUEST] && NextState[DROP_S] && qvGrantLck[3])? (KSAT_DropCnt + 1'b1) : KSAT_DropCnt;
      APM_DropCnt     <= (CurState[RP_RQUEST] && NextState[DROP_S] && qvGrantLck[4])? (APM_DropCnt + 1'b1) : APM_DropCnt;
  	 end
  end


/////////////////////////////////////////////////////////////////////////////////////
endmodule
