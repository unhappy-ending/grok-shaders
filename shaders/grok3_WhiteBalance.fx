// Grok Shaders - White Balance
// A ReShade 6.4.0 post-processing shader to adjust white balance in RGB space, using sRGB luminance weights for PC displays.
// Simple mode adjusts overall white balance with a single slider (-1.0 to 1.0).
// Advanced mode adjusts white balance per 10-point IRE scale with 11 sliders (-1.0 to 1.0), hidden when ADVANCED=0.
// Debug mode shows an 11-box IRE scale (copied from grok3_Gamma.fx) to visualize white balance effects across grayscale.
// Created with assistance from Grok 3, xAI.
// MIT License

#include "ReShade.fxh"

// Preprocessor Definitions
// ADVANCED: Enables 10-point IRE white balance sliders and hides simple mode when set to 1
#ifndef ADVANCED
#define ADVANCED 0
#endif

// ENABLE_DEBUG: Shows an 11-box IRE scale when set to 1
#ifndef ENABLE_DEBUG
#define ENABLE_DEBUG 0
#endif

// UI Controls - Simple Mode (shown only when ADVANCED=0)
// Adjusts overall white balance from warm (-1.0) to cool (1.0), with 0.0 as neutral (D65)
#if !ADVANCED
uniform float WhiteBalance <
ui_type = "slider";
ui_category = "Grok White Balance (Simple)";
ui_label = "White Balance";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "Adjusts color temperature. -1.0 = warm (reddish), 0.0 = neutral (D65), 1.0 = cool (bluish).";
> = 0.0;
#endif

// UI Controls - Advanced Mode (shown only when ADVANCED=1)
// Adjusts white balance for 11 IRE levels (0 to 100), each with a slider from -1.0 (warm) to 1.0 (cool)
#if ADVANCED
uniform float IRE0 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 0";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 0 (black). -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE10 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 10";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 10. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE20 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 20";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 20. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE30 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 30";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 30. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE40 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 40";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 40. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE50 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 50";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 50 (mid-gray). -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE60 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 60";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 60. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE70 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 70";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 70. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE80 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 80";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 80. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE90 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 90";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 90. -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;

uniform float IRE100 <
ui_type = "slider";
ui_category = "Grok White Balance (Advanced)";
ui_label = "IRE 100";
ui_min = -1.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "White balance for IRE 100 (white). -1.0 = warm, 0.0 = neutral, 1.0 = cool.";
> = 0.0;
#endif

// UI Controls - Debug Mode (shown only when ENABLE_DEBUG=1)
// Controls the position and size of the 11-box IRE scale debug rectangle
#if ENABLE_DEBUG
uniform float DebugPosX <
ui_type = "slider";
ui_category = "Grok White Balance (Debug)";
ui_label = "Debug Rectangle X Position";
ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "Adjusts the horizontal position of the debug rectangle (0 = left, 1 = right).";
> = 0.0;

uniform float DebugPosY <
ui_type = "slider";
ui_category = "Grok White Balance (Debug)";
ui_label = "Debug Rectangle Y Position";
ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "Adjusts the vertical position of the debug rectangle (0 = top, 1 = bottom).";
> = 0.0;

uniform float DebugWidth <
ui_type = "slider";
ui_category = "Grok White Balance (Debug)";
ui_label = "Debug Rectangle Width";
ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "Adjusts the width of the debug rectangle (as a fraction of screen width).";
> = 0.25;

uniform float DebugHeight <
ui_type = "slider";
ui_category = "Grok White Balance (Debug)";
ui_label = "Debug Rectangle Height";
ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
ui_tooltip = "Adjusts the height of the debug rectangle (as a fraction of screen height).";
> = 0.05;
#else
// Define static defaults for debug variables when ENABLE_DEBUG=0
static const float DebugPosX = 0.0;
static const float DebugPosY = 0.0;
static const float DebugWidth = 0.25;
static const float DebugHeight = 0.05;
#endif

// Pixel Shader
// Processes each pixel to apply white balance adjustments and optionally render the debug IRE scale
float4 PS_WhiteBalance(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color from the back buffer
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Calculate luminance using sRGB weights for IRE mapping in advanced mode
	// Weights (0.299, 0.587, 0.114) reflect human vision’s sensitivity, optimized for sRGB monitors
	float luminance = dot(color.rgb, float3(0.299, 0.587, 0.114));

	// Define RGB scaling factors for warm and cool tones
	// warmScale boosts red, reduces blue; coolScale boosts blue, reduces red; neutralScale is D65
	float3 warmScale = float3(1.2, 1.0, 0.8); // Reddish at -1.0
	float3 coolScale = float3(0.8, 1.0, 1.2); // Bluish at 1.0
	float3 neutralScale = float3(1.0, 1.0, 1.0); // D65 at 0.0

	// Initialize result with original color
	float3 result = color.rgb;

	// Apply white balance based on mode
	#if ADVANCED
	// Advanced mode: Apply white balance based on IRE level
	// Map luminance (0.0–1.0) to IRE (0–100) and select the appropriate IRE slider
	float ire = luminance * 100.0;
	float3 scale;
	if (ire <= 10.0)
	{
		if (IRE0 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE0);
		else
			scale = lerp(neutralScale, coolScale, IRE0);
	}
	else if (ire <= 20.0)
	{
		if (IRE10 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE10);
		else
			scale = lerp(neutralScale, coolScale, IRE10);
	}
	else if (ire <= 30.0)
	{
		if (IRE20 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE20);
		else
			scale = lerp(neutralScale, coolScale, IRE20);
	}
	else if (ire <= 40.0)
	{
		if (IRE30 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE30);
		else
			scale = lerp(neutralScale, coolScale, IRE30);
	}
	else if (ire <= 50.0)
	{
		if (IRE40 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE40);
		else
			scale = lerp(neutralScale, coolScale, IRE40);
	}
	else if (ire <= 60.0)
	{
		if (IRE50 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE50);
		else
			scale = lerp(neutralScale, coolScale, IRE50);
	}
	else if (ire <= 70.0)
	{
		if (IRE60 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE60);
		else
			scale = lerp(neutralScale, coolScale, IRE60);
	}
	else if (ire <= 80.0)
	{
		if (IRE70 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE70);
		else
			scale = lerp(neutralScale, coolScale, IRE70);
	}
	else if (ire <= 90.0)
	{
		if (IRE80 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE80);
		else
			scale = lerp(neutralScale, coolScale, IRE80);
	}
	else
	{
		if (IRE90 < 0.0)
			scale = lerp(neutralScale, warmScale, -IRE90);
		else
			scale = lerp(neutralScale, coolScale, IRE90);
	}
	// Apply the computed scale to the color
	result = color.rgb * scale;
	#else
	// Simple mode: Apply overall white balance
	// Interpolate from neutral to warm (negative) or cool (positive) based on WhiteBalance
	float3 scale;
	if (WhiteBalance < 0.0)
		scale = lerp(neutralScale, warmScale, -WhiteBalance);
	else
		scale = lerp(neutralScale, coolScale, WhiteBalance);
	result = color.rgb * scale;
	#endif

	// Debug mode: Draw an 11-box IRE scale (copied from grok3_Gamma.fx)
	// Renders discrete grayscale boxes (IRE 0 to 100) with the white balance effect applied
	#if ENABLE_DEBUG
	// Define the debug rectangle’s top-left corner position
	float2 rectPos = float2(DebugPosX, DebugPosY);
	// Define the debug rectangle’s size, ensuring non-zero dimensions to avoid division issues
	float2 rectSize = float2(max(DebugWidth, 0.01), max(DebugHeight, 0.01));

	// Check if the current pixel is within the debug rectangle
	bool inRect = texcoord.x >= rectPos.x && texcoord.x <= (rectPos.x + rectSize.x) &&
	texcoord.y >= rectPos.y && texcoord.y <= (rectPos.y + rectSize.y);

	if (inRect)
	{
		// Calculate the IRE index based on the x-position within the rectangle
		// Divide into 11 segments for IRE 0, 10, ..., 100
		float xFraction = (texcoord.x - rectPos.x) / rectSize.x;
		int ireIndex = clamp(floor(xFraction * 11.0), 0, 10);
		float ire = ireIndex / 10.0;
		float3 gray = float3(ire, ire, ire);

		// Apply the current white balance effect to the IRE box
		#if ADVANCED
		float3 debugScale;
		if (ireIndex == 0)
		{
			if (IRE0 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE0);
			else
				debugScale = lerp(neutralScale, coolScale, IRE0);
		}
		else if (ireIndex == 1)
		{
			if (IRE10 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE10);
			else
				debugScale = lerp(neutralScale, coolScale, IRE10);
		}
		else if (ireIndex == 2)
		{
			if (IRE20 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE20);
			else
				debugScale = lerp(neutralScale, coolScale, IRE20);
		}
		else if (ireIndex == 3)
		{
			if (IRE30 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE30);
			else
				debugScale = lerp(neutralScale, coolScale, IRE30);
		}
		else if (ireIndex == 4)
		{
			if (IRE40 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE40);
			else
				debugScale = lerp(neutralScale, coolScale, IRE40);
		}
		else if (ireIndex == 5)
		{
			if (IRE50 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE50);
			else
				debugScale = lerp(neutralScale, coolScale, IRE50);
		}
		else if (ireIndex == 6)
		{
			if (IRE60 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE60);
			else
				debugScale = lerp(neutralScale, coolScale, IRE60);
		}
		else if (ireIndex == 7)
		{
			if (IRE70 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE70);
			else
				debugScale = lerp(neutralScale, coolScale, IRE70);
		}
		else if (ireIndex == 8)
		{
			if (IRE80 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE80);
			else
				debugScale = lerp(neutralScale, coolScale, IRE80);
		}
		else if (ireIndex == 9)
		{
			if (IRE90 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE90);
			else
				debugScale = lerp(neutralScale, coolScale, IRE90);
		}
		else
		{
			if (IRE100 < 0.0)
				debugScale = lerp(neutralScale, warmScale, -IRE100);
			else
				debugScale = lerp(neutralScale, coolScale, IRE100);
		}
		result = gray * debugScale;
		#else
		float3 debugScale;
		if (WhiteBalance < 0.0)
			debugScale = lerp(neutralScale, warmScale, -WhiteBalance);
		else
			debugScale = lerp(neutralScale, coolScale, WhiteBalance);
		result = gray * debugScale;
		#endif
	}
	#endif

	// Clamp to valid RGB range to prevent artifacts
	result = saturate(result);

	// Return final color with original alpha
	return float4(result, color.a);
}

// Technique
// Defines the rendering pass for the white balance effect
technique grok3_WhiteBalance
{
	pass
	{
		VertexShader = PostProcessVS; // ReShade’s standard post-process vertex shader
		PixelShader = PS_WhiteBalance; // Pixel shader for white balance and debug
	}
}
