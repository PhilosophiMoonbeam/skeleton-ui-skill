# Migration and version-mixed documentation

## Identify the installed generation first

Inspect the application's manifest **and resolved lockfile**, not just the repository name or docs title. This skill targets core `@skeletonlabs/skeleton@3.2.2` plus `@skeletonlabs/skeleton-svelte@1.5.3`. The [component package metadata](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/1.5.3) explicitly develops against core `3.2.2`; its `1.x` version is not evidence that the application uses Skeleton v1. Select component `1.5.3` from the [published releases](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte), not a version inferred from core's major.

| Signal | Interpretation/action |
| --- | --- |
| Components and store helpers imported from `@skeletonlabs/skeleton` | Likely v2-era code. In this pinned v3 pair, core exports CSS, while components come from `@skeletonlabs/skeleton-svelte`. |
| `initializeStores`, `getModalStore`, `getToastStore`, `getDrawerStore`, `AppShell`, `variant-*`, a Skeleton Tailwind plugin | Inventory legacy features before changing dependencies. They are not a v3 setup recipe. |
| Core `3.2.2`, component package `1.5.3`, Tailwind 4 CSS imports | Correct version family; still inspect component props and the actual import subpath. |
| Core/component `4.x` or `5.x`; unversioned `skeleton.dev` examples | Not this skill's pinned API. Use archived `v3.skeleton.dev` plus exact package declarations. |

Sources: [core CSS exports](https://registry.npmjs.org/@skeletonlabs/skeleton/3.2.2), [v2-to-v3 migration](https://v3.skeleton.dev/docs/get-started/migrate-from-v2), [v2 modal stores](https://v2.skeleton.dev/utilities/modals), [v2 toast stores](https://v2.skeleton.dev/utilities/toasts). A store **name alone** is a search clue; confirm its import and use before removing unrelated application stores.

## Separate framework upgrades from Skeleton migration

Work on a migration branch and preserve existing changes. The archived guide describes a major rewrite, not a prop-compatible update, and explicitly leaves component props and many utility migrations to manual work.

**Skeleton-only migration:** retain a supported existing toolchain. The [archived installation baseline](https://v3.skeleton.dev/docs/get-started/installation/sveltekit) is Kit 2 or later, Svelte 5, and Tailwind 4; the pinned component package requires Svelte `^5.20.0`, and core requires Tailwind `^4.0.0`. Check the installed framework, Vite integration, Node, and adapter peers. These minimums do not require Kit 3, Svelte `5.57.2`, or the other greenfield pins.

1. Inventory legacy imports, root-level providers, Tailwind and PostCSS configuration, theme registration, custom CSS classes, and each affected component callsite.
2. If a prerequisite is missing, migrate only what is required within the requested scope. Use the [Svelte 5 migration guide](https://svelte.dev/docs/svelte/v5-migration-guide) for a Svelte 4 app and the [Tailwind 4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide) for Tailwind 3. Existing legacy Svelte syntax can still work; removed Skeleton APIs cannot.
3. Install core `3.2.2` and components `1.5.3` as in [existing-project setup](setup.md#existing-project); preserve compatible framework and Tailwind/Vite releases. Integrate CSS, themes, and source scanning.
4. Remove the v2 integration described below and migrate every affected component and store caller. Do not change unrelated application state or deployment conventions.

**Optional exact-target migration:** only when the user requests Svelte `5.57.2` / Kit `3.0.1`, apply the [complete target pins](setup.md#version-contract) and [Kit 3 migration guide](https://svelte.dev/docs/kit/migrating-to-sveltekit-3). Coordinate Node, Vite, the Svelte Vite plugin, optional TypeScript, and the existing deployment adapter. Move supported `svelte.config.*` options into `sveltekit({...})`, flattening the old `kit` options, then remove the obsolete file. Merge the [Kit 3 tsconfig](setup.md#typescript-configuration) with existing source paths and compiler options. Add the application's [package-import mapping](setup.md#kit-3-package-imports-and-environment); migrate every `$lib` import/re-export to `#lib` with explicit file extensions and every `$app/environment` caller to `$app/env`. Remove obsolete alias configuration, not just failing imports, and review other changed modules and options in the Kit guide. Do not apply those Kit 3 changes to a retained Kit 2 project.

The archived guide describes `npx skeleton migrate skeleton-3`. Do not blindly run this unpinned historical CLI against a modern project: the guide says it changes dependencies, imports, names, and classes but **does not update component props or most v2 utilities**. Migrate manually to avoid letting a current CLI silently choose newer packages. If using automation, inspect its exact version, help, and resulting diff, then restore the target pins; no CLI invocation substitutes for the manual steps here.

## Remove Tailwind 3 and v2 plugin assumptions

Follow the [archived prerequisites](https://v3.skeleton.dev/docs/get-started/migrate-from-v2#migrate-core-technologies) and [Tailwind 4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide):

- Remove the Skeleton plugin from `tailwind.config.*` and its import from `@skeletonlabs/tw-plugin`; remove that dependency when no callers remain. The [legacy plugin metadata](https://registry.npmjs.org/@skeletonlabs/tw-plugin/0.4.0) identifies this separate package.
- Remove `vite-plugin-tailwind-purgecss` from Vite and dependencies if installed.
- Rename an old `app.postcss` or `app.pcss` global stylesheet to `app.css` and update every import. Replace old Tailwind layer directives with the Tailwind 4 import and the v3 CSS imports in [setup](setup.md#global-css-and-dependency-scanning).
- Add the Tailwind Vite plugin before `sveltekit(...)`. Remove the old Tailwind PostCSS processing path. Delete a PostCSS configuration or its dependencies only if they are now unused; preserve unrelated CSS transforms.
- Move relevant Tailwind configuration to CSS. Tailwind 4 does not automatically detect a JavaScript config; if temporarily retaining necessary non-Skeleton configuration, explicitly load it with `@config` and check the upgrade guide's unsupported options. Do not preserve the old Skeleton plugin this way.
- Replace each legacy `variant-*` class with the documented v3 `preset-*` equivalent rather than mechanically guessing suffixes. Register the optional presets stylesheet when using these classes.
- Replace v2 custom themes with v3 CSS-format themes. The archived migration guide offers a theme-import tool, but verify generated CSS against the pinned v3 variables rather than assuming today's generator emits that version. Import the resulting theme and activate its matching name on `<html>`, not only `<body>`.
- Review `@apply` uses against removed or changed utilities. Prefer documented CSS variables and Tailwind 4 directives over restoring removed classes.

## Remove legacy store wiring and migrate every caller

The v2 [modal](https://v2.skeleton.dev/utilities/modals) and [toast](https://v2.skeleton.dev/utilities/toasts) guides require `initializeStores()` in the root layout and helpers such as `getModalStore()` and `getToastStore()`. The [pinned v3 component index](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/index.d.ts) does not export those functions, and v3 core is CSS-only.

Search both imports and usage sites, including wrappers and shared helpers:

- Remove `initializeStores()` and the legacy Skeleton helper imports **after replacing their callers**; do not just silence import errors.
- Replace old `modalStore.trigger(...)`, `drawerStore.open(...)`, and their global queue hosts with the appropriate v3 integration or application-owned dialog state. The root v3 package exports `Modal` and `Popover`, not a v2-compatible queue store or a `Drawer` export. The [archived popover integration](https://v3.skeleton.dev/docs/integrations/popover/svelte) covers modal, popover, tooltip, and combobox APIs.
- Replace v2 `Toast`/`getToastStore()` wiring with the v3 `Toaster`/`createToaster` API documented on the [archived toast page](https://v3.skeleton.dev/docs/components/toast/svelte). Do not rename a store variable and assume its method signatures survived.
- Replace `AppShell` with semantic HTML and Tailwind layouts. Replace a v2 component `Table` with the documented styled HTML table rather than looking for a root `Table` export.
- Remove leftover obsolete imports, hosts, type aliases, dependencies, and wrapper functions once all callers have migrated. Do not add compatibility shims to this skill's examples.

Skeleton's removal of its persisted-store utility does **not** mean Svelte's `svelte/store` is unsupported; do not remove unrelated application stores. The [archived unsupported-features list](https://v3.skeleton.dev/docs/get-started/migrate-from-v2#replace-unsupported-features) is the authority for those Skeleton utilities.

## Components are not a rename-only migration

Selected mappings from the [official archived component migration table](https://v3.skeleton.dev/docs/get-started/migrate-from-v2#migrating-components):

| v2 | v3 | Required review |
| --- | --- | --- |
| `RangeSlider` | `Slider` | Array-valued `value`, callback payload, markers, accessibility |
| `SlideToggle` | `Switch` | Checked state and change callbacks |
| `TabGroup` | `Tabs` | Root/item composition and snippets |
| `InputChip` | `TagsInput` | Values, input behavior, callbacks |
| `FileButton`, `FileDropzone` | `FileUpload` | Combined upload behavior and props |
| `ProgressBar`, `ProgressRadial` | `Progress`, `ProgressRing` | Value/indeterminate semantics and style props |
| `AppRail` | `Navigation` | Changed navigation composition |

For example, the archived guide changes a bound scalar `RangeSlider` value into a `$state([15])` array passed to `Slider`, with `onValueChange={(e) => (value = e.value)}`. Read the target component's declarations before translating event names or accessing `.detail`: v3 callbacks are not automatically Svelte-dispatched events. Preserve labels, keyboard behavior, state ownership, and domain logic while changing UI contracts.

## Avoid v4/v5 compound-API traps

The root [v3 exports](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/index.d.ts) are the offline catalog. They include `Avatar`, `Accordion`, `Tabs`, `Navigation`, `Modal`, `Toaster`, and `createToaster`; they do **not** export `Portal`, `useListCollection`, `Dialog`, `Select`, `Checkbox`, `Clipboard`, or `PinInput`. Do not infer v3 support from a current component catalog or install Skeleton 5 just to make a copied example compile.

**v3 itself has some compound APIs**. Its root Accordion supports `Accordion.Item`, and its separate `@skeletonlabs/skeleton-svelte/composed` export contains experimental Accordion and Avatar APIs. The [composed export index](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/composed/index.d.ts) exposes only those two families, and the [archived composed Avatar page](https://v3.skeleton.dev/docs/components-composed/avatar/svelte) explicitly warns that this alpha API is not intended for production.

Consequently, `Avatar.Image` or `Avatar.Fallback` does not by itself prove a snippet is v5: check the **import subpath**. Root v3 `Avatar` is a single component, whereas `/composed` has a different API. Never blend root props or snippets with composed or current-doc child components. Prefer the supported root API unless the user explicitly requests the v3 alpha path.

Treat current `skeleton.dev` documentation and version-ambiguous Context7 results as discovery leads, not v3 authority. A result containing `Portal`, `useListCollection`, or an unavailable export should trigger an installed-types comparison. Do not claim every component in later documentation belongs to v3, or that all dotted component names are later-version-only.

## Offline inspection fallback

When web research is unavailable or mixes versions:

1. Read the resolved versions from the workspace lockfile and installed packages' `package.json`. Distinguish a manifest range from the version actually installed.
2. Locate `@skeletonlabs/skeleton-svelte` through the app's actual dependency directory or symlink. Read `dist/index.d.ts` for root exports and `dist/composed/index.d.ts` only if that subpath is being used. The package's `exports` map identifies the public entrypoints; do not infer public imports from arbitrary internal files.
3. Follow the declaration's relative path to the component `.svelte.d.ts` and its `types.d.ts` or `types.js` target. Read required props, snippet signatures, callback payloads, and whether the exported value has child components. Inspect the paired `.svelte` source for details declarations cannot explain.
4. Read core `dist/index.css`, `dist/optional/presets.css`, and the chosen `dist/themes/*.css` to identify real classes and CSS variables; keep theme activation separate from import registration.
5. Use these references' known v3 patterns. If no matching public export exists, choose a documented styled HTML element, an application-owned implementation, or an explicitly approved dependency; do not invent a missing component or prop.

For online confirmation, use version-qualified metadata, for example `npm view @skeletonlabs/skeleton-svelte@1.5.3 peerDependencies exports --json`, or read its [exact registry document](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/1.5.3). Do not replace an offline inspection with an unpinned package install.

## Diagnose the failing layer

| Failure | Targeted next step |
| --- | --- |
| `initializeStores` or `get*Store` is not exported | Finish the v2 store migration; no store-initialization workaround exists in this pinned core CSS package. |
| `Avatar.Image` missing from root import | Check root versus alpha `/composed` APIs; use supported root Avatar props instead of copying newer docs. |
| `Portal`, `Dialog`, `useListCollection` import failure | Compare `dist/index.d.ts`; rewrite for the available v3 integration/API, not a newer package version. |
| `value`/callback type error after rename | Compare component declarations and archived examples; preserve the new value shape and read callback payload directly. |
| Theme/preset utilities disappeared | Fix v3 CSS imports, active theme, class names, and component source scan; don't re-enable the Tailwind 3 Skeleton plugin. |
| Kit fails before rendering | Inspect the installed Kit generation, configuration, modules, adapter, and peers. Use [setup](setup.md) for an approved Kit 3 migration; do not force that upgrade or blame the Skeleton API. |
| Styling vanishes only in monorepo builds | Resolve `@source` relative to the actual stylesheet and check Tailwind's scan base path. |

After migration, the integrating agent should run existing checks and the build, then verify real component interactions, overlays, keyboard behavior, focus behavior, and themed styling. Report only exercised checks. API consistency, type consistency, and published peers are evidence, not a substitute for runtime verification.
