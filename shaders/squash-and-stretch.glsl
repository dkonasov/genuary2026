precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    float ratio = u_resolution.x / u_resolution.y;
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 mainColor = vec3(.9, .4, .1);
    float basicRadius = 0.15;

    float topPoint = 1.0 - basicRadius;
    float bottomPoint = basicRadius;
    float squashTime = 0.9;
    float squashDuration = 1.0 - squashTime;
    float maxDeformationDelta = 0.05;
    bool isSquashing = u_time > squashTime + squashDuration / 2.0;
    bool isStretching = u_time < squashTime;

    vec2 majorSemiAxis = isSquashing ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

    float dist = topPoint - bottomPoint;

    st.x *= ratio;

    vec2 center = vec2(0.5 * ratio, topPoint - dist * u_time);
    float deformationProgress = isStretching ? (u_time / squashTime) : 1.0 - ((1.0 - u_time) / (squashDuration / 2.0));
    deformationProgress = max(deformationProgress, 0.00000015);

    float deformationDelta = maxDeformationDelta * deformationProgress;
    
    // Major semi-axis length
    float a = 0.15 + deformationDelta;

    // Minor semi-axis length
    float b = 0.15;

    float extentricity = sqrt(1.0 - (b * b) / (a * a));

    float cosValue = dot(normalize(st - center), majorSemiAxis);

    float ellipse = b / sqrt(1.0 - (extentricity * extentricity * cosValue * cosValue));

    float mask = step(ellipse, length(st - center));
    vec3 color = mainColor * (1.0 - mask);

    gl_FragColor = vec4(color, 1.0);
}
