Shader "Custom/ClothShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _Tessellation ("Tessellation Factor", Range(1, 32)) = 1
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
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Specular = 0.2;
            o.Smoothness = 0.5;
            o.Alpha = 1.0;
        }

        [maxtess 64]
        void TessFunction(Input IN, Output o, float2 tess)
        {
            o[0] = tess.x * _Tessellation;
            o[1] = tess.y * _Tessellation;
        }
        ENDCG
    }

    CustomEditor "ShaderForgeMaterialInspector"
}
