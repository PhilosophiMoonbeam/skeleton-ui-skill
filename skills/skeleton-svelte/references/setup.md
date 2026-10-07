# Setup: Skeleton v3 with Svelte 5 and SvelteKit 3

## Version contract

Use this exact package set for a **greenfield project or an explicitly requested framework migration**. Preserve a supported existing toolchain otherwise. **Skeleton's core and Svelte component packages do not share a v3 version number.** When installing this skill's Skeleton pair, pin both packages; do not replace `1.5.3` with `3`, `4`, or `latest`.

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

For this target, use **Node 22.17+ within 22.x, or Node 24+**: Kit requires `>=22.17`, Vite requires `^20.19.0 || >=22.12.0`, and the Svelte Vite plugin requires `^20.19 || ^22.12 || >=24`. Node 20 and 23 do not satisfy the combined contract. TypeScript is optional for JavaScript-only Kit projects; when present in this target, use the pinned TypeScript 6 release.

The [archived v3 installation guide](https://v3.skeleton.dev/docs/get-started/installation/sveltekit) documents minimums of **Kit 2, Svelte 5, Tailwind 4**, not Kit 3 certification. The pins above meet published peer contracts; peer compatibility alone does not prove runtime behavior. Run the exact project's typecheck and build, then perform an interactive smoke test. Do not report those checks as passed merely because installation succeeded.

## Greenfield project

Use the [official Svelte CLI](https://svelte.dev/docs/kit/creating-a-project) to generate a project:

```sh
npx sv create my-skeleton-app
cd my-skeleton-app
```

Choose TypeScript if desired. Select the intended package manager in the prompts. Configure Tailwind manually as shown below if needed; do not assume the current generator selects this reference's dependency versions. Inspect the generated manifest before proceeding.

Honor `packageManager`, the existing lockfile, and workspace conventions. The examples below use npm; translate their version-qualified arguments to the repository's package manager's exact-version dev-dependency syntax. Do not create a second lockfile. Run installation in the application workspace, not an unrelated monorepo root.

For a TypeScript project, replace generated versions with these exact dependencies:

```sh
npm install -D --save-exact @skeletonlabs/skeleton@3.2.2 @skeletonlabs/skeleton-svelte@1.5.3 svelte@5.57.2 @sveltejs/kit@3.0.1 vite@8.0.12 @sveltejs/vite-plugin-svelte@7.0.0 typescript@6.0.3 tailwindcss@4.3.3 @tailwindcss/vite@4.3.3
```

For JavaScript-only projects without TypeScript tooling, omit `typescript@6.0.3`. Keep the scaffold's other tools only if their peers support this toolchain. For greenfield projects using `adapter-auto`, pin a Kit 3-compatible adapter as well:

```sh
npm install -D --save-exact @sveltejs/adapter-auto@8.0.0
```

[Adapter auto 8 metadata](https://registry.npmjs.org/@sveltejs/adapter-auto/8.0.0) declares a Kit `^3.0.0-next.0` peer, which includes `3.0.1`. During an approved Kit 3 migration, retain the existing deployment target and select a compatible release of its adapter instead of replacing it with auto. Preserve ESM `"type": "module"` and scripts; merge the Kit 3 TypeScript changes below. If the generator created `svelte.config.*`, migrate its supported options into the Vite plugin and remove the obsolete file as described below. Adapter auto is not a substitute for selecting a production deployment target.

## Existing project

First inspect `package.json`, the resolved lockfile, Node version, `vite.config.*`, `svelte.config.*`, root layout, `src/app.html`, and the imported global stylesheet. **Inspection does not authorize an upgrade.** Preserve the supported framework, adapter, toolchain, lockfile, and working conventions; an existing app already using this Skeleton pair needs only the requested UI changes.

For an approved Skeleton installation or v2-to-v3 migration, install the pair with the repository's package manager; the npm command is:

```sh
npm install -D --save-exact @skeletonlabs/skeleton@3.2.2 @skeletonlabs/skeleton-svelte@1.5.3
```

Retain compatible existing Svelte 5, Kit 2-or-later, Tailwind 4, and Vite integration versions. The component peer requires Svelte `^5.20.0`; core requires Tailwind `^4.0.0`. If prerequisites are missing, establish the necessary migration scope rather than silently upgrading unrelated packages. Skeleton 2/Tailwind 3 callers require the [migration](migration.md), not just a dependency update.

**Only if the user requests this exact framework target**, apply the greenfield pins and [Kit 3 migration guide](https://svelte.dev/docs/kit/migrating-to-sveltekit-3). Coordinate Kit, Svelte, Vite, the Svelte Vite plugin, optional TypeScript, Node, and the adapter; never force incompatible peers. The Kit 3 configuration sections below do not apply to retained Kit 2 projects. Preserve application settings, plugins, layouts, and CSS; merge supported changes rather than overwriting whole files.

## TypeScript configuration

For **Kit 3 only**, the application's root `tsconfig.json` must extend `$app/tsconfig`, not `./.svelte-kit/tsconfig.json`. The old generated `.svelte-kit/tsconfig.json` is obsolete; do not try to restore it by rerunning sync. Kit's new base configuration does not supply `include` or `exclude`, so set them explicitly. Use this complete minimal configuration:

`tsconfig.json`:

```json
{
  "extends": "$app/tsconfig",
  "include": ["src", "test", "*"],
  "exclude": ["src/service-worker"]
}
```

For an existing project, merge these fields into its configuration rather than replacing the file: preserve application `compilerOptions` and other supported settings, retain additional source and test paths in `include`, and retain existing exclusions alongside `src/service-worker`. `$app/tsconfig` supplies essential `isolatedModules` and `verbatimModuleSyntax` options; do not disable them when merging. If the project has a TypeScript service worker, give it a separate `src/service-worker/tsconfig.json` extending `$app/tsconfig/service-worker`, as described in the same migration guide.

Sources: [Kit 3 `$app/tsconfig` migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig), [exact 3.0.1 tsconfig generator](https://unpkg.com/@sveltejs/kit@3.0.1/src/core/sync/write_tsconfig/index.js).

## Vite integration

**Kit 3** no longer supports `svelte.config.js`. Move its `kit` options to the object passed to `sveltekit()`; put `preprocess`, `compilerOptions`, and other supported Svelte options alongside them. Preserve the deployment adapter, then remove the obsolete configuration file. Review removed or renamed Kit options instead of copying them blindly. Retained Kit 2 projects keep their supported configuration convention. Merge the Tailwind Vite plugin **before** `sveltekit()`. A minimal greenfield configuration using adapter auto is:

`vite.config.ts`:

```ts
import adapter from '@sveltejs/adapter-auto';
import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [tailwindcss(), sveltekit({ adapter: adapter() })]
});
```

If existing components require `vitePreprocess()`, keep its import from `@sveltejs/vite-plugin-svelte` and pass `preprocess: vitePreprocess()` to `sveltekit(...)`. Kit 3 also replaces `$lib` with explicit `#lib` package imports and `$app/environment` with `$app/env`; migrate affected callsites, not just the configuration.

Sources: [Kit 3 configuration migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#Configuration), [exact Kit 3.0.1 plugin declarations](https://unpkg.com/@sveltejs/kit@3.0.1/types/index.d.ts), [Tailwind Vite installation](https://tailwindcss.com/docs/installation/using-vite), [archived Skeleton migration plugin order](https://v3.skeleton.dev/docs/get-started/migrate-from-v2#migrate-to-the-tailwind-vite-plugin). Do not add Skeleton's old Tailwind plugin. Avoid processing Tailwind a second time via PostCSS; preserve unrelated PostCSS work if the project still needs it.

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

Insert this directive **after all `@import` rules**, including theme imports, and before `@source` directives or application styles. Keep the imports grouped first:

```css
@plugin '@tailwindcss/forms';
```

See [styling](styling.md) for complete form and theme patterns.

Tailwind normally ignores `node_modules`; Skeleton's component classes need the explicit source. **`@source` is relative to the stylesheet, not to `vite.config.*` or the shell's working directory.** Verify that the directory exists in this installation.

For a monorepo with `apps/web/src/app.css`, hoisted dependencies in the repository's `node_modules`, and shared components in `packages/ui/src`, use the following. `source('../')` scans the app root, not only `apps/web/src`; the separate shared source is outside that scope.

`apps/web/src/app.css`:

```css
@import 'tailwindcss' source('../');
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton/optional/presets';
@import '@skeletonlabs/skeleton/themes/cerberus';

@source '../../../node_modules/@skeletonlabs/skeleton-svelte/dist';
@source '../../../packages/ui/src';
```

Adjust both source paths to directories that actually exist. If the app has its own `node_modules` symlink, `../node_modules/...` may already resolve correctly. Register every additional shared UI directory used by the app; `source()` does not discover sources outside its base. Source: [Tailwind source detection and base-path rules](https://tailwindcss.com/docs/detecting-classes-in-source-files).

## Root layout and active theme

Import the stylesheet once in `src/routes/+layout.svelte`. A minimal Svelte 5 layout uses a `children` snippet:

`src/routes/+layout.svelte`:

```svelte
<script lang="ts">
  import '../app.css';
  import type { Snippet } from 'svelte';

  let { children }: { children: Snippet } = $props();
</script>

{@render children()}
```

Source: [Svelte 5 children/snippet migration](https://svelte.dev/docs/svelte/v5-migration-guide#Snippets-instead-of-slots). Merge the import and rendering with existing layout data, providers, and markup; do not discard them. A JavaScript layout can omit the type import and annotation. Do not introduce `initializeStores()` from Skeleton 2.

In `src/app.html`, **add only `data-theme="cerberus"` to the existing `<html>` element**. Preserve language attributes and the rest of the template. For a template already using English, the opening tag becomes:

```html
<html lang="en" data-theme="cerberus">
```

Theme registration (the CSS import) and theme activation (`data-theme`) are separate requirements, and their names must match. Do not place this attribute only on `<body>`. Keep `%sveltekit.head%`, `%sveltekit.body%` and its wrapper, asset paths, CSP placeholders, metadata, and preload attributes intact. Sources: [Skeleton theme activation](https://v3.skeleton.dev/docs/get-started/installation/sveltekit), [Kit template placeholders](https://svelte.dev/docs/kit/project-structure#Project-files-src).

## Targeted diagnosis

| Symptom | Inspect and correct |
| --- | --- |
| Installer proposes Skeleton 5 | Ensure both Skeleton arguments are pinned (`3.2.2`, `1.5.3`); check the workspace manifest and resolved lockfile. Never use `latest` or infer equal package majors. |
| Peer conflict involving Vite in the Kit 3 target | Check Kit's Vite `^8.0.12` and Svelte-plugin `^7.0.0` peers; the pinned Tailwind 4.3.3 Vite plugin supports Vite 8. Do not apply these target pins to a retained Kit 2 toolchain. |
| TypeScript peer error in the Kit 3 target | Kit's optional peer is `^6.0.0`; the published target pin is `6.0.3`. Check installed tooling peers rather than bypassing them. |
| `tsconfig_extends_missing` or missing `.svelte-kit/tsconfig.json` in Kit 3 | Extend `$app/tsconfig` and explicitly set `include`/`exclude` as in [TypeScript configuration](#typescript-configuration); preserve application compiler options. Retained Kit 2 projects still use their own generated configuration. |
| Kit 3 complains about `svelte.config.*` or old module aliases | Move configuration to `sveltekit({...})`, remove the old file, and migrate imports per the Kit 3 guide. This is a Kit upgrade issue, not a Skeleton stylesheet problem. |
| Tailwind works, component internals lack styles | Check the actual stylesheet-relative `@source` directory and root layout CSS import. |
| Utilities exist, theme colors do not | Check core CSS import, theme CSS import, and the matching `<html data-theme>` value. |
| `preset-*` styles missing | Import `@skeletonlabs/skeleton/optional/presets`; inspect exact class spelling rather than restoring a v2 plugin. |
| Export/prop error for a component | Inspect installed `dist/index.d.ts` and the component declarations; the docs may describe v2, v4/v5, or the v3 experimental `/composed` subpath. See [migration](migration.md). |
| HTML/hydration template error | Restore Kit's template placeholders and body wrapper; adding a theme never requires replacing `app.html`. |

Before handing off, inspect resolved versions with the chosen package manager, run the project's existing typecheck and build, and smoke-test a rendered styled page and one interactive component. Record exact commands and results; a successful compile does not establish focus behavior, keyboard behavior, or deployment compatibility. For offline API inspection, use the [migration reference](migration.md#offline-inspection-fallback).
