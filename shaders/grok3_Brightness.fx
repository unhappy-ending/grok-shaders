#include "ReShade.fxh"

uniform float Brightness <
ui_label = "Brightness";
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
> = 1.0;

float4 PS_Brightness(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
	float4 color = tex2D(ReShade::BackBuffer, texcoord);
	return color * Brightness;
}

technique grok3_Brightness {
	pass {
		VertexShader = PostProcessVS;
		PixelShader = PS_Brightness;
	}
}
