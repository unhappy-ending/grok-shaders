// Define a preprocessor directive to toggle between advanced (10-point) and basic (2-point) gamma adjustment
// ADVANCED = 1 enables 11 IRE sliders (0 to 100) with Catmull-Rom spline interpolation; ADVANCED = 0 uses IRE 30 and IRE 80 with logarithmic interpolation
#ifndef ADVANCED
#define ADVANCED 0
#endif

// Define a preprocessor directive to enable/disable the debug rectangle and its control sliders
// ENABLE_DEBUG = 1 renders an 11-box IRE scale and includes DebugPosX, DebugPosY, DebugWidth, DebugHeight sliders; ENABLE_DEBUG = 0 disables both
#ifndef ENABLE_DEBUG
#define ENABLE_DEBUG 0
#endif

// Include the ReShade standard header file to access common functions and definitions
// such as the backbuffer texture, texture sampling, and post-process vertex shader
#include "ReShade.fxh"

#if ADVANCED
// Define uniform float variables for IRE 0 to 100, only active when ADVANCED = 1
// These sliders control gamma for 11 IRE levels, included in the "Grok Gamma (Advanced)" UI category
uniform float GammaIRE0 <
// UI category for this slider, ensuring it appears under "Grok Gamma (Advanced)"
ui_category = "Grok Gamma (Advanced)";
// Specify the UI control type as a slider for intuitive adjustment
ui_type = "slider";
// Set the minimum value to -1.0 for darkening the image
ui_min = -1.0;
// Set the maximum value to 1.0 for brightening the image
ui_max = 1.0;
// Define the step size for fine-grained control (0.01 increments)
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Gamma IRE 0";
// Tooltip explaining the slider’s effect
ui_tooltip = "Adjusts gamma for the 0% IRE level. Negative values darken, positive values brighten.";
> = 0.0; // Default to neutral (maps to gamma 1.0)

uniform float GammaIRE10 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 10";
ui_tooltip = "Adjusts gamma for the 10% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE20 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 20";
ui_tooltip = "Adjusts gamma for the 20% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE30 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 30";
ui_tooltip = "Adjusts gamma for the 30% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE40 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 40";
ui_tooltip = "Adjusts gamma for the 40% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE50 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 50";
ui_tooltip = "Adjusts gamma for the 50% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE60 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 60";
ui_tooltip = "Adjusts gamma for the 60% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE70 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 70";
ui_tooltip = "Adjusts gamma for the 70% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE80 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 80";
ui_tooltip = "Adjusts gamma for the 80% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE90 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 90";
ui_tooltip = "Adjusts gamma for the 90% IRE level. Negative values darken, positive values brighten.";
> = 0.0;

uniform float GammaIRE100 <
ui_category = "Grok Gamma (Advanced)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 100";
ui_tooltip = "Adjusts gamma for the 100% IRE level. Negative values darken, positive values brighten.";
> = 0.0;
#else
// Define uniform float variables for IRE 30 and IRE 80, used in basic mode (ADVANCED = 0)
// These control gamma for mid-tone levels, with logarithmic interpolation for other IRE levels
uniform float GammaIRE30 <
// UI category for this slider, ensuring it appears under "Grok Gamma (Simple)"
ui_category = "Grok Gamma (Simple)";
// Specify the UI control type as a slider for intuitive adjustment
ui_type = "slider";
// Set the minimum value to -1.0 for darkening the image
ui_min = -1.0;
// Set the maximum value to 1.0 for brightening the image
ui_max = 1.0;
// Define the step size for fine-grained control (0.01 increments)
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Gamma IRE 30";
// Tooltip explaining the slider’s effect
ui_tooltip = "Adjusts gamma for the 30% IRE level. Negative values darken, positive values brighten.";
> = 0.0; // Default to neutral (maps to gamma 1.0)

uniform float GammaIRE80 <
ui_category = "Grok Gamma (Simple)";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Gamma IRE 80";
ui_tooltip = "Adjusts gamma for the 80% IRE level. Negative values darken, positive values brighten.";
> = 0.0;
#endif

#if ENABLE_DEBUG
// Define uniform float variables for the debug rectangle’s position and size, included only if ENABLE_DEBUG = 1
// These control the placement and dimensions of the 11-box IRE scale, grouped in the "Grok Gamma (Debug)" UI category
uniform float DebugPosX <
// UI category for this slider, ensuring it appears under "Grok Gamma (Debug)"
ui_category = "Grok Gamma (Debug)";
// Specify the UI control type as a slider for adjustment
ui_type = "slider";
// Set the minimum x-position to 0.0 (left edge of the screen)
ui_min = 0.0;
// Set the maximum x-position to 1.0 (right edge)
ui_max = 1.0;
// Define the step size for fine-grained control
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Debug Rectangle X Position";
// Tooltip explaining the slider’s purpose
ui_tooltip = "Adjusts the horizontal position of the debug rectangle (0 = left, 1 = right).";
> = 0.0; // Default to top-left corner

uniform float DebugPosY <
ui_category = "Grok Gamma (Debug)";
ui_type = "slider";
ui_min = 0.0; // Top edge of the screen
ui_max = 1.0; // Bottom edge
ui_step = 0.01;
ui_label = "Debug Rectangle Y Position";
ui_tooltip = "Adjusts the vertical position of the debug rectangle (0 = top, 1 = bottom).";
> = 0.0; // Default to top-left corner

uniform float DebugWidth <
ui_category = "Grok Gamma (Debug)";
ui_type = "slider";
ui_min = 0.0; // Minimum width (0.0 allows flexibility, clamped in shader if needed)
ui_max = 1.0; // Full screen width
ui_step = 0.01;
ui_label = "Debug Rectangle Width";
ui_tooltip = "Adjusts the width of the debug rectangle (as a fraction of screen width).";
> = 0.25; // Default to 25% of screen width

uniform float DebugHeight <
ui_category = "Grok Gamma (Debug)";
ui_type = "slider";
ui_min = 0.0; // Minimum height (0.0 allows flexibility, clamped in shader if needed)
ui_max = 1.0; // Full screen height
ui_step = 0.01;
ui_label = "Debug Rectangle Height";
ui_tooltip = "Adjusts the height of the debug rectangle (as a fraction of screen height).";
> = 0.05; // Default to 5% of screen height
#else
// Define static values for debug rectangle when ENABLE_DEBUG = 0
// These are unused since the rectangle is not rendered, but defined for completeness
static const float DebugPosX = 0.0; // Top-left corner
static const float DebugPosY = 0.0; // Top-left corner
static const float DebugWidth = 0.25; // 25% of screen width
static const float DebugHeight = 0.05; // 5% of screen height
#endif

// Function to compute Catmull-Rom spline interpolation for a given t and four control points
// Returns the interpolated value for smooth gamma transitions in advanced mode
float CatmullRom(float p0, float p1, float p2, float p3, float t)
{
	// Compute the Catmull-Rom polynomial: 0.5 * (2*p1 + (-p0 + p2)*t + (2*p0 - 5*p1 + 4*p2 - p3)*t^2 + (-p0 + 3*p1 - 3*p2 + p3)*t^3)
	// t is normalized to [0, 1] within the segment
	return 0.5 * (
		2.0 * p1 +
		(-p0 + p2) * t +
		(2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t * t +
		(-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t * t * t
	);
}

// Pixel shader function that applies gamma adjustments and optionally displays the IRE scale
// Takes vertex position (vpos) and texture coordinates (texcoord) as input
// Returns the modified color or debug IRE scale as the shader output
float3 GammaPass(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Define the debug rectangle’s top-left corner position
	// DebugPosX and DebugPosY control x (left-to-right) and y (top-to-bottom), defaulting to (0,0)
	float2 rectPos = float2(DebugPosX, DebugPosY);

	// Define the debug rectangle’s size, ensuring non-zero dimensions to avoid division issues
	// Clamp width and height to small positive values if they are set to 0.0
	float2 rectSize = float2(max(DebugWidth, 0.01), max(DebugHeight, 0.01));

	// Check if the current pixel is within the debug rectangle and ENABLE_DEBUG is enabled
	// If true, render the 11-box IRE scale; otherwise, apply gamma to the backbuffer
	bool inRect = ENABLE_DEBUG && texcoord.x >= rectPos.x && texcoord.x <= (rectPos.x + rectSize.x) &&
	texcoord.y >= rectPos.y && texcoord.y <= (rectPos.y + rectSize.y);

	if (inRect) {
		// Calculate the IRE index based on the x-position within the rectangle
		// Divide the rectangle into 11 equal segments for discrete boxes (IRE 0, 10, ..., 100)
		float xFraction = (texcoord.x - rectPos.x) / rectSize.x; // 0 to 1 across rectangle
		int ireIndex = clamp(floor(xFraction * 11.0), 0, 10); // 0 to 10 for 11 boxes
		float ire = ireIndex / 10.0; // IRE value (0.0, 0.1, ..., 1.0)

		// Create a grayscale color for the IRE level
		// Each box has a constant value corresponding to its IRE level
		float3 color = float3(ire, ire, ire);

		// Select the gamma value for the IRE level
		// Use the corresponding GammaIRE slider in advanced mode or interpolate in basic mode
		float gamma;
		#if ADVANCED
		// ADVANCED mode: select the gamma slider for the corresponding IRE index (discrete for debug boxes)
		if (ireIndex == 0) {
			gamma = 1.0 + GammaIRE0;
		} else if (ireIndex == 1) {
			gamma = 1.0 + GammaIRE10;
		} else if (ireIndex == 2) {
			gamma = 1.0 + GammaIRE20;
		} else if (ireIndex == 3) {
			gamma = 1.0 + GammaIRE30;
		} else if (ireIndex == 4) {
			gamma = 1.0 + GammaIRE40;
		} else if (ireIndex == 5) {
			gamma = 1.0 + GammaIRE50;
		} else if (ireIndex == 6) {
			gamma = 1.0 + GammaIRE60;
		} else if (ireIndex == 7) {
			gamma = 1.0 + GammaIRE70;
		} else if (ireIndex == 8) {
			gamma = 1.0 + GammaIRE80;
		} else if (ireIndex == 9) {
			gamma = 1.0 + GammaIRE90;
		} else {
			gamma = 1.0 + GammaIRE100;
		}
		#else
		// Basic mode: interpolate between IRE 30 and IRE 80 using logarithmic interpolation
		if (ire <= 0.3) {
			// Below or at IRE 30, use GammaIRE30
			gamma = 1.0 + GammaIRE30;
		} else if (ire >= 0.8) {
			// Above or at IRE 80, use GammaIRE80
			gamma = 1.0 + GammaIRE80;
		} else {
			// Between IRE 30 and IRE 80, use logarithmic interpolation
			float t = (ire - 0.3) / (0.8 - 0.3); // Linear t from 0 to 1
			float a = 5.0; // Logarithmic strength (higher = stronger curve)
			float t_log = log(1.0 + t * a) / log(1.0 + a); // Logarithmic t from 0 to 1
			gamma = 1.0 + lerp(GammaIRE30, GammaIRE80, t_log);
		}
		#endif

		// Apply the gamma adjustment to the IRE box color
		// Use pow(color, 1.0 / gamma) to adjust brightness, matching the main image’s gamma processing
		color = pow(color, 1.0 / gamma);

		// Clamp the resulting color to the valid range [0,1]
		// saturate() prevents invalid colors in the debug boxes
		return saturate(color);
	}

	// Sample the color from the backbuffer at the given texture coordinates
	// ReShade::BackBuffer provides access to the current frame’s pixel data
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	// Convert the color’s luminance to an IRE level (0 to 1 range)
	// Use the maximum RGB component as a proxy for luminance to simplify
	float ire = max(max(color.r, color.g), color.b);

	// Define the gamma value to be applied based on the IRE level
	// In ADVANCED mode, use Catmull-Rom spline interpolation; in basic mode, use logarithmic interpolation
	float gamma;
	#if ADVANCED
	// ADVANCED mode: Catmull-Rom spline interpolation across 11 IRE points
	if (ire <= 0.0) {
		// For IRE 0 or below, use GammaIRE0 directly
		gamma = 1.0 + GammaIRE0;
	} else if (ire >= 1.0) {
		// For IRE 100 or above, use GammaIRE100 directly
		gamma = 1.0 + GammaIRE100;
	} else {
		// Find the segment for the current IRE (0.0 to 1.0 maps to IRE 0 to 100)
		int i = clamp(floor(ire * 10.0), 0, 9); // Segment index (0 to 9 for IRE 0-10, 10-20, ..., 90-100)
		float t = (ire - (i * 0.1)) / 0.1; // Normalized t within the segment [0, 1]

		// Select the four control points for Catmull-Rom spline
		// Use boundary handling for first and last segments
		float p0, p1, p2, p3;
		if (i == 0) {
			// First segment (IRE 0 to 10): duplicate GammaIRE0 for p0
			p0 = GammaIRE0;
			p1 = GammaIRE0;
			p2 = GammaIRE10;
			p3 = GammaIRE20;
		} else if (i == 9) {
			// Last segment (IRE 90 to 100): duplicate GammaIRE100 for p3
			p0 = GammaIRE80;
			p1 = GammaIRE90;
			p2 = GammaIRE100;
			p3 = GammaIRE100;
		} else {
			// Middle segments: use consecutive points
			if (i == 1) { p0 = GammaIRE0; p1 = GammaIRE10; p2 = GammaIRE20; p3 = GammaIRE30; }
			else if (i == 2) { p0 = GammaIRE10; p1 = GammaIRE20; p2 = GammaIRE30; p3 = GammaIRE40; }
			else if (i == 3) { p0 = GammaIRE20; p1 = GammaIRE30; p2 = GammaIRE40; p3 = GammaIRE50; }
			else if (i == 4) { p0 = GammaIRE30; p1 = GammaIRE40; p2 = GammaIRE50; p3 = GammaIRE60; }
			else if (i == 5) { p0 = GammaIRE40; p1 = GammaIRE50; p2 = GammaIRE60; p3 = GammaIRE70; }
			else if (i == 6) { p0 = GammaIRE50; p1 = GammaIRE60; p2 = GammaIRE70; p3 = GammaIRE80; }
			else if (i == 7) { p0 = GammaIRE60; p1 = GammaIRE70; p2 = GammaIRE80; p3 = GammaIRE90; }
			else if (i == 8) { p0 = GammaIRE70; p1 = GammaIRE80; p2 = GammaIRE90; p3 = GammaIRE100; }
		}

		// Compute the interpolated gamma value using Catmull-Rom spline
		float interpolatedGamma = CatmullRom(p0, p1, p2, p3, t);
		gamma = 1.0 + interpolatedGamma;
	}
	#else
	// Basic mode: interpolate between IRE 30 and IRE 80 using logarithmic interpolation
	if (ire <= 0.3) {
		// Below or at IRE 30, use GammaIRE30
		gamma = 1.0 + GammaIRE30;
	} else if (ire >= 0.8) {
		// Above or at IRE 80, use GammaIRE80
		gamma = 1.0 + GammaIRE80;
	} else {
		// Between IRE 30 and IRE 80, use logarithmic interpolation
		float t = (ire - 0.3) / (0.8 - 0.3); // Linear t from 0 to 1
		float a = 5.0; // Logarithmic strength (higher = stronger curve)
		float t_log = log(1.0 + t * a) / log(1.0 + a); // Logarithmic t from 0 to 1
		gamma = 1.0 + lerp(GammaIRE30, GammaIRE80, t_log);
	}
	#endif

	// Apply the gamma adjustment to the backbuffer color
	// Use pow(color, 1.0 / gamma) to adjust the tonal curve based on the computed gamma
	color = pow(color, 1.0 / gamma);

	// Clamp the resulting color to the valid range [0,1]
	// saturate() ensures no negative values or values above 1, preventing artifacts
	return saturate(color);
}

// Define the shader technique named grok3_Gamma
// Techniques group passes to apply effects in a specific order
technique grok3_Gamma
{
	// Define a single rendering pass for the gamma adjustment and debug display
	pass
	{
		// Use ReShade’s built-in post-process vertex shader
		// PostProcessVS handles standard vertex transformations for full-screen effects
		VertexShader = PostProcessVS;

		// Specify the pixel shader to be executed for this pass
		// GammaPass handles both gamma adjustments and debug IRE scale rendering
		PixelShader = GammaPass;

		// Optional: RenderTarget = BackBuffer is commented out as it’s the default
		// This indicates the output is written directly to the backbuffer
		/* RenderTarget = BackBuffer */
	}
}
