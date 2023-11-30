Shader "Nature/Rock" {
    Properties {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _SpecularMap("Specular Map", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Tiling("Tiling", Range(1, 10)) = 3
        _TessellationAmount("Tessellation Amount", Range(1, 10)) = 1
    }

    SubShader {
        Tags {"Queue" = "Overlay" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Standard addshadow tessellate:tessPhong

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _SpecularMap;

        struct Input {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_SpecularMap;
        };

        fixed _Smoothness;
        float _Tiling;
        float _TessellationAmount;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex * _Tiling);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap * _Tiling));
            o.Specular = tex2D(_SpecularMap, IN.uv_SpecularMap * _Tiling).r;
            o.Smoothness = _Smoothness;
            o.TessEdgeLength = _TessellationAmount;
            o.TessellationAmount = _TessellationAmount;
        }
        ENDCG
    }
    
    Fallback "Diffuse"
}
