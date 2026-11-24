# Lucide patterns: typed consumers and advanced SVG

These patterns extend the [Lucide guide](lucide.md) for optional `@lucide/svelte` 1.77.0 on Svelte 5. Use only what the application needs; no shared icon wrapper or registry is required. Copy each named fence into a file with that name. The examples use native controls and local CSS, without Tailwind, Skeleton, or Bits UI; only the Lab example adds another package.

## Reactive consumer

Use `LucideIcon` for a component value and `Pick<LucideProps, 'size' | 'color' | 'strokeWidth' | 'nonScalingStroke'>` for a narrow set of reactive presentation props. Read them through `$props()` and render the dynamic component directly. Validate incoming string keys with `Object.hasOwn` against a finite static map before selecting a component. Keep raw keys serializable; never return component functions from a serialized load response.

A single independent toggle can use a native button with a stable name (“Favorite”) and `aria-pressed`. Keep the button mounted when an icon changes or is missing, so the control retains focus, label, and state. For managed toolbar choices such as text alignment, use Bits UI [`ToggleGroup`](https://www.bits-ui.com/docs/components/toggle-group/llms.txt); preserve its item props and put the name on the item, not the SVG.

Save these two files together and mount `ReactiveIconDemo.svelte`. Native styling avoids SVG auto-sizing rules, so the size prop is visible in the rendered dimensions.

**File: `IconToggle.svelte`**
```svelte
<script lang="ts">
  import type { LucideIcon, LucideProps } from '@lucide/svelte';

  type Props = Pick<LucideProps,
    'size' | 'color' | 'strokeWidth' | 'nonScalingStroke' | 'stroke-linecap'
  > & {
    icon: LucideIcon | undefined;
    pressed: boolean;
    disabled: boolean;
    onclick: () => void;
    'data-icon-key'?: string;
  };

  let {
    icon: SelectedIcon, pressed, disabled, onclick,
    size = 24, color = 'currentColor', strokeWidth = 2,
    nonScalingStroke = false,
    'stroke-linecap': strokeLinecap = 'round',
    'data-icon-key': iconKey
  }: Props = $props();
</script>

<button type="button" aria-pressed={pressed} {disabled} {onclick}>
  {#if SelectedIcon}
    <SelectedIcon
      {size} {color} {strokeWidth} {nonScalingStroke}
      stroke-linecap={strokeLinecap} data-icon-key={iconKey}
      aria-hidden="true" focusable="false"
    />
  {/if}
  Favorite
</button>

<style>
  button { display: inline-flex; align-items: center; gap: 0.5rem; }
</style>
```

**File: `ReactiveIconDemo.svelte`**
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import type { LucideIcon } from '@lucide/svelte';
  import Heart from '@lucide/svelte/icons/heart';
  import Star from '@lucide/svelte/icons/star';
  import IconToggle from './IconToggle.svelte';

  const icons = { heart: Heart, star: Star } satisfies Record<string, LucideIcon>;
  function isIconKey(key: string): key is keyof typeof icons {
    return Object.hasOwn(icons, key);
  }

  let rawKey = $state('heart');
  let size = $state(32);
  let strokeWidth = $state(2);
  let nonScalingStroke = $state(false);
  let favorite = $state(false);
  let ready = $state(false);
  const { icon, unknownKey } = $derived(isIconKey(rawKey)
    ? { icon: icons[rawKey], unknownKey: false }
    : { icon: undefined, unknownKey: true });
  onMount(() => { ready = true; });
</script>

<fieldset disabled={!ready}>
  <legend>Local favorite preview</legend>
  <p><label>Icon key (try heart, star, or an unknown key)
    <input type="text" bind:value={rawKey} />
  </label></p>
  <p><label>Size: {size}px
    <input type="range" min="16" max="64" step="8" bind:value={size} />
  </label></p>
  <p><label>Stroke width: {strokeWidth}
    <input type="range" min="1" max="4" step="0.5" bind:value={strokeWidth} />
  </label></p>
  <p><label>
    <input type="checkbox" bind:checked={nonScalingStroke} />
    Keep stroke width constant as the icon scales
  </label></p>
  <IconToggle
    {icon} {size} {strokeWidth} {nonScalingStroke}
    pressed={favorite} disabled={!ready} onclick={() => favorite = !favorite}
    color="currentColor" stroke-linecap="square" data-icon-key={rawKey}
  />
  <p role="status">{unknownKey ? 'Unknown icon key; the button remains text-only. ' : ''}Favorite: {favorite ? 'on' : 'off'}. Local preview only; not saved.</p>
</fieldset>
```

The conditional destructuring is on `$derived(...)` itself, so both bindings update when `rawKey` changes. Ordinary `const { icon } = someReactiveObject` in the instance script would read only once. In markup, a fragment inside a narrowed `{#if}` branch can use `{@const { icon: SelectedIcon } = choice}` rather than destructuring an absent value before narrowing. In this demo the fallback always provides the same fields, and only the SVG is conditional.

Expose only approved custom SVG attributes if needed, such as `stroke-linecap`; do not forward arbitrary attributes, child snippets, titles, or ARIA props from untrusted data. Check that switching heart to star updates the geometry without moving focus, changing size updates the computed dimensions, and `nonScalingStroke` affects the SVG shapes. An unknown key should leave the named text-only toggle usable.

## Fill and composition

Lucide is an outline set. SVG `fill` works on suitable geometry, such as a closed star, but can obscure details or close open paths unexpectedly. Inspect the particular icon; do not globally fill `.lucide`. To compare a solid star with the normal outline, set `fill="currentColor"` and `strokeWidth={0}` on the solid version.

Child snippets can add native SVG elements or nested icon SVGs and stop Lucide's automatic hiding; a snippet is not itself an accessible name. Here the composed image has exactly one accessible name: the outer SVG references an instance-safe nested `<title>`; the inner SVG stays explicitly decorative. Coordinates are in the outer 24×24 viewBox, not the displayed pixel size.

**File: `IconArtwork.svelte`**
```svelte
<script lang="ts">
  import Star from '@lucide/svelte/icons/star';
  import Scan from '@lucide/svelte/icons/scan';
  import User from '@lucide/svelte/icons/user';

  const id = $props.id();
  const titleId = `${id}-scan-title`;
  const clipId = `${id}-scan-clip`;
</script>

<figure>
  <Star size={40} fill="none" aria-hidden="true" focusable="false" />
  <Star size={40} fill="currentColor" strokeWidth={0} aria-hidden="true" focusable="false" />
  <figcaption>Outline star and filled star: the same shape, different paint.</figcaption>
</figure>
<Scan size={48} nonScalingStroke role="img" aria-labelledby={titleId} focusable="false">
  <g>
    <title id={titleId}>Scanned user</title>
    <defs>
      <clipPath id={clipId}><circle cx={12} cy={12} r={6} /></clipPath>
    </defs>
    <g clip-path={`url(#${clipId})`}>
      <User size={12} x={6} y={6} nonScalingStroke aria-hidden="true" focusable="false" />
    </g>
  </g>
</Scan>
```

The explicit SVG `<g>` gives Svelte's snippet a native SVG ancestor for `<title>`, which would otherwise be ambiguous in a component's children. The outer image's explicit ID reference supplies its name. Use one `$props.id()` per component, with distinct suffixes for every SVG ID and referencing attribute (`aria-labelledby`, `url(#…)`, etc.). Mount two instances and check that each reference resolves within its own image, even after hydration, and that each exposes exactly one “Scanned user” image. Review geometry and contrast in both schemes.

## Directional icons

Choose direction at the application's actual locale boundary. Mirror only icons whose meaning follows reading direction. A next-section arrow can mirror in RTL; a checkmark, logo, clock, or physical-direction symbol should not inherit a blanket mirror rule. Choosing an explicit left or right component is also valid.

**File: `DirectionalIcons.svelte`**
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import ArrowRight from '@lucide/svelte/icons/arrow-right';
  import Check from '@lucide/svelte/icons/check';

  const id = $props.id();
  const targetId = `${id}-next`;
  let direction = $state<'ltr' | 'rtl'>('ltr');
  let ready = $state(false);
  onMount(() => { ready = true; });
</script>

<label>
  Preview reading direction
  <select bind:value={direction} disabled={!ready}>
    <option value="ltr">Left to right</option>
    <option value="rtl">Right to left</option>
  </select>
</label>
<section dir={direction}>
  <a class="next-link" href={`#${targetId}`}>
    Next section
    <ArrowRight class="next-arrow" aria-hidden="true" focusable="false" />
  </a>
  <p><Check aria-hidden="true" focusable="false" /> Confirmed: the checkmark does not mirror.</p>
  <section id={targetId}>
    <h2>Next section</h2>
    <p>This is the local navigation target.</p>
  </section>
</section>

<style>
  .next-link { display: inline-flex; align-items: center; gap: 0.5rem; }
  .next-link :global(.next-arrow:dir(rtl)) { transform: scaleX(-1); }
  @media (prefers-reduced-motion: no-preference) {
    .next-link :global(.next-arrow) { transition: transform 120ms ease-out; }
  }
</style>
```

The transform affects only the decorative arrow, not the link, label, or focus styling; reduced motion makes the same flip immediate. If JavaScript drives motion, gate that mechanism itself rather than assuming the CSS media rule cancels it. In both directions, activate the link by keyboard and verify it reaches the instance's target, with the arrow mirrored only in RTL. The link works before hydration. See [responsive design](design.md) for direction and layout checks.

## Custom icon data and Lab

Use the generic `Icon` with exactly one of `icon: LucideIconData` or `iconNode: LucideIconNode[]`. For custom geometry, use static, trusted SVG node data; do not use this API to ingest arbitrary SVG or HTML.

**File: `CustomIconData.svelte`**
```svelte
<script lang="ts">
  import { Icon, type LucideIconData } from '@lucide/svelte';

  const addition = {
    name: 'local-addition',
    size: 24,
    node: [
      ['circle', { cx: 12, cy: 12, r: 9 }],
      ['path', { d: 'M8 12h8M12 8v8' }]
    ]
  } satisfies LucideIconData;
</script>

<Icon icon={addition} size={32} role="img" aria-label="Addition symbol in a circle" focusable="false" />
```

### Optional Lucide Lab 0.17.0

Only the next file needs this separate experimental package:

```sh
bun add --exact @lucide/lab@0.17.0
```

In 0.17.0, the named `pear` export is an array of two SVG path tuples compatible with `LucideIconNode[]`, not a component or a `LucideIconData` object. Use `iconNode`, not `icon`. Lab icons can graduate: for example, `jacket` was removed from Lab in [0.15.0](https://github.com/lucide-icons/lucide/releases/tag/@lucide%2Flab@0.15.0) and has a core component at `@lucide/svelte/icons/jacket` in 1.77.0. Check declarations before replacing a Lab import and drop Lab when no imports still need it.

**File: `OptionalLabIcon.svelte`**
```svelte
<script lang="ts">
  import { Icon, type LucideIconNode } from '@lucide/svelte';
  import { pear } from '@lucide/lab';

  const pearNode: LucideIconNode[] = pear;
</script>

<Icon iconNode={pearNode} size={40} role="img" aria-label="Pear" focusable="false" />
```

Inspect the two components separately for inline SVG, the intended geometry, and their named images in the accessibility tree.

## Primary references

- Current official guidance: [filled icons](https://lucide.dev/guide/svelte/advanced/filled-icons), [combining icons](https://lucide.dev/guide/svelte/advanced/combining-icons), and [Lucide Lab](https://lucide.dev/guide/svelte/advanced/with-lucide-lab).
- Exact **@lucide/svelte 1.77.0**: [public types](https://unpkg.com/@lucide/svelte@1.77.0/dist/types.d.ts), [data types](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/types.d.ts), [Icon implementation](https://unpkg.com/@lucide/svelte@1.77.0/dist/Icon.svelte), and [SVG construction](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/buildLucideIconNode.js).
- Exact **@lucide/lab 0.17.0**: [metadata](https://registry.npmjs.org/@lucide/lab/0.17.0), [named ESM exports](https://unpkg.com/@lucide/lab@0.17.0/dist/esm/lucide-lab.js), [declarations](https://unpkg.com/@lucide/lab@0.17.0/dist/lucide-lab.d.ts), and [pear data](https://unpkg.com/@lucide/lab@0.17.0/dist/esm/icons/pear.js).
