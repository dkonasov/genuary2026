uniform vec2 u_resolution;

void main() {
    float epsilon = .5;
    vec2 lowResolution = vec2(128.0, 0.0);
    float pixelSize = u_resolution.x / lowResolution.x;
    lowResolution.y = u_resolution.y / pixelSize;

     vec3 mainColor = vec3(.9, .4, .1);

    float radius = (min(lowResolution.x, lowResolution.y) / 2.0) - 2.0;
    vec2 center = floor(lowResolution / 2.0);
    
    vec2 pos = floor(gl_FragCoord.xy / pixelSize);
    bool drawCircle = abs(distance(pos, center) - radius) < epsilon;
    bool drawMainLine = distance(pos, center) < radius && abs(pos.x - center.x) < epsilon;

    float xSymmetryCoord = center.x + abs(pos.x - center.x);


    bool drawSideRays = distance(pos, center) < radius && pos.y < center.y && abs((center.y -pos.y) - (xSymmetryCoord - center.x)) < epsilon;
    float brightness = drawCircle || drawMainLine || drawSideRays ? 1.0 : 0.0;

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
