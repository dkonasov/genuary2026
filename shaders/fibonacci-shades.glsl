#include "../node_modules/glsl-hsl2rgb/index.glsl"

uniform vec2 u_resolution;
uniform float totalSegments;
uniform float step;
uniform float sequence[50];

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float segmentLength = u_resolution.x / totalSegments;
    float currentSegment = floor(gl_FragCoord.x / segmentLength);
    float luminosity = sequence[int(currentSegment)] * step;

    vec3 color = hsl2rgb(0.1, 0.6, luminosity);

    gl_FragColor = vec4(vec3(color), 1.0);
}
