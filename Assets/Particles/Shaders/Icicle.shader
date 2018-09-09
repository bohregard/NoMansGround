// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/IceShader"
{
	Properties
	{
		_IceMask("IceMask", 2D) = "white" {}
		_DarkTone("DarkTone", Color) = (0,0.2420384,0.9485294,0)
		_FreezeAmount("FreezeAmount", Range( 0.001 , 1)) = 1
		_LightTone("LightTone", Color) = (0,0.8035495,0.8382353,0)
		_IcicileTest_NM("IcicileTest_NM", 2D) = "bump" {}
		_GroundBump_NM("GroundBump_NM", 2D) = "bump" {}
		_Scale("Scale", Float) = 1
		_Fringe("Fringe", Float) = 10
		_EmissiveAmount("EmissiveAmount", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "black" {}
		_FadeCharacter("FadeCharacter", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _FreezeAmount;
		uniform float _Fringe;
		uniform sampler2D _IceMask;
		uniform float4 _IceMask_ST;
		uniform sampler2D _GroundBump_NM;
		uniform float _Scale;
		uniform sampler2D _IcicileTest_NM;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _LightTone;
		uniform float4 _DarkTone;
		uniform float _EmissiveAmount;
		uniform float _FadeCharacter;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float ifLocalVar46 = 0;
			if( _FreezeAmount <= 0.0 )
				ifLocalVar46 = 0.0;
			else
				ifLocalVar46 = ( _FreezeAmount + ( _Fringe / 100.0 ) );
			float2 uv_IceMask = i.uv_texcoord * _IceMask_ST.xy + _IceMask_ST.zw;
			float4 tex2DNode35 = tex2D( _IceMask, uv_IceMask );
			float2 temp_output_17_0 = ( i.uv_texcoord * _Scale );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode67 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 ifLocalVar61 = 0;
			if( ifLocalVar46 <= tex2DNode35.r )
				ifLocalVar61 = tex2DNode67;
			else
				ifLocalVar61 = float4( ( UnpackNormal( tex2D( _GroundBump_NM, temp_output_17_0 ) ) + UnpackNormal( tex2D( _IcicileTest_NM, temp_output_17_0 ) ) ) , 0.0 );
			o.Normal = ifLocalVar61.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode6 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV6, 5.0 ) );
			float4 lerpResult5 = lerp( _LightTone , _DarkTone , ( 1.0 - fresnelNode6 ));
			o.Albedo = lerpResult5.rgb;
			float4 _Color0 = float4(0,0,0,0);
			float4 ifLocalVar48 = 0;
			if( ifLocalVar46 <= tex2DNode35.r )
				ifLocalVar48 = _Color0;
			else
				ifLocalVar48 = float4(0,0.5517241,0.9411765,0);
			o.Emission = ( ifLocalVar48 * _EmissiveAmount ).rgb;
			o.Metallic = 0.0;
			float2 uv_TexCoord12 = i.uv_texcoord * float2( 200,200 );
			float simplePerlin2D10 = snoise( uv_TexCoord12 );
			float4 temp_cast_4 = (( 0.3 + simplePerlin2D10 )).xxxx;
			float4 ifLocalVar65 = 0;
			if( ifLocalVar46 <= tex2DNode35.r )
				ifLocalVar65 = tex2DNode67;
			else
				ifLocalVar65 = temp_cast_4;
			o.Smoothness = ifLocalVar65.r;
			float4 temp_cast_6 = (0.0).xxxx;
			float4 _Color1 = float4(1,1,1,0);
			float4 ifLocalVar70 = 0;
			if( _FadeCharacter <= tex2DNode35.r )
				ifLocalVar70 = _Color1;
			else
				ifLocalVar70 = temp_cast_6;
			o.Alpha = ifLocalVar70.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows noshadow 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
822;92;714;433;-718.0559;-382.4834;1.703923;True;False
Node;AmplifyShaderEditor.RangedFloatNode;43;186.893,1081.92;Float;False;Property;_Fringe;Fringe;7;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-972.6964,882.2302;Float;False;Property;_Scale;Scale;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;386.6844,1095.859;Float;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1038.996,606.6304;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;122.7056,998.8417;Float;False;Property;_FreezeAmount;FreezeAmount;2;0;Create;True;0;0;False;0;1;0;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-501.8976,482.7585;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;200,200;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-734.7966,775.6299;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;47;256.089,750.2122;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;543.1103,1060.237;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-291.2976,491.8586;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;6;-538.6264,-184.0681;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;681.2194,1008.176;Float;True;Property;_IceMask;IceMask;0;0;Create;True;0;0;False;0;cd460ee4ac5c1e746b7a734cc7cc64dd;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;50;1023.534,1029.642;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;46;575.6693,806.7184;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;974.2029,667.7782;Float;False;Constant;_IceColor;IceColor;6;0;Create;True;0;0;False;0;0,0.5517241,0.9411765,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-516.2462,860.7322;Float;True;Property;_IcicileTest_NM;IcicileTest_NM;4;0;Create;True;0;0;False;0;47f55a2f2a2d9cc4ab8fb64c19bf99b3;47f55a2f2a2d9cc4ab8fb64c19bf99b3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-520.392,656.2638;Float;True;Property;_GroundBump_NM;GroundBump_NM;5;0;Create;True;0;0;False;0;56344b0ef0650184cbf36175ce6dd087;56344b0ef0650184cbf36175ce6dd087;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-51.11967,292.9548;Float;False;Constant;_Roughness;Roughness;2;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;10;-39.51151,383.1812;Float;True;Simplex2D;1;0;FLOAT2;4.5,3.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;1563.667,1060.774;Float;False;Property;_EmissiveAmount;EmissiveAmount;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-427.0756,-568.2892;Float;False;Property;_LightTone;LightTone;3;0;Create;True;0;0;False;0;0,0.8035495,0.8382353,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;48;1161.733,834.1763;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-213.6582,742.3074;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;67;218.5427,501.23;Float;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;240.1252,314.5782;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-223.6821,-188.816;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-425.7931,-398.0439;Float;False;Property;_DarkTone;DarkTone;1;0;Create;True;0;0;False;0;0,0.2420384,0.9485294,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;1253.834,576.3721;Float;False;Property;_FadeCharacter;FadeCharacter;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;1269.38,1040.785;Float;False;Constant;_Color1;Color 1;11;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;1242.847,689.378;Float;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;897.1762,42.5304;Float;False;Constant;_Metallic;Metallic;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1433.933,844.0515;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;65;676.642,397.7385;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;70;1403.152,663.9387;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-199.9422,-459.4464;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;61;781.5927,573.5489;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1678.313,212.329;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Custom/IceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;43;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;45;0;40;0
WireConnection;45;1;44;0
WireConnection;12;0;13;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;46;2;45;0
WireConnection;46;3;47;0
WireConnection;46;4;47;0
WireConnection;14;1;17;0
WireConnection;15;1;17;0
WireConnection;10;0;12;0
WireConnection;48;0;46;0
WireConnection;48;1;35;1
WireConnection;48;2;38;0
WireConnection;48;3;50;0
WireConnection;48;4;50;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;7;0;6;0
WireConnection;51;0;48;0
WireConnection;51;1;52;0
WireConnection;65;0;46;0
WireConnection;65;1;35;1
WireConnection;65;2;11;0
WireConnection;65;3;67;0
WireConnection;65;4;67;0
WireConnection;70;0;68;0
WireConnection;70;1;35;1
WireConnection;70;2;71;0
WireConnection;70;3;72;0
WireConnection;70;4;72;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;7;0
WireConnection;61;0;46;0
WireConnection;61;1;35;1
WireConnection;61;2;16;0
WireConnection;61;3;67;0
WireConnection;61;4;67;0
WireConnection;0;0;5;0
WireConnection;0;1;61;0
WireConnection;0;2;51;0
WireConnection;0;3;8;0
WireConnection;0;4;65;0
WireConnection;0;9;70;0
ASEEND*/
//CHKSM=1B5AC5823EEAC02D7A609993E3F5D2725C60E29D