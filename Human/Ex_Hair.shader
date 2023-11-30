Shader "Human/Hair/ExHair"
{
    Properties
    {
        _Color ("Hair Color", Color) = (1,1,1,1)
        _MainTex ("Hair Texture", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Glossiness ("Glossiness", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed4 _Color;
        fixed _Specular;
        fixed _Glossiness;

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Specular = _Specular;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }

    CustomEditor "ShaderForgeMaterialInspector"
}