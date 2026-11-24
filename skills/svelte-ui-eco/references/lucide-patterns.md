# Lucide patterns: typed consumers and advanced SVG

These patterns extend the [Lucide guide](lucide.md). Use only what the application needs; no shared icon wrapper or registry is required. These fragments explain optional icon integration; the standalone examples in [the mounting guide](../examples/README.md) do not require Lucide.

## Reactive consumer

Use `LucideIcon` for a component value and `Pick<LucideProps, 'size' | 'color' | 'strokeWidth' | 'nonScalingStroke'>` for a narrow set of reactive presentation props. Read them through `$props()` and render the dynamic component directly. Validate incoming string keys with `Object.hasOwn` against a finite static map before selecting a component. Keep raw keys serializable; never return component functions from a serialized load response.

A single independent toggle can use a native button with a stable name (“Favorite”) and `aria-pressed`. Keep the button mounted when an icon changes or is missing, so the control retains focus, label, and state. For managed toolbar choices such as text alignment, use Bits UI [`ToggleGroup`](https://www.bits-ui.com/docs/components/toggle-group/llms.txt); preserve its item props and put the name on the item, not the SVG.

Inside the single toggle's native button, where `SelectedIcon` is the validated component and the presentation props come from `$props()`:

```svelte
{#if SelectedIcon}
  <SelectedIcon {size} {color} {strokeWidth} {nonScalingStroke} aria-hidden="true" focusable="false" />
{/if}
Favorite
```

Expose only approved custom SVG attributes if needed, such as `stroke-linecap`; do not forward arbitrary attributes, child snippets, titles, or ARIA props from untrusted data. Check that switching heart to star updates the geometry without moving focus, changing size updates the computed dimensions, and `nonScalingStroke` affects the SVG shapes. An unknown key should leave the named text-only toggle usable.

## Fill and composition

Lucide is an outline set. SVG `fill` works on suitable geometry, such as a closed star, but can obscure details or close open paths unexpectedly. Inspect the particular icon; do not globally fill `.lucide`. To compare a solid star with the normal outline, set `fill="currentColor"` and `strokeWidth={0}` on the solid version.

Child snippets can add native SVG elements or nested icon SVGs and stop Lucide's automatic hiding; a snippet is not itself an accessible name. Here the composed image has exactly one accessible name: the outer SVG references an instance-safe nested `<title>`; the inner SVG stays explicitly decorative. Coordinates are in the outer 24×24 viewBox, not the displayed pixel size.

Set `const id = $props.id()` in the component instance. With `Scan` and `User` imported, the composed image is one accessible object:

```svelte
<Scan size={48} nonScalingStroke role="img" aria-labelledby={`${id}-scan-title`} focusable="false">
  <title id={`${id}-scan-title`}>Scanned user</title>
  <User size={12} x={6} y={6} nonScalingStroke aria-hidden="true" focusable="false" />
</Scan>
```

Mount two instances and confirm unique title IDs and exactly one “Scanned user” image per instance. Review geometry and contrast in both schemes.

## Directional icons

Choose direction at the application's actual locale boundary. Mirror only icons whose meaning follows reading direction. A next-section arrow can mirror in RTL; a checkmark, logo, clock, or physical-direction symbol should not inherit a blanket mirror rule. Choosing an explicit left or right component is also valid.

Apply the transform only to a decorative SVG given an application-owned class. For example, `.next-arrow:dir(rtl) { transform: scaleX(-1); }` should affect the arrow, not its parent link, label, or focus styling. See [responsive design](design.md) for direction and layout checks. In both directions activate the actual link by keyboard, verify it reaches the real target, and inspect the arrow and an unmirrored checkmark.

## Custom icon data and Lab

Use the generic `Icon` with exactly one of `icon: LucideIconData` or `iconNode: LucideIconNode[]`. For custom geometry, use static, trusted SVG node data; do not use this API to ingest arbitrary SVG or HTML.

One data object, checked before passing it through `icon={addition}`:

```ts
import type { LucideIconData } from '@lucide/svelte';

const addition = {
  name: 'local-addition',
  size: 24,
  node: [
    ['circle', { cx: 12, cy: 12, r: 9 }],
    ['path', { d: 'M8 12h8M12 8v8' }]
  ]
} satisfies LucideIconData;
```

Lab is a separate experimental package, never required for core Lucide icons. The `pear` export in `@lucide/lab` 0.17.0 is an array of SVG node tuples compatible with `LucideIconNode[]`, not a component or `LucideIconData`. Pass it to `Icon` via `iconNode={pear}`; if it is a standalone meaningful image, set `role="img" aria-label="Pear"`. Inspect the installed declarations: Lab icons can graduate to core, in which case use the confirmed core component and remove Lab if nothing else needs it.

## Primary references

- Current official guidance: [filled icons](https://lucide.dev/guide/svelte/advanced/filled-icons), [combining icons](https://lucide.dev/guide/svelte/advanced/combining-icons), and [Lucide Lab](https://lucide.dev/guide/svelte/advanced/with-lucide-lab).
- Exact **@lucide/svelte 1.77.0**: [public types](https://unpkg.com/@lucide/svelte@1.77.0/dist/types.d.ts), [data types](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/types.d.ts), [Icon implementation](https://unpkg.com/@lucide/svelte@1.77.0/dist/Icon.svelte), and [SVG construction](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/buildLucideIconNode.js).
- Exact **@lucide/lab 0.17.0**: [metadata](https://registry.npmjs.org/@lucide/lab/0.17.0), [named ESM exports](https://unpkg.com/@lucide/lab@0.17.0/dist/esm/lucide-lab.js), [declarations](https://unpkg.com/@lucide/lab@0.17.0/dist/lucide-lab.d.ts), and [pear data](https://unpkg.com/@lucide/lab@0.17.0/dist/esm/icons/pear.js).
