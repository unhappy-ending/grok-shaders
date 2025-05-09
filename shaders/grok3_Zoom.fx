// Include the ReShade standard header file to access common functions and definitions
// Provides access to the backbuffer texture, texture sampling, and post-process vertex shader
#include "ReShade.fxh"

// Define a uniform float variable for controlling the zoom level
// This slider adjusts the image’s zoom, centered at (0.5, 0.5)
uniform float ZoomLevel <
// UI category for this slider, ensuring it appears under "Grok Zoom"
ui_category = "Grok Zoom";
// Specify the UI control type as a slider for intuitive adjustment
ui_type = "slider";
// Set the minimum value to -0.75 (zooms out, increasing coordinate scale)
ui_min = -0.75;
// Set the maximum value to 10.0 (zooms in significantly, reducing coordinate scale)
ui_max = 10.0;
// Define the step size for fine-grained control (0.01 increments)
ui_step = 0.01;
// Label displayed in the ReShade UI for this slider
ui_label = "Zoom Level";
// Tooltip explaining the slider’s effect
ui_tooltip = "Adjusts the zoom level, centered at the screen’s middle. Negative values (down to -0.75) zoom out, 0.0 = no zoom, positive values (up to 10.0) zoom in. Out-of-bounds areas are black.";
> = 0.0; // Default to no zoom (original image)

// Pixel shader function that applies the zoom effect
// Takes vertex position (vpos) and texture coordinates (texcoord) as input
// Returns the color sampled at the scaled coordinates, or black for out-of-bounds areas
float4 Zoom_PS(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Center the texture coordinates around (0.5, 0.5) for uniform zooming
	// Subtracting 0.5 shifts the origin to the screen’s center
	float2 centeredTexcoord = texcoord - 0.5;

	// Compute the scaling factor based on ZoomLevel
	// scale = 1.0 / (1.0 + ZoomLevel): positive ZoomLevel reduces scale (zoom in), negative increases scale (zoom out)
	float scale = 1.0 / (1.0 + ZoomLevel);

	// Apply the zoom by scaling the centered coordinates
	// Smaller scale (e.g., 0.5) zooms in, larger scale (e.g., 2.0) zooms out
	centeredTexcoord *= scale;

	// Shift the coordinates back to the original texture space
	// Adding 0.5 repositions the origin to the top-left corner
	centeredTexcoord += 0.5;

	// Sample the color from the backbuffer at the scaled coordinates
	// ReShade::BackBuffer provides access to the current frame’s pixel data
	float4 color = tex2D(ReShade::BackBuffer, centeredTexcoord);

	// Check if the scaled coordinates are outside the valid texture range [0,1]
	// Out-of-bounds areas (e.g., when zooming out) are filled with black
	if (centeredTexcoord.x < 0.0 || centeredTexcoord.x > 1.0 ||
		centeredTexcoord.y < 0.0 || centeredTexcoord.y > 1.0)
	{
		// Return black (with full opacity) for out-of-bounds coordinates
		color = float4(0.0, 0.0, 0.0, 1.0);
	}

	// Return the final color, either sampled or black for out-of-bounds
	// Ensures the output is in the valid range [0,1] for RGB
	return color;
}

// Define the shader technique named grok3_Zoom
// Techniques group passes to apply effects in a specific order
technique grok3_Zoom
{
	// Define a single rendering pass for the zoom effect
	pass
	{
		// Use ReShade’s built-in post-process vertex shader
		// PostProcessVS handles standard vertex transformations for full-screen effects
		VertexShader = PostProcessVS;

		// Specify the pixel shader to be executed for this pass
		// Zoom_PS handles the zoom effect and out-of-bounds handling
		PixelShader = Zoom_PS;

		// Optional: RenderTarget = BackBuffer is commented out as it’s the default
		// This indicates the output is written directly to the backbuffer
		/* RenderTarget = BackBuffer */
	}
}
