import gtype::xgmii32_t;
import gtype::xgmii64_t;

module simple10GbaseR
#(
    parameter NUM_TR = 3
)
(
    input  wire sys_clk               ,
    input  wire ref_clk               , 
    input  wire serial_rx [NUM_TR-1:0],
    output wire serial_tx [NUM_TR-1:0]
);
    
localparam [NUM_TR-1:0] TYPE_TR_PMA = {1'b0,1'b1,1'b1};

genvar i;

wire clk_rst_tr_fpll_powerdown_w    ;
wire clk_rst_tr_fpll_pll_locked_w   ;
wire clk_rst_tr_fpll_tx_serial_clk_w;
wire clk_rst_tr_fpll_pll_cal_busy_w ;

wire        tr_pma_wrapper_clk_glbl_w             [NUM_TR-1:0]; 
wire        tr_pma_wrapper_rst_glbl_w             [NUM_TR-1:0]; 
wire        tr_pma_wrapper_refclk_w               [NUM_TR-1:0]; 
wire        tr_pma_wrapper_rx_serial_w            [NUM_TR-1:0]; 
wire        tr_pma_wrapper_tx_serial_w            [NUM_TR-1:0]; 
wire        tr_pma_wrapper_tr_fpll_pll_powerdown_w[NUM_TR-1:0];
wire        tr_pma_wrapper_tr_fpll_pll_locked_w   [NUM_TR-1:0];
wire        tr_pma_wrapper_tr_fpll_tx_serial_clk_w[NUM_TR-1:0];
wire        tr_pma_wrapper_tr_fpll_pll_cal_busy_w [NUM_TR-1:0];
wire [31:0] tr_pma_wrapper_pma_tx_w               [NUM_TR-1:0]; 
wire        tr_pma_wrapper_pma_tx_rdy_w           [NUM_TR-1:0]; 
wire        tr_pma_wrapper_pma_tx_clk_w           [NUM_TR-1:0]; 
wire        tr_pma_wrapper_pma_slip_w             [NUM_TR-1:0]; 
wire [31:0] tr_pma_wrapper_pma_rx_w               [NUM_TR-1:0]; 
wire        tr_pma_wrapper_pma_rx_rdy_w           [NUM_TR-1:0]; 
wire        tr_pma_wrapper_pma_rx_clk_w           [NUM_TR-1:0]; 

wire      tr_baser_wrapper_clk_glbl_w              [NUM_TR-1:0];
wire      tr_baser_wrapper_rst_glbl_w              [NUM_TR-1:0];
wire      tr_baser_wrapper_clk_156_w               [NUM_TR-1:0];
wire      tr_baser_wrapper_rst_156_w               [NUM_TR-1:0];
wire      tr_baser_wrapper_refclk_w                [NUM_TR-1:0];
wire      tr_baser_wrapper_rx_serial_w             [NUM_TR-1:0];
wire      tr_baser_wrapper_tx_serial_w             [NUM_TR-1:0];
wire      tr_baser_wrapper_tr_fpll_pll_powerdown_w [NUM_TR-1:0];
wire      tr_baser_wrapper_tr_fpll_pll_locked_w    [NUM_TR-1:0];
wire      tr_baser_wrapper_tr_fpll_tx_serial_clk_w [NUM_TR-1:0];
wire      tr_baser_wrapper_tr_fpll_pll_cal_busy_w  [NUM_TR-1:0];
xgmii64_t tr_baser_wrapper_xgmii_tx_w              [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_tx_rdy_w          [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_tx_clk_w          [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_tx_rst_w          [NUM_TR-1:0];
xgmii64_t tr_baser_wrapper_xgmii_rx_w              [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_rx_rdy_w          [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_rx_clk_w          [NUM_TR-1:0];
wire      tr_baser_wrapper_xgmii_rx_rst_w          [NUM_TR-1:0];
wire      tr_baser_wrapper_rx_sync_w               [NUM_TR-1:0];

wire        pcs_rx_32b_clk_w     [NUM_TR-1:0];
wire        pcs_rx_32b_rst_w     [NUM_TR-1:0];
wire [31:0] pcs_rx_32b_pma_data_w[NUM_TR-1:0];
wire        pcs_rx_32b_pma_slip_w[NUM_TR-1:0];
wire        pcs_rx_32b_pma_sync_w[NUM_TR-1:0];
xgmii32_t   pcs_rx_32b_xgmii_rx_w[NUM_TR-1:0];
                                 
wire        pcs_tx_32b_clk_w     [NUM_TR-1:0];
wire        pcs_tx_32b_rst_w     [NUM_TR-1:0];
xgmii32_t   pcs_tx_32b_xgmii_tx_w[NUM_TR-1:0];
wire [31:0] pcs_tx_32b_pma_data_w[NUM_TR-1:0];

wire      xgmii_retransmit_32b32b_fifo_0to0_clk_rx_w;
xgmii32_t xgmii_retransmit_32b32b_fifo_0to0_rx_w;    
wire      xgmii_retransmit_32b32b_fifo_0to0_clk_tx_w;
xgmii32_t xgmii_retransmit_32b32b_fifo_0to0_tx_w;    
xgmii32_t xgmii_retransmit_32b32b_fifo_0to0_tx_r;    

wire      xgmii_retransmit_32b32b_fifo_0to1_clk_rx_w;
xgmii32_t xgmii_retransmit_32b32b_fifo_0to1_rx_w;    
wire      xgmii_retransmit_32b32b_fifo_0to1_clk_tx_w;
xgmii32_t xgmii_retransmit_32b32b_fifo_0to1_tx_w;    
xgmii32_t xgmii_retransmit_32b32b_fifo_0to1_tx_r;    

wire      xgmii_retransmit_32b64b_fifo_0to2_clk_rx_w;
xgmii32_t xgmii_retransmit_32b64b_fifo_0to2_rx_w;    
wire      xgmii_retransmit_32b64b_fifo_0to2_clk_tx_w;
xgmii64_t xgmii_retransmit_32b64b_fifo_0to2_tx_w;    
xgmii64_t xgmii_retransmit_32b64b_fifo_0to2_tx_r;    

wire clk_glbl_w;
wire rst_glbl_w;
wire clk_156_w;
wire rst_156_w;
wire xgmii_rx_clk_w[NUM_TR-1:0];
wire xgmii_tx_clk_w[NUM_TR-1:0];

//////////////////////////////////////////////////////////////////////////
assign clk_rst_tr_fpll_powerdown_w = tr_baser_wrapper_tr_fpll_pll_powerdown_w[2] | tr_pma_wrapper_tr_fpll_pll_powerdown_w[1] | tr_pma_wrapper_tr_fpll_pll_powerdown_w[0];

clk_rst clk_rst_u
(
    .clk                   (sys_clk                         ),//input  
    .rst                   (1'b0                            ),//input
    .clk_glbl              (clk_glbl_w                      ),//output
    .rst_glbl              (rst_glbl_w                      ),//output
    .clk_156               (clk_156_w                       ),//output
    .rst_156               (rst_156_w                       ),//output
    .refclk                (ref_clk                         ),//input 
    .tr_fpll_powerdown     (clk_rst_tr_fpll_powerdown_w     ),//input 
    .tr_fpll_pll_locked    (clk_rst_tr_fpll_pll_locked_w    ),//output
    .tr_fpll_tx_serial_clk (clk_rst_tr_fpll_tx_serial_clk_w ),//output
    .tr_fpll_pll_cal_busy  (clk_rst_tr_fpll_pll_cal_busy_w  ) //output
);
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
for (i=0;i<NUM_TR;i=i+1) begin : TR
    if (TYPE_TR_PMA[i]==1'b1) begin : PMA
        assign tr_pma_wrapper_clk_glbl_w              [i]= clk_glbl_w              ;
        assign tr_pma_wrapper_rst_glbl_w              [i]= rst_glbl_w              ;
        assign tr_pma_wrapper_refclk_w                [i]= ref_clk                 ;
        assign tr_pma_wrapper_rx_serial_w             [i]= serial_rx            [i];
        assign tr_pma_wrapper_pma_tx_w                [i]= pcs_tx_32b_pma_data_w[i];
        assign tr_pma_wrapper_pma_slip_w              [i]= pcs_rx_32b_pma_slip_w[i];
        assign tr_pma_wrapper_tr_fpll_pll_locked_w    [i]= clk_rst_tr_fpll_pll_locked_w    ;
        assign tr_pma_wrapper_tr_fpll_tx_serial_clk_w [i]= clk_rst_tr_fpll_tx_serial_clk_w ;
        assign tr_pma_wrapper_tr_fpll_pll_cal_busy_w  [i]= clk_rst_tr_fpll_pll_cal_busy_w  ;

        tr_pma_wrapper tr_pma_wrapper_u
        (
            .clk_glbl              (tr_pma_wrapper_clk_glbl_w             [i]),// input  
            .rst_glbl              (tr_pma_wrapper_rst_glbl_w             [i]),// input  
            .refclk                (tr_pma_wrapper_refclk_w               [i]),// input  
            .rx_serial             (tr_pma_wrapper_rx_serial_w            [i]),// input  
            .tx_serial             (tr_pma_wrapper_tx_serial_w            [i]),// output 
            .tr_fpll_pll_powerdown (tr_pma_wrapper_tr_fpll_pll_powerdown_w[i]),// output 
            .tr_fpll_pll_locked    (tr_pma_wrapper_tr_fpll_pll_locked_w   [i]),// input 
            .tr_fpll_tx_serial_clk (tr_pma_wrapper_tr_fpll_tx_serial_clk_w[i]),// input 
            .tr_fpll_pll_cal_busy  (tr_pma_wrapper_tr_fpll_pll_cal_busy_w [i]),// input 
            .pma_tx                (tr_pma_wrapper_pma_tx_w               [i]),// input  
            .pma_tx_rdy            (tr_pma_wrapper_pma_tx_rdy_w           [i]),// output 
            .pma_tx_clk            (tr_pma_wrapper_pma_tx_clk_w           [i]),// output 
            .pma_slip              (tr_pma_wrapper_pma_slip_w             [i]),// input  
            .pma_rx                (tr_pma_wrapper_pma_rx_w               [i]),// output 
            .pma_rx_rdy            (tr_pma_wrapper_pma_rx_rdy_w           [i]),// output 
            .pma_rx_clk            (tr_pma_wrapper_pma_rx_clk_w           [i]) // output 
        );

        assign xgmii_rx_clk_w [i] = tr_pma_wrapper_pma_rx_clk_w[i];
        assign xgmii_tx_clk_w [i] = tr_pma_wrapper_pma_tx_clk_w[i];
        assign serial_tx      [i] = tr_pma_wrapper_tx_serial_w [i];
    end
    else begin : BASER
        assign tr_baser_wrapper_clk_glbl_w              [i]= clk_glbl_w;
        assign tr_baser_wrapper_rst_glbl_w              [i]= rst_glbl_w;
        assign tr_baser_wrapper_clk_156_w               [i]= clk_156_w;
        assign tr_baser_wrapper_rst_156_w               [i]= rst_156_w;
        assign tr_baser_wrapper_refclk_w                [i]= ref_clk;
        assign tr_baser_wrapper_rx_serial_w             [i]= serial_rx[i];
        assign tr_baser_wrapper_tr_fpll_pll_locked_w    [i]= clk_rst_tr_fpll_pll_locked_w    ;
        assign tr_baser_wrapper_tr_fpll_tx_serial_clk_w [i]= clk_rst_tr_fpll_tx_serial_clk_w ;
        assign tr_baser_wrapper_tr_fpll_pll_cal_busy_w  [i]= clk_rst_tr_fpll_pll_cal_busy_w  ;
        assign tr_baser_wrapper_xgmii_tx_w              [i]= xgmii_retransmit_32b64b_fifo_0to2_tx_r;

        tr_baser_wrapper tr_baser_wrapper_u
        (
            .clk_glbl              ( tr_baser_wrapper_clk_glbl_w             [i]),//input
            .rst_glbl              ( tr_baser_wrapper_rst_glbl_w             [i]),//input
            .clk_156               ( tr_baser_wrapper_clk_156_w              [i]),//input
            .rst_156               ( tr_baser_wrapper_rst_156_w              [i]),//input
            .refclk                ( tr_baser_wrapper_refclk_w               [i]),//input
            .rx_serial             ( tr_baser_wrapper_rx_serial_w            [i]),//input
            .tx_serial             ( tr_baser_wrapper_tx_serial_w            [i]),//output
            .tr_fpll_pll_powerdown ( tr_baser_wrapper_tr_fpll_pll_powerdown_w[i]),//output
            .tr_fpll_pll_locked    ( tr_baser_wrapper_tr_fpll_pll_locked_w   [i]),//input
            .tr_fpll_tx_serial_clk ( tr_baser_wrapper_tr_fpll_tx_serial_clk_w[i]),//input
            .tr_fpll_pll_cal_busy  ( tr_baser_wrapper_tr_fpll_pll_cal_busy_w [i]),//input
            .xgmii_tx              ( tr_baser_wrapper_xgmii_tx_w             [i]),//input
            .xgmii_tx_rdy          ( tr_baser_wrapper_xgmii_tx_rdy_w         [i]),//output
            .xgmii_tx_clk          ( tr_baser_wrapper_xgmii_tx_clk_w         [i]),//output
            .xgmii_tx_rst          ( tr_baser_wrapper_xgmii_tx_rst_w         [i]),//output
            .xgmii_rx              ( tr_baser_wrapper_xgmii_rx_w             [i]),//output
            .xgmii_rx_rdy          ( tr_baser_wrapper_xgmii_rx_rdy_w         [i]),//output
            .xgmii_rx_clk          ( tr_baser_wrapper_xgmii_rx_clk_w         [i]),//output
            .xgmii_rx_rst          ( tr_baser_wrapper_xgmii_rx_rst_w         [i]),//output
            .rx_sync               ( tr_baser_wrapper_rx_sync_w              [i]) //output
        );

        assign xgmii_rx_clk_w [i] = tr_baser_wrapper_xgmii_rx_clk_w[i];
        assign xgmii_tx_clk_w [i] = tr_baser_wrapper_xgmii_tx_clk_w[i];
        assign serial_tx      [i] = tr_baser_wrapper_tx_serial_w   [i];
    end
end
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
for (i=0;i<NUM_TR;i=i+1) begin : PCSRX
    if (TYPE_TR_PMA[i]==1'b1) begin : PMA
    assign pcs_rx_32b_clk_w      [i]= xgmii_rx_clk_w[i]; 
    assign pcs_rx_32b_rst_w      [i]= 0;
    assign pcs_rx_32b_pma_data_w [i]= tr_pma_wrapper_pma_rx_w[i];

    pcs_rx_32b pcs_rx_32b_u
    (
        .clk      (pcs_rx_32b_clk_w     [i]),//input  
        .rst      (pcs_rx_32b_rst_w     [i]),//input 
        .pma_data (pcs_rx_32b_pma_data_w[i]),//input 
        .pma_slip (pcs_rx_32b_pma_slip_w[i]),//output
        .pma_sync (pcs_rx_32b_pma_sync_w[i]),//output
        .xgmii_rx (pcs_rx_32b_xgmii_rx_w[i]) //output
    );
    end
end
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
for (i=0;i<NUM_TR;i=i+1) begin : PCSTX
    if (TYPE_TR_PMA[i]==1'b1) begin : PMA
    assign pcs_tx_32b_clk_w      [i]= xgmii_tx_clk_w[i];
    assign pcs_tx_32b_rst_w      [i]= 0;
    assign pcs_tx_32b_xgmii_tx_w [i]= (i==0) ? xgmii_retransmit_32b32b_fifo_0to0_tx_r : xgmii_retransmit_32b32b_fifo_0to1_tx_r;

    pcs_tx_32b pcs_tx_32b_u
    (
        .clk      (pcs_tx_32b_clk_w     [i]),//input  
        .rst      (pcs_tx_32b_rst_w     [i]),//input 
        .xgmii_tx (pcs_tx_32b_xgmii_tx_w[i]),//input 
        .pma_data (pcs_tx_32b_pma_data_w[i]) //output
    );
    end
end
//////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
assign xgmii_retransmit_32b32b_fifo_0to0_clk_rx_w = xgmii_rx_clk_w       [0];
assign xgmii_retransmit_32b32b_fifo_0to0_rx_w     = pcs_rx_32b_xgmii_rx_w[0];
assign xgmii_retransmit_32b32b_fifo_0to0_clk_tx_w = xgmii_tx_clk_w       [0];

xgmii_retransmit_32b32b_fifo xgmii_retransmit_32b32b_fifo_0to0_u
(
    .clk_rx (xgmii_retransmit_32b32b_fifo_0to0_clk_rx_w),
    .rx     (xgmii_retransmit_32b32b_fifo_0to0_rx_w    ),
    .clk_tx (xgmii_retransmit_32b32b_fifo_0to0_clk_tx_w),
    .tx     (xgmii_retransmit_32b32b_fifo_0to0_tx_w    )
);
always @(posedge xgmii_retransmit_32b32b_fifo_0to0_clk_tx_w) xgmii_retransmit_32b32b_fifo_0to0_tx_r <= xgmii_retransmit_32b32b_fifo_0to0_tx_w;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
assign xgmii_retransmit_32b32b_fifo_0to1_clk_rx_w = xgmii_rx_clk_w       [0];
assign xgmii_retransmit_32b32b_fifo_0to1_rx_w     = pcs_rx_32b_xgmii_rx_w[0];
assign xgmii_retransmit_32b32b_fifo_0to1_clk_tx_w = xgmii_tx_clk_w       [1];

xgmii_retransmit_32b32b_fifo xgmii_retransmit_32b32b_fifo_0to1_u
(
    .clk_rx (xgmii_retransmit_32b32b_fifo_0to1_clk_rx_w),
    .rx     (xgmii_retransmit_32b32b_fifo_0to1_rx_w    ),
    .clk_tx (xgmii_retransmit_32b32b_fifo_0to1_clk_tx_w),
    .tx     (xgmii_retransmit_32b32b_fifo_0to1_tx_w    )
);
always @(posedge xgmii_retransmit_32b32b_fifo_0to1_clk_tx_w) xgmii_retransmit_32b32b_fifo_0to1_tx_r <= xgmii_retransmit_32b32b_fifo_0to1_tx_w;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
assign xgmii_retransmit_32b64b_fifo_0to2_clk_rx_w = xgmii_rx_clk_w       [0];
assign xgmii_retransmit_32b64b_fifo_0to2_rx_w     = pcs_rx_32b_xgmii_rx_w[0];
assign xgmii_retransmit_32b64b_fifo_0to2_clk_tx_w = xgmii_tx_clk_w       [2];

xgmii_retransmit_32b64b_fifo xgmii_retransmit_32b64b_fifo_0to2_u
(
    .clk_rx (xgmii_retransmit_32b64b_fifo_0to2_clk_rx_w),
    .rx     (xgmii_retransmit_32b64b_fifo_0to2_rx_w    ),
    .clk_tx (xgmii_retransmit_32b64b_fifo_0to2_clk_tx_w),
    .tx     (xgmii_retransmit_32b64b_fifo_0to2_tx_w    )
);
always @(posedge xgmii_retransmit_32b64b_fifo_0to2_clk_tx_w) xgmii_retransmit_32b64b_fifo_0to2_tx_r <= xgmii_retransmit_32b64b_fifo_0to2_tx_w;
////////////////////////////////////////////////////////////////////////////////

endmodule
