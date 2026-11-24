# Upgrade Skeleton in place

Use this reference only when the intent is to **keep Skeleton** and change its version. Compatible Skeleton widgets, providers and themes can stay as they are; see [Skeleton UI](skeleton.md) for maintenance. If the intent is to replace a widget with native HTML or Bits UI, follow the [interaction-library migration](migration.md#replace-wrappers-by-intent) instead. Adopting this skill requires neither migration, and the two migrations are independent.

- [Identify the installed generation](#identify-the-installed-generation)
- [Stage an authorized upgrade](#stage-an-authorized-upgrade)
- [Choose the right CLI stage](#choose-the-right-cli-stage)
- [Remove Tailwind 3 assumptions](#remove-tailwind-3-assumptions)
- [Migrate stores and compound widgets](#migrate-stores-and-compound-widgets)
- [Convert v4 themes and utilities](#convert-v4-themes-and-utilities)
- [Inspect exact packages and diagnose gaps](#inspect-exact-packages-and-diagnose-gaps)

## Identify the installed generation

Read the consuming app's manifest, **resolved lockfile** and installed packages. An import from a wrapper can hide an older API; trace it to its source. Inventory callers, re-exports, hosts/providers, themes, literal and generated classes, CSS processing, shared UI packages, stories and tests before removing anything.

| Resolved version or historical clue | Route |
| --- | --- |
| Core `2.x`; `@skeletonlabs/tw-plugin`, `variant-*`, `AppShell`, `initializeStores` or `get*Store` | Historical v2: use the archived v2 path through v3 and v4. Confirm a store's actual import before removing it. |
| Core `3.x` plus Svelte components `1.x` | Historical v3 pair: unequal majors were intentional. Use the archived v3 → v4 path. |
| Core and Svelte components `4.x` | Establish a working pair at `4.15.2`, then move to v5. |
| Core and Svelte components `5.0.6` | Reference destination. No migration CLI needed. Compare actual wrappers and styles with the exact exports before changing them. |

The [4.15.2 component package](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/4.15.2) requires Svelte `^5.29.0`; [5.0.6 components](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/5.0.6) require `^5.40.0`, and [5.0.6 core](https://registry.npmjs.org/@skeletonlabs/skeleton/5.0.6) requires Tailwind `^4.0.0`. Neither package requires Kit. Keep a compatible existing Svelte/framework/Vite/adapter setup and preserve the project's package manager. The local [Kit-specific guidance](sveltekit.md) targets Kit `>=3.1.0`, where the reference `3.4.0` release requires Svelte `^5.57.1`. That guidance's floor is not a Skeleton requirement. If Svelte or Tailwind must change majors, or the app intends to move to the Kit 3 baseline, [scope those prerequisites](migration.md#separate-framework-prerequisites) rather than silently folding them into a component upgrade.

## Stage an authorized upgrade

Use a dedicated branch or isolated migration copy and preserve existing user changes. Confirm that the original app works; decide which package and framework changes are required, not just which versions are newest.

1. **From v2:** The [archived v2 → v4 guide](https://v4.skeleton.dev/docs/svelte/get-started/migrate-from-v2) describes the legacy Kit source. Prepare Svelte 5 and Tailwind 4, including [old Tailwind cleanup](#remove-tailwind-3-assumptions), then apply the `skeleton-3` and `skeleton-4` changes in order. Its Kit 2 step is historical: use [Kit 2's upgrade guide](https://svelte.dev/docs/kit/migrating-to-sveltekit-2) only if needed for that older source, not as a reason to downgrade a working newer app or install Kit in a standalone app.
2. **From v3:** Use the [archived v3 → v4 guide](https://v4.skeleton.dev/docs/svelte/get-started/migrate-from-v3) and apply the `skeleton-4` changes. If the migration needs a reproducible final v3 starting point, the published stable pair is [core `3.2.2`](https://registry.npmjs.org/@skeletonlabs/skeleton/3.2.2) with [Svelte components `1.5.3`](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/1.5.3); an app already functional on a compatible v3 pair need not be updated for its own sake. Review imports, styles and component markup; establish a functional v4 app, not just a changed manifest.
3. **Intermediate v4:** Pin both [core](https://registry.npmjs.org/@skeletonlabs/skeleton/4.15.2) and [Svelte components](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/4.15.2) to `4.15.2`. The archived `@latest` or release-candidate commands do not reproduce this stage. For a Bun app declaring both as dev dependencies:

   ```sh
   bun add --dev --exact @skeletonlabs/skeleton@4.15.2 @skeletonlabs/skeleton-svelte@4.15.2
   ```

   At this checkpoint, restore any custom theme import displaced by the v2 migration and use v4-compatible theme CSS. Keep the original theme and fonts for reviewing the final conversion; do not assume a converter that emits v5 tokens also produces v4-compatible output.

4. **From working v4.15.2:** Follow the [v4 → v5 guide](https://www.skeleton.dev/docs/svelte/get-started/migrate-from-v4.md). Manually resolve the Svelte peer against the full app toolchain; the Skeleton CLI does not bump it. Use the exact `5.0.6` pair and current CSS from [Skeleton UI](skeleton.md#add-styled-skeleton-components), and finish the [theme and utility cutover](#convert-v4-themes-and-utilities). Preserve the dependency section and package manager appropriate to the consuming app, review the lockfile, and do not force peers or upgrade unrelated packages.

## Choose the right CLI stage

Automation is optional. For the Bun commands below, verify that the owning app/workspace has `bun.lock`, that any `packageManager` declaration matches the Bun baseline (`bun@1.4.5`), and that parent/workspace lockfiles or `devEngines.packageManager` do not select a different installer. Review `prepare` and other install hooks: `--bun` forces the **CLI runtime**, not the install command or the runtime of child scripts. For example, use `bun --bun svelte-kit sync` for a compatible Kit app's sync hook instead of relying on a Node shebang. If project ownership or lifecycle compatibility is ambiguous, do not run the Bun mutator or switch package managers implicitly; use the manual route with the existing toolchain or separately scope the prerequisite.

Run each required stage separately from the app directory (or pass `--cwd <app-directory>` **after** the migration name). Do not run all three just because the commands are listed:

| Starting generation | Pinned invocation | Actual automation in CLI `5.0.6` |
| --- | --- | --- |
| v2 | `bunx --bun skeleton@5.0.6 migrate skeleton-3` | Requires `package.json`, `src/app.html`, `src/app.css`. Transforms eligible old package entries, the app template and CSS, and selected imports, names and classes. Queries core `>=3.0.0-0 <4.0.0` and components `>=1.0.0-0 <2.0.0`, then writes caret ranges for applicable entries. Review theme relocation, preset/name fallback and custom import markers before proceeding. |
| v3 (including the v2 route after `skeleton-3`) | `bunx --bun skeleton@5.0.6 migrate skeleton-4` | Updates eligible Skeleton entries to `^4.0.0`, converts old Skeleton `@source` directives to stylesheet imports, drops the optional presets import and renames selected imports/identifiers. It does not create the new compound anatomy or supply layout/other props. |
| Working v4.15.2 | `bunx --bun skeleton@5.0.6 migrate skeleton-5` | Updates eligible Skeleton entries to `^5.0.0`, transforms supported theme CSS tokens and class usages, and reports selected manual steps. It does not migrate widget APIs, upgrade Svelte or repair semantic Field Group markup. |

The [published CLI identity](https://registry.npmjs.org/skeleton/5.0.6) and its [shipped implementation](https://unpkg.com/skeleton@5.0.6/dist/index.mjs) establish the commands, not the resulting dependency versions. All three mutate and then run an install. The CLI uses [package-manager detection](https://unpkg.com/package-manager-detector@1.9.0/dist/detect.mjs) from its target directory and falls back to npm if it detects none. There is no Skeleton `--dry-run`, `--no-install` or installer override in `5.0.6`; the Kit CLI's flags do not transfer. Review diffs, restore the intended exact pins and update the lockfile at each applicable stage. Use the manual route if you cannot let it install or if the app does not match its file-layout assumptions.

Each stage prompts for top-level source folders (initially all offered folders) and scans beneath the selection, excluding `node_modules`. `skeleton-3` and `skeleton-4` scan `.svelte`, `.js`, `.mjs`, `.ts`, `.mts`, `.css`, `.pcss` and `.postcss` (v3 separately processes `src/app.css` and `src/app.html`). `skeleton-5` scans `.svelte`, `.css`, `.pcss`, `.postcss`, `.jsx`, `.tsx`, `.js`, `.mjs` and `.cjs`; it **omits `.ts` and `.html`**. Even in a scanned `.svelte` file, the v5 transform walks markup and styles, not script-side class maps; JS-family handling targets JSX class attributes, not arbitrary computed classes. Inspect root-level files, omitted extensions, project-specific re-exports, generated class strings, unselected/shared directories and any parse warnings manually. CLI help or dependency detection is not evidence of a completed migration.

## Remove Tailwind 3 assumptions

- Remove the old Skeleton plugin from `tailwind.config.*` and the `@skeletonlabs/tw-plugin` dependency once its callers are gone. Remove `vite-plugin-tailwind-purgecss` if present. Rename historical `app.postcss`/`app.pcss` to `app.css` where appropriate and update every importer; `skeleton-3` specifically expects `src/app.css`.
- Follow the [Tailwind 4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide). Replace old `@tailwind` directives with the [current CSS imports](skeleton.md#add-styled-skeleton-components): Tailwind, core, framework CSS, then theme. Presets are in core; the public framework CSS replaces manual Skeleton `dist` scanning, **not** explicit application `@source` paths for shared UI. Keep imports grouped before plugins/application rules and keep `@source` paths relative to the stylesheet.
- Prepend the Tailwind Vite plugin to the framework plugins. Remove redundant Tailwind PostCSS processing; retain unrelated PostCSS transforms and delete the configuration or packages only if unused. Prefer CSS-first configuration. If temporarily retaining non-Skeleton JavaScript config, load it with `@config` and review Tailwind 4's unsupported options; do not use it to restore the old Skeleton plugin.
- Audit `@apply`, theme overrides and generated classes. If an obsolete `@apply` blocks automated Tailwind migration, inventory the affected rules and translate them to supported utilities or explicit CSS properties before restoring the styling. Map `variant-*` and historical color-pairing tokens using the archived guide and current presets; do not guess a suffix. Install `@tailwindcss/forms` only for Skeleton's styled native fields as shown in [setup](setup.md#global-css-and-dependency-scanning).

## Migrate stores and compound widgets

Historical v2 `initializeStores()`, `getModalStore()`, `getDrawerStore()` and `getToastStore()` came from the old `@skeletonlabs/skeleton` JavaScript API, not today's CSS package. There is no v5 compatibility API. Migrate each producer, payload and host, not only imports. Preserve app-owned `svelte/store` state where it still serves a purpose; a legacy persisted-store helper is not a runes persistence API. Preserve preference keys and serialization explicitly, and access browser storage only in a browser-safe path. Keep per-user queues and UI state scoped to their component/layout/request, never mutable SSR singletons.

| Historical source | Destination and review |
| --- | --- |
| `Modal`, modal/drawer helpers and global hosts | Use [Skeleton Dialog](https://www.skeleton.dev/docs/svelte/framework-components/dialog.md) (or native dialog where sufficient). A drawer is placement of an overlay if modal, not a queue API; persistent navigation isn't a modal. Preserve title, dismissal, focus containment/return and async failure behavior. |
| Old toast store/host or v3 `Toaster` | Use public `createToaster` and one `Toast.Group` per instance; use `Toast` parts for entries. Translate queue timing, action, dismissal and payloads. Keep essential feedback in the page. Do not reintroduce an old `Toaster` compatibility wrapper. |
| `AppShell`, `AppRail`, `Navigation.Bar` / `Navigation.Rail`, historical `Table` | Use semantic responsive layout and a native table with styling. For an existing Skeleton navigation pattern, 5.0.6 exports callable `Navigation` with `layout="bar"`, `layout="rail"` or `layout="sidebar"`, not `Navigation.Bar` / `Navigation.Rail`. Preserve real links, landmarks and active-route semantics. |
| `RangeSlider`, `SlideToggle` | Use `Slider` (`value: number[]`, `onValueChange`, `event.value`, labels and markers) and `Switch` (`checked`, `onCheckedChange`, `event.checked`, control/thumb/label/hidden input). Do not confuse the old slide toggle with today's slider. |
| `TabGroup` or old Tabs snippets | Use callable `Tabs` with `.List`, `.Trigger`, `.Content`, optional `.Indicator`. `.Control` and `.Panel` are not its current parts. Tabs switch panels, not routes. |
| `InputChip`, `Autocomplete`, `FileButton` / `FileDropzone` | Compare `TagsInput`, `Combobox` and `FileUpload` respectively. Preserve keyboard picking, value shapes and file validation; UI selection is not server upload. |
| `Paginator`, `ProgressBar`, `ProgressRadial` / `ProgressRing` | Use `Pagination` or `Progress` as appropriate. Preserve active links and boundaries, determinate versus indeterminate behavior, and linear versus circular anatomy. |
| `Ratings`, `RadioGroup` / `Segment`, historical multi-step controls | Compare `RatingGroup`, `SegmentedControl`, native radio inputs and `Steps` by intent, not as automatic renames. Keep validation and application navigation separate from display. |
| Historical QR integration | 5.0.6 exports `QrCode`, including `Frame`, `Pattern`, `Overlay` and `DownloadTrigger`. Check the encoded destination and retain a readable link. It is a new v5 export, not a v4 intermediate API. |
| Legacy popup/action or removed utility | Replace with the documented menu, popover, tooltip or modal that matches the behavior. For other removed v2 helpers (clipboard, SVG filters, code blocks, table of contents and mode controls), inventory callers and use the app's native or application-owned implementation; the CLI does not migrate these. See the [archived removal list](https://v4.skeleton.dev/docs/svelte/get-started/migrate-from-v2#replace-unsupported-features). |

Most simple-to-compound conversions belong to **v2/v3 → v4**, not a new v5-wide rename. Check each used part against the exact destination declarations; [v4.15.2](https://unpkg.com/@skeletonlabs/skeleton-svelte@4.15.2/dist/index.d.ts) and [v5.0.6](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.d.ts) have distinct export surfaces (e.g. v5 adds `Marquee`, `QrCode` and `LocaleProvider`). In v5, import `Avatar`, `Accordion`, `Switch` or `Tabs` from `@skeletonlabs/skeleton-svelte`; they are callable roots, not Bits `.Root` objects. There is no public `/composed` entrypoint. Move historical `Avatar` source/alt props into `Avatar.Image`; supply `Avatar.Fallback` explicitly instead of relying on automatic initials from a `name` prop.

Use the actual value and event shapes: `Accordion` takes `value: string[]` and `onValueChange`, reading `event.value`; do not assume `bind:` or DOM-style `.detail`. Keep stable IDs with `$props.id()`, spread supplied attributes in Skeleton `element` snippets, and honor hidden state when adding transitions. See [local Skeleton recipes](skeleton-recipes.md) for worked Svelte compositions and [the behavior checklist](migration.md#behavior-equivalence-checklist) for migration acceptance. Exercise each old caller's equivalent state, keyboard/focus, forms, SSR and theming before removing its obsolete initialization, hosts, helpers, aliases or CSS.

## Convert v4 themes and utilities

Built-in themes ship in the exact core package; preserve the existing one when it is available, rather than switching themes to fix a migration. Convert custom themes with the [Theme Generator importer](https://themes.skeleton.dev/themes/import) or update the CSS locally using the mappings below. The importer strips custom fonts; restore typography settings and retain local font assets and loading. Review palette and contrast in both modes (built-in palettes use OKLCH, but custom colors need not be rewritten to OKLCH). Register the theme with a CSS import and activate the **same name** on `<html data-theme>`; for Kit, keep the existing template attributes, placeholders and body wrapper. Theme activation and light/dark mode are [separate concerns](styling.md).

| v4 CSS token | v5 CSS token/replacement |
| --- | --- |
| `--base-font-family`, `--base-font-size` | `--typo-base--font-family`, `--typo-base--font-size` |
| `--base-font-color`, `--base-font-color-dark` | `--typo-base--color-light`, `--typo-base--color-dark` |
| `--base-line-height`, `--base-font-weight`, `--base-font-style`, `--base-letter-spacing` | `--typo-base--line-height`, `--typo-base--font-weight`, `--typo-base--font-style`, `--typo-base--letter-spacing` |
| `--heading-font-family`, `--heading-font-weight`, `--heading-font-style`, `--heading-letter-spacing` | `--typo-heading--font-family`, `--typo-heading--font-weight`, `--typo-heading--font-style`, `--typo-heading--letter-spacing` |
| `--heading-font-color`, `--heading-font-color-dark` | `--typo-heading--color-light`, `--typo-heading--color-dark` |
| `--anchor-font-family`, `--anchor-font-size` | `--typo-anchor--font-family`, `--typo-anchor--font-size` |
| `--anchor-font-color`, `--anchor-font-color-dark` | `--typo-anchor--color-light`, `--typo-anchor--color-dark` |
| `--anchor-line-height`, `--anchor-font-weight`, `--anchor-font-style`, `--anchor-letter-spacing` | `--typo-anchor--line-height`, `--typo-anchor--font-weight`, `--typo-anchor--font-style`, `--typo-anchor--letter-spacing` |
| `--anchor-text-decoration` | `--typo-anchor--text-decoration-line` |
| `--anchor-text-decoration-hover`, `--anchor-text-decoration-active`, `--anchor-text-decoration-focus` | `--typo-anchor--hover--text-decoration-line`, `--typo-anchor--active--text-decoration-line`, `--typo-anchor--focus--text-decoration-line` |
| `--body-background-color`, `--body-background-color-dark` | `--color-root-bg-light`, `--color-root-bg-dark` |
| `--heading-font-size`, `--heading-line-height` | Removed; use the typographic scale. |
| `--default-divide-width` | Removed; division derives from `--default-border-width`. |

Check theme overrides and token references, not just their definitions. New typography controls include stretch, kerning, text shadow, word spacing, hyphens and text transform; anchor decoration adds color, style, thickness, underline offset and underline position for default, hover, active and focus. Review the [exact preset CSS](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/src/themes/cerberus.css) instead of copying assumptions about defaults from the converter. Preserve visible focus outlines (`--default-outline-width`) and review `--corner-shape-base`/`--corner-shape-container` if using custom corners.

The new accent tokens are `--color-brand-light`, `--color-brand-dark`, `--color-brand-contrast-light` and `--color-brand-contrast-dark`, with `preset-filled-brand`, `preset-tonal-brand` and `preset-outlined-brand`. Brand now defaults for checkboxes, radios, circular progress, steps, switches, tabs and accordions. Most built-ins use `primary-500`; `nouveau` differs by mode. Set accent and contrast as a pair and check light and dark rendered controls; token names do not guarantee contrast.

Utility class names migrate independently of CSS tokens:

| v4 utility | v5 utility or action |
| --- | --- |
| `base-font-family`, `base-font-size`, `base-line-height`, `base-letter-spacing` | `font-typo-base`, `text-typo-base`, `leading-typo-base`, `tracking-typo-base` |
| `base-font-color`, `base-font-color-dark` | `text-typo-base-light`, `text-typo-base-dark` |
| `heading-font-family`, `heading-letter-spacing` | `font-typo-heading`, `tracking-typo-heading` |
| `heading-font-color`, `heading-font-color-dark` | `text-typo-heading-light`, `text-typo-heading-dark` |
| `anchor-font-family`, `anchor-font-size`, `anchor-line-height`, `anchor-letter-spacing` | `font-typo-anchor`, `text-typo-anchor`, `leading-typo-anchor`, `tracking-typo-anchor` |
| `anchor-font-color`, `anchor-font-color-dark` | `text-typo-anchor-light`, `text-typo-anchor-dark` |
| `body-background-color`, `body-background-color-dark` | `bg-root-bg-light`, `bg-root-bg-dark` |
| `heading-font-size`, `heading-line-height` | Choose semantic heading scale or current `text-*` / `leading-*` utilities. |
| `base-font-weight`, `heading-font-weight`, `anchor-font-weight` | Choose a `font-*` weight or consume the matching typography token. |
| `base-font-style`, `heading-font-style`, `anchor-font-style` | Use `italic` / `not-italic`, or consume the matching typography token. |
| `anchor-text-decoration` and its `-hover` / `-active` / `-focus` forms | Use explicit decoration utilities with state variants or the corresponding anchor tokens. |
| `code` | Remove the utility class, keep semantic `<code>`; core styles the native element. Add app styles only when needed. |
| `card-hover` | Use `card` on an actual link or button for automatic hover styling; keep non-interactive cards non-interactive. |
| `@variant theme-[name]`, `theme-name:` class variants | Removed. Scope ordinary CSS to `[data-theme='name']` or its descendants. Keep unrelated variants such as `dark:`. |
| `input-group`, `ig-cell`, `ig-input`, `ig-select`, `ig-btn` | `field-group`, `label label-text`, `input`, `select`, `btn`. Rebuild the actual markup, not only the classes. For still older `input-group-shim`/`input-group-divider`, use the archived Input Group stage first. |

Use the optional `--spacing-elem-{size}` scale with `size-elem-*`, `w-elem-*`, `h-elem-*`, spacing utilities, `btn-{size}` and `field-{size}` (`xs`, `sm`, `base`, `lg`, `xl`, `2xl`–`9xl`). Keep working `btn-sm`/`btn-base`/`btn-lg`. Inspect the resulting size before removing explicit icon sizing; Skeleton automatically sizes certain SVG children of buttons, badges, chips and disclosures, not every icon or wrapper.

### Exercise a converted Field Group

After loading [Skeleton styles](skeleton.md#add-styled-skeleton-components) and the optional forms plugin for these native field classes, save this as `MigrationFieldGroup.svelte` and mount it on an existing page (or use the [example mount instructions](../examples/README.md)). It illustrates the markup conversion, not persistence or a submit flow. The two grid tracks match the two children; the visible label names the whole input, not only a URL prefix.

```svelte
<script>
  const id = $props.id();
</script>

<div class="field-group grid-cols-[auto_1fr]">
  <label class="label label-text preset-tonal" for={id}>Website URL</label>
  <input class="input" id={id} name="website" type="url" />
</div>
```

Mount it twice and click each label: only its associated input should receive focus. Tab through both, and check readability and focus in both themes/modes and at narrow widths. In a real form, keep the field's existing name, validation and submission behavior.

## Inspect exact packages and diagnose gaps

When docs are unavailable or mix versions, resolve the actual dependency directory used by the consuming workspace (follow symlinks). Read `package.json` and its public `exports`, then follow `dist/index.d.ts` and its relative declarations to each required prop, callback, child or snippet. Inspect implementation if types do not establish behavior. Do not install an unpinned version just for inspection, and do not import internals.

At `5.0.6`, core ships [`src/index.css`](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/src/index.css) and `src/themes/*.css`; presets come through core. The Svelte framework ships [`dist/index.css`](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.css) and public root declarations. Those paths identify files to inspect, not specifiers to paste into application imports. Core does not provide widget JS. Do not resurrect old core `dist` CSS, optional presets or `/composed` subpaths.

| Symptom | Next step |
| --- | --- |
| Legacy store or initialization import fails | Find the original producer and host and migrate both. There is no CSS-core initialization workaround. |
| Compound child or prop missing; callback or value type differs | Check exact root/part declarations and event payloads, not a historical example or forced type cast. If no suitable export exists, use native HTML or application-owned behavior. |
| No theme/presets, or widget styles missing | Verify core and framework imports, the theme name on `<html>` and the utility spelling. If shared application classes disappear, check stylesheet-relative source paths and the Tailwind scan base. |
| CLI did not change a token, utility or import | Review selected folders, omitted extensions and literals versus dynamic code; then complete the relevant manual step. |
| Kit fails before components render | Inspect its resolved dependencies, config and deployment adapter separately. Apply framework changes only when scoped; do not mask a hydration or request-isolation error with `ssr: false`. |
