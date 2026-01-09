import { FC, useEffect, useMemo, useState } from "react";
import { DataTexture, DepthFormat } from "three";
import { Pseudo2DCanvas } from "../pseudo-2d-canvas/pseudo-2d-canvas";

import fragmentShader from "../../shaders/cellular-automata.glsl";

let step = 0;

function calculateNextStep(
  data: Uint8Array,
  width: number,
  height: number,
  step: number
) {
  const ruleTable: Record<number, number> = {
    0xffffff: 0x00,
    0xffff00: 0x00,
    0xff00ff: 0x00,
    0xff0000: 0xff,
    0x00ffff: 0xff,
    0x00ff00: 0xff,
    0x0000ff: 0xff,
    0x000000: 0x00,
  };

  const nextStepIndex = step < height - 1 ? step + 1 : height - 1;
  const prevRow = data.slice(
    (nextStepIndex - 1) * width * 4,
    nextStepIndex * width * 4
  );

  for (let x = 0; x < width; x++) {
    const neighbors: number[] = [];
    for (let i = -1; i <= 1; i++) {
      let startIndex = (x + i) * 4;

      if (startIndex > prevRow.length - 4) {
        startIndex = 0;
      }

      let endIndex = startIndex > -1 ? startIndex + 4 : undefined;

      const bytes = prevRow.slice(startIndex, endIndex);
      const num = bytes.slice(0, 3).reduce((acc, byte) => (acc << 8) | byte, 0);
      neighbors.push(num >> 16);
    }

    let key = 0;

    for (let b = 2; b > -1; b--) {
      key = (key << 8) | neighbors[b];
    }

    const newValue = ruleTable[key] || 0x00;

    for (let b = 0; b < 3; b++) {
      data[(nextStepIndex * width + x) * 4 + b] = newValue;
    }
  }
}

export const CellularAutomata: FC = () => {
  const [canvasSize, setCanvasSize] = useState<{
    width: number;
    height: number;
  }>({ width: 0, height: 0 });

  const customUniforms = useMemo(() => {
    const width = canvasSize.width;
    const height = canvasSize.height;
    const size = width * height;
    const data = new Uint8Array(size * 4);

    for (let x = 0; x < size * 4; x++) {
      const pixelIndex = Math.floor(x / 4);
      const px = pixelIndex % width;
      const py = Math.floor(pixelIndex / width);

      data[x] = px === Math.floor(width / 2) && py === 0 ? 255 : 0;
    }

    const texture = new DataTexture(data, width, height);
    texture.needsUpdate = true;

    return {
      u_texture: { value: texture },
    };
  }, [canvasSize.width, canvasSize.height]);

  useEffect(() => {
    const timeout = setInterval(() => {
      const oldData: Uint8Array =
        customUniforms.u_texture.value.source.data.data;
      const newData = oldData.slice();

      if (step >= canvasSize.height - 1) {
        // TODO: shift row in the new data;
        for (let y = 0; y < canvasSize.height - 1; y++) {
          for (let x = 0; x < canvasSize.width * 4; x++) {
            if (y < canvasSize.height - 1) {
              newData[y * canvasSize.width * 4 + x] =
                newData[(y + 1) * canvasSize.width * 4 + x];
            } else {
              newData[y * canvasSize.width * 4 + x] = 0;
            }
          }
        }
      }

      calculateNextStep(newData, canvasSize.width, canvasSize.height, step);

      const texture = new DataTexture(
        newData,
        canvasSize.width,
        canvasSize.height
      );
      texture.needsUpdate = true;
      customUniforms.u_texture.value = texture;

      step++;
    }, 100);

    return () => {
      step = 0;
      clearTimeout(timeout);
    };
  }, [customUniforms]);

  const handleSizeSettled = (width: number, height: number) => {
    setCanvasSize({ width, height });
  };

  return (
    <Pseudo2DCanvas
      fragmentShader={fragmentShader}
      customUniforms={customUniforms}
      onSizeSettled={handleSizeSettled}
    />
  );
};
