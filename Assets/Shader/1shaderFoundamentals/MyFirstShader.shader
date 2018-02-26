Shader "Custom/MyFirstShader" 
{
	Properties
	{
		_Tint("Tint",color) = (1,1,1,1)
		_MainTex("Texture",2d) = "white"{}
	}
	SubShader
	{
		pass
		{
			CGPROGRAM
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram
			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;//贴图的tiling与offset

			struct VertexData 
			{
				float4 position:POSITION;//模型空间顶点坐标
				float2 uv:TEXCOORD0;//模型顶点uv
			};

			struct Interpolators
			{
				float4 position:SV_POSITION;
				//float3 localPosition:TEXCOORD0;//把模型顶点的物体坐标转为颜色
				float2 uv:TEXCOORD0;//把模型顶点的uv坐标转为颜色
			};

			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;
				//i.localPosition = v.position.xyz;//把模型顶点的物体坐标转为颜色
				i.uv = v.uv*_MainTex_ST.xy+_MainTex_ST.zw; // UnityCG.cginc中有一个宏定义 TRANSFORM_TEX(v.uv,_MainTex)与这句对应
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				return i;
			}

			float4 MyFragmentProgram(Interpolators i):SV_TARGET
			{
				//return float4(i.localPosition+0.5,1)*_Tint;//把模型顶点的物体坐标转为颜色
				//return float4(i.uv,1,1);//把模型顶点的uv坐标转为颜色
				return tex2D(_MainTex,i.uv)*_Tint;//为模型贴上纹理
			}
			ENDCG
		}
	}
}
