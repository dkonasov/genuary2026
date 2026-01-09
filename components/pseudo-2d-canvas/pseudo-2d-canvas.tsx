import { FC, useRef } from "react";
import { useMount } from "react-use";
import {
  Scene,
  OrthographicCamera,
  WebGLRenderer,
  Mesh,
  ShaderMaterial,
  PlaneGeometry,
  Vector2,
  ShaderMaterialParameters,
} from "three";
import styles from "./pseudo-2d-canvas.module.css";

import baseVertexShader from "../../shaders/common-vertex.glsl";

export interface Pseudo2DCanvasProps {
  vertexShader?: string;
  fragmentShader: string;
  customUniforms?: ShaderMaterialParameters["uniforms"];
  onClick?: () => void;
  onSizeSettled?: (width: number, height: number) => void;
}

export const Pseudo2DCanvas: FC<Pseudo2DCanvasProps> = (props) => {
  const mainRef = useRef<HTMLDivElement>(null);
  const {
    vertexShader = baseVertexShader,
    fragmentShader,
    customUniforms = {},
    onClick,
    onSizeSettled,
  } = props;
  const timeRef = useRef(0);

  const customUniformsRef = useRef(customUniforms);
  customUniformsRef.current = customUniforms;

  useMount(() => {
    if (mainRef.current) {
      onSizeSettled?.(
        mainRef.current.clientWidth,
        mainRef.current.clientHeight
      );
      const ratio = mainRef.current.clientWidth / mainRef.current.clientHeight;
      const scene = new Scene();
      const camera = new OrthographicCamera(-ratio, ratio, 1, -1, 0.1, 1000);
      const planeGeometry = new PlaneGeometry(2 * ratio, 2);
      timeRef.current = Date.now();

      const planeMaterial = new ShaderMaterial({
        vertexShader,
        fragmentShader,
        uniforms: {
          u_resolution: {
            value: new Vector2(
              mainRef.current.clientWidth,
              mainRef.current.clientHeight
            ),
          },
          u_time: { value: Math.abs(Math.cos(0)) },
          ...customUniforms,
        },
      });
      const plane = new Mesh(planeGeometry, planeMaterial);
      scene.add(plane);
      camera.position.z = 2;

      const renderer = new WebGLRenderer({ antialias: true });
      renderer.setSize(
        mainRef.current.clientWidth,
        mainRef.current.clientHeight
      );
      mainRef.current.appendChild(renderer.domElement);

      const animate = () => {
        requestAnimationFrame(animate);
        planeMaterial.uniforms.u_time.value = Math.abs(
          Math.cos((Date.now() - timeRef.current) / 1000)
        );
        Object.entries(customUniformsRef.current).forEach(([key, uniform]) => {
          planeMaterial.uniforms[key].value = uniform.value;
        });
        renderer.render(scene, camera);
      };
      animate();
    }
  });

  return <main ref={mainRef} className={styles.root} onClick={onClick}></main>;
};
