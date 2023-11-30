Shader "Nature/Water/Water"
{
    Properties
    {
        _Color("Water Color", Color) = (0.0, 0.5, 1.0, 1.0)
        _DepthColor("Depth Color", Color) = (0.0, 0.2, 0.5, 1.0)
        _WaveSpeed("Wave Speed", Range(0, 5)) = 1.0
        _WaveStrength("Wave Strength", Range(0, 1)) = 0.1
        _FoamColor("Foam Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _FoamThreshold("Foam Threshold", Range(0, 1)) = 0.5
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    ENDCG

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _CameraDepthTexture;

        struct Input
        {
            float2 uv_CameraDepthTexture;
        };

        fixed4 _Color;
        fixed4 _DepthColor;
        float _WaveSpeed;
        float _WaveStrength;
        fixed4 _FoamColor;
        float _FoamThreshold;
        fixed4 depthColor(float depth)
        {
            return lerp(_Color, _DepthColor, smoothstep(0.1, 0.5, depth));
        }

        float wave(float time, float speed, float strength, float uv)
        {
            return sin(time * speed + uv) * strength;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float depth = LinearEyeDepth(tex2D(_CameraDepthTexture, IN.uv_CameraDepthTexture).r);
            fixed4 waterColor = depthColor(depth);
            float waveOffset = wave(_Time.y, _WaveSpeed, _WaveStrength, IN.uv_CameraDepthTexture.x + IN.uv_CameraDepthTexture.y);
            o.Albedo = waterColor.rgb + waveOffset;
            float foam = smoothstep(_FoamThreshold - 0.02, _FoamThreshold + 0.02, depth);
            fixed4 foamColor = lerp(waterColor, _FoamColor, foam);
            o.Emission = foamColor.rgb;
            o.Alpha = waterColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
