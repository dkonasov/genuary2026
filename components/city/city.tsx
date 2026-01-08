import { FC, useRef } from "react";
import { useMount } from "react-use";
import {
  DirectionalLight,
  OrthographicCamera,
  Scene,
  WebGLRenderer,
} from "three";
import { useCity } from "../../hooks/use-city";
import styles from "./city.module.css";

import { OrbitControls } from "three/addons/controls/OrbitControls.js";

export const City: FC = () => {
  const mainRef = useRef<HTMLDivElement>(null);
  const cityMeshes = useCity();

  useMount(() => {
    if (mainRef.current) {
      const ratio = mainRef.current.clientWidth / mainRef.current.clientHeight;

      const scene = new Scene();
      cityMeshes.meshes.forEach((mesh) => scene.add(mesh));
      const camera = new OrthographicCamera(-ratio, ratio, 1, -1, 0.1, 1000);
      const light1 = new DirectionalLight(0xffffff, 0.5);
      const light2 = new DirectionalLight(0xffffff, 0.5);
      light2.position.set(0, 30, -20);
      light1.position.set(0, 30, 20);
      scene.add(light1);
      scene.add(light2);
      camera.position.set(50, 50, 100);
      camera.lookAt(0, 0, 0);
      camera.zoom = 0.03;
      camera.updateProjectionMatrix();

      const renderer = new WebGLRenderer({ antialias: true });
      renderer.setSize(
        mainRef.current.clientWidth,
        mainRef.current.clientHeight
      );
      mainRef.current.appendChild(renderer.domElement);

      const controls = new OrbitControls(camera, renderer.domElement);
      controls.update();

      const animate = () => {
        controls.update();
        requestAnimationFrame(animate);
        renderer.render(scene, camera);
      };
      animate();
    }
  });

  return <main ref={mainRef} className={styles.root}></main>;
};
