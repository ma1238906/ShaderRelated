Shader "Custom/computerShader3" 
{
	Properties 
	{
		_MainCube("base",cube) = "white"{}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		pass 
		{
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			StructuredBuffer<float3> points;
			samplerCUBE _MainCube;

			struct vertIN
			{
				uint id:SV_VertexID;
			};

			struct vertOUT 
			{
				float4 pos :SV_POSITION;
				float3 nDir :NORMAL;
				float3 vDir :TEXCOORD0;
				float3 rDir :TEXCOORD1;
			};

			vertOUT vert(vertIN i)
			{
				vertOUT o;
				float4 position = float4(points[i.id], 1);
				o.pos = mul(UNITY_MATRIX_MVP, position);
				if (position.z == 0)
					o.nDir = fixed3(0, 0, 1);
				else
					o.nDir = fixed3(1, 0, 0);
				o.vDir = normalize(WorldSpaceViewDir(position));
				o.rDir = reflect(-o.vDir, o.nDir);
				return o;
			}

			fixed4 frag(vertOUT I):SV_TARGET
			{
				fixed4 c = texCUBE(_MainCube,I.rDir);
				return c;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
