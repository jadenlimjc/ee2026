`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 14:16:53
// Design Name: 
// Module Name: uart_tx
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


module uart_tx
	#(
	parameter CLK_PER_BIT = 868,
	parameter WORD_LEN = 8
	)
	(
	input i_clock,
	input i_tx_dv,
	input [WORD_LEN-1:0] i_tx_byte,
	output o_tx_active,
	output reg o_tx_serial,
	output o_tx_done
	);
	localparam s_IDLE = 3'b000;
	localparam s_TX_START_BIT = 3'b001;
	localparam s_TX_DATA_BIT = 3'b010;
	localparam s_TX_STOP_BIT = 3'b011;
	localparam s_CLEANUP = 3'b100;
	reg [2:0] r_sm_main = 0;
	reg [31:0] r_clock_count = 0;
	reg [7:0] r_bit_index = 0;
	reg [WORD_LEN-1:0] r_tx_data = 0;
	reg r_tx_done = 0;
	reg r_tx_active = 0;
	always @ (posedge i_clock)
	begin
		case (r_sm_main)
			s_IDLE:
			begin
				o_tx_serial <= 1'b1;
				r_tx_done <=1'b0;
				r_clock_count <= 0;
				r_bit_index <= 0;
				if (i_tx_dv == 1'b1)
				begin
					r_tx_active <= 1'b1;
					r_tx_data <= i_tx_byte;
					r_sm_main <= s_TX_START_BIT;
				end
				else
					r_sm_main <= s_IDLE;
			end
			s_TX_START_BIT:
			begin
				o_tx_serial <= 1'b0;
				if (r_clock_count < CLK_PER_BIT - 1)
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_TX_START_BIT;
				end
				else
				begin
					r_clock_count <= 0;
					r_sm_main <= s_TX_DATA_BIT;
				end
			end
			s_TX_DATA_BIT:
			begin
				o_tx_serial <= r_tx_data[r_bit_index];
				if (r_clock_count < CLK_PER_BIT - 1)
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_TX_DATA_BIT;
				end
				else
				begin
					r_clock_count <= 0;
					if (r_bit_index < WORD_LEN-1)
					begin
						r_bit_index <= r_bit_index + 1;
						r_sm_main <= s_TX_DATA_BIT;
					end
					else
					begin
						r_bit_index <= 0;
						r_sm_main <= s_TX_STOP_BIT;
					end
				end
			end
			s_TX_STOP_BIT:
			begin
				o_tx_serial <= 1'b1;
				if (r_clock_count < CLK_PER_BIT - 1)
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_TX_STOP_BIT;
				end
				else
				begin
					r_tx_done <= 1'b1;
					r_clock_count <= 0;
					r_sm_main <= s_CLEANUP;
					r_tx_active <= 1'b0;
				end
			end
			s_CLEANUP:
			begin
				r_tx_done <= 1'b1;
				r_sm_main <= s_IDLE;
			end
			default:
				r_sm_main <= s_IDLE;
		endcase
	end
assign o_tx_active = r_tx_active;
assign o_tx_done = r_tx_done;
endmodule