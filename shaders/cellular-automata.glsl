uniform vec2 u_resolution;
uniform sampler2D u_texture;

void main() {
    vec3 mainColor = vec3(.9, .4, .1);
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv.y = 1.0 - uv.y;
    float brightness = texture2D(u_texture, uv).r;

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
