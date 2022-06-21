`timescale 1ns/1ps
`define clk_period 20

module myscfifo_tb;

//source define

	reg	  Clk;
	reg	[15:0]  data;
	reg	  rdreq;
	reg	  sclr;
	reg	  wrreq;
//probe define
	wire	  almost_empty;
<<<<<<< HEAD
				wire	  almost_full;
	wire	  empty;
					wire	  full;
=======
	wire	  almost_full;
	wire	  empty;
	wire	  full;
>>>>>>> ebad25106af0751a57c9154eb888799e6dce8a47
	wire	[15:0]  q;
	wire	[7:0]  usedw;

//instant user module
	myscfifo fifo(
<<<<<<< HEAD
		  .clock(Clk),
		.data(data),
								.rdreq(rdreq),
		  .sclr(sclr),
		.wrreq(wrreq),
		   .almost_empty(almost_empty),
		.almost_full(almost_full),
		 .empty(empty),
	                   	.full(full),
=======
		.clock(Clk),
		.data(data),
		.rdreq(rdreq),
		.sclr(sclr),
		.wrreq(wrreq),
		.almost_empty(almost_empty),
		.almost_full(almost_full),
		.empty(empty),
		.full(full),
>>>>>>> ebad25106af0751a57c9154eb888799e6dce8a47
		.q(q),
		.usedw(usedw)
	);

//generater clock
<<<<<<< HEAD
	initial Clk                    = 1;
	always #(`clk_period/2)Clk     = ~Clk;
	
	integer i;

		initial begin
		wrreq                       = 0;
						data              = 0;
		rdreq                       = 0;
												sclr = 0;
												#(`clk_period*20 + 1);
		for (i=0;i <= 255 ;i        = i + 1)begin //=
			wrreq                     = 1;
			data                      = i;
			#`clk_period;
		end
										wrreq   = 0;
		#(`clk_period*20);
		for (i=0;i <= 255 ;i        = i + 1)begin
			rdreq                     = 1;
						#`clk_period;
		end	
		rdreq                       = 0;
=======
	initial Clk = 1;
	always #(`clk_period/2)Clk = ~Clk;
	
	integer i;

	initial begin
		wrreq = 0;
		data = 0;
		rdreq = 0;
		sclr = 0;
		#(`clk_period*20 + 1);
		for (i=0;i <= 255 ;i = i + 1)begin //=
			wrreq = 1;
			data = i;
			#`clk_period;
		end
		wrreq = 0;
		#(`clk_period*20);
		for (i=0;i <= 255 ;i = i + 1)begin
			rdreq = 1;
			#`clk_period;
		end	
		rdreq = 0;
>>>>>>> ebad25106af0751a57c9154eb888799e6dce8a47
		$stop;		
	end

endmodule
