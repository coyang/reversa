# Architecture Tour

Animated camera traversing the scene at a cinematic pace, with a synchronized **narrative overlay**. It works like a system "trailer": someone presses play and the video unfolds by itself, stopping at key points with explanatory captions.

## Concept

Tour is not an isolated mode; it is an **animated layer** that overlays any of the other modes (Code City, Dependency Graph 3D, Layer Stack, Call Graph). The skill receives a sequence of waypoints and narrations, and the camera travels between them.

## When to use

- Presentations for non-technical stakeholders.
- Onboarding for new devs ("press play and see what the system is like").
- Short executive demonstrations (1 to 3 minutes).
- Accompanying the `deck.html` of the mini-site.

## Data model: the choreography

```json
{
  "baseMode": "code-city",
  "duration": 90,
  "waypoints": [
    {
      "at": 0,
      "camera": { "position": [200, 250, 400], "target": [0, 0, 0] },
      "overlay": "This is the payment system seen from above."
    },
    {
      "at": 12,
      "camera": { "position": [50, 30, 80], "target": [40, 0, 20] },
      "overlay": "The highest district, src/payments, concentrates 40% of the code."
    },
    {
      "at": 24,
      "camera": { "position": [80, 60, 60], "target": [60, 20, 30] },
      "highlight": ["src/payments/charge.ts", "src/payments/refund.ts"],
      "overlay": "Charge and refund are the central files."
    },
    {
      "at": 40,
      "camera": { "position": [-100, 80, 200], "target": [-50, 0, 0] },
      "switchMode": "dependency-graph",
      "overlay": "Now let's look at its dependencies."
    }
  ]
}
```

- `at`: second on the timeline when the waypoint triggers.
- `camera`: camera position and target upon arrival.
- `highlight`: list of node/module IDs to highlight (others blur).
- `overlay`: caption text, in en-us.
- `switchMode` (optional): changes the base mode in the middle of the tour, with a transition.

## Interpolation algorithm

Between two waypoints, the camera interpolates position and target with easing.

```javascript
import { CatmullRomCurve3 } from "https://cdn.jsdelivr.net/npm/three@0.158.0/build/three.module.js";

const positions = waypoints.map((w) => new THREE.Vector3(...w.camera.position));
const targets = waypoints.map((w) => new THREE.Vector3(...w.camera.target));
const positionCurve = new CatmullRomCurve3(positions);
const targetCurve = new CatmullRomCurve3(targets);

let startTime = null;
function playTour() {
    startTime = performance.now();
    controls.enabled = false; // disable manual interaction
    animateTour();
}

function animateTour() {
    const now = performance.now();
    const elapsed = (now - startTime) / 1000;

    if (elapsed >= tour.duration) {
        finishTour();
        return;
    }

    const t = elapsed / tour.duration; // 0..1
    const pos = positionCurve.getPoint(t);
    const tgt = targetCurve.getPoint(t);
    camera.position.copy(pos);
    camera.lookAt(tgt);

    updateOverlay(elapsed);
    updateHighlights(elapsed);

    renderer.render(scene, camera);
    requestAnimationFrame(animateTour);
}
```

## Narrative overlay

Text box positioned at the bottom or side, with smooth transitions between lines.

```html
<div id="tour-overlay">
    <p id="tour-text"></p>
    <div id="tour-progress"><div id="tour-progress-fill"></div></div>
    <div id="tour-controls">
        <button id="tour-pause">Pause</button>
        <button id="tour-restart">Restart</button>
        <button id="tour-skip">Skip</button>
    </div>
</div>
```

```javascript
function updateOverlay(elapsed) {
    const current = waypoints.findLast((w) => w.at <= elapsed);
    if (!current) return;
    const textEl = document.getElementById("tour-text");
    if (textEl.dataset.at !== String(current.at)) {
        textEl.dataset.at = current.at;
        textEl.style.opacity = 0;
        setTimeout(() => {
            textEl.textContent = current.overlay;
            textEl.style.opacity = 1;
        }, 300);
    }
    const progress = (elapsed / tour.duration) * 100;
    document.getElementById("tour-progress-fill").style.width = progress + "%";
}
```

## Element highlighting

During highlights, selected modules gain emissive properties while others reduce opacity.

```javascript
function updateHighlights(elapsed) {
    const current = waypoints.findLast((w) => w.at <= elapsed);
    const highlightIds = new Set(current?.highlight ?? []);

    modules.forEach((m, i) => {
        const isHighlighted = highlightIds.size === 0 || highlightIds.has(m.name);
        const targetOpacity = isHighlighted ? 1.0 : 0.15;
        // animating opacity via InstancedMesh is more difficult;
        // alternative: change color to a desaturated version when opacity is low
        const baseColor = colorForModule(m);
        const finalColor = isHighlighted ? baseColor : dim(baseColor, 0.3);
        instanced.setColorAt(i, new THREE.Color(finalColor));
    });
    instanced.instanceColor.needsUpdate = true;
}

function dim(hex, factor) {
    const c = new THREE.Color(hex);
    c.r *= factor; c.g *= factor; c.b *= factor;
    return c.getHex();
}
```

## Mode change mid-tour

When a waypoint has `switchMode`, fade out the current scene, dispose, create the new scene, and fade in.

```javascript
function switchSceneMode(newMode) {
    fadeOverlay.style.opacity = 1;
    setTimeout(() => {
        clearScene();
        if (newMode === "dependency-graph") buildDependencyGraph();
        else if (newMode === "code-city") buildCodeCity();
        // etc
        fadeOverlay.style.opacity = 0;
    }, 600);
}
```

## Tour controls

- **Pause**: stops `requestAnimationFrame`, freezes time.
- **Restart**: resets `startTime` to now.
- **Skip**: jumps to the next waypoint.
- **Manual takeover**: if the user drags the mouse in the scene, the tour stops and OrbitControls are enabled.

```javascript
renderer.domElement.addEventListener("pointerdown", () => {
    if (tourPlaying) {
        pauseTour();
        controls.enabled = true;
        showResumeButton();
    }
});
```

## Optional soundtrack

The tour can include subtle ambient music via base64-embedded `<audio>` (short, ~30s loop) or via Web Audio API generating procedural drones. Default: no audio.

## Choreography generation

The skill receives ready-made waypoints OR generates them automatically using heuristics:

- Start from the top looking at the center.
- Dive into the 3 largest buildings (Code City).
- Fly through the dependency graph highlighting the most central node.
- End by showing the layer stack of violating layers (if any).

Each heuristic can be enabled or disabled via parameters.

## Tour sidebar

```html
<aside id="sidebar">
    <h3>Architecture Tour</h3>

    <label>Total duration
        <input type="range" min="30" max="300" value="90" data-param="duration"> s
    </label>

    <label>Base mode
        <select data-param="baseMode">
            <option value="code-city">Code City</option>
            <option value="dependency-graph">Dependency Graph</option>
            <option value="layer-stack">Layer Stack</option>
        </select>
    </label>

    <label>
        <input type="checkbox" data-param="autoPlay"> Auto-play on open
    </label>

    <label>
        <input type="checkbox" data-param="includeViolationsScene" checked> Include violations scene
    </label>

    <button id="play-tour">Play Tour</button>
    <button id="pause-tour">Pause</button>
    <button id="restart-tour">Restart</button>
</aside>
```

## Performance

The tour inherits performance from the base mode. Adding a tour costs little: only camera interpolation and opacity animations. Be careful with `switchMode` mid-tour: dispose + rebuild can cause 200-500ms stutter.
