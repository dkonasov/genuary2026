uniform vec2 u_resolution;
uniform bool u_lightsOn;

void main() {
    float brightness = u_lightsOn ? 1.0 : 0.2;

    vec3 mainColor = vec3(0.58, 0.83, 1.0);
    float moonRadius = 25.0;

    vec2 center = vec2(u_resolution.x / 1.2, u_resolution.y / 1.2);
    vec2 eclipseCenter = center - vec2(moonRadius / 2.0, 0.0);

    if (distance(gl_FragCoord.xy, center) < moonRadius && distance(gl_FragCoord.xy, eclipseCenter) > moonRadius) {
        gl_FragColor = vec4(vec3(0.58, 0.83, 1.0) * 1.2, 1.0);
        return;
    }

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
