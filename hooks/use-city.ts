import { BoxGeometry, Mesh, MeshStandardMaterial, Vector2 } from "three";

interface Building {
  x: number;
  y: number;
  height: number;
}

const CITY_SIZE = 4;
const QUARTER_SPACING = 3;
const BUILDINGS_SPACING = 0.4;
const QUARTER_SIZE = 10;

const quarterLength = QUARTER_SIZE + BUILDINGS_SPACING * (QUARTER_SIZE - 1);

function generateQuarter(
  quarterCenterX: number,
  quarterCenterY: number,
  lowestHeight: number,
  highestHeight: number
): Building[] {
  const buildings: Building[] = [];
  const spacing = BUILDINGS_SPACING;
  const quarterSize = QUARTER_SIZE;
  const sideLength = quarterLength;
  for (
    let x = quarterCenterX - sideLength / 2 + 0.5;
    x < quarterCenterX + sideLength / 2;
    x += 1 + spacing
  ) {
    for (
      let y = quarterCenterY - sideLength / 2 + 0.5;
      y < quarterCenterY + sideLength / 2;
      y += 1 + spacing
    ) {
      const height =
        Math.random() * (highestHeight - lowestHeight) + lowestHeight;
      buildings.push({ x, y, height });
    }
  }
  return buildings;
}

let buildings: Building[] = [];

let quarterCenter = new Vector2(
  -CITY_SIZE / 2 + QUARTER_SIZE / 2,
  -CITY_SIZE / 2 + QUARTER_SIZE / 2
);

for (let i = 0; i < CITY_SIZE; i++) {
  for (let j = 0; j < CITY_SIZE; j++) {
    const quarterBuildings = generateQuarter(
      quarterCenter.x + i * (quarterLength + QUARTER_SPACING),
      quarterCenter.y + j * (quarterLength + QUARTER_SPACING),
      1,
      10
    );
    buildings = buildings.concat(quarterBuildings);
  }
}

const meshes = buildings.map((building) => {
  const geometry = new BoxGeometry(1, building.height, 1);
  geometry.translate(building.x, building.height / 2, building.y);

  const material = new MeshStandardMaterial({ color: 0x808080 });
  return new Mesh(geometry, material);
});

export function useCity() {
  return { meshes };
}
