uniform vec2 u_resolution;

void main() {
    // gl_FragColor = vec4(vec3(float(3 / 2)), 0.0);
    // return;
    int[7] letters = int[7](364, 488, 316, 124, 444, 441, 244);
    
    float letterHeight = 102.0;
    float segmentLength = letterHeight / 2.0;
    float lineThickness = 3.0;
    float horizontalMargin = 30.0;
    float letterSpacing = 15.0;

    float brightness = 0.0;

    for (int i = 0; i < 7; i++) {

        float xPosBase = horizontalMargin + float(i) * (segmentLength + letterSpacing);
        float xPos = xPosBase + segmentLength / 2.0;

        int mask = 256; // starting with 0b100000000

        // horizontal segments (first 3 bits)

        for (int j = 0; j < 3; j++) {
            int yShift = 0 - (j - 1);
            float yPos = u_resolution.y / 2.0 + float(yShift) * segmentLength;

            if ((letters[i] & mask) != 0) {
                bool drawSegment = abs(gl_FragCoord.y - yPos) < lineThickness / 2.0 && abs(gl_FragCoord.x - xPos) < segmentLength / 2.0;

                if (drawSegment) {
                    brightness += 1.0;
                    break;
                }
            }

            mask = mask >> 1;
        }

        if (brightness > 1.0) {
            break;
        }

        // bits from 4 to 7 - vertical segments
        mask = 32; // starting with 100000
        
        for (int j = 0; j < 4; j++) {
            int xShift = j % 2;
            int yShift = j / 2;
            float xPosV = xPosBase + float(xShift) * segmentLength;
            float yPosV = u_resolution.y / 2.0 + (yShift == 0 ? 1.0 : -1.0) * segmentLength / 2.0;

            if ((letters[i] & mask) != 0) {
                bool drawSegment = abs(gl_FragCoord.x - xPosV) < lineThickness / 2.0 && abs(gl_FragCoord.y - yPosV) < segmentLength / 2.0;

                if (drawSegment) {
                    brightness += 1.0;
                    break;
                }
            }

            mask = mask >> 1;
        }

        // last two bits - diagonal segments
        mask = 2; // starting with 10
        for (int j = 0; j < 2; j++) {
            float xPosD = xPosBase + segmentLength / 2.0;
            float yPosD = u_resolution.y / 2.0 + (segmentLength / 2.0) * (j == 0 ? 1.0 : -1.0);

            if ((letters[i] & mask) != 0) {
                float k = -1.0;
                float b = yPosD - k * xPosD;

                float distanceToLine = abs(k * gl_FragCoord.x - gl_FragCoord.y + b) / sqrt(k * k + 1.0);
                bool drawSegment = distanceToLine < lineThickness / 2.0 &&
                                    (gl_FragCoord.x >= (xPosD - segmentLength / 2.0) && gl_FragCoord.y >= (u_resolution.y / 2.0) - segmentLength * float(j));

                if (drawSegment) {
                    brightness += 1.0;
                    break;
                }
            }

            mask = mask >> 1;
        }
    }
    

    vec3 mainColor = vec3(.9, .4, .1);

    gl_FragColor = vec4(mainColor * brightness, 1.0);
}
