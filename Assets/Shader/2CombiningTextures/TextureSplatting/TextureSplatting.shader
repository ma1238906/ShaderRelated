//根据遮罩图来显示出不同的颜色
Shader "Custom/TextureSplatting" 
{
	Properties 
	{
		_Tint("Tint",color) = (1,1,1,1)
		_MainTex("MainTex",2d) = "white"{}
		[NoScaleOffset]_Texture1("Texture1",2d) = "white"{}
		[NoScaleOffset]_Texture2("Texture2",2d) = "white"{}
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

			sampler2D _Texture1, _Texture2;

			struct appDate 
			{
				float4 position:POSITION;
				float2 uv:TEXCOORD0;
			};
			 
			struct v2f 
			{
				float4 position:SV_POSITION;
				float2 uv:TEXCOORD0;
				float2 uvSplat:TEXCOORD1;
			};

			v2f vert(appDate i)
			{
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, i.position);
				o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				o.uvSplat = i.uv;
				return o;
			}

			float4 frag(v2f i):SV_TARGET
			{
				float4 splat = tex2D(_MainTex,i.uv);
				//根据遮罩图来显示出不同的颜色
				return tex2D(_Texture1,i.uv*10)*splat.r+
						tex2D(_Texture2,i.uv*10)*(1-splat.r);
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
