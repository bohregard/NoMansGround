// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Toon" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { }
		_IntensityDamp("Intensity Damper", Range(-.3,.03)) = 0
		_FaceCamera("Face Camera", Range(0,1)) = 1
		_BrightnessDim("Brightness Dimmer", Range(1,10)) = 1
		_Brightness("Brightness", Range(1,3)) = 2
	}


	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Name "CUSTOM"
			Cull Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			samplerCUBE _ToonShade;
			float4 _MainTex_ST;
			float4 _Color;


			struct appdata {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float3 cubenormal : TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			float _Brightness;
			float _IntensityDamp;
			float _FaceCamera;
			float _BrightnessDim;

			v2f vert (appdata v)
			{

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				if (_FaceCamera == 1) {
					o.cubenormal = mul(UNITY_MATRIX_MV, float4(v.normal, _IntensityDamp));
				}
				else
					o.cubenormal = mul(UNITY_MATRIX_V, float4(v.normal, _IntensityDamp));
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _Color/_BrightnessDim* tex2D(_MainTex, i.texcoord);
				fixed4 cube = texCUBE(_ToonShade, i.cubenormal);
				fixed4 c = fixed4(_Brightness * cube.rgb * col.rgb, col.a);
				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG			
		}
	} 

	Fallback "VertexLit"
}
