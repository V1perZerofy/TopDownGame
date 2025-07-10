extern vec2 direction;    // (1,0)=horizontal, (0,1)=vertikal
extern float blurRadius;  // neu: multipliziert die Offsets

const float offset[5] = float[](0.0, 1.3846153846, 3.2307692308, 5.0769230769, 6.9230769231);
const float weight[5] = float[](0.2270270270, 0.3162162162, 0.0702702703, 0.0090090090, 0.0009842206);

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 pixelCoord) {
    // Texel-Größe in UV
    vec2 texelSize = 1.0 / love_ScreenSize.xy;
    // Offsets skaliert um blurRadius
    vec2 off = direction * texelSize * blurRadius;

    vec4 sum = Texel(tex, uv) * weight[0];
    for (int i = 1; i < 5; i++) {
        sum += Texel(tex, uv + off * offset[i]) * weight[i];
        sum += Texel(tex, uv - off * offset[i]) * weight[i];
    }
    return sum * color;
}