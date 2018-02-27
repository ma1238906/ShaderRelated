Shader "Custom/MuiltSampler" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScanTex("ScanTex",2d) = "white"{}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" "Queue" ="Geometry"}
		LOD 200
		
		pass 
		{
			//Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _ScanTex;
			float4 _ScanTex_ST;
			float4 _Color;

			struct v2f
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
				float2 uv1:TEXCOORD1;
			};

			v2f vert(appdata_base i)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = i.texcoord;
				o.uv1 = TRANSFORM_TEX(i.texcoord, _ScanTex) + frac(float2(0, -.5)*_Time.y);
				return o;
			}

			half4 frag(v2f i):SV_TARGET
			{
				half4 color;
				half4 color1;
				half alpha;
				color = tex2D(_MainTex, i.uv);
				color1 = tex2D(_ScanTex, i.uv1)*_Color;
				alpha = color1.w;
				color = color*(1 - alpha) + color1*alpha;
				return color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
