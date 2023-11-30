Shader "Human/Hair/ExHair2"
{
    Properties
    {
        _Color ("Hair Color", Color) = (1,1,1,1)
        _MainTex ("Hair Texture", 2D) = "white" { }
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Glossiness ("Glossiness", Range(0, 1)) = 0.5
        _Alpha ("Alpha", Range(0, 1)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="TransparentCutout" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On
        Cull Off

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        sampler2D _MainTex;
        fixed4 _Color;
        fixed _Specular;
        fixed _Glossiness;
        fixed _Alpha;

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Specular = _Specular;
            o.Smoothness = _Glossiness;
            o.Alpha = _Alpha;
        }
        ENDCG
    }

    CustomEditor "ShaderForgeMaterialInspector"
}