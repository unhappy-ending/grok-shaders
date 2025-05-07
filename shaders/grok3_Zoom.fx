#include "ReShade.fxh"

// Slider for controlling the zoom level
uniform float ZoomLevel <
ui_type = "slider";
ui_min = -1.0;
ui_max = 10.0;
ui_step = 0.01;
ui_label = "Zoom Level";
ui_tooltip = "Adjusts the zoom (negative = zoom out, 0 = no zoom, positive = zoom in).";
> = 0.0;

float4 Zoom_PS(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color
	float4 color;

	// Center texture coordinates around (0.5, 0.5)
	float2 centeredTexcoord = texcoord - 0.5;

	// Apply zoom: positive ZoomLevel zooms in (scale < 1), negative zooms out (scale > 1)
	float scale = 1.0 / (1.0 + ZoomLevel);
	centeredTexcoord *= scale;

	// Shift back to original coordinate space
	centeredTexcoord += 0.5;

	// Sample the color at the scaled coordinates
	color = tex2D(ReShade::BackBuffer, centeredTexcoord);

	// Handle out-of-bounds coordinates (black for simplicity)
	if (centeredTexcoord.x < 0.0 || centeredTexcoord.x > 1.0 ||
		centeredTexcoord.y < 0.0 || centeredTexcoord.y > 1.0)
	{
		color = float4(0.0, 0.0, 0.0, 1.0); // Black for out-of-bounds
	}

	return color;
}

technique grok3_Zoom
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = Zoom_PS;
	}
}
