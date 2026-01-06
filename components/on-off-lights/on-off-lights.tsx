import { Pseudo2DCanvas } from "../pseudo-2d-canvas/pseudo-2d-canvas";
import { FC, useState, useCallback, useMemo, ComponentProps } from "react";

import fragmentShader from "../../shaders/switch-lights.glsl";

export const OnOffLights: FC = () => {
  const [lightsOn, setLightsOn] = useState(false);

  const handleClick = useCallback(() => {
    setLightsOn((prev) => !prev);
  }, []);

  const customUniforms: ComponentProps<
    typeof Pseudo2DCanvas
  >["customUniforms"] = useMemo(
    () => ({
      u_lightsOn: { value: lightsOn ? 1 : 0 },
    }),
    [lightsOn]
  );

  return (
    <Pseudo2DCanvas
      fragmentShader={fragmentShader}
      customUniforms={customUniforms}
      onClick={handleClick}
    />
  );
};
