#include "write-letter.glsl"

uniform vec2 u_resolution;

void main() {
    float brightness = 0.0;

     vec3 mainColor = vec3(.9, .4, .1);
     vec2 center = u_resolution / 2.0;
     float gateSize = u_resolution.x / 8.0;

     // Gate
    float gateHeight = (gateSize / 2.0) * 1.3;
    float gateFoundationHeight = gateHeight - (gateSize / 2.0);
    float foundationUpperBorder = center.y - (gateHeight / 2.0) + gateFoundationHeight;
    float foundationLowerBorder = center.y - (gateHeight / 2.0);
    float contactThickness = 3.0;

    bool drawOutputContact = abs(gl_FragCoord.x - center.x) < (contactThickness / 2.0) && gl_FragCoord.y > foundationUpperBorder && gl_FragCoord.y < center.y + 75.0;
    bool drawInputContactLeft = abs(gl_FragCoord.x - (center.x - gateSize / 4.0)) < (contactThickness / 2.0) && gl_FragCoord.y < foundationLowerBorder && gl_FragCoord.y > center.y - 75.0;
    bool drawInputContactRight = abs(gl_FragCoord.x - (center.x + gateSize / 4.0)) < (contactThickness / 2.0) && gl_FragCoord.y < foundationLowerBorder && gl_FragCoord.y > center.y - 75.0;

    bool inGate = abs(gl_FragCoord.x - center.x) < (gateSize / 2.0) && gl_FragCoord.y < foundationUpperBorder && gl_FragCoord.y > foundationLowerBorder;
    bool inCircle = gl_FragCoord.y > foundationUpperBorder && distance(gl_FragCoord.xy, vec2(center.x, foundationUpperBorder)) < (gateSize / 2.0);
    if (inGate || inCircle || drawOutputContact || drawInputContactLeft || drawInputContactRight) {
        brightness = 1.0;
    }

    if (brightness < 1.0) {
        int[4] lettersLeft = int[4](104, 380, 53, 488);
        int[5] lettersRight = int[5]( 440, 488, 444, 360, 488);
        float segmentSize = gateSize * 0.4;
        float horizontalMargin = 20.0;
        float letterSpacing = 10.0;
        float xPos = center.x - (gateSize / 2.0) - horizontalMargin - (segmentSize + letterSpacing) * 4.0;
        float lineThickness = 3.0;

        for (int i = 0; i < 4; i++) {
            brightness += writeLetter(xPos, segmentSize, lineThickness, lettersLeft[i], u_resolution);
            if (brightness > 0.0) {
                break;
            }
    
            xPos += segmentSize + letterSpacing;
        }

        if (brightness < 1.0) {
            xPos = center.x + (gateSize / 2.0) + horizontalMargin;

            for (int i = 0; i < 5; i++) {
                brightness += writeLetter(xPos, segmentSize, lineThickness, lettersRight[i], u_resolution);
                if (brightness > 0.0) {
                    break;
                }
        
                xPos += segmentSize + letterSpacing;
            }
        }
    }

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
