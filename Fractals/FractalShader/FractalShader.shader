Shader "Fractals/FractalShader"
{
    Properties
    {
        _MaxIterations("Max Iterations", Range(1, 500)) = 100
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _MaxIterations;
        fixed4 fractalColor(float2 uv, int iterations)
        {
            float3 color = float3(0, 0, 0);
            color = 0.5 + 0.5 * sin(iterations * 0.1 + uv.xyx * 10);

            return fixed4(color, 1.0);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float2 uv = (IN.uv_MainTex - 0.5) * 4;
            float2 z = uv;
            int iterations;
            for (iterations = 0; iterations < _MaxIterations; iterations++)
            {
                z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + uv;
            }
            fixed4 color = fractalColor(uv, iterations);
            o.Albedo = color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
