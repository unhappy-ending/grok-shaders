// Include the ReShade standard header file to access common functions and definitions
// Provides access to the backbuffer texture, texture sampling, and post-process vertex shader
#include "ReShade.fxh"

// Define a uniform float variable for controlling the exposure adjustment
// This slider scales the RGB color values to darken or brighten the image
uniform float Exposure <
// UI category for this slider, ensuring it appears under "Grok Exposure"
ui_category = "Grok Exposure";
// Specify the UI control type as a slider for intuitive adjustment
ui_type = "slider";
// Set the minimum value to 0.0 (completely dark image)
ui_min = 0.0;
// Set the maximum value to 2.0 (doubles the color intensity, may clip highlights)
ui_max = 2.0;
// Define the step size for fine-grained control (0.01 increments)
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Exposure";
// Tooltip explaining the slider’s effect
ui_tooltip = "Adjusts the exposure of the image by scaling RGB values. 0.0 = fully dark, 1.0 = original, 2.0 = doubled intensity (may clip highlights).";
> = 1.0; // Default to no change (original image)

// Pixel shader function that applies the exposure adjustment
// Takes vertex position (vpos) and texture coordinates (texcoord) as input
// Returns the modified color with scaled RGB values as the shader output
float4 PS_Exposure(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color from the backbuffer at the given texture coordinates
	// ReShade::BackBuffer provides access to the current frame’s pixel data
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Scale the RGB color by the Exposure value to adjust intensity
	// Exposure < 1.0 darkens, 1.0 preserves, > 1.0 brightens (may clip to 1.0)
	color.rgb *= Exposure;

	// Return the modified color, preserving the alpha channel
	// No clamping is applied, as ReShade’s output is typically clamped to [0,1]
	return color;
}

// Define the shader technique named grok3_Exposure
// Techniques group passes to apply effects in a specific order
technique grok3_Exposure
{
	// Define a single rendering pass for the exposure adjustment
	pass
	{
		// Use ReShade’s built-in post-process vertex shader
		// PostProcessVS handles standard vertex transformations for full-screen effects
		VertexShader = PostProcessVS;

		// Specify the pixel shader to be executed for this pass
		// PS_Exposure handles the exposure adjustment
		PixelShader = PS_Exposure;

		// Optional: RenderTarget = BackBuffer is commented out as it’s the default
		// This indicates the output is written directly to the backbuffer
		/* RenderTarget = BackBuffer */
	}
}
