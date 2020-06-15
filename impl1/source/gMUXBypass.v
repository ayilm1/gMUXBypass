module gMUXBypass #(
	parameter USE_PWM = 0
)(

	// LVDS input
	input	[2:0]	LVDS_IG_A_DATA	,
	
	input	[2:0]	LVDS_IG_B_DATA	,

	input	LVDS_IG_A_CLK			,
	
	// Panel control signals input
	input	LVDS_IG_BKL_ON			,
	input	LVDS_IG_PANEL_PWR		,
	
	// LVDS output
	output	[2:0]	LVDS_A_DATA		,
	
	output	[2:0]	LVDS_B_DATA		,
	
	output	LVDS_A_CLK				,
	output	LVDS_B_CLK				,
	
	// Panel control signals output
	output	LCD_BKLT_EN				,
	output	LCD_PWR_EN				,
	output	LCD_BKLT_PWM			,
	
	// dGPU power enable and reset
	output	P3V3GPU_EN				,
	output	P1V5FB1V8GPU_R_EN		,
	output	P1V0GPU_EN				,
	output	GPUVCORE_EN				,
	output	EG_RESET_L				,
	
	// DDC signals
	output	LVDS_DDC_SEL_IG			,
	output	LVDS_DDC_SEL_EG
);

	assign LVDS_A_DATA[2:0] = LVDS_IG_A_DATA[2:0];

	assign LVDS_B_DATA[2:0] = LVDS_IG_B_DATA[2:0];
	
	assign LVDS_A_CLK	= LVDS_IG_A_CLK;
	
	assign LVDS_B_CLK	= LVDS_IG_A_CLK;
	
	// Pass through panel control signals
	assign LCD_BKLT_EN	= LVDS_IG_BKL_ON;
	assign LCD_PWR_EN	= LVDS_IG_PANEL_PWR;
	
	// Disable dGPU rails and hold in reset
	assign P3V3GPU_EN			= 0;
	assign P1V5FB1V8GPU_R_EN	= 0;
	assign P1V0GPU_EN			= 0;
	assign GPUVCORE_EN			= 0;
	assign EG_RESET_L			= 0;
	
	// Display Config Channel MUX select
	assign LVDS_DDC_SEL_IG		= 1;
	assign LVDS_DDC_SEL_EG		= 0;
	
generate
	// If PWM mod wire isn't installed
	if (!USE_PWM) begin
		assign LCD_BKLT_PWM = 1;
	end
endgenerate
endmodule