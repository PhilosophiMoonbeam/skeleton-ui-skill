---
name: skeleton-svelte
description: >-
  Build, style, debug, or migrate Skeleton UI v3 apps in Svelte and SvelteKit.
  Use for Skeleton components, themes, and polished responsive page composition.
  Includes version-pinned Svelte 5.57.2 / SvelteKit 3.0.1 examples. Not for React
  or UI work unrelated to Skeleton.
compatibility: >-
  Reference: Skeleton core 3.2.2, Svelte components 1.5.3, Svelte 5.57.2,
  SvelteKit 3.0.1, Tailwind CSS 4.3.3. Kit 3 needs a compatible Node/Vite/adapter
  toolchain; see references/setup.md. Bundled guidance and installed packages
  support offline work; dependency installation needs registry or cache access.
metadata:
  version: "1.1"
  skeleton-core: "3.2.2"
  skeleton-svelte: "1.5.3"
  svelte: "5.57.2"
  sveltekit: "3.0.1"
---

# Skeleton v3 for Svelte

Create coherent, attractive UI using Skeleton's theme vocabulary and the
application's visual language. Prefer styled native HTML for simple controls;
use a verified functional component for managed interaction.

## Version boundary: inspect before using examples

The frozen pair is **`@skeletonlabs/skeleton@3.2.2`** (CSS) and
**`@skeletonlabs/skeleton-svelte@1.5.3`** (Svelte components). Their version
numbers are independent; Skeleton v3 does not mean component-package `@3`.
The framework target is **Svelte `5.57.2` and SvelteKit `3.0.1`**.

- **Existing app:** inspect resolved versions; preserve its toolchain, adapter,
  conventions, and unrelated work. A UI task does not authorize a migration.
- **Different version:** retrieve matching primary documentation/types/source
  for affected APIs. Do not upgrade or downgrade to satisfy a bundled example.
- **Greenfield:** use [setup](references/setup.md) for the frozen target; inspect
  scaffold output rather than assuming the current CLI emits those versions.
  Honor an explicitly requested alternative target. Never force incompatible peers.

## Read only the references needed for the task

Read the relevant sections, not the full reference set. Longer resources have
section links for targeted reads.

| Task | Reference and starting section |
| --- | --- |
| Installation or toolchain/CSS integration failure | [Setup](references/setup.md): version contract, existing or greenfield project, targeted diagnosis |
| Explicit v2/Tailwind 3/Kit 3 migration; mixed-major APIs | [Migration](references/migration.md): affected configuration and every caller |
| Choose a control; verify exports, props, callbacks, snippets | [Components](references/components.md): functional inventory, native alternatives, installed-types lookup |
| Implement a functional control | [Recipes](references/recipes.md): shared state contract and the selected example |
| Theme, tokens, presets, native classes, dark mode | [Styling](references/styling.md): theme registration, colors/presets, mode, diagnosis |
| Page composition or visual refinement | [Design](references/design.md): brief, visual system, responsive composition; app-shell recipe when useful |
| Labels, errors, keyboard/focus, contrast, motion | [Accessibility](references/accessibility.md): relevant interaction contract and browser checks |
| Runes, SSR, lifecycle, route/load data, server forms | [SvelteKit](references/sveltekit.md): selected framework boundary or example |
| Conflicting documentation, offline inspection, evidence | [Sources](references/sources.md): primary-source map, package inspection, verification limits |

For a page or visual refresh, combine **design + styling** and the relevant
accessibility checks. Add **components + the selected recipe** for interaction,
or **SvelteKit** for server data/forms. An explicit migration needs **migration +
setup** and each affected control's contract. Do not copy the app-shell example
into an existing page merely to change its appearance.

## Blind-session workflow

Scale the work to the request: a card restyle needs its markup, theme/CSS, and
relevant versions; setup or migration needs the full toolchain/configuration.

1. **Inspect and route.** Establish existing-app, greenfield, or migration scope.
   Distinguish manifest ranges from resolved versions. Inspect affected files and
   callers; read the corresponding references. Preserve the package manager and
   lockfile; merge configuration changes rather than replacing whole files.
2. **Calibrate the design.** For visual work, inspect representative screens,
   theme tokens, type, spacing, and density. Preserve the existing language unless
   redesign is requested. For a new composition, establish a brief, hierarchy,
   primary action, realistic states, and narrow/wide layout before markup.
3. **Implement the verified contract.** Use public APIs and instance-owned state.
   When introducing or changing a library API, confirm its exact declarations;
   inspect source when types omit behavior or conflict with examples. Adapt the
   selected recipe, including labels, callbacks, snippets, and rendered tags.
   Preserve application validation/persistence; local examples are not saved data.
   See [SvelteKit](references/sveltekit.md) for runes, SSR, and server forms.
4. **Verify affected behavior.** Run the project's relevant check/build scripts
   when application code or configuration changes. For visual work, inspect
   narrow/wide screenshots and refine hierarchy, spacing, contrast, and overflow.
   For interaction, exercise the relevant keyboard/focus, state, form, and
   hydration checks from [accessibility](references/accessibility.md). Setup or
   migration also needs a production build and representative runtime smoke.
5. **Report evidence.** State what changed and the checks actually performed.
   Identify unavailable checks and material limits; do not equate compilation
   with visual quality, accessibility, persistence, or deployment proof.

## Version-specific traps

- **Kit 3 configuration is conditional.** It changes Vite/TypeScript setup and
  uses `#lib/*` and `$app/env`; apply the Kit 3 instructions in
  [setup](references/setup.md) and [migration](references/migration.md) only to Kit 3.
  Archive minimums and peers do not certify every later framework version.
- **Root exports differ from later majors.** Use `Modal` for dialogs/drawers and
  `Toaster`/`createToaster` for notifications. Root `Dialog`, `Drawer`, `Toast`,
  `Portal`, and `useListCollection` do not exist. Root `Avatar` is flat;
  `/composed` is a separate alpha API. Consult [components](references/components.md)
  for the actual native alternatives and supported dot members.
- **Props do not imply bindings.** The recipe controls in package `1.5.3` use
  controlled props and callbacks, not `bind:value`/`bind:checked`/`bind:open`.
  Callback payloads differ; native inputs support bindings. Verify other exports
  individually. A snippet trigger may already render a button; avoid nesting one.
- **CSS is integration, not behavior.** Import core, the chosen theme, and
  optional presets when used; activate the imported theme on `<html>` and scan
  the actual component distribution. Styled native forms require
  `@tailwindcss/forms`. Use v3 tokens/presets, not v2 plugin/`variant-*` wiring.
- **SSR must isolate users.** Keep mutable user state per component/layout/request,
  guard browser-only work, and clean it up. Server and initial client markup must
  agree. Do not disable app-wide SSR to hide a browser-only import. Reusable field
  associations need hydration-stable instance IDs; see
  [SvelteKit](references/sveltekit.md) for forms, load data, and lifecycle details.

## Evidence hierarchy and offline fallback

Use resolved installed exports/types/source/CSS for the actual API and exact
registry metadata for peers/engines. Consult archived **`v3.skeleton.dev`** for
Skeleton v3 intent and official framework docs for the requested version.

Current `skeleton.dev` and Context7 results are discovery leads, not v3 proof;
even a v3-labeled index can return newer-major material. Compare affected APIs
against exact packages before copying code.

Offline, follow [components' installed-types lookup](references/components.md#offline-installed-types-lookup)
through the actual dependency layout. [Sources](references/sources.md) records
primary links and verification limits. If evidence is missing, identify the
unknown contract rather than inventing an API or claiming verification.
