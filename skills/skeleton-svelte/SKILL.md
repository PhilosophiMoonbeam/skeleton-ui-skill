---
name: skeleton-svelte
description: >-
  Build, style, debug, or migrate Skeleton UI 5 apps in Svelte and SvelteKit.
  Use for Skeleton components, themes, native controls, responsive page composition,
  SSR, and server forms. Includes exact Skeleton 5.0.1, Svelte 5.57.2,
  SvelteKit 3.1.0, and Tailwind CSS 4.3.3 examples. Preserve compatible existing
  Kit 2 apps unless migration is requested. Not for React or unrelated UI work.
compatibility: >-
  Baseline: Skeleton core and Svelte components 5.0.1, Svelte 5.57.2,
  SvelteKit 3.1.0, Tailwind CSS 4.3.3. Kit 3 setup requires its compatible
  Node/Vite/adapter toolchain; existing Kit 2 apps need not migrate.
  Bundled guidance and installed packages support offline inspection;
  dependency installation requires registry or cache access.
metadata:
  version: "2.0"
  skeleton-core: "5.0.1"
  skeleton-svelte: "5.0.1"
  svelte: "5.57.2"
  sveltekit: "3.1.0"
  tailwindcss: "4.3.3"
---

# Skeleton 5 for Svelte

Create coherent UI using Skeleton's theme vocabulary and the application's
visual language. Prefer styled native HTML for simple controls; use a verified
framework component when managed interaction requires it. React is out of scope.

## Version boundary: inspect before using examples

The exact reference baseline is **`@skeletonlabs/skeleton@5.0.1`** (CSS),
**`@skeletonlabs/skeleton-svelte@5.0.1`**, **Svelte `5.57.2`**,
**SvelteKit `3.1.0`**, and **Tailwind CSS `4.3.3`**.

- **Existing app:** inspect resolved versions; preserve its toolchain, adapter,
  conventions, and unrelated work. A UI task does not authorize a migration.
  Skeleton 5 does not require an otherwise compatible Kit 2 app to adopt Kit 3.
- **Different version:** retrieve matching primary documentation/types/source
  for affected APIs. Do not upgrade or downgrade to satisfy a bundled example.
- **Greenfield:** use [setup](references/setup.md) for the exact baseline; inspect
  scaffold output rather than assuming the CLI emits these versions. Honor an
  explicitly requested alternative target. Never force incompatible peers.

## Read only the references needed for the task

Read the relevant sections, not the full reference set.

| Task | Reference and starting section |
| --- | --- |
| Installation or toolchain/CSS integration failure | [Setup](references/setup.md): version contract, existing or greenfield project, targeted diagnosis |
| Explicit Skeleton 2/3/4-to-5 or Kit 3 migration; mixed-major APIs | [Migration](references/migration.md): staged migration, affected configuration and every caller |
| Choose a control; verify exports, props, callbacks, anatomy | [Components](references/components.md): functional inventory, native alternatives, installed-types lookup |
| Implement a functional control; customize providers/elements | [Recipes](references/recipes.md) for complete controls; [Components](references/components.md#six-supported-composition-patterns) for provider/element patterns |
| Theme, tokens, brand presets, native classes, dark mode | [Styling](references/styling.md): theme registration, colors/presets, mode, diagnosis |
| Page composition or visual refinement | [Design](references/design.md): brief, visual system, responsive composition; app-shell recipe when useful |
| Labels, errors, keyboard/focus, contrast, motion | [Accessibility](references/accessibility.md): relevant interaction contract and browser checks |
| Runes, SSR, lifecycle, route/load data, native server forms | [SvelteKit](references/sveltekit.md): selected framework boundary or example |
| Conflicting documentation, offline inspection, evidence | [Sources](references/sources.md): authority hierarchy, primary-source map, verification limits |

For a page refresh, combine **design + styling** and relevant accessibility
checks. Add **components + the selected recipe** for interaction, or **SvelteKit**
for server data/forms. An explicit migration needs **migration + setup** and each
affected control's contract. Do not copy the app shell merely to restyle a page.

## Blind-session workflow

Scale inspection to the request: a card restyle needs its markup, theme/CSS, and
relevant versions; setup or migration needs the full toolchain/configuration.

1. **Inspect and route.** Establish existing-app, greenfield, or migration scope.
   Distinguish manifest ranges from resolved versions. Inspect affected callers;
   read corresponding references. Preserve package manager and lockfile; merge
   configuration rather than replacing unrelated work.
2. **Calibrate the design.** Inspect representative screens, theme tokens, type,
   spacing, and density. Preserve the visual language unless redesign is requested.
   For new compositions, establish hierarchy, primary action, realistic states,
   and narrow/wide layouts before markup.
3. **Implement the verified contract.** Confirm exact declarations for changed
   APIs and source when types omit behavior. Adapt the selected recipe's labels,
   callbacks, anatomy, and rendered tags. Keep mutable state instance-owned.
   Preserve application validation/persistence; local previews do not save data.
4. **Verify affected behavior.** Use the project's authorized check/build workflow.
   For visual work, inspect narrow/wide rendering, contrast, and overflow. Exercise
   relevant keyboard/focus, state, native/enhanced form, and hydration checks from
   [accessibility](references/accessibility.md). Setup or migration also needs a
   production build and representative runtime smoke.
5. **Report evidence.** State checks actually performed and material limits.
   Compilation is not proof of visual quality, accessibility, persistence,
   deployment, or compatibility across an entire peer range.

## Version-specific traps

- **Kit 3 configuration is conditional.** Apply its Vite/TypeScript setup,
  `#lib/*`, and `$app/env` guidance only to Kit 3. Do not turn a Skeleton upgrade
  into an unrequested framework migration.
- **Use current public anatomy.** Callable roots such as `<Tabs>` and `<Dialog>`
  have verified child members; do not invent `.Root`. Tabs uses `.List`,
  `.Trigger`, and `.Content`, not old `.Control`/`.Panel` or list snippets.
  `Dialog`, `Toast`, `QrCode`, `Progress`, `RatingGroup`, and `SegmentedControl`
  are current names. `/composed`, `Modal`, and `Toaster` are obsolete destinations.
- **Props do not imply bindings.** Verified recipe roots use props/callbacks:
  Accordion `value: string[]` / `onValueChange(e.value)`, Switch
  `checked` / `onCheckedChange(e.checked)`. Native inputs support bindings.
  Verify other APIs individually; use `.Context` for an API getter when required.
- **Providers and custom elements have contracts.** Supply a hydration-stable
  `$props.id()` to `useTooltip` and similar factories; pass their API getter to
  `.Provider`, then call methods through the getter. An `element(attributes)`
  snippet replaces markup: spread all supplied attributes onto the real element.
  Do not nest a button inside a trigger that already renders one.
- **CSS is integration, not behavior.** Import Tailwind, Skeleton core, Skeleton
  Svelte CSS, and the chosen theme; activate matching `data-theme` on `<html>`.
  Presets are in core, not `/optional/presets`; framework CSS replaces the old
  Skeleton distribution scan. Retain `@source` for other shared UI when needed.
  Styled native form utilities require `@tailwindcss/forms`. CSS alone does not
  make a dialog modal or a styled disabled control semantically disabled.
- **SSR must isolate users.** Keep mutable user state, dialogs, and toast queues
  per component/layout/request, not a shared server module. Guard browser-only
  work and clean it up. Initial markup and IDs must agree across hydration.
  Never disable app-wide SSR to hide one browser-only import. Preserve native
  POST forms, server validation, and exact raw failed values; enhance only
  supported POST page actions. See [SvelteKit](references/sveltekit.md).

## Evidence hierarchy and offline fallback

Use resolved installed exports/types/source/CSS for the actual API and exact
registry metadata for peers/engines. Current official **`skeleton.dev`** v5 docs
are relevant; archived v4 docs support only the staged migration to v5. Framework
docs must match the requested version. Search, Context7, and supplied Gemini
research are discovery/secondary evidence, not proof against shipped declarations.

Offline, follow [components' installed-types lookup](references/components.md#offline-installed-types-lookup)
through the actual dependency layout. [Sources](references/sources.md) records
primary links, research corrections, and evidence limits. If evidence is missing,
name the unknown contract rather than inventing an API or claiming verification.
