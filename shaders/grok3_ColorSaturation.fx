// Grok Shaders - Color Saturation
// A ReShade 6.4.0 post-processing shader to adjust overall color saturation in RGB space, using sRGB luminance weights for PC displays.
// Created with assistance from Grok 3, xAI.
// MIT License

#include "ReShade.fxh"

// UI Controls
uniform float Saturation <
ui_type = "slider";
ui_category = "Grok Color Saturation";
ui_label = "Saturation";
ui_min = 0.0; ui_max = 2.0; ui_step = 0.01;
ui_tooltip = "Adjusts overall color saturation. 0.0 = fully desaturated (black and white), 1.0 = original, 2.0 = double saturation.";
> = 1.0;

// Pixel Shader
float4 PS_ColorSaturation(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	// Sample the original color from the back buffer
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Calculate luminance using sRGB weights for accurate grayscale
	// Weights (0.299, 0.587, 0.114) reflect human vision’s sensitivity, optimized for sRGB monitors
	float luminance = dot(color.rgb, float3(0.299, 0.587, 0.114));

	// Apply saturation: Lerp between grayscale (luminance) and original color
	// 0.0 = full grayscale, 1.0 = original, 2.0 = double saturation
	float3 result = lerp(float3(luminance, luminance, luminance), color.rgb, Saturation);

	// Clamp to valid RGB range to prevent artifacts
	result = saturate(result);

	// Return final color with original alpha
	return float4(result, color.a);
}

// Technique
technique grok3_ColorSaturation
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_ColorSaturation;
	}
}
