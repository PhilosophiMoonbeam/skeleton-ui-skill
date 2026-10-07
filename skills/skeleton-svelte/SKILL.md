---
name: skeleton-svelte
description: >-
  Implement, debug, style, or migrate Skeleton UI in Svelte and SvelteKit applications.
  Use for Skeleton Svelte components, styled native buttons/forms/tables, themes,
  tokens, presets, dark mode, tabs, accordions, switches, tooltips, popovers,
  dialogs/drawers, toasts, file upload, accessibility, SSR, hydration, and v2-to-v3
  migration. Provides a frozen Skeleton v3 reference for Svelte 5.57.2 and
  SvelteKit 3.0.1, with installed-version checks before applying APIs. Not a
  React skill and not a requirement for unrelated UI work.
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
- **Different major or API:** stop applying this catalog. Use version-matched
  primary documentation and installed types/source, or perform an explicitly
  agreed migration. Do not install a newer package to satisfy a copied example
  or downgrade an existing v4/v5 application to fit these references.
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
| Forms, labels, validation feedback, keyboard/focus, contrast, motion | [Accessibility](references/accessibility.md) | Native semantics and concrete browser checks, including overlays and assistive feedback |
| Runes/snippets, SSR, hydration, route/load data, server forms | [SvelteKit](references/sveltekit.md) | Kit 3 removals, request isolation, browser lifecycle cleanup, server actions and native enhancement |
| Establish provenance, resolve conflicting docs, work offline | [Sources](references/sources.md) | Version-qualified primary sources, package inspection, evidence boundaries |

For a persisted form, combine **components/styling + SvelteKit + accessibility**;
for an overlay, combine **components + the relevant recipe + accessibility**;
for a theme preference, combine **styling + SvelteKit**. Migration requires
**migration + setup** and the reference for each affected control.

## Blind-session workflow

1. **Inspect the application.** Read its manifest, resolved lockfile, installed
   package versions, package-manager/workspace configuration, Node/toolchain,
   Vite and any legacy Svelte config, TypeScript config, root layout, HTML
   template, global CSS, theme ownership, and relevant component/server callers.
   Distinguish declared ranges from resolved versions. Do not create a second
   lockfile or replace configuration wholesale.
2. **Choose semantics and behavior.** Use styled native elements for simple
   buttons, text fields, select/checkbox/radio controls, cards, and tables.
   Choose an available functional primitive for managed interaction. Confirm
   its public export/subpath before importing it; missing behavior is not a
   reason to invent a Skeleton component.
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
   responsive layout, SSR/hydration, and console errors as relevant. Follow the
   accessibility checklist; compile success cannot establish these behaviors.
6. **Hand off truthfully.** State changed behavior, resolved versions, exact
   commands and results, and actual browser coverage. Name unperformed checks
   and limits on deployment and accessibility. Do not present local previews or
   selected files as persisted operations, or a build or SSR smoke test as deployment proof.

## Nonnegotiable traps

- **Kit 3 configuration is not Kit 2 configuration.** Put supported options in
  `sveltekit({...})` in Vite; `svelte.config.js` is removed. Extend `$app/tsconfig`
  with explicit `include`/`exclude`, not `.svelte-kit/tsconfig.json`. Preserve
  adapter, preprocessing, compiler options, and project-specific paths.
- **Kit 3 imports changed.** `$app/environment` became `$app/env`; `$app/stores`
  was removed. `$lib` is no longer generated: declare `#lib` package imports or
  use relative paths. `$env/...` paths are deprecated. Read the framework
  reference before applying familiar Kit 2 examples, including form enhancement.
- **Use the matching toolchain.** For the frozen target: Node >=22.17, Vite
  `8.0.12`, Svelte Vite plugin `7.0.0`, Tailwind/plugin `4.3.3`; when TypeScript
  is present, `6.0.3` satisfies Kit's optional `^6.0.0` peer. Check the adapter
  separately. The archived Skeleton installation guide alone is not Kit 3 proof.
- **Do not invent root exports.** This pair has `Modal` for dialogs/drawers and
  `Toaster`/`createToaster` for notifications, not `Dialog`, `Drawer`, or `Toast`.
  No root `Portal` or `useListCollection` exists. Simple select/checkbox/radio
  controls use native styled HTML. Root `Avatar` is flat; `/composed` is a
  separate alpha API, not the production root API. Some verified root components
  do have dot members: consult the inventory rather than applying a universal
  compound-component pattern.
- **Props do not imply bindings.** The stable root recipe components expose no
  bindable state props. Use controlled props and verified callbacks, not assumed
  `bind:value`/`bind:checked`; native inputs can use bindings. Callback payloads
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
