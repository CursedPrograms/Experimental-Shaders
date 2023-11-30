Shader "Glass/Glass" {
    Properties {
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _DisplacementStrength ("Displacement Strength", Range (0, 0.1)) = 0.02
    }

    SubShader {
        Tags {"Queue"="Overlay" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_NormalMap;
            float3 viewDir;
        };

        sampler2D _NormalMap;
        fixed _DisplacementStrength;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            float displace = _DisplacementStrength * tex2D(_NormalMap, IN.uv_NormalMap).r;
            IN.uv_NormalMap += displace * IN.viewDir.xz;
        }
        ENDCG
    }

    FallBack "Diffuse"
}