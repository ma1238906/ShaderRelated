Shader "Custom/FirstLightingShader" 
{
	Properties 
	{
		_Tint("Tint",color) = (1,1,1,1)
		_MainTex("MainTex",2d) = "white"{}
	}
	SubShader 
	{
		pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appData 
			{
				float4 position:POSITION;
				float3 normal:NORMAL;
				float2 uv:TEXCOORD0;
			};

			struct v2f 
			{
				float4 position:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 normal:TEXCOORD1;
			};

			v2f vert(appData i)
			{
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, i.position);
				o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				o.normal = i.normal;
				return o;
			}

			float4 frag(v2f i):SV_TARGET
			{
				return float4(i.normal*0.5+0.5,1);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
