#include "../node_modules/lygia/generative/cnoise.glsl"

uniform vec2 u_resolution;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 mainColor = vec3(.9, .4, .1);
    st.x *= u_resolution.x/u_resolution.y;

    // Scale
    st *= .5;

    float magnitude = cnoise(st);

    float multiplier = step(0.2, magnitude);

    vec3 color = mainColor * multiplier;
    // vec3 color = vec3(length(st));

    gl_FragColor = vec4(color,1.0);
}
