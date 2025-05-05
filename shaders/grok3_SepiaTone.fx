#include "ReShade.fxh"

uniform float SepiaIntensity <
ui_label = "Sepia Intensity";
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
ui_tooltip = "Controls the strength of the sepia tone effect. 0 = original colors, 1 = full sepia.";
> = 0.5;

float4 PS_SepiaTone(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
	// Sample the backbuffer (screen color)
	float4 color = tex2D(ReShade::BackBuffer, texcoord);

	// Sepia tone matrix (converts RGB to sepia-like values)
	float3 sepia = float3(
		dot(color.rgb, float3(0.393, 0.769, 0.189)), // Red component
			      dot(color.rgb, float3(0.349, 0.686, 0.168)), // Green component
			      dot(color.rgb, float3(0.272, 0.534, 0.131))  // Blue component
	);

	// Blend original color with sepia based on intensity
	float3 finalColor = lerp(color.rgb, sepia, SepiaIntensity);

	return float4(finalColor, color.a);
}

technique grok3_SepiaTone {
	pass {
		VertexShader = PostProcessVS;
		PixelShader = PS_SepiaTone;
	}
}
