//////////////////////////////////////////////////////////////////////
////                                                              ////
////  dbg_top.v                                                   ////
////                                                              ////
////                                                              ////
////  This file is part of the SoC/OpenRISC Development Interface ////
////  http://www.opencores.org/projects/DebugInterface/           ////
////                                                              ////
////  Author(s):                                                  ////
////       Igor Mohor (igorm@opencores.org)                       ////
////                                                              ////
////                                                              ////
////  All additional information is avaliable in the README.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 - 2003 Authors                            ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.33  2003/10/23 16:17:01  mohor
// CRC logic changed.
//
// Revision 1.32  2003/09/18 14:00:47  simons
// Lower two address lines must be always zero.
//
// Revision 1.31  2003/09/17 14:38:57  simons
// WB_CNTL register added, some syncronization fixes.
//
// Revision 1.30  2003/08/28 13:55:22  simons
// Three more chains added for cpu debug access.
//
// Revision 1.29  2003/07/31 12:19:49  simons
// Multiple cpu support added.
//
// Revision 1.28  2002/11/06 14:22:41  mohor
// Trst signal is not inverted here any more. Inverted on higher layer !!!.
//
// Revision 1.27  2002/10/10 02:42:55  mohor
// WISHBONE Scan Chain is changed to reflect state of the WISHBONE access (WBInProgress bit added). 
// Internal counter is used (counts 256 wb_clk cycles) and when counter exceeds that value, 
// wb_cyc_o is negated.
//
// Revision 1.26  2002/05/07 14:43:59  mohor
// mon_cntl_o signals that controls monitor mux added.
//
// Revision 1.25  2002/04/22 12:54:11  mohor
// Signal names changed to lower case.
//
// Revision 1.24  2002/04/17 13:17:01  mohor
// Intentional error removed.
//
// Revision 1.23  2002/04/17 11:16:33  mohor
// A block for checking possible simulation/synthesis missmatch added.
//
// Revision 1.22  2002/03/12 10:31:53  mohor
// tap_top and dbg_top modules are put into two separate modules. tap_top
// contains only tap state machine and related logic. dbg_top contains all
// logic necessery for debugging.
//
// Revision 1.21  2002/03/08 15:28:16  mohor
// Structure changed. Hooks for jtag chain added.
//
// Revision 1.20  2002/02/06 12:23:09  mohor
// latched_jtag_ir used when muxing TDO instead of JTAG_IR.
//
// Revision 1.19  2002/02/05 13:34:51  mohor
// Stupid bug that was entered by previous update fixed.
//
// Revision 1.18  2002/02/05 12:41:01  mohor
// trst synchronization is not needed and was removed.
//
// Revision 1.17  2002/01/25 07:58:35  mohor
// IDCODE bug fixed, chains reused to decreas size of core. Data is shifted-in
// not filled-in. Tested in hw.
//
// Revision 1.16  2001/12/20 11:17:26  mohor
// TDO and TDO Enable signal are separated into two signals.
//
// Revision 1.15  2001/12/05 13:28:21  mohor
// trst signal is synchronized to wb_clk_i.
//
// Revision 1.14  2001/11/28 09:36:15  mohor
// Register length fixed.
//
// Revision 1.13  2001/11/27 13:37:43  mohor
// CRC is returned when chain selection data is transmitted.
//
// Revision 1.12  2001/11/26 10:47:09  mohor
// Crc generation is different for read or write commands. Small synthesys fixes.
//
// Revision 1.11  2001/11/14 10:10:41  mohor
// Wishbone data latched on wb_clk_i instead of risc_clk.
//
// Revision 1.10  2001/11/12 01:11:27  mohor
// Reset signals are not combined any more.
//
// Revision 1.9  2001/10/19 11:40:01  mohor
// dbg_timescale.v changed to timescale.v This is done for the simulation of
// few different cores in a single project.
//
// Revision 1.8  2001/10/17 10:39:03  mohor
// bs_chain_o added.
//
// Revision 1.7  2001/10/16 10:09:56  mohor
// Signal names changed to lowercase.
//
//
// Revision 1.6  2001/10/15 09:55:47  mohor
// Wishbone interface added, few fixes for better performance,
// hooks for boundary scan testing added.
//
// Revision 1.5  2001/09/24 14:06:42  mohor
// Changes connected to the OpenRISC access (SPR read, SPR write).
//
// Revision 1.4  2001/09/20 10:11:25  mohor
// Working version. Few bugs fixed, comments added.
//
// Revision 1.3  2001/09/19 11:55:13  mohor
// Asynchronous set/reset not used in trace any more.
//
// Revision 1.2  2001/09/18 14:13:47  mohor
// Trace fixed. Some registers changed, trace simplified.
//
// Revision 1.1.1.1  2001/09/13 13:49:19  mohor
// Initial official release.
//
// Revision 1.3  2001/06/01 22:22:35  mohor
// This is a backup. It is not a fully working version. Not for use, yet.
//
// Revision 1.2  2001/05/18 13:10:00  mohor
// Headers changed. All additional information is now avaliable in the README.txt file.
//
// Revision 1.1.1.1  2001/05/18 06:35:02  mohor
// Initial release
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "dbg_defines.v"

// Top module
module dbg_top(
                // JTAG signals
                trst_i,     // trst_i is active high (inverted on higher layers)
                tck_i,
                tdi_i,
                tdo_o,

                // TAP states
                shift_dr_i,
                pause_dr_i,
                update_dr_i,

                // Instructions
                debug_select_i,

                // WISHBONE common signals
                wb_rst_i, wb_clk_i,
                                                                                
                // WISHBONE master interface
                wb_adr_o, wb_dat_o, wb_dat_i, wb_cyc_o, wb_stb_o, wb_sel_o,
                wb_we_o, wb_ack_i, wb_cab_o, wb_err_i, wb_cti_o, wb_bte_o
              );


// JTAG signals
input   trst_i;
input   tck_i;
input   tdi_i;
output  tdo_o;

// TAP states
input   shift_dr_i;
input   pause_dr_i;
input   update_dr_i;

// Instructions
input   debug_select_i;

// WISHBONE common signals
input         wb_rst_i;                   // WISHBONE reset
input         wb_clk_i;                   // WISHBONE clock
                                                                                
// WISHBONE master interface
output [31:0] wb_adr_o;
output [31:0] wb_dat_o;
input  [31:0] wb_dat_i;
output        wb_cyc_o;
output        wb_stb_o;
output  [3:0] wb_sel_o;
output        wb_we_o;
input         wb_ack_i;
output        wb_cab_o;
input         wb_err_i;
output  [2:0] wb_cti_o;
output  [1:0] wb_bte_o;


reg     cpu_debug_scan_chain;
reg     wishbone_scan_chain;

reg [`DATA_CNT -1:0]        data_cnt;
reg [`CRC_CNT -1:0]         crc_cnt;
reg [`STATUS_CNT -1:0]      status_cnt;
reg [`CHAIN_DATA_LEN -1:0]  chain_dr;
reg [`CHAIN_ID_LENGTH -1:0] chain; 

wire data_cnt_end;
wire crc_cnt_end;
wire status_cnt_end;
reg  crc_cnt_end_q;
reg  crc_cnt_end_q2;
reg  crc_cnt_end_q3;
reg  chain_select;
reg  chain_select_error;
wire crc_out;
wire crc_match;
wire crc_en_wb;
wire shift_crc_wb;

wire data_shift_en;
wire selecting_command;

reg tdo_o;
reg wishbone_ce;

// data counter
always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    data_cnt <= #1 'h0;
  else if(shift_dr_i & (~data_cnt_end))
    data_cnt <= #1 data_cnt + 1'b1;
  else if (update_dr_i)
    data_cnt <= #1 'h0;
end


assign data_cnt_end = data_cnt == `CHAIN_DATA_LEN;


// crc counter
always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    crc_cnt <= #1 'h0;
  else if(shift_dr_i & data_cnt_end & (~crc_cnt_end) & chain_select)
    crc_cnt <= #1 crc_cnt + 1'b1;
  else if (update_dr_i)
    crc_cnt <= #1 'h0;
end

assign crc_cnt_end = crc_cnt == `CRC_LEN;


always @ (posedge tck_i)
  begin
    crc_cnt_end_q  <= #1 crc_cnt_end;
    crc_cnt_end_q2 <= #1 crc_cnt_end_q;
    crc_cnt_end_q3 <= #1 crc_cnt_end_q2;
  end


// status counter
always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    status_cnt <= #1 'h0;
  else if(shift_dr_i & crc_cnt_end & (~status_cnt_end))
    status_cnt <= #1 status_cnt + 1'b1;
  else if (update_dr_i)
    status_cnt <= #1 'h0;
end

assign status_cnt_end = status_cnt == `STATUS_LEN;


assign selecting_command = shift_dr_i & (data_cnt == `DATA_CNT'h0) & debug_select_i;


always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    chain_select <= #1 1'b0;
  else if(selecting_command & tdi_i)       // Chain select
    chain_select <= #1 1'b1;
  else if (update_dr_i)
    chain_select <= #1 1'b0;
end


always @ (chain)
begin
  cpu_debug_scan_chain  <= #1 1'b0;
  wishbone_scan_chain   <= #1 1'b0;
  chain_select_error    <= #1 1'b0;
  
  case (chain)                /* synthesis parallel_case */
    `CPU_DEBUG_CHAIN      :   cpu_debug_scan_chain  <= #1 1'b1;
    `WISHBONE_SCAN_CHAIN  :   wishbone_scan_chain   <= #1 1'b1;
    default               :   chain_select_error    <= #1 1'b1; 
  endcase
end


always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    chain <= `CHAIN_ID_LENGTH'b111;
  else if(chain_select & crc_cnt_end & (~crc_cnt_end_q) & crc_match)
    chain <= #1 chain_dr[`CHAIN_DATA_LEN -1:1];
end


assign data_shift_en = shift_dr_i & (~data_cnt_end);


always @ (posedge tck_i)
begin
  if (data_shift_en)
    chain_dr[`CHAIN_DATA_LEN -1:0] <= #1 {tdi_i, chain_dr[`CHAIN_DATA_LEN -1:1]};
end


// Calculating crc for input data
dbg_crc32_d1 i_dbg_crc32_d1_in
             ( 
              .data       (tdi_i),
              .enable     (shift_dr_i),
              .shift      (1'b0),
              .rst        (trst_i),
              .sync_rst   (update_dr_i),
              .crc_out    (),
              .clk        (tck_i),
              .crc_match  (crc_match)
             );


reg tdo_chain_select;
wire crc_en;
wire crc_en_dbg;
reg crc_started;
assign crc_en = crc_en_dbg | crc_en_wb;
assign crc_en_dbg = shift_dr_i & crc_cnt_end & (~status_cnt_end);

always @ (posedge tck_i)
begin
  if (crc_en)
    crc_started <= #1 1'b1;
  else if (update_dr_i)
    crc_started <= #1 1'b0;
end


reg tdo_tmp;


// Calculating crc for input data
dbg_crc32_d1 i_dbg_crc32_d1_out
             ( 
              .data       (tdo_tmp),
              .enable     (crc_en), // enable has priority
//              .shift      (1'b0),
              .shift      (shift_dr_i & crc_started & (~crc_en)),
              .rst        (trst_i),
              .sync_rst   (update_dr_i),
              .crc_out    (crc_out),
              .clk        (tck_i),
              .crc_match  ()
             );

// Following status is shifted out: 
// 1. bit:          1 if crc is OK, else 0
// 2. bit:          1 if command is "chain select", else 0
// 3. bit:          1 if non-existing chain is selected else 0
// 4. bit:          always 1

reg [799:0] current_on_tdo;

always @ (status_cnt or chain_select or crc_match or chain_select_error or crc_out)
begin
  case (status_cnt)                   /* synthesis full_case parallel_case */ 
    `STATUS_CNT'd0  : begin
                        tdo_chain_select = crc_match;
                        current_on_tdo = "crc_match";
                      end
    `STATUS_CNT'd1  : begin
                        tdo_chain_select = chain_select;
                        current_on_tdo = "chain_select";
                      end
    `STATUS_CNT'd2  : begin
                        tdo_chain_select = chain_select_error;
                        current_on_tdo = "chain_select_error";
                      end
    `STATUS_CNT'd3  : begin
                        tdo_chain_select = 1'b1;
                        current_on_tdo = "one 1";
                      end
    `STATUS_CNT'd4  : begin
                        tdo_chain_select = crc_out;
                  //      tdo_chain_select = 1'hz;
                        current_on_tdo = "crc_out";
                      end
  endcase
end


wire tdi_wb;
wire tdo_wb;

always @ (shift_crc_wb or crc_out or wishbone_ce or tdo_wb or tdo_chain_select)
begin
  if (shift_crc_wb)       // shifting crc
    tdo_tmp = crc_out;
  else if (wishbone_ce)   //  shifting data from wb
    tdo_tmp = tdo_wb;
  else
    tdo_tmp = tdo_chain_select;
end


always @ (negedge tck_i)
begin
  tdo_o <= #1 tdo_tmp;
end




// Signals for WISHBONE module


always @ (posedge tck_i or posedge trst_i)
begin
  if (trst_i)
    wishbone_ce <= #1 1'b0;
  else if(selecting_command & (~tdi_i) & wishbone_scan_chain) // wishbone CE
    wishbone_ce <= #1 1'b1;
  else if (update_dr_i)   // igor !!! This needs to be changed?
    wishbone_ce <= #1 1'b0;
end


assign tdi_wb = wishbone_ce & tdi_i;

// Connecting wishbone module
dbg_wb i_dbg_wb (
                  // JTAG signals
                  .trst_i        (trst_i), // trst_i is active high (inverted on higher layers)
                  .tck_i         (tck_i),
                  .tdi_i         (tdi_wb),
                  .tdo_o         (tdo_wb),

                  // TAP states
                  .shift_dr_i    (shift_dr_i),
                  .pause_dr_i    (pause_dr_i),
                  .update_dr_i   (update_dr_i),

                  .wishbone_ce_i (wishbone_ce),
                  .crc_match_i   (crc_match),
                  .crc_en_o      (crc_en_wb),
                  .shift_crc_o   (shift_crc_wb),

                  // WISHBONE common signals
                  .wb_rst_i      (wb_rst_i),
                  .wb_clk_i      (wb_clk_i),

                  // WISHBONE master interface
                  .wb_adr_o      (wb_adr_o), 
                  .wb_dat_o      (wb_dat_o),
                  .wb_dat_i      (wb_dat_i),
                  .wb_cyc_o      (wb_cyc_o),
                  .wb_stb_o      (wb_stb_o),
                  .wb_sel_o      (wb_sel_o),
                  .wb_we_o       (wb_we_o),
                  .wb_ack_i      (wb_ack_i),
                  .wb_cab_o      (wb_cab_o),
                  .wb_err_i      (wb_err_i),
                  .wb_cti_o      (wb_cti_o),
                  .wb_bte_o      (wb_bte_o)

            );

endmodule
