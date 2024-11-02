`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 14:16:53
// Design Name: 
// Module Name: uart_rx
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


// uart receiver
// 8 bit serial with 1 start, 1 stop bit, no parity
// when rx complete, o_rx_dv driven high for one cycle
// param CLK_PER_BIT = (i_clock) / (freq of uart)
// ex. 100MHz input clock, 115200 baud
// 100_000_000 / 115200 = 868
module uart_rx
	#(
	parameter CLK_PER_BIT = 868,
	parameter WORD_LEN = 8)
	(
	input i_clock,
	input i_rx_serial,
	output o_rx_dv,
	output [WORD_LEN-1:0] o_rx_byte
	);
	localparam s_IDLE = 3'b000;
	localparam s_RX_START_BIT = 3'b001;
	localparam s_RX_DATA_BIT = 3'b010;
	localparam s_RX_STOP_BIT = 3'b011;
	localparam s_CLEANUP = 3'b100;
	reg r_rx_data_r = 1'b1;
	reg r_rx_data = 1'b1;
	reg [31:0] r_clock_count = 0;
	reg [7:0] r_bit_index = 0;
	reg [WORD_LEN-1:0] r_rx_byte = 0;
	reg r_rx_dv = 0;
	reg [2:0] r_sm_main = 0;
	always @ (posedge i_clock)
	begin
		r_rx_data_r <= i_rx_serial;
		r_rx_data <= r_rx_data_r;
	end
	always @ (posedge i_clock)
	begin
		case (r_sm_main)
			s_IDLE:
			begin
				r_rx_dv <= 1'b0;
				r_clock_count <= 0;
				r_bit_index <= 0;
				if (r_rx_data == 1'b0) // start bit detected
					r_sm_main <= s_RX_START_BIT;
				else
					r_sm_main <= s_IDLE;
			end
			s_RX_START_BIT:
			begin
				if (r_clock_count == (CLK_PER_BIT - 1) / 2)
				begin
					if (r_rx_data == 1'b0)
					begin
						r_clock_count <= 0;
						r_sm_main <= s_RX_DATA_BIT;
					end
					else
						r_sm_main <= s_IDLE;
				end else
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_RX_START_BIT;
				end
			end
			s_RX_DATA_BIT:
			begin
				if (r_clock_count < CLK_PER_BIT - 1)
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_RX_DATA_BIT;
				end else
				begin
					r_clock_count <= 0;
					r_rx_byte[r_bit_index] <= r_rx_data;
					if (r_bit_index < WORD_LEN-1)
					begin
						r_bit_index <= r_bit_index + 1;
						r_sm_main <= s_RX_DATA_BIT;
					end else
					begin
						r_bit_index <= 0;
						r_sm_main <= s_RX_STOP_BIT;
					end
				end
			end
			s_RX_STOP_BIT:
			begin
				if (r_clock_count < CLK_PER_BIT - 1)
				begin
					r_clock_count <= r_clock_count + 1;
					r_sm_main <= s_RX_STOP_BIT;
				end else
				begin
					r_rx_dv <= 1'b1;
					r_clock_count <= 0;
					r_sm_main <= s_CLEANUP;
				end
			end
			s_CLEANUP:
			begin
				r_sm_main <= s_IDLE;
				r_rx_dv <= 1'b0;
			end
			default:
				r_sm_main <= s_IDLE;
		endcase
	end
assign o_rx_dv = r_rx_dv;
assign o_rx_byte = r_rx_byte;
endmodule
