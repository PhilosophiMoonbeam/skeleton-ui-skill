# Set up Bits UI in Svelte 5

Bits UI provides headless interaction primitives. Use native HTML when it meets the requirement. Bits UI does not require SvelteKit, Tailwind, Skeleton CSS, icons, a global provider, or a stylesheet. Choose styling separately.

In an existing app, retain compatible Skeleton Svelte widgets. Add Bits UI only when you choose it for a new or explicitly migrated widget. See [Skeleton UI](skeleton.md) for its separate component installation and CSS.

## Version contract

| Package or tool | Baseline |
| --- | --- |
| Svelte | `5.59.1` |
| Bits UI | `2.22.0` |
| `@internationalized/date` | `3.12.4` |
| Bun | `1.4.5` |
| Vite / `@sveltejs/vite-plugin-svelte` | `8.3.8` / `7.3.1` |
| SvelteKit (only for Kit projects) / `@sveltejs/adapter-auto` (greenfield) | `3.4.0` / `9.0.0` |
| TypeScript / `svelte-check` (optional Kit tooling) | `6.0.3` / `4.7.8` |
| Tailwind CSS / `@tailwindcss/vite` (optional styling) | `4.3.5` each |
| `@skeletonlabs/skeleton` (optional themes and CSS utilities) | `5.0.6` |
| `@skeletonlabs/skeleton-svelte` (optional styled components) | `5.0.6` |
| `@lucide/svelte` (optional icons) | `1.77.0` |

The [Bits UI 2.22.0 manifest](https://unpkg.com/bits-ui@2.22.0/package.json) declares peers `svelte@^5.33.0` and `@internationalized/date@^3.8.1`. The package manager may resolve the date peer automatically; explicitly declare `@internationalized/date` in any app or workspace package that imports date or time values/types. Do not depend on a hoisted peer.

The Kit instructions target **Kit 3.1+**; the exact baseline is [Kit 3.4.0](https://registry.npmjs.org/@sveltejs/kit/3.4.0) with Svelte `^5.57.1`, Vite `^8.0.12`, Svelte Vite plugin `^7.0.0`, and optional TypeScript `^6.0.0`. Use TypeScript `6.0.3` with `svelte-check@4.7.8`, not TypeScript 7. This Kit boundary does not apply to standalone Svelte. Use Bun for baseline project commands. For an explicitly Node-targeted production adapter, also verify its runtime requirements and upstream engines: the pinned Kit and Svelte Vite plugin permit Node 22.17+ within 22.x, or 24+ in their intersection.

Pins and a committed lockfile define a reproducible dependency set, not a guarantee that the application works. For an existing app on another supported release, compare that release's framework, plugin, and adapter contracts rather than assuming the baseline certifies it. Use ordinary `svelte-check` for the TypeScript baseline, not its experimental `--tsgo` mode.

## Existing project

Inspect the app's manifest, lockfile, installed versions, scripts, Vite settings, entry point or root layout, and global styles. Keep the existing compatible toolchain, adapter, and package manager. Do not add a second lockfile.

In a Bun workspace, `bun pm ls` inspects installed versions and `bun info @sveltejs/kit@3.4.0 peerDependencies` reads exact published metadata without updating dependencies. Compare that metadata with the consuming app's manifest and lockfile; do not force conflicting peers. If an install hook needs changes outside scope, report the prerequisite instead of proceeding or masking the failure.

If the app needs Bits UI, install it in the consuming workspace:

```sh
bun add --exact bits-ui@2.22.0
```

When the workspace imports `@internationalized/date`, add it directly:

```sh
bun add --exact @internationalized/date@3.12.4
```

Do not upgrade Svelte or Kit implicitly. A Kit version below the supported floor needs a separately scoped [framework migration](migration.md) before applying the Kit-specific configuration below. Check existing install hooks before adding packages; for Bun-managed Kit sync, use `bun --bun svelte-kit sync` rather than a Node shebang or a fallback that hides failure.

## Greenfield standalone Svelte

With Bun `1.4.5`, create a minimal Vite app without Kit or any styling stack:

```sh
mkdir my-svelte-app
cd my-svelte-app
printf '%s\n' '{"private":true,"type":"module","packageManager":"bun@1.4.5"}' > package.json
bun add --dev --exact svelte@5.59.1 vite@8.3.8 @sveltejs/vite-plugin-svelte@7.3.1
bun add --exact bits-ui@2.22.0
mkdir -p src
```

Create `vite.config.mjs`:

```js
import { svelte } from '@sveltejs/vite-plugin-svelte';
import { defineConfig } from 'vite';

export default defineConfig({ plugins: [svelte()] });
```

Create `index.html`:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Shipping help</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
```

Create `src/main.js`:

```js
import { mount } from 'svelte';
import App from './App.svelte';

mount(App, { target: document.getElementById('app') });
```

Use the component in [First interactive check](#first-interactive-check) as `src/App.svelte`, then start Vite:

```sh
bunx --bun vite
```

Commit `bun.lock`. See [Vite's project entry documentation](https://vite.dev/guide/) and [Bits UI getting started](https://www.bits-ui.com/docs/getting-started/llms.txt).

For a standalone app that already owns an SSR entry, use `hydrate` on server-rendered markup rather than calling `mount` on it. [Svelte 5.59.1](https://github.com/sveltejs/svelte/releases/tag/svelte@5.59.1) aligns the `mount` and `hydrate` type parameters so a union of the two is callable in a shared entry point. This does not change Kit's ownership of hydration.

## Greenfield SvelteKit

Use Kit only when the app needs Kit features. Generate a minimal TypeScript app without installing scaffold versions:

```sh
bunx --bun sv@1.7.0 create --template minimal --types ts --no-add-ons --no-install my-kit-app
cd my-kit-app
```

For JavaScript, use `--no-types` instead of `--types ts`. Before the first `bun add`, apply the TypeScript (or JavaScript) and Vite configuration below, remove any obsolete `svelte.config.*`, and merge these fields into the scaffold manifest. Keep the other scripts and `"type": "module"`. The install hook runs Kit sync, which reads the Vite config.

```json
{
  "packageManager": "bun@1.4.5",
  "scripts": {
    "prepare": "bun --bun svelte-kit sync"
  }
}
```

Install the Kit baseline and Bits UI in the application workspace:

```sh
bun add --dev --exact svelte@5.59.1 @sveltejs/kit@3.4.0 vite@8.3.8 @sveltejs/vite-plugin-svelte@7.3.1 typescript@6.0.3 svelte-check@4.7.8 @sveltejs/adapter-auto@9.0.0
bun add --exact bits-ui@2.22.0
```

In an app without TypeScript tooling, omit `typescript` and `svelte-check`. Inspect remaining scaffold dependencies for incompatible peers and commit `bun.lock`. Keep an existing explicit deployment adapter rather than replacing it with adapter-auto; adapter-auto 9 detects Cloudflare Workers, not Pages.

Use the component in [First interactive check](#first-interactive-check) as `src/routes/+page.svelte`, then run `bun run --bun dev`. Kit owns hydration; do not add a manual mount entry.

## First interactive check

```svelte
<script>
  import { Accordion } from 'bits-ui';
</script>

<Accordion.Root type="single">
  <Accordion.Item value="delivery">
    <Accordion.Header>
      <Accordion.Trigger>When will my order arrive?</Accordion.Trigger>
    </Accordion.Header>
    <Accordion.Content>Standard delivery takes three to five business days.</Accordion.Content>
  </Accordion.Item>
  <Accordion.Item value="tracking">
    <Accordion.Header>
      <Accordion.Trigger>Where can I track my order?</Accordion.Trigger>
    </Accordion.Header>
    <Accordion.Content>Use the tracking link in your shipping confirmation email.</Accordion.Content>
  </Accordion.Item>
</Accordion.Root>
```

Tab to the first trigger and press Enter or Space. Its content and expanded state should change together. Use the Down Arrow to move focus to the second trigger, then open it; the first section should close. The unstyled appearance is expected. See the [example mounting guide](../examples/README.md) for additional controls.

## Lucide when icons are useful

```sh
bun add --exact @lucide/svelte@1.77.0
```

Lucide supplies inline SVG, not interaction, and needs no CSS import or browser initializer. See [Lucide](lucide.md) for imports, accessible use, and the separately optional [Lab pattern](lucide-patterns.md#custom-icon-data-and-lab). For route lists and layout context, see [SvelteKit integration](sveltekit.md#lucide-rendering-and-subtree-scope).

## Kit configuration

Merge these changes into an existing supported Kit app; preserve unrelated plugins, CSS, layouts, deployment settings and supported compiler options. See [SvelteKit integration](sveltekit.md) for route behavior and migration boundaries.

### TypeScript configuration

The application's root `tsconfig.json` (or `jsconfig.json` for JavaScript) must extend `$app/tsconfig`, not `./.svelte-kit/tsconfig.json`. The old generated `.svelte-kit/tsconfig.json` is obsolete; do not try to restore it by rerunning sync. Kit's new base configuration does not supply `include` or `exclude`, so set them explicitly. Use this complete minimal configuration:

`tsconfig.json`:

```json
{
  "extends": "$app/tsconfig",
  "include": ["src", "test", "*"],
  "exclude": ["src/service-worker"]
}
```

For an existing project, merge these fields into its configuration rather than replacing the file: preserve application `compilerOptions` and other supported settings, retain additional source and test paths in `include`, and retain existing exclusions alongside `src/service-worker`. `$app/tsconfig` supplies essential `isolatedModules` and `verbatimModuleSyntax` options; do not disable them when merging. If the project has a TypeScript service worker, give it a separate `src/service-worker/tsconfig.json` extending `$app/tsconfig/service-worker`, as described in the same migration guide.

Sources: [Kit 3 `$app/tsconfig` migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig), [exact 3.4.0 tsconfig generator](https://unpkg.com/@sveltejs/kit@3.4.0/src/core/sync/write_tsconfig/index.js).

### Vite integration

Kit `>=3.1.0` no longer supports `svelte.config.js`. Move its `kit` options to the object passed to `sveltekit()`; put `preprocess`, `compilerOptions`, and other supported Svelte options alongside them. Preserve the deployment adapter, review removed or renamed options, then remove the obsolete configuration file. This greenfield configuration does not include a CSS processor:

`vite.config.ts`:

```ts
import adapter from '@sveltejs/adapter-auto';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [sveltekit({ adapter: adapter() })]
});
```

If existing components require `vitePreprocess()`, keep its import from `@sveltejs/vite-plugin-svelte` and pass `preprocess: vitePreprocess()` to `sveltekit(...)`. Migrate Kit 3 module imports as described below; moving configuration alone is insufficient.

Sources: [Kit 3 configuration migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#Configuration), [exact Kit 3.4.0 declarations](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts).

### Kit 3 package imports and environment

`$lib` is no longer generated. Merge this public package subpath-import mapping into the **application's** `package.json`, preserving its other fields and existing import mappings:

```json
{
  "imports": {
    "#lib/*": "./src/lib/*"
  }
}
```

Replace every `$lib/...` import and re-export with `#lib/...`, including in wrappers, tests, and shared helpers. Include the actual filename extension: `src/lib/components/ProfileCard.svelte` becomes `#lib/components/ProfileCard.svelte`; `src/lib/utils.ts` becomes `#lib/utils.ts` (or `.js` for a JavaScript file). The mapping does not create files or infer directory indexes. If callers import bare `$lib`, also map `"#lib": "./src/lib/index.ts"` (or `.js`) to the real barrel file and migrate those callers to `#lib`. Remove obsolete `files.lib` and `$lib` alias overrides; for a custom library directory, point the package mapping at that directory instead. Do not add a `$lib` compatibility alias.

Use `$app/env` instead of `$app/environment`. The [compatibility module shipped in Kit 3.4.0](https://unpkg.com/@sveltejs/kit@3.4.0/src/runtime/app/environment/index.js) still re-exports `$app/env` and warns in development. The public `browser`, `building`, `dev`, and `version` exports remain available:

```ts
import { browser, building, dev, version } from '$app/env';
```

`$app/stores` is removed: migrate to read-only rune-reactive `$app/state`, not `$page`/`subscribe`/`set`. For environment configuration, export `variables = defineEnvVars({...})` from `src/env.ts`/`.js`, importing `defineEnvVars` from `@sveltejs/kit/env`; public/static default false. Runtime values are read at startup, not per request; without a schema values must exist but may be empty. Keep private values out of browser imports; public values are deliberately exposed. Sources: [Kit 3 import migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3), [environment variables](https://svelte.dev/docs/kit/environment-variables), [exact 3.4.0 declarations](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts).

## Global CSS and dependency scanning

Using plain CSS? Skip the optional Tailwind configuration and [load your stylesheet](#load-the-stylesheet-and-activate-an-optional-theme) directly. To use Tailwind on Vite:

```sh
bun add --dev --exact tailwindcss@4.3.5 @tailwindcss/vite@4.3.5
```

Import `tailwindcss` from `@tailwindcss/vite` in `vite.config.*` and prepend `tailwindcss()` to the existing plugin list: `[tailwindcss(), svelte()]` for standalone Vite or `[tailwindcss(), sveltekit({ adapter: adapter() })]` for the greenfield Kit configuration above. Do not also process Tailwind through PostCSS; retain unrelated transforms.

For Tailwind alone, `src/app.css` needs only `@import 'tailwindcss';`. For optional Skeleton themes and CSS utilities, also install the CSS core:

```sh
bun add --dev --exact @skeletonlabs/skeleton@5.0.6
```

Then use:

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton/themes/cerberus';
```

Core includes presets; the old `@skeletonlabs/skeleton/optional/presets` subpath is not exported by [5.0.6](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/package.json). Do not add a historical Skeleton Tailwind plugin. If using Skeleton Svelte widgets, add their [framework CSS import](skeleton.md#add-styled-skeleton-components) between core and the theme; it replaces the historical manual Skeleton `dist` scan. Neither Bits UI nor Skeleton CSS requires a manual dependency scan.

When using Skeleton's styled native form utilities, install their form reset:

```sh
bun add --dev --exact @tailwindcss/forms@0.5.11
```

Add `@plugin '@tailwindcss/forms';` after **all** imports, including custom themes, and before any application `@source`, variants, or style rules. Native forms and Kit enhancement do not otherwise require this plugin.

Tailwind's default scan starts from the working directory and skips ignored files, `node_modules`, and CSS. Use complete literal classes; Tailwind scans source text, not evaluated expressions. For a monorepo with `apps/web/src/app.css` and shared components in `packages/ui/src`, set the app scan base explicitly and register the shared files:

```css
@import 'tailwindcss' source('../');
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton/themes/cerberus';

@source '../../../packages/ui/src';
```

`source('../')` scans all of `apps/web`, not just `apps/web/src`. Both paths are relative to the stylesheet, not `vite.config.*`. Register each additional shared UI source outside the app scan. Just Tailwind? Omit the Skeleton imports. See [Tailwind Vite installation](https://tailwindcss.com/docs/installation/using-vite), [source detection](https://tailwindcss.com/docs/detecting-classes-in-source-files), and [styling and themes](styling.md).

If the first build picks up shared classes but edits do not, check that a new literal class in the registered path generates CSS during development. [Tailwind 4.3.4](https://github.com/tailwindlabs/tailwindcss/releases/tag/v4.3.4) fixed watching explicitly registered symlinks whose real paths are not scanned and automatic detection of `.gitignore` negations; the 4.3.5 baseline includes those fixes. Do not register the real path a second time to work around the fixed watch bug. [Tailwind 4.3.5](https://github.com/tailwindlabs/tailwindcss/releases/tag/v4.3.5) also fixes changed and new file detection on the Oxide WASM fallback; do not install that internal fallback package directly.

### Load the stylesheet and activate an optional theme

In standalone Vite, add `import './app.css';` to `src/main.js`. In Kit, add the import once in the root layout. Merge it into the existing layout rather than replacing its children, providers or shell:

```svelte
<!-- src/routes/+layout.svelte -->
<script>
  import '../app.css';
  let { children } = $props();
</script>

{@render children()}
```

If using the Cerberus theme, set `data-theme="cerberus"` on the existing `<html>` in `index.html` (standalone Vite) or `src/app.html` (Kit), not only on `<body>`. Match the attribute to the imported theme. Preserve the rest of [Kit's template](https://svelte.dev/docs/kit/project-structure#Project-files-src), including placeholders, the body wrapper, `lang`, preload attributes, metadata, asset paths, and CSP. See [styling](styling.md) for light/dark mode, contrast and SSR.

## Targeted diagnosis

| Symptom | Inspect |
| --- | --- |
| Trigger renders but does not respond | Confirm client JS has started, the Bits parts share their required root, and any `child` snippet spreads its supplied props onto the interactive element. Check focus, disabled state, and bound state separately. |
| Trigger works but looks plain | Bits UI is headless. Check the app stylesheet and class selectors; if using Tailwind, check Vite processing, complete literal class strings, and shared `@source` paths. |
| Utilities work but theme colors do not | Check Skeleton core/theme imports, the matching root `data-theme`, and computed `color-scheme`. |
| A compatible Skeleton widget works but its internal styles are missing | Check the [framework CSS import](skeleton.md#add-styled-skeleton-components) and root stylesheet loading, not a manual Skeleton dependency scan. |
| SSR and client disagree or controls never hydrate | Check the first render's open/selected values, IDs, browser-only APIs, and invalid HTML nesting. In Kit also check the template placeholders. Do not disable SSR to cover a mismatch. |
| Package or prop error | Check the workspace lockfile, peer resolution, and installed public declarations. See [sources](sources.md). |
| Kit reports obsolete config, aliases or missing `.svelte-kit/tsconfig.json` | Migrate the Kit configuration and imports above; this is not a Bits or CSS problem. |

For a Bun-managed setup, run its existing check and build scripts with `bun run --bun check` (if defined) and `bun run --bun build`; `--bun` also runs executables with Node shebangs under Bun. A successful build does not establish keyboard, focus, form, or hydration behavior. Use the [example mounting guide](../examples/README.md) to exercise the relevant controls and the [SvelteKit form recipe](sveltekit.md#native-form-actions-with-progressive-enhancement) for a native/enhanced submission comparison.
