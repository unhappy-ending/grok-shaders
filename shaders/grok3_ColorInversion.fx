// Include the ReShade standard header file to access common functions and definitions
// Provides access to the backbuffer texture, texture sampling, and post-process vertex shader
#include "ReShade.fxh"

// Define a preprocessor directive to enable/disable debug mode
// ENABLE_DEBUG = 1 splits the screen (left half inverted, right half normal) only when EnableInversion = true; ENABLE_DEBUG = 0 applies full inversion when EnableInversion = true
#ifndef ENABLE_DEBUG
#define ENABLE_DEBUG 0
#endif

// Define a uniform boolean variable for toggling the color inversion effect
// This toggle enables or disables inversion and gates the debug mode when ENABLE_DEBUG = 1
uniform bool EnableInversion <
// UI category for this toggle, ensuring it appears under "Grok Color Inversion"
ui_category = "Grok Color Inversion";
// Specify the UI control type as a boolean toggle (on/off)
ui_type = "bool";
// Label displayed in the ReShade UI for this toggle
ui_label = "Enable Color Inversion";
// Tooltip explaining the toggle’s effect
ui_tooltip = "Enables or disables the color inversion effect. When true and ENABLE_DEBUG = 0, applies full inversion; when true and ENABLE_DEBUG = 1, splits screen (left inverted, right normal). When false, shows original image, ignoring ENABLE_DEBUG.";
> = true; // Default to inversion enabled

// Pixel shader function that applies the color inversion effect or debug split-screen
// Takes vertex position (vpos) and texture coordinates (texcoord) as input
// Returns the modified color (inverted or original) as the shader output
float4 ColorInversion_PS(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color from the backbuffer at the given texture coordinates
	// ReShade::BackBuffer provides access to the current frame’s pixel data
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Check if inversion is enabled to determine whether to apply inversion or debug mode
	if (EnableInversion) {
		// Inversion is enabled: check debug mode to decide between split-screen or full inversion
		#if ENABLE_DEBUG
		// Debug mode: split the screen into left (inverted) and right (normal)
		if (texcoord.x < 0.5) {
			// Left half of the screen: apply full inversion
			color.rgb = 1.0 - color.rgb;
		} else {
			// Right half of the screen: keep original color
			color.rgb = color.rgb;
		}
		#else
		// Normal mode: apply full color inversion to the entire screen
		color.rgb = 1.0 - color.rgb;
		#endif
	} else {
		// Inversion is disabled: keep original color, ignoring ENABLE_DEBUG
		color.rgb = color.rgb;
	}

	// Return the final color, preserving the alpha channel
	// Ensures the output is in the valid range [0,1] for RGB
	return color;
}

// Define the shader technique named grok3_ColorInversion
// Techniques group passes to apply effects in a specific order
technique grok3_ColorInversion
{
	// Define a single rendering pass for the color inversion effect
	pass
	{
		// Use ReShade’s built-in post-process vertex shader
		// PostProcessVS handles standard vertex transformations for full-screen effects
		VertexShader = PostProcessVS;

		// Specify the pixel shader to be executed for this pass
		// ColorInversion_PS handles color inversion and debug split-screen
		PixelShader = ColorInversion_PS;

		// Optional: RenderTarget = BackBuffer is commented out as it’s the default
		// This indicates the output is written directly to the backbuffer
		/* RenderTarget = BackBuffer */
	}
}
