# Styling and themes — Skeleton v3

Use the framework-agnostic CSS from `@skeletonlabs/skeleton@3.2.2`; these are native-element utilities, not Svelte component imports. Its [package exports](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/package.json) resolve to CSS, and its [core stylesheet](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css) defines the utilities below. Prefer this pinned source over current Skeleton docs; use the [archived v3 documentation](https://v3.skeleton.dev/docs/get-started/core-api) for context. Tailwind's version number is separate: Skeleton v3 uses Tailwind CSS v4.

## Theme registration and activation

A theme is a set of CSS custom properties scoped by `[data-theme='name']`. Import its stylesheet **and** activate its exact name on the root HTML element. Importing alone does not select it. Register only themes the application uses; each import adds CSS.

Global stylesheet example (`src/app.css`; component source path is relative to this file):

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton/optional/presets';
@import '@skeletonlabs/skeleton/themes/cerberus';
@plugin '@tailwindcss/forms';
@source '../node_modules/@skeletonlabs/skeleton-svelte/dist';
```

The forms plugin requires the installed `@tailwindcss/forms` package. Keep **all imports before** `@plugin`, `@source`, variants, and style rules; this preserves [CSS import ordering](https://developer.mozilla.org/en-US/docs/Web/CSS/@import). The archived Forms page places the plugin immediately after Tailwind; the ordering above retains that plugin without interleaving imports and other directives. Presets are optional for Skeleton itself but required for the `preset-*` classes in this reference. Load this global stylesheet through the root layout. Set `data-theme="cerberus"` on the existing `<html>` element in `src/app.html`; preserve SvelteKit's head and body placeholders.

For a custom theme:

1. Open the generator linked by the [v3 Themes page](https://v3.skeleton.dev/docs/design/themes) at [themes.skeleton.dev](https://themes.skeleton.dev/).
2. Give the theme a unique name; customize palette, contrast colors, typography, spacing, and radii. Open its code view and copy the CSS.
3. Check the output against the [3.2.2 theme shape](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/themes/cerberus.css) before importing it: the hosted generator can evolve independently of the archive. V3 expects a `[data-theme='name']` block with the properties below, not a v2 configuration object or plugin registration.
4. Save the exported stylesheet, for example `src/acme.css`. Add `@import './acme.css';` after the imported Skeleton theme and before `@plugin`/`@source` or style rules. Set `data-theme="acme"` on `<html>` to match the exported selector, not necessarily the file name.
5. If switching at runtime, change `document.documentElement.dataset.theme` in browser-only code to one of your imported theme names. Ensure the initial server theme and any theme-dependent rendered text agree.

Core v3 tokens include:

| Purpose | Properties |
| --- | --- |
| Palette | `--color-{primary,secondary,tertiary,success,warning,error,surface}-{50,100,200,300,400,500,600,700,800,900,950}` |
| Foreground for each shade | `--color-primary-contrast-500` and equivalent colors and shades; the theme also defines `--color-primary-contrast-light` and `--color-primary-contrast-dark` |
| Body background | `--body-background-color`, `--body-background-color-dark` |
| Text | `--base-font-family`, `--base-font-color`, `--base-font-color-dark`, `--heading-font-family`, `--heading-font-weight`, `--heading-font-color`, `--heading-font-color-dark`, `--anchor-font-color`, `--anchor-font-color-dark` |
| Scale and shape | `--text-scaling`, `--spacing`, `--radius-base`, `--radius-container`, `--default-border-width`, `--default-ring-width` |

Override a token after the imported theme; scope it to the theme rather than globally altering every palette:

```css
[data-theme='cerberus'] {
  --radius-container: 0.75rem;
  --heading-font-family: system-ui, sans-serif;
  --base-font-family: system-ui, sans-serif;
  --body-background-color: var(--color-surface-50);
  --body-background-color-dark: var(--color-surface-950);
}
```

Sources: [v3 Themes](https://v3.skeleton.dev/docs/design/themes), [v3 installation](https://v3.skeleton.dev/docs/get-started/installation/sveltekit), [pinned core CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css), [pinned Cerberus theme](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/themes/cerberus.css), [v3 Forms prerequisites](https://v3.skeleton.dev/docs/tailwind/forms), [CSS import ordering](https://developer.mozilla.org/en-US/docs/Web/CSS/@import).

## Colors, pairings, and presets

Use semantic palettes instead of hardcoded colors: `primary` for a brand action, `surface` for neutral containers, and `success`, `warning`, or `error` for status accompanied by text. Standard utilities include `bg-primary-500`, `text-surface-950`, `border-secondary-600`, and `ring-primary-500`.

A single shade does **not** automatically invert in dark mode. Pairings use `{property}-{color}-{lightShade}-{darkShade}`; for example `bg-surface-100-900` selects 100 in a light color scheme and 900 in a dark color scheme. Supported pairs are `50-950`, `100-900`, `200-800`, `300-700`, `400-600`, and their reverses. Pairing values use CSS `light-dark()`, so check the computed `color-scheme`, not just the presence of a `.dark` class.

Match a filled background with its contrast token, such as `bg-primary-500 text-primary-contrast-500`, or `bg-secondary-200-800 text-secondary-contrast-200-800`. These are theme-supplied values, not a runtime contrast calculator. Recheck contrast after theme edits, opacity, gradients, or translucent backgrounds.

The preset styles have **different rules** in [3.2.2's actual CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/optional/presets.css):

| Class example | What it sets |
| --- | --- |
| `preset-filled-primary-500` | Background primary 500; text primary contrast 500. |
| `preset-filled-primary-100-900` | Background primary 100/900; corresponding contrast 100/900. |
| `preset-tonal-primary` | Background primary **50/950**; text primary **950/50**. No shade suffix. |
| `preset-outlined-primary-500` | A 1px primary-500 border only; does **not** assign a matching text color or filled background. |
| `preset-outlined-primary-200-800` | A 1px primary 200/800 border only. Supply foreground/background as needed. |
| `preset-filled` | Neutral surface 950/50 background with surface 50/950 text. |
| `preset-tonal` | A 5% surface 950/50 mixed with transparent background; foreground is inherited. |
| `preset-outlined` | Neutral 1px surface 950/50 border; foreground/background are inherited. |

Do not invent `preset-tonal-primary-500`, arbitrary filled shade suffixes, or a uniform “all presets use 500” rule. Separate shape (`btn`, `card`) from paint (`preset-*`) and layout (`p-4`, `gap-4`).

Sources: [v3 Colors](https://v3.skeleton.dev/docs/design/colors), [v3 Presets](https://v3.skeleton.dev/docs/design/presets), [pinned pairing definitions](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css), [pinned preset CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/optional/presets.css).

## Typography, spacing, and responsive layout

Typography is opt-in: use `h1`–`h6`, `anchor`, `blockquote`, `code`, `pre`, and `kbd` classes on appropriate semantic elements. A visual class is not a semantic heading level: `<h2 class="h3">` remains a level-two heading. Choose levels from document structure and visual size separately. Theme `--text-scaling` affects Tailwind text sizes; font-family tokens select fonts, which must also be loaded unless they are system fonts.

Use the theme's spacing scale with `p-4`, `gap-4`, `space-y-4`, and related Tailwind utilities. Changing `--spacing` affects many dimensions, not only padding: review widths, heights, gaps, and hit targets after altering it. Use a small spacing vocabulary consistently rather than arbitrary pixel offsets.

Start with one column, `w-full`, and readable maximum widths; add `md:grid-cols-2` or `lg:grid-cols-3` only when content benefits. Use `min-w-0` for grid and flex children that must shrink, allow labels to wrap, and use horizontal overflow for wide data tables rather than squeezing cells or changing their semantics. Keep visual order consistent with keyboard and reading order. Check narrow widths and zoom in real browsers.

Sources: [v3 Typography](https://v3.skeleton.dev/docs/design/typography), [v3 Spacing](https://v3.skeleton.dev/docs/design/spacing), [v3 layout guidance](https://v3.skeleton.dev/docs/guides/layouts).

For visual direction, hierarchy, density, and a complete responsive shell, see [design.md](design.md). These utilities implement a design; they do not choose one.

## Native button, form, card, and table classes

| Native markup | V3 utility classes | Preserve behavior |
| --- | --- | --- |
| `<button>` / navigation `<a>` | `btn`, `btn-sm`, `btn-base`, `btn-lg`, `btn-icon`; add a preset | Use a button for an action, anchor with `href` for navigation. Set button `type`; use native `disabled` on buttons. Name icon-only buttons. |
| `<label>` + controls | `label`, `label-text`, `input`, `textarea`, `select`, `checkbox`, `radio` | Install/enable the forms plugin. Preserve input type, label association, `name`, required state, and native keyboard behavior. |
| `<article>` / `<section>` / container | `card`, optionally `card-hover`; add a preset and padding | A card does not create an interaction. Use a real link/button; avoid clickable `div`s and nested interactive elements inside a card link. |
| `<table>` in a wrapper | `table-wrap`, `table` | Use caption, header cells and scope. Actions belong in a cell as links/buttons, not row click handlers. |

Standalone display recipe; no script or network dependency.

**File: `Summary.svelte`**

```svelte
<section class="card preset-filled-surface-100-900 space-y-4 p-4 md:p-6" aria-labelledby="summary-title">
  <h2 id="summary-title" class="h3">Project summary</h2>
  <p>Two tasks remain before the release.</p>
  <div class="table-wrap">
    <table class="table">
      <caption class="p-2 text-left">Release checklist</caption>
      <thead>
        <tr><th scope="col">Task</th><th scope="col">Status</th></tr>
      </thead>
      <tbody>
        <tr><th scope="row">Documentation</th><td>In review</td></tr>
        <tr><th scope="row">Keyboard checks</th><td>Pending</td></tr>
      </tbody>
    </table>
  </div>
  <a href="#summary-title" class="btn preset-tonal-primary">Return to summary heading</a>
</section>
```

Give IDs unique values if repeating the recipe on one page. See [accessibility.md](accessibility.md) for a local-only form recipe and interaction checks.

Sources: [Buttons](https://v3.skeleton.dev/docs/tailwind/buttons), [Forms](https://v3.skeleton.dev/docs/tailwind/forms), [Cards](https://v3.skeleton.dev/docs/tailwind/cards), [Tables](https://v3.skeleton.dev/docs/tailwind/tables).

## Dark mode, initial paint, and hydration

Media strategy is the default: CSS follows `prefers-color-scheme`. In [core 3.2.2](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css), `:root` sets `color-scheme: light` and switches to `dark` through `@variant dark`; body background/text also use that variant. Pairings use `light-dark()` and inherit the computed scheme. For an explicit class-based choice, define this after imports in the global stylesheet and toggle `.dark` on `<html>`:

```css
@custom-variant dark (&:where(.dark, .dark *));
```

Alternatively, choose the attribute strategy instead:

```css
@custom-variant dark (&:where([data-mode=dark], [data-mode=dark] *));
```

Then set `data-mode="dark"` on `<html>`. Choose **one** strategy; changing `data-mode` does nothing to a `.dark`-configured variant. `data-theme` chooses a theme, not light or dark mode. Tailwind's `scheme-light` and `scheme-dark` locally force `color-scheme` and thus pairing colors and native control appearance; they do not activate the global `dark:` selector or replace Skeleton's variant-controlled body background/text.

For an SSR app, choose the initial mode deliberately. CSS media mode needs no browser JavaScript to determine the initial color scheme. Render a persisted explicit choice server-side from a cookie, or apply it with a small pre-paint browser script consistent with the selected CSS strategy. The server cannot read `localStorage` or `matchMedia`. Reading preferences only in `onMount` is browser-safe but occurs after mount, so the default theme or mode may visibly flash. A head script must respect the application's CSP and handle unavailable storage. Do not copy the archive's Astro navigation hooks into SvelteKit.

Keep server and client initial component markup deterministic. If an early script changes the root mode, do not render a different mode label or icon during hydration from a separately initialized client preference. Establish one source of truth; render mode-dependent controls consistently, then update after mount when necessary. CSS-only color changes do not justify suppressing hydration warnings.

Sources: [pinned root/body/pairing CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css), [v3 Dark Mode](https://v3.skeleton.dev/docs/guides/mode), [Tailwind color scheme](https://tailwindcss.com/docs/color-scheme), [Tailwind dark-mode initial-paint guidance](https://tailwindcss.com/docs/dark-mode), [Svelte lifecycle hooks](https://svelte.dev/docs/svelte/lifecycle-hooks).

## Styling debugging checklist

1. Inspect `<html>` in the browser. Confirm the correct imported `data-theme`, chosen mode selector, and computed `color-scheme`. Check ancestor `scheme-light` and `scheme-dark` overrides when pairings appear stuck.
2. Inspect computed styles and CSS rules. Check whether theme tokens resolve or are unset or overridden. For outlined presets, inspect the border separately from inherited text and background.
3. If `preset-*` does nothing, confirm `optional/presets` is imported globally. If forms differ, confirm the forms plugin import and installed dependency.
4. If utilities are missing, confirm Tailwind processing, the app's source detection, and the correct component-package `@source` path relative to the stylesheet. Keep complete class strings visible to Tailwind; do not build names as `"bg-" + color + "-500"`. Map choices to full literal classes.
5. Compare both schemes for every active theme in actual target browsers: pairing colors use modern `light-dark()`; native form rendering varies by platform. A screenshot from one browser is insufficient.
6. Reload with JavaScript delayed and disabled, and with a persisted opposite-mode preference. Observe first paint, hydration console warnings, and navigation consistency. Use the interaction checklist in [accessibility.md](accessibility.md) before shipping.

Sources: [v3 installation](https://v3.skeleton.dev/docs/get-started/installation/sveltekit), [v3 Mode](https://v3.skeleton.dev/docs/guides/mode), [Tailwind class detection](https://tailwindcss.com/docs/detecting-classes-in-source-files), [v3 Forms browser support](https://v3.skeleton.dev/docs/tailwind/forms).
