Shader "Custom/CombiningTextureShader" 
{
	Properties 
	{
		_Tint("Tint",color) = (1,1,1,1)
		_MainTex("Texture",2d) = "white"{}
		_DetailTex("Detail Texture",2d) = "white"{}
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
			sampler2D _MainTex,_DetailTex;
			float4 _MainTex_ST, _DetailTex_ST;

			struct VertexData 
			{
				float4 position:POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f 
			{
				float4 position:SV_POSITION;
				float2 uv:TEXCOORD0;
				float2 uvDetail:TEXCOORD1;
			};

			v2f vert(VertexData i)
			{
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, i.position);
				o.uv = i.uv*_MainTex_ST.xy+_MainTex_ST.zw;
				o.uvDetail = TRANSFORM_TEX(i.uv, _DetailTex);
				return o;
			}

			float4 frag(v2f i) :SV_TARGET
			{
				float4 color = tex2D(_MainTex,i.uv)*_Tint;
				color *= tex2D(_DetailTex, i.uvDetail)*unity_ColorSpaceDouble;//使用了detailTexture使距离模型更近的时候不产生锯齿,作为detailTexture 的图片通常勾选上fadeout mip maps ;颜色空间：gamma linear。linear 对于光线反射更真实，但是变暗了，unity_ColorSpaceDouble是为了对应两种颜色空间
				return color;
			}

			ENDCG
		}	
		
	}
}
