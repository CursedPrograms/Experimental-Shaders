Shader "Fractals/ProceduralFractal" {
    Properties {
        _MainTex("Texture", 2D) = "white" { }
        _Power("Fractal Power", Range(1, 8)) = 4
        _MaxIterations("Max Iterations", Range(10, 100)) = 50
        _Scale("Scale", Range(0.1, 5.0)) = 1.0
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        float _Power;
        int _MaxIterations;
        float _Scale;

        float3 Mandelbulb(float3 p) {
            float3 z = p;
            float dr = 1.0;
            float r = 0.0;

            for (int i = 0; i < _MaxIterations; i++) {
                r = length(z);
                if (r > 2.0)
                    break;

                float theta = acos(z.y / r);
                float phi = atan2(z.z, z.x);
                dr = pow(r, _Power - 1.0) * _Power * dr + 1.0;

                float3 delta = _Scale * float3(
                    sin(_Power * theta) * cos(_Power * phi),
                    sin(_Power * theta) * sin(_Power * phi),
                    cos(_Power * theta)
                );

                z = z * delta + p;
            }

            return 0.5 + 0.5 * cos(3.0 * r + float3(0.0, 2.0, 4.0));
        }

        void surf(Input IN, inout SurfaceOutput o) {
            float3 pos = float3(IN.uv_MainTex - 0.5, _Time.y);
            float3 color = Mandelbulb(pos);
            o.Albedo = color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
