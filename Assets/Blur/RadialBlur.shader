//径向模糊
Shader "Custom/RadialBlur" 
{
	Properties 
	{
		_MainTex("Texture", 2D) = "white" {}
		_Level("Level",Range(1,100)) = 50
		_CenterX("Center.x",Range(0,1)) = 0.5
		_CenterY("Center.y",Range(0,1)) = 0.5
	}
	SubShader 
	{
		Tags{ "RenderType" = "Opaque" }
		pass
		{
			CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag  
			// make fog work  
			#pragma multi_compile_fog  

			#include "UnityCG.cginc"  

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			int _Level;
			fixed _CenterX;
			fixed _CenterY;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//设置径向模糊的中心位置，一般来说都是图片重心（0.5，0.5）  
				fixed2 center = fixed2(_CenterX,_CenterY);

				//计算像素与中心点的距离，距离越远偏移越大  
				fixed2 uv = i.uv - center;
				fixed3 col1 = fixed3(0,0,0);
				for (fixed j = 0; j < _Level; j++)
				{
					//根据设置的level对像素进行叠加，然后求平均值  
					col1 += tex2D(_MainTex, uv*(1 - 0.01*j) + center).rgb;
				}
				fixed4 col = fixed4(col1.rgb / _Level,1);
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
