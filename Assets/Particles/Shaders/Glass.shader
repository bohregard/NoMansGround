// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Glass"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_PatternTiling("PatternTiling", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _CameraDepthTexture;
		uniform sampler2D _TextureSample0;
		uniform float2 _PatternTiling;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV8 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode8 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV8, 2.0 ) );
			float4 temp_cast_0 = (fresnelNode8).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth25 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth25 = abs( ( screenDepth25 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float4 temp_cast_1 = (( 1.0 - distanceDepth25 )).xxxx;
			float4 temp_output_23_0 = max( CalculateContrast(0.5,temp_cast_0) , temp_cast_1 );
			float4 lerpResult11 = lerp( float4(0,1,0.8758622,0) , float4(0,0.1724138,1,0) , temp_output_23_0);
			o.Emission = lerpResult11.rgb;
			float4 temp_cast_3 = (( 1.0 - distanceDepth25 )).xxxx;
			float fresnelNdotV36 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode36 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV36, 1.0 ) );
			float2 uv_TexCoord26 = i.uv_texcoord * _PatternTiling;
			o.Alpha = max( temp_output_23_0 , ( fresnelNode36 + ( tex2D( _TextureSample0, uv_TexCoord26 ) * abs( ( _SinTime.w * 2.0 ) ) ) ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
774;92;762;433;1863.651;317.0761;2.383211;True;False
Node;AmplifyShaderEditor.Vector2Node;35;-1330.733,456.6305;Float;False;Property;_PatternTiling;PatternTiling;1;0;Create;True;0;0;False;0;0,0;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinTimeNode;31;-659.3051,586.0942;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-760.9688,735.7122;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-491.8277,709.0851;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1126.749,411.5091;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;20,20;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-830.1071,398.4287;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;2e0a56d9481d51e4daf274761b6896d8;2e0a56d9481d51e4daf274761b6896d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1165.712,153.2493;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;25;-816.0396,149.7221;Float;False;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;33;-373.2246,654.2744;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;8;-1389.916,-48.48251;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-528.7811,486.002;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;20;-596.8837,119.3459;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;14;-985.8251,31.96551;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;36;-555.0152,263.4745;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-198.516,397.4166;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;23;-548.577,7.440312;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-688.357,-182.0906;Float;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;0,0.1724138,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-637.7512,-342.7095;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-377.291,-149.4581;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;30;-847.9523,649.868;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;27;-316.7335,35.11273;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;9;-1027.89,807.1277;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-1044.358,665.0932;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;31;4
WireConnection;32;1;16;0
WireConnection;26;0;35;0
WireConnection;10;1;26;0
WireConnection;33;0;32;0
WireConnection;28;0;10;0
WireConnection;28;1;33;0
WireConnection;20;0;25;0
WireConnection;14;1;8;0
WireConnection;14;0;15;0
WireConnection;37;0;36;0
WireConnection;37;1;28;0
WireConnection;23;0;14;0
WireConnection;23;1;20;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;23;0
WireConnection;30;0;29;0
WireConnection;27;0;23;0
WireConnection;27;1;37;0
WireConnection;0;2;11;0
WireConnection;0;9;27;0
ASEEND*/
//CHKSM=34966FF8EBFFACA6203D1B975E6FB903300DB344