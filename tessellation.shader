Shader "Custom/TessellationShader"
{
    Properties
    {
        _Tessellation ("Tessellation Factor", Range(1, 32)) = 1
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _LumaTex ("Luma Texture", 2D) = "white" { }
        _NoiseTex ("Noise Texture", 2D) = "white" { }
        _Metallic ("Metallic", Range(0, 1)) = 0.5
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert tessellate:TessFunction
        #pragma target 4.0

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_LumaTex;
            float2 uv_NoiseTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _LumaTex;
        sampler2D _NoiseTex;

        fixed _Metallic;
        fixed _Smoothness;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // Normal Map
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

            // Luma
            float luma = tex2D(_LumaTex, IN.uv_LumaTex).r;

            // Noise
            float noise = tex2D(_NoiseTex, IN.uv_NoiseTex).r;

            // Combine luma and noise for tessellation
            float tessellation = luma + noise;

            // Apply metallic and smoothness
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }

        // Tessellation function
        [maxtess 64]
        void TessFunction(Input IN, Output o, float2 tess)
        {
            o[0] = tess.x * _Tessellation; // Tessellation factor for outer tessellation
            o[1] = tess.y * _Tessellation; // Tessellation factor for inner tessellation
        }
        ENDCG
    }

    CustomEditor "ShaderForgeMaterialInspector"
}
