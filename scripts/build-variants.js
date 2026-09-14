#!/usr/bin/env node
// Yazılım Yolu Dark ve Light temalarından ek varyantları üretir.
// Varyant dosyalarını elle düzenlemeyin; ana temayı değiştirip yeniden çalıştırın:
//   npm run build:variants
const fs = require("fs");
const path = require("path");

const THEMES = path.join(__dirname, "..", "themes");
const HEX = /#[0-9A-Fa-f]{6}(?![0-9A-Fa-f])/g;
const COLOR_LINE = /^(\s*"([^"]+)":\s*")(#[0-9A-Fa-f]{6})(?=")/gm;
const SURFACE_KEY = /background|border|stroke|shadow|outline|indentguide|whitespace|ruler|separator/i;
const MIN_CONTRAST = 4.5;

const toRgb = (hex) => [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16));
const toHex = (rgb) =>
  "#" + rgb.map((v) => Math.round(Math.min(255, Math.max(0, v))).toString(16).padStart(2, "0")).join("").toUpperCase();
const mix = (hex, target, amount) => {
  const a = toRgb(hex);
  const b = toRgb(target);
  return toHex(a.map((v, i) => v + (b[i] - v) * amount));
};

function hsl(hex) {
  const c = toRgb(hex).map((v) => v / 255);
  const max = Math.max(...c);
  const min = Math.min(...c);
  const l = (max + min) / 2;
  if (max === min) return { s: 0, l };
  const d = max - min;
  return { s: l > 0.5 ? d / (2 - max - min) : d / (max + min), l };
}

const luminance = (hex) =>
  toRgb(hex)
    .map((v) => v / 255)
    .map((c) => (c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4))
    .reduce((sum, c, i) => sum + c * [0.2126, 0.7152, 0.0722][i], 0);

function contrast(a, b) {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}

const isNeutralText = (hex) => {
  const { s, l } = hsl(hex);
  return s < 0.3 && l < 0.35;
};

const VARIANTS = [
  {
    source: "yazilim-yolu-dark-color-theme.json",
    target: "yazilim-yolu-extra-dark-color-theme.json",
    name: "Yazılım Yolu Extra Dark",
    // Koyu zemin ve kenarlık tonları %30 siyaha yaklaştırılır.
    surface: (hex) => (hsl(hex).l < 0.3 ? mix(hex, "#000000", 0.3) : hex),
    text: (hex) => hex,
  },
  {
    source: "yazilim-yolu-light-color-theme.json",
    target: "yazilim-yolu-soft-light-color-theme.json",
    name: "Yazılım Yolu Soft Light",
    // Açık zemin ve kenarlık tonları %30 gri-maviye yaklaştırılır.
    surface: (hex) => (hsl(hex).l > 0.8 ? mix(hex, "#C5CBDD", 0.3) : hex),
    // Koyu nötr metin tonları %8 açılır.
    text: (hex) => (isNeutralText(hex) ? mix(hex, "#FFFFFF", 0.08) : hex),
  },
];

function build(variant) {
  const text = fs.readFileSync(path.join(THEMES, variant.source), "utf8");
  const theme = JSON.parse(text);
  const cut = text.indexOf('"tokenColors"');
  if (cut < 0) throw new Error(`${variant.source}: "tokenColors" bulunamadı`);

  // Arayüz renkleri: anahtara göre zemin mi metin mi olduğuna karar verilir.
  const colors = text.slice(0, cut).replace(COLOR_LINE, (_, prefix, key, hex) => {
    const upper = hex.toUpperCase();
    if (SURFACE_KEY.test(key)) return prefix + variant.surface(upper);
    if (/foreground/i.test(key)) return prefix + variant.text(upper);
    return prefix + upper;
  });

  const oldBg = theme.colors["editor.background"].toUpperCase();
  const newBg = variant.surface(oldBg);
  const towards = theme.type === "dark" ? "#FFFFFF" : "#000000";

  // Sözdizimi renkleri: kontrast, eskisinden ve 4.5:1'den düşük olanı altına inmez.
  const tokenMap = new Map();
  let lowest = Infinity;
  const tokens = text.slice(cut).replace(HEX, (hex) => {
    const upper = hex.toUpperCase();
    if (!tokenMap.has(upper)) {
      const required = Math.min(MIN_CONTRAST, contrast(upper, oldBg));
      let next = variant.text(upper);
      for (let step = 0.02; contrast(next, newBg) < required && step <= 1; step += 0.02) {
        next = mix(variant.text(upper), towards, step);
      }
      tokenMap.set(upper, next);
      lowest = Math.min(lowest, contrast(next, newBg));
    }
    return tokenMap.get(upper);
  });

  const out = (colors + tokens).replace(`"name": "${theme.name}"`, `"name": "${variant.name}"`);
  JSON.parse(out);
  fs.writeFileSync(path.join(THEMES, variant.target), out, "utf8");

  const changed = [...tokenMap].filter(([from, to]) => from !== to).length;
  console.log(
    `${variant.target}: editör zemini ${oldBg} → ${newBg}, ` +
      `değişen sözdizimi rengi ${changed}, en düşük sözdizimi kontrastı ${lowest.toFixed(2)}`
  );
}

VARIANTS.forEach(build);
