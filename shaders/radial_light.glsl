extern vec2  lightPos;    // Pixel-Koordinaten
extern float radius;      // in Pixeln
extern vec3  lightColor;  // RGB-Farbe (0–1)

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 pixelCoord) {
    // Abstand zur Lichtquelle
    float d = distance(pixelCoord, lightPos);
    // linearer Falloff
    float a = clamp(1.0 - d / radius, 0.0, 1.0);
    // weiche Kante
    a = smoothstep(0.0, 1.0, a);
    // Einfärben: lightColor * color.rgb (normalerweise color.rgb ist 1,1,1)
    vec3 col = lightColor * color.rgb;
    return vec4(col, a);
}
