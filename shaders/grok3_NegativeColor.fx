#include "ReShade.fxh"

// Slider for controlling the intensity of the negative effect (0.0 = original, 1.0 = full negative)
uniform float NegativeIntensity <
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.01;
ui_label = "Negative Effect Intensity";
ui_tooltip = "Adjusts the strength of the negative color effect (0 = original image, 1 = full negative).";
> = 1.0;

float4 NegativeColor_PS(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Calculate inverted color
	float3 inverted = 1.0 - color.rgb;

	// Lerp between original and inverted color based on intensity
	color.rgb = lerp(color.rgb, inverted, NegativeIntensity);

	return color;
}

technique grok3_NegativeColor
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = NegativeColor_PS;
		/* RenderTarget = BackBuffer */
	}
}
