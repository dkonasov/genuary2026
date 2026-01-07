#include "write-letter.glsl"

uniform vec2 u_resolution;

void main() {
    int[7] letters = int[7](364, 488, 316, 124, 444, 441, 244);
    
    float letterHeight = 52.0;
    float segmentLength = letterHeight / 2.0;
    float lineThickness = 3.0;
    float horizontalMargin = 30.0;
    float letterSpacing = 15.0;

    float brightness = 0.0;

    for (int i = 0; i < 7; i++) {

        float xPosBase = horizontalMargin + float(i) * (segmentLength + letterSpacing);
        brightness += writeLetter(xPosBase, segmentLength, lineThickness, letters[i], u_resolution);
    }
    

    vec3 mainColor = vec3(.9, .4, .1);

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
