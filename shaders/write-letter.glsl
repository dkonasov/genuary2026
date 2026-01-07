float writeLetter(float pos, float segmentLength, float lineThickness, int letterCode, vec2 resolution) {
    float brightness = 0.0;
    int mask = 256; // starting with 0b100000000

    // horizontal segments (first 3 bits)
    for (int j = 0; j < 3; j++) {
        int yShift = 0 - (j - 1);
        float yPos = resolution.y / 2.0 + float(yShift) * segmentLength;

        if ((letterCode & mask) != 0) {
            bool drawSegment = abs(gl_FragCoord.y - yPos) < lineThickness / 2.0 && abs(gl_FragCoord.x - (pos + segmentLength / 2.0)) < segmentLength / 2.0;

            if (drawSegment) {
                brightness += 1.0;
                break;
            }
        }

        mask = mask >> 1;
    }

    if (brightness > 1.0) {
        return brightness;
    }

    // bits from 4 to 7 - vertical segments
    mask = 32; // starting with 100000

    for (int j = 0; j < 4; j++) {
        int xShift = j % 2;
        int yShift = j / 2;
        float xPosV = pos + float(xShift) * segmentLength;
        float yPosV = resolution.y / 2.0 + (yShift == 0 ? 1.0 : -1.0) * segmentLength / 2.0;

        if ((letterCode & mask) != 0) {
            bool drawSegment = abs(gl_FragCoord.x - xPosV) < lineThickness / 2.0 && abs(gl_FragCoord.y - yPosV) < segmentLength / 2.0;

            if (drawSegment) {
                brightness += 1.0;
                break;
            }
        }

        mask = mask >> 1;
    }

    if (brightness > 1.0) {
        return brightness;
    }

    // last two bits - diagonal segments
    mask = 2; // starting with 10
    for (int j = 0; j < 2; j++) {
        float xPosD = pos + segmentLength / 2.0;
        float yPosD = resolution.y / 2.0 + (segmentLength / 2.0) * (j == 0 ? 1.0 : -1.0);
        if ((letterCode & mask) != 0) {
            float k = -1.0;
            float b = yPosD - k * xPosD;

            float distanceToLine = abs(k * gl_FragCoord.x - gl_FragCoord.y + b) / sqrt(k * k + 1.0);
            bool drawSegment = distanceToLine < lineThickness / 2.0 &&
                                (gl_FragCoord.x >= (xPosD - segmentLength / 2.0) && gl_FragCoord.y >= (resolution.y / 2.0) - segmentLength * float(j));

            if (drawSegment) {
                brightness += 1.0;
                break;
            }
        }

        mask = mask >> 1;
    }

    return brightness;
}
