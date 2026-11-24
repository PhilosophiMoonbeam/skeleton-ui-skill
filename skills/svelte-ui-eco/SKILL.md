---
name: svelte-ui-eco
description: >-
  Build, style, debug, or migrate accessible Svelte 5 interfaces in standalone
  apps or SvelteKit. Use for native controls, Bits UI dialogs, menus, comboboxes,
  selection and date/time controls, keyboard and focus behavior, responsive
  design, SSR, hydration, and Kit server forms. Prefer Bits UI for new custom
  interactions; retain working Skeleton UI components and use them for gaps.
compatibility: >-
  Supports standalone modern Svelte 5. The reference baseline is Svelte 5.59.1,
  Bits UI 2.22.0, and Bun 1.4.5; date/time examples use @internationalized/date
  3.12.4. Kit-specific guidance starts at SvelteKit 3.1 (reference: 3.4.0).
metadata:
  version: "4.1"
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

## Choose the interaction layer

1. **Native HTML first.** Use buttons, links, inputs, selects, details, and forms when their semantics and behavior meet the requirement.
2. **Keep working widgets.** Preserve the app's existing compatible components and visual language. Migrate only for a concrete requirement. Do not combine two libraries' triggers, content, or state machines inside one widget.
3. **Prefer Bits UI for new custom interaction.** Use it for managed focus, keyboard navigation, selection, and overlays. Use [Skeleton Svelte components](references/skeleton.md) when they fit the app's design system or supply a missing capability, such as Toast or Carousel. Avoid adding a second library merely to duplicate a widget the app already has.
4. **Choose styling independently.** Skeleton core themes and Tailwind utilities can style native or Bits UI markup. Neither supplies interactive behavior by itself. Add Lucide only when useful and name the actual control.

Standalone modern Svelte 5 does not require Kit. SvelteKit 3.1+ applies only to Kit-specific guidance. Keep compatible versions and tooling already in the app; do not downgrade just to match an example.

## Open only the references you need

| Task | Read |
| --- | --- |
| Install, inspect peers and pins, or configure optional packages | [Setup](references/setup.md) |
| Choose a native element or a Bits UI component by use case | [Component catalog](references/components.md) |
| Verify Bits UI anatomy, state, composition, or installed types | [Bits UI](references/bits-ui.md) |
| Keep or adopt Skeleton's styled components; fill a Bits UI gap | [Skeleton UI](references/skeleton.md) |
| Copy a complete Skeleton component example or upgrade an existing Skeleton app | [Skeleton recipes](references/skeleton-recipes.md) or [Skeleton migration](references/skeleton-migration.md) |
| Adapt an implementation pattern or mount a standalone component | [Recipes](references/recipes.md) or [examples index](examples/README.md) |
| Integrate SSR, route data, or native and enhanced Kit forms | [SvelteKit](references/sveltekit.md) |
| Apply themes, tokens, responsive utilities, or dark mode | [Styling](references/styling.md) |
| Establish hierarchy, layout, or realistic page states | [Design](references/design.md) |
| Review semantics, keyboard behavior, focus, errors, contrast, or motion | [Accessibility](references/accessibility.md) |
| Find an icon, verify its export, and label icon controls | [Lucide](references/lucide.md) |
| Compose icons, handle RTL, or use typed dynamic icon selection | [Lucide patterns](references/lucide-patterns.md) |
| Replace historical wrappers or upgrade incompatible conventions | [Migration](references/migration.md) |
| Resolve conflicting docs or compare earlier pinned browser observations | [Sources](references/sources.md) or [verification history](references/verification-history.md) |

## Work from the resolved contracts

1. Inspect the app's resolved versions and affected callers. Prefer installed exports, types, and source for exact contracts. Use the [Bits UI LLM index](https://www.bits-ui.com/llms.txt) for a selected Bits primitive, or [Skeleton fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md) for Skeleton components.
2. Adapt the smallest relevant pattern. Keep state instance- or request-owned, use hydration-stable IDs, preserve native form submission and app validation, and keep focus visible. CSS and icons must not substitute for labels or behavior.
3. Verify the changed behavior: check keyboard/focus and relevant form and hydration paths; inspect narrow and wide layouts for visual work. Report only what you checked. Compilation alone does not verify accessibility, persistence, or deployment.
