# Setup: Skeleton v3 with Svelte 5 and SvelteKit 3

## Version contract

Use this exact package set. **Skeleton's core and Svelte component packages do not share a v3 version number.** Do not install either Skeleton package without its explicit version, and do not replace `1.5.3` with `3`, `4`, or `latest`.

| Package | Pin | Evidence |
| --- | --- | --- |
| `@skeletonlabs/skeleton` | `3.2.2` | [Registry](https://registry.npmjs.org/@skeletonlabs/skeleton/3.2.2): CSS exports; Tailwind peer `^4.0.0` |
| `@skeletonlabs/skeleton-svelte` | `1.5.3` | [Registry](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/1.5.3): Svelte peer `^5.20.0`; its own development dependency is core `3.2.2` |
| `svelte` | `5.57.2` | [Registry](https://registry.npmjs.org/svelte/5.57.2); satisfies both component and Kit peers |
| `@sveltejs/kit` | `3.0.1` | [Registry](https://registry.npmjs.org/@sveltejs/kit/3.0.1): Svelte `^5.57.1`, Vite `^8.0.12`, Svelte Vite plugin `^7.0.0` |
| `vite` | `8.0.12` | [Registry](https://registry.npmjs.org/vite/8.0.12) |
| `@sveltejs/vite-plugin-svelte` | `7.0.0` | [Registry](https://registry.npmjs.org/@sveltejs/vite-plugin-svelte/7.0.0): supports Vite 8 and Svelte `^5.46.4` |
| `typescript` | `6.0.3` | [Registry](https://registry.npmjs.org/typescript/6.0.3): published stable release satisfying Kit's optional `^6.0.0` peer |
| `tailwindcss`, `@tailwindcss/vite` | `4.3.3` each | [Plugin registry](https://registry.npmjs.org/@tailwindcss/vite/4.3.3): supports Vite `^8` and depends on Tailwind `4.3.3` |

Use Node **22.17 or newer**, also satisfying the selected Vite/plugin engines; Node 24 is a straightforward choice. Kit's Node floor is higher than Vite 8's Node 20 floor, so Node 20 is not enough. TypeScript is optional for JavaScript-only Kit projects; when present, use TypeScript 6 rather than leaving a scaffold's TypeScript 5 or installing current TypeScript 7.

The [archived v3 installation guide](https://v3.skeleton.dev/docs/get-started/installation/sveltekit) documents minimums of **Kit 2, Svelte 5, Tailwind 4**, not a Kit 3 certification. The pins above meet published peer contracts; peer compatibility alone does not prove runtime behavior. Check the exact project with its typecheck/build and an interactive smoke test. Do not report those checks as passed merely because installation succeeded.

## Greenfield project

Use the [official Svelte CLI](https://svelte.dev/docs/kit/creating-a-project) to generate a project:

```sh
npx sv create my-skeleton-app
cd my-skeleton-app
```

Choose TypeScript if desired. Choose the intended package manager in the prompts. Tailwind can be configured manually below; do not assume the current generator selects this reference's dependency versions. Inspect the generated manifest before proceeding.

Honor `packageManager`, the existing lockfile, and workspace conventions. The examples below use npm; for pnpm use `pnpm add -D -E`, for Yarn use `yarn add -D -E`, and for Bun use `bun add -d --exact` with the same version-qualified arguments. Do not create a second lockfile. Run installation in the application workspace, not an unrelated monorepo root.

For a TypeScript project, replace generated versions with these exact dependencies:

```sh
npm install -D --save-exact @skeletonlabs/skeleton@3.2.2 @skeletonlabs/skeleton-svelte@1.5.3 svelte@5.57.2 @sveltejs/kit@3.0.1 vite@8.0.12 @sveltejs/vite-plugin-svelte@7.0.0 typescript@6.0.3 tailwindcss@4.3.3 @tailwindcss/vite@4.3.3
```

For JavaScript-only projects without TypeScript tooling, omit `typescript@6.0.3`. Keep the scaffold's other tools only if their peers support this toolchain. For greenfield projects using `adapter-auto`, pin a Kit 3-compatible adapter as well:

```sh
npm install -D --save-exact @sveltejs/adapter-auto@8.0.0
```

[Adapter auto 8 metadata](https://registry.npmjs.org/@sveltejs/adapter-auto/8.0.0) declares a Kit `^3.0.0-next.0` peer, which includes `3.0.1`. For an existing deployment, preserve its adapter and choose a release supporting Kit 3 instead of replacing it with auto. Preserve ESM `"type": "module"`, scripts, and TypeScript configuration. If the generator created `svelte.config.*`, migrate its options into the Vite plugin and remove the obsolete file as described below. Adapter auto is not a substitute for selecting a production deployment target.

## Existing project

First inspect `package.json`, the resolved lockfile, Node version, `vite.config.*`, `svelte.config.*`, root layout, `src/app.html`, and the imported global stylesheet. If Skeleton 2 or Tailwind 3 is present, perform the [migration](migration.md), not just a dependency update.

Install the exact version set from the greenfield section using the repository's package manager. Upgrade Kit, Svelte, Vite, the Svelte Vite plugin, any TypeScript installation, and the deployment adapter together. Do not force installation past incompatible peer dependencies. Migrate Kit 2 configuration and imports using the [official Kit 3 migration guide](https://svelte.dev/docs/kit/migrating-to-sveltekit-3). Preserve server settings, plugins, layouts, and application CSS while relocating supported settings; merge the changes below rather than overwriting whole configuration files.

## TypeScript configuration

For Kit 3, the application's root **`tsconfig.json`** must extend `$app/tsconfig`, not `./.svelte-kit/tsconfig.json`. The old generated `.svelte-kit/tsconfig.json` is obsolete; do not try to restore it by rerunning sync. Kit's new base config does not supply `include` or `exclude`, so set them explicitly. A complete minimal root `tsconfig.json` is:

```json
{
  "extends": "$app/tsconfig",
  "include": ["src", "test", "*"],
  "exclude": ["src/service-worker"]
}
```

For an existing project, merge these fields into its configuration rather than replacing the file: preserve application `compilerOptions` and other supported settings, retain additional source/test paths in `include`, and retain existing exclusions alongside `src/service-worker`. `$app/tsconfig` supplies essential `isolatedModules` and `verbatimModuleSyntax` options; do not disable them when merging. If the project has a TypeScript service worker, give it a separate `src/service-worker/tsconfig.json` extending `$app/tsconfig/service-worker`, as described in the same migration guide.

Source: [Kit 3 `$app/tsconfig` migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig).

## Vite integration

Kit 3 no longer supports `svelte.config.js`. Move its `kit` options to the object passed to `sveltekit()`; put `preprocess`, `compilerOptions`, and other supported Svelte options alongside them. Preserve the deployment adapter, then remove the obsolete configuration file. Review removed/renamed Kit options instead of copying them blindly. Merge the Tailwind Vite plugin **before** `sveltekit()`. A minimal greenfield `vite.config.ts` using adapter auto is:

```ts
import adapter from '@sveltejs/adapter-auto';
import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [tailwindcss(), sveltekit({ adapter: adapter() })]
});
```

If existing components require `vitePreprocess()`, keep its import from `@sveltejs/vite-plugin-svelte` and pass `preprocess: vitePreprocess()` to `sveltekit(...)`. Kit 3 also replaces `$lib` with explicit `#lib` package imports and `$app/environment` with `$app/env`; migrate affected callsites, not just the config.

Sources: [Kit 3 configuration migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#Configuration), [Tailwind Vite installation](https://tailwindcss.com/docs/installation/using-vite), [archived Skeleton migration plugin order](https://v3.skeleton.dev/docs/get-started/migrate-from-v2#migrate-to-the-tailwind-vite-plugin). Do not add Skeleton's old Tailwind plugin. Avoid processing Tailwind a second time via PostCSS; preserve unrelated PostCSS work if the project still needs it.

## Global CSS and dependency scanning

For `src/app.css` with `node_modules` in the app root, use:

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton/optional/presets';
@import '@skeletonlabs/skeleton/themes/cerberus';

@source '../node_modules/@skeletonlabs/skeleton-svelte/dist';
```

These are the [archived v3 imports](https://v3.skeleton.dev/docs/get-started/installation/sveltekit). Presets are optional, but import them when using `preset-*` classes. Keep application styles after the imports.

**Opt in to form normalization when using Skeleton's styled native form classes** (`input`, `select`, `textarea`, `checkbox`, etc.). The [archived forms prerequisites](https://v3.skeleton.dev/docs/tailwind/forms#prerequisites) require `@tailwindcss/forms` for those utilities; it is not required for a page using only other Skeleton features. Install the [Tailwind 4-compatible release](https://registry.npmjs.org/@tailwindcss/forms/0.5.11) with the same package manager:

```sh
npm install -D --save-exact @tailwindcss/forms@0.5.11
```

Insert this directive immediately after the Tailwind import in the global stylesheet:

```css
@plugin '@tailwindcss/forms';
```

See [styling](styling.md) for complete form and theme patterns.

Tailwind normally ignores `node_modules`; Skeleton's component classes need the explicit source. **`@source` is relative to the stylesheet, not to `vite.config.*` or the shell's working directory.** Verify the directory actually exists in this installation.

For example, if the stylesheet is `apps/web/src/app.css` and the dependency is hoisted to the repository's `node_modules`, replace the source line with:

```css
@source '../../../node_modules/@skeletonlabs/skeleton-svelte/dist';
```

If the workspace has its own `node_modules` symlink, the original `../node_modules/...` path may already work; follow the actual resolved location rather than assuming hoisting. With a monorepo-root build working directory, Tailwind's app scan can also be scoped by replacing the first import in `apps/web/src/app.css` with:

```css
@import 'tailwindcss' source('./');
```

Explicitly register shared UI source directories if they lie outside that app scope. Source: [Tailwind source detection and base-path rules](https://tailwindcss.com/docs/detecting-classes-in-source-files).

## Root layout and active theme

Import the stylesheet once in `src/routes/+layout.svelte`. A minimal Svelte 5 layout uses a `children` snippet:

```svelte
<script lang="ts">
  import '../app.css';
  import type { Snippet } from 'svelte';

  let { children }: { children: Snippet } = $props();
</script>

{@render children()}
```

Source: [Svelte 5 children/snippet migration](https://svelte.dev/docs/svelte/v5-migration-guide#Snippets-instead-of-slots). Merge the import/rendering with existing layout data, providers, and markup; do not discard them. A JavaScript layout can omit the type import and annotation. Do not introduce `initializeStores()` from Skeleton 2.

In `src/app.html`, **add only `data-theme="cerberus"` to the existing `<html>` element**. Preserve language attributes and the rest of the template. For a template already using English, the opening tag becomes:

```html
<html lang="en" data-theme="cerberus">
```

Theme registration (the CSS import) and theme activation (`data-theme`) are separate requirements, and their names must match. Do not place this attribute only on `<body>`. Keep `%sveltekit.head%`, `%sveltekit.body%` and its wrapper, asset paths, CSP placeholders, metadata, and preload attributes intact. Sources: [Skeleton theme activation](https://v3.skeleton.dev/docs/get-started/installation/sveltekit), [Kit template placeholders](https://svelte.dev/docs/kit/project-structure#Project-files-src).

## Targeted diagnosis

| Symptom | Inspect and correct |
| --- | --- |
| Installer proposes Skeleton 5 | Ensure both Skeleton arguments are pinned (`3.2.2`, `1.5.3`); check the workspace manifest and resolved lockfile. Never use `latest` or infer equal package majors. |
| Peer conflict involving Vite | Kit 3.0.1 needs Vite 8.0.12+ and Svelte plugin 7. Older Tailwind 4 Vite-plugin releases may not support Vite 8; use the pinned 4.3.3 pair. |
| TypeScript peer error | Kit's peer range is `^6.0.0`, not an instruction to install the unpublished `6.0.0` release. Use published `6.0.3`; don't bypass the peer check. |
| `tsconfig_extends_missing` or missing `.svelte-kit/tsconfig.json` | Update root `tsconfig.json` to extend `$app/tsconfig` and explicitly set `include`/`exclude` as in [TypeScript configuration](#typescript-configuration); preserve application compiler options. Kit 3 no longer uses the old generated config. |
| Kit complains about `svelte.config.*` or old module aliases | Move configuration to `sveltekit({...})` and remove the old file; migrate imports per the Kit 3 guide. This is a Kit upgrade issue, not a Skeleton stylesheet problem. |
| Tailwind works, component internals lack styles | Check the actual stylesheet-relative `@source` directory and root layout CSS import. |
| Utilities exist, theme colors do not | Check core CSS import, theme CSS import, and the matching `<html data-theme>` value. |
| `preset-*` styles missing | Import `@skeletonlabs/skeleton/optional/presets`; inspect exact class spelling rather than restoring a v2 plugin. |
| Export/prop error for a component | Inspect installed `dist/index.d.ts` and the component declarations; the docs may describe v2, v4/v5, or the v3 experimental `/composed` subpath. See [migration](migration.md). |
| HTML/hydration template error | Restore Kit's template placeholders and body wrapper; adding a theme never requires replacing `app.html`. |

Before handing off, inspect resolved versions with the chosen package manager, run the project's existing typecheck/build, and smoke a rendered styled page plus one interactive component. Record exact commands and results; a successful compile does not establish focus/keyboard behavior or deployment compatibility. For offline API inspection, use the [migration reference](migration.md#offline-inspection-fallback).
