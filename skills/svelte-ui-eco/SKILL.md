---
name: svelte-ui-eco
description: >-
  Build, style, debug, or migrate accessible standalone Svelte 5 and SvelteKit
  interfaces. Use for visual direction, responsive design, themes, native
  controls, styled Skeleton UI widgets, or headless Bits UI primitives such as
  dialogs, menus, comboboxes, and date/time controls. Covers keyboard and focus
  behavior, selection, SSR, hydration, and Kit server forms.
compatibility: >-
  Supports standalone modern Svelte 5. The reference baseline is Svelte 5.59.1,
  Bits UI 2.22.0, and Bun 1.4.5; date/time examples use @internationalized/date
  3.12.4. Kit-specific guidance starts at SvelteKit 3.1 (reference: 3.4.0).
metadata:
  version: "4.2"
  bun: "1.4.5"
  svelte: "5.59.1"
  bits-ui: "2.22.0"
  internationalized-date: "3.12.4"
  sveltekit: "3.4.0"
  sveltekit-minimum: "3.1.0"
  skeleton-core: "5.0.6"
  skeleton-svelte: "5.0.6"
  tailwindcss: "4.3.5"
  lucide: "1.77.0"
---

# svelte-ui-eco

## Choose a stack for the task

1. **Define the outcome first.** Start with the user task and a short [visual brief](references/design.md): audience, content, hierarchy, and tone. Use a demo as design inspiration, not a dependency list. Keep compatible components and the app's design system; change them only for a concrete requirement.
2. **Use native HTML when sufficient.** Prefer semantic buttons, links, inputs, selects, details, and forms when their behavior meets the need.
3. **For a new product without a visual system, if Tailwind fits, start with Tailwind 4 and Skeleton core.** Calibrate a theme on one representative screen. Add [Skeleton's styled, Zag-backed Svelte components](references/skeleton.md) for managed widgets that fit the brief. Don't install Bits UI by default.
4. **Choose Bits UI for bespoke markup or when its behavior is the better fit.** It supplies managed keyboard, focus, selection, and overlay behavior without imposing a look. Style its markup with app CSS, Tailwind, or optional Skeleton core themes and utilities. Skeleton core by itself supplies styling, not widget behavior; its styled Svelte package is separate.
5. **Share styling and application values, not widget internals.** Give each widget one root and interaction owner. Don't mix libraries' trigger/content parts, state machines, or generated ARIA. Avoid adding another library for an equivalent widget. Add Lucide only when useful and name the actual control.

Use standalone modern Svelte 5 unless the project needs SvelteKit features. SvelteKit 3.1+ applies only to Kit-specific guidance. Keep compatible versions and tooling already in the app; do not downgrade just to match an example.

## Open only the references you need

| Task | Read |
| --- | --- |
| Establish the visual brief, hierarchy, responsive layout, and realistic page states before selecting libraries | [Design](references/design.md) |
| Choose dependencies, inspect peers and pins, or configure the selected stack | [Setup](references/setup.md) |
| Choose a native element or a Bits UI component by use case | [Component catalog](references/components.md) |
| Verify Bits UI anatomy, state, composition, or installed types | [Bits UI](references/bits-ui.md) |
| Adopt or retain styled Skeleton widgets, or check component fit and capabilities | [Skeleton UI](references/skeleton.md) |
| Copy a complete Skeleton component example or upgrade an existing Skeleton app | [Skeleton recipes](references/skeleton-recipes.md) or [Skeleton migration](references/skeleton-migration.md) |
| Adapt an implementation pattern or mount a standalone component | [Recipes](references/recipes.md) or [examples index](examples/README.md) |
| Give a standalone headless widget the app's Skeleton theme without replacing its behavior | [Themed Bits UI Calendar](examples/ThemedCalendar.svelte) and [mounting guide](examples/README.md) |
| Integrate SSR, route data, or native and enhanced Kit forms | [SvelteKit](references/sveltekit.md) |
| Apply themes, tokens, responsive utilities, or dark mode | [Styling](references/styling.md) |
| Review semantics, keyboard behavior, focus, errors, contrast, or motion | [Accessibility](references/accessibility.md) |
| Find an icon, verify its export, and label icon controls | [Lucide](references/lucide.md) |
| Compose icons, handle RTL, or use typed dynamic icon selection | [Lucide patterns](references/lucide-patterns.md) |
| Replace historical wrappers or upgrade incompatible conventions | [Migration](references/migration.md) |
| Resolve conflicting docs or compare earlier pinned browser observations | [Sources](references/sources.md) or [verification history](references/verification-history.md) |

## Work from the resolved contracts

1. Inspect the app's resolved versions and affected callers. Prefer installed exports, types, and source for exact contracts. Use the [Bits UI LLM index](https://www.bits-ui.com/llms.txt) for a selected Bits primitive, or [Skeleton fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md) for Skeleton components.
2. Adapt the smallest relevant pattern. Keep state instance- or request-owned, use hydration-stable IDs, preserve native form submission and app validation, and keep focus visible. CSS and icons must not substitute for labels or behavior.
3. Verify the changed behavior: check keyboard/focus and relevant form and hydration paths; inspect narrow and wide layouts for visual work. Report only what you checked. Compilation alone does not verify accessibility, persistence, or deployment.
