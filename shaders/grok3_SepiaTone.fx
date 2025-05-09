// Include the ReShade standard header file to access common functions and definitions
// Provides access to the backbuffer texture, texture sampling, and post-process vertex shader
#include "ReShade.fxh"

// Define a uniform float variable for controlling the intensity of the sepia tone effect
// This slider blends between the original color and a sepia tone
uniform float SepiaIntensity <
// UI category for this slider, ensuring it appears under "Grok Sepia Tone"
ui_category = "Grok Sepia Tone";
// Specify the UI control type as a slider for intuitive adjustment
ui_type = "slider";
// Set the minimum value to 0.0 (original colors, no sepia effect)
ui_min = 0.0;
// Set the maximum value to 1.0 (full sepia tone effect)
ui_max = 1.0;
// Define the step size for fine-grained control (0.01 increments)
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Sepia Intensity";
// Tooltip explaining the slider’s effect
ui_tooltip = "Controls the strength of the sepia tone effect. 0.0 = original colors, 1.0 = full sepia tone, intermediate values blend the two.";
> = 0.5; // Default to a balanced blend of original and sepia

// Pixel shader function that applies the sepia tone effect
// Takes vertex position (vpos) and texture coordinates (texcoord) as input
// Returns the modified color with a sepia tone as the shader output
float4 PS_SepiaTone(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color from the backbuffer at the given texture coordinates
	// ReShade::BackBuffer provides access to the current frame’s pixel data
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Compute the sepia tone color using a color matrix
	// The matrix transforms RGB values to a sepia-like tone with brownish hues
	float3 sepia = float3(
		// Red component: weighted sum of RGB to produce sepia red (stronger contribution from green)
		dot(color.rgb, float3(0.393, 0.769, 0.189)),
			      // Green component: balanced contribution from RGB for sepia green
			      dot(color.rgb, float3(0.349, 0.686, 0.168)),
			      // Blue component: reduced contribution for sepia blue, emphasizing brownish tones
			      dot(color.rgb, float3(0.272, 0.534, 0.131))
	);

	// Blend the original color with the sepia tone based on SepiaIntensity
	// SepiaIntensity = 0.0 returns original color, 1.0 returns full sepia, intermediate values interpolate
	float3 finalColor = lerp(color.rgb, sepia, SepiaIntensity);

	// Return the final color, preserving the alpha channel
	// Ensures the output is in the valid range [0,1] for RGB
	return float4(finalColor, color.a);
}

// Define the shader technique named grok3_SepiaTone
// Techniques group passes to apply effects in a specific order
technique grok3_SepiaTone
{
	// Define a single rendering pass for the sepia tone effect
	pass
	{
		// Use ReShade’s built-in post-process vertex shader
		// PostProcessVS handles standard vertex transformations for full-screen effects
		VertexShader = PostProcessVS;

		// Specify the pixel shader to be executed for this pass
		// PS_SepiaTone handles the sepia tone effect
		PixelShader = PS_SepiaTone;

		// Optional: RenderTarget = BackBuffer is commented out as it’s the default
		// This indicates the output is written directly to the backbuffer
		/* RenderTarget = BackBuffer */
	}
}
