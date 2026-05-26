# Error Scenarios and Handling

Common scenarios in the `selo-generativo` skill and how to handle them.

---

## ERR-01: p5.js unavailable (CDN inaccessible)

**Cause**: user offline on first execution, or CDN blocked.

**Detection**: global `p5` variable not defined after the CDN `<script>`.

**Handling**:

```javascript
window.addEventListener("load", () => {
    if (typeof p5 === "undefined") {
        document.getElementById("seal-container").innerHTML = `
            <div class="seal-fallback" style="width: ${SIZE}px; height: ${SIZE}px;
                 background: ${palette.bg}; display: flex; align-items: center;
                 justify-content: center; border-radius: 50%; color: ${palette.fg};">
                <span>Seal unavailable</span>
            </div>`;
        return;
    }
    // normal setup here
});
```

Fallback: minimal SVG (circle + palette background color) inline, no p5 dependency.

---

## ERR-02: Canvas not supported by browser

**Cause**: very old browser without `<canvas>` support (extremely rare today).

**Detection**: `canvas.getContext("2d")` returns `null`.

**Handling**: fall back to inline SVG with `crystal-lattice` (which is the pattern most compatible with real SVG).

---

## ERR-03: Invalid or missing seed

**Cause**: agent called the skill without a seed, or passed an empty string.

**Detection**: input validation.

**Handling**: safe fallback.

```javascript
function resolveSeed(rawSeed) {
    if (!rawSeed || typeof rawSeed !== "string" || rawSeed.length === 0) {
        const timestamp = Date.now().toString();
        console.warn("Seed missing, using timestamp as fallback. Seal will not be reproducible.");
        return timestamp;
    }
    return rawSeed;
}
```

When a timestamp is used, display a warning in the page footer (only if it is a large hero): "Non-reproducible seal (no seed)".

---

## ERR-04: Extreme size

**Cause**: canvas request too large (>4096) or too small (<16).

**Detection**: `size` parameter validation.

**Handling**:

```javascript
function clampSize(requested) {
    const MIN = 16;
    const MAX = 4096;
    if (requested < MIN) {
        console.warn(`Size ${requested} below minimum (${MIN}). Adjusting.`);
        return MIN;
    }
    if (requested > MAX) {
        console.warn(`Size ${requested} above maximum (${MAX}). Adjusting.`);
        return MAX;
    }
    return requested;
}
```

Above 1024, pixel-loop patterns like `wave-interference` become heavy. The skill should warn and enforce `noLoop()` with canvas caching.

---

## ERR-05: Palette with invalid colors

**Cause**: received palette with malformed hex or missing field.

**Detection**: validation regex on each color.

**Handling**:

```javascript
function validatePalette(palette) {
    const HEX_RX = /^#[0-9a-fA-F]{6}$/;
    const required = ["bg", "foreground", "accent", "fg"];
    for (const field of required) {
        if (!(field in palette)) {
            throw new Error(`Invalid palette: field '${field}' missing.`);
        }
    }
    if (!Array.isArray(palette.foreground) || palette.foreground.length === 0) {
        throw new Error("Invalid palette: 'foreground' must be a non-empty list.");
    }
    [palette.bg, palette.accent, palette.fg].forEach((c) => {
        if (!HEX_RX.test(c)) throw new Error(`Invalid color: ${c}`);
    });
    palette.foreground.forEach((c) => {
        if (!HEX_RX.test(c)) throw new Error(`Invalid color in foreground: ${c}`);
    });
}
```

If the palette is invalid, fall back to `palettes.sober` (most conservative fallback palette) and log the failure.

---

## ERR-06: Insufficient contrast

**Cause**: palette with `accent` and `bg` too similar, producing an invisible central element.

**Detection**: `contrastRatio(accent, bg) < 4.5` (see PALETTE_BY_STYLE.md).

**Handling**: automatically derive adjusted `accent`.

```javascript
function ensureContrast(palette) {
    if (contrastRatio(palette.accent, palette.bg) < 4.5) {
        const bgIsLight = luminance(palette.bg) > 0.5;
        palette.accent = bgIsLight ? darken(palette.accent, 0.4) : lighten(palette.accent, 0.4);
    }
    return palette;
}
```

---

## ERR-07: Chosen pattern incompatible with style

**Cause**: seed derivation resulted in a pattern visually incompatible with the chosen style (e.g., `crystal-lattice` in `exploratory` style).

**Detection**: compatibility table declared in `GENERATIVE_PATTERNS.md`.

**Handling**: re-roll within compatible patterns.

```javascript
const STYLE_COMPATIBLE = {
    sober: ["flow-field", "crystal-lattice", "noise-strata"],
    premium: ["particle-orbit", "wave-interference"],
    dense: ["crystal-lattice", "wave-interference"],
    exploratory: ["flow-field", "particle-orbit", "noise-strata"]
};

function pickCompatible(seedHex, styleHint) {
    const allowed = STYLE_COMPATIBLE[styleHint];
    if (!allowed) return PATTERNS[0];
    const idx = parseInt(seedHex.slice(2, 4), 16) % allowed.length;
    return allowed[idx];
}
```

---

## ERR-08: Very poor performance on mini-seal

**Cause**: heavy pattern on small canvas consuming disproportionate CPU.

**Detection**: measure time between `setup` and final `draw`.

**Handling**: if canvas is mini (<200px) and chosen pattern is `wave-interference` (pixel loop), automatically switch to `crystal-lattice` (simple geometry) with a message in the console.

---

## ERR-09: Multiple instances of the same seal on the same page

**Cause**: the mini-seal appears on every page of the mini-site. Reloading p5.js and generating canvas on each one is wasteful.

**Handling**: generate the seal once as SVG (for `crystal-lattice`) or PNG dataURI (for other patterns) and embed inline on all pages. The skill accepts a `mode: "svg" | "dataURI" | "html"` parameter to return the appropriate format.

```javascript
function exportAs(mode) {
    if (mode === "svg") return canvasToSvg();
    if (mode === "dataURI") return canvas.elt.toDataURL("image/png");
    return wrapInStandaloneHtml(canvas);
}
```

---

## ERR-10: Corrupted seed localStorage

Not directly applicable, because the skill does not persist state between executions. The seed always comes from the invoker (orchestrating agent), and reproducibility depends solely on it.

If the invoker lost the seed, the agent should recalculate from soul.md (sha256). This skill is not responsible for that.

---

## General principle

The seal is a **decorative** element. A seal failure should never break the entire page. In all scenarios above, there is a fallback that always renders something: a colored circle, a minimal SVG, a simplified version. No white screens.

Messages in en-us, no em dashes.
