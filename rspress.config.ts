import * as path from "node:path";
import { defineConfig } from "rspress/config";

import { stat, readdir } from "node:fs/promises";

import mytadata from "./mytadata.json" assert { type: "json" };

const { year, author } = mytadata;

const demos = await readdir(path.join(__dirname, "docs", "demos"));

export default defineConfig({
  root: path.join(__dirname, "docs"),
  markdown: {},
  title: `Genuary ${year} by ${author}`,
  icon: "/rspress-icon.png",
  base: process.env.BASE || "/",
  builderConfig: {
    tools: {
      rspack(_, { addRules }) {
        addRules([
          {
            test: /\.glsl$/i,
            loader: "@davcri/webpack-glsl-loader",
          },
        ]);
      },
    },
  },
  themeConfig: {
    socialLinks: [
      {
        icon: "github",
        mode: "link",
        content: "https://github.com/web-infra-dev/rspress",
      },
    ],
    sidebar: {
      "/": demos.map((fileName) => {
        const [name] = fileName.split(".");

        return {
          text: `Day ${name}`,
          link: `/demos/${name}`,
        };
      }),
    },
  },
});
