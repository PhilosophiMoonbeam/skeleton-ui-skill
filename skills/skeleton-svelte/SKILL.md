---
name: skeleton-svelte
description: >-
  Build, refine, debug, or explicitly migrate Skeleton UI v3 applications in
  Svelte and SvelteKit. Use for polished responsive app shells, visual hierarchy,
  themes, tokens, presets, dark mode, native forms/tables, Skeleton components,
  accessibility, SSR, and hydration. Includes a frozen reference for Svelte
  5.57.2 and SvelteKit 3.0.1; inspect installed versions before applying APIs.
  Preserve existing apps unless migration is requested. Not for React or
  unrelated UI work.
compatibility: >-
  Reference target: @skeletonlabs/skeleton 3.2.2, @skeletonlabs/skeleton-svelte
  1.5.3, Svelte 5.57.2, SvelteKit 3.0.1, Tailwind CSS 4.3.3. Kit 3 requires
  Node >=22.17 and compatible Vite/plugin/adapter tooling. Honor the project's
  package manager and lockfile. Network optional: bundled references plus
  installed declarations/source support offline work.
metadata:
  version: "1.0"
  skeleton-core: "3.2.2"
  skeleton-svelte: "1.5.3"
  svelte: "5.57.2"
  sveltekit: "3.0.1"
---

# Skeleton v3 for Svelte

Use this skill when the task involves Skeleton's Svelte integration or design
system. Prefer semantic native HTML with Skeleton styling for simple UI; use a
verified functional component when its behavior is needed. Neither approach
makes application validation, persistence, or accessibility automatic.

## Version boundary: inspect before using examples

The frozen pair is **`@skeletonlabs/skeleton@3.2.2`** (CSS) and
**`@skeletonlabs/skeleton-svelte@1.5.3`** (Svelte components). Their version
numbers are independent; Skeleton v3 does not mean component-package `@3`.
The framework target is **Svelte `5.57.2` and SvelteKit `3.0.1`**.

- **Existing app:** inspect resolved versions first. Preserve the user's working
  toolchain, adapter, conventions, and unrelated changes. This skill is not an
  instruction to upgrade or downgrade the application.
- **Different major or API:** do not apply this catalog unchanged. Keep the
  installed version and retrieve matching primary documentation/types/source,
  or migrate only when explicitly requested. Do not install a newer package to
  satisfy an example or downgrade an existing v4/v5 application to fit it.
- **Greenfield target:** use the exact pins and complete configuration in
  [setup](references/setup.md). Inspect generated scaffold versions rather than
  assuming the current CLI emits this toolchain. Do not force incompatible peers.

## Read only the references needed for the task

Read each resource directly from this entrypoint; you do not need to load the
full catalog for a single control.

| Task / question | Read | What to extract |
| --- | --- | --- |
| Install, greenfield scaffold, peer/toolchain failure, CSS not generated | [Setup](references/setup.md) | Exact pins, Kit 3 Vite/TypeScript configuration, global CSS, scanning, adapter constraints |
| v2 stores/components/classes, Tailwind 3, mixed-major examples | [Migration](references/migration.md) | Inventory and clean cutover of callers; removed APIs; root versus alpha subpath; offline lookup |
| Choose a control or verify an import/prop/callback/snippet | [Components](references/components.md) | Complete runtime export inventory and `FileUploadApi` type; native alternatives; exact declaration links |
| Implement tabs, accordion, preferences, tooltip, modal/drawer, or toast | [Recipes](references/recipes.md) | Six complete standalone components; copy the relevant example as a unit and adapt its state/semantics |
| Theme, tokens, presets, native classes, responsive styling, mode | [Styling](references/styling.md) | Theme import plus activation, v3 CSS variables/presets, form prerequisites, hydration-aware mode |
| Compose a polished page, dashboard, or responsive app shell | [Design](references/design.md) | Visual brief, hierarchy, spacing, density, responsive composition, and a complete app-shell recipe |
| Forms, labels, validation feedback, keyboard/focus, contrast, motion | [Accessibility](references/accessibility.md) | Native semantics and concrete browser checks, including overlays and assistive feedback |
| Runes/snippets, SSR, hydration, route/load data, server forms | [SvelteKit](references/sveltekit.md) | Kit 3 removals, request isolation, browser lifecycle cleanup, server actions and native enhancement |
| Establish provenance, resolve conflicting docs, work offline | [Sources](references/sources.md) | Version-qualified primary sources, package inspection, evidence boundaries |

For a new page or app shell, combine **design + styling + accessibility**, adding
the relevant **recipe or SvelteKit** reference for interaction or server data.
For a persisted form, combine **components/styling + SvelteKit + accessibility**;
for an overlay, combine **components + recipe + accessibility**;
for a theme preference, combine **styling + SvelteKit**. An explicitly requested
migration requires **migration + setup** and each affected control's reference.

## Blind-session workflow

1. **Inspect the application.** Read its manifest, resolved lockfile, installed
   package versions, package-manager/workspace configuration, Node/toolchain,
   Vite and any legacy Svelte config, TypeScript config, root layout, HTML
   template, global CSS, theme ownership, and relevant component/server callers.
   Distinguish declared ranges from resolved versions. Do not create a second
   lockfile or replace configuration wholesale.
   Establish whether this is existing-app work, greenfield setup, or an explicitly
   requested migration; do not treat version inspection as permission to migrate.
   Read only the task router's relevant references.
2. **Choose semantics and behavior.** Use styled native elements for simple
   buttons, text fields, select/checkbox/radio controls, cards, and tables.
   Choose an available functional primitive for managed interaction. Confirm
   its public export/subpath before importing it; missing behavior is not a
   reason to invent a Skeleton component.
   For page composition, read [design](references/design.md): preserve the app's
   visual language or choose a coherent brief, then define hierarchy, density,
   primary action, content states, and narrow/wide layout before assembling controls.
3. **Read the contract.** Consult the task-specific reference, then the selected
   component's exact declarations and source for required props, value shape,
   callback payload, snippets, rendered tags, and binding support. Use only
   public entrypoints. Resolve conflicts between docs and types before implementing.
4. **Implement in the existing application.** Own controlled state in a
   component instance; update it from the actual callback payload. Use Svelte
   runes, typed snippets, and event properties for new runes components.
   Preserve labels, native form participation, focus behavior, and server
   validation. Keep initial markup deterministic and user state request-safe.
5. **Verify the real result.** Run the application's check/typecheck and build
   scripts with its package manager. Exercise the rendered UI in supported
   browsers: state changes, keyboard/focus, dismissal, forms, theme/mode,
   SSR/hydration, and console errors as relevant. Inspect screenshots at narrow
   and wide widths with realistic content; refine hierarchy, spacing, alignment,
   contrast, overflow, and empty/loading/error states. Follow the
   [design](references/design.md) and [accessibility](references/accessibility.md)
   checklists; compilation cannot establish visual quality or interaction.
6. **Hand off truthfully.** State changed behavior, resolved versions, exact
   commands/results, and actual browser/viewport coverage. Name unperformed checks
   and deployment/accessibility limits. Do not present previews as persisted
   operations, or build/SSR smoke results as deployment proof.

## Nonnegotiable traps

- **Framework versions matter.** Kit 3 changes configuration and imports.
  Read [setup](references/setup.md) for the exact toolchain/peer contract and
  [SvelteKit](references/sveltekit.md) before copying older framework examples.
  Apply those instructions to Kit 3 only; preserve other working versions.
  Archived Skeleton minimums are not proof of compatibility with every later Kit.
- **Do not invent root exports.** This pair has `Modal` for dialogs/drawers and
  `Toaster`/`createToaster` for notifications, not `Dialog`, `Drawer`, or `Toast`.
  No root `Portal` or `useListCollection` exists. Simple select/checkbox/radio
  controls use native styled HTML. Root `Avatar` is flat; `/composed` is a
  separate alpha API, not interchangeable with the root API. Some root components
  have dot members; some are marked temporary in source. Consult the inventory
  and component contract, not a universal compound pattern or stability assumption.
- **Props do not imply bindings.** The root components used by the six recipes
  expose no bindable state props. Use controlled props and verified callbacks,
  not assumed `bind:value`/`bind:checked`; native inputs can use bindings. This
  is not a claim about every export or `/composed` component. Callback payloads
  differ between components. Snippet triggers may already render a button: do
  not nest another button inside them.
- **CSS is integration, not behavior.** Import core, the chosen theme, and
  optional presets when used; activate the imported theme on `<html>` and scan
  the actual component distribution. Styled native forms require
  `@tailwindcss/forms`. Use v3 tokens/presets, not v2 plugin/`variant-*` wiring.
- **SSR must isolate users.** Never keep user data, drafts, theme preferences,
  modal state, or toast queues in mutable server module singletons. Keep state
  per component/layout/request; guard browser-only work and clean it up. Do not
  expose secrets through load/action results or disable app-wide SSR to hide a
  browser-only import. Server render and initial hydration must agree.

## Evidence hierarchy and offline fallback

Use **resolved installed package exports, declarations, source, and CSS** for the
actual API; use version-qualified registry metadata for peers/engines. Consult
**archived `v3.skeleton.dev`** for this Skeleton generation and the official
Svelte/Kit migration documentation for the requested framework version. The
bundled references link these authorities; [sources](references/sources.md)
records provenance and verification boundaries.

Current `skeleton.dev` and version-ambiguous Context7 results are discovery
leads, not v3 authority—even a library labeled v3 can return later-major material.
Compare any example with the actual export/prop contract before using it.

Offline, locate packages through the application's real dependency directory
or symlink. Read `package.json`/`exports`, component `dist/index.d.ts`, the
selected `.svelte.d.ts` and `types.d.ts`, inherited primitive declarations, and
shipped `.svelte` source; inspect core CSS/presets/theme files for styling.
Follow the detailed lookup in the component/migration references. If required
API evidence is unavailable, report the precise missing contract rather than
fabricating a prop/export or claiming an unperformed verification.
