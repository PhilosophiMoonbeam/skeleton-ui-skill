# Lucide for Svelte

Use optional Lucide when icons improve recognition. The [baseline](setup.md) pins `@lucide/svelte` 1.77.0; its peer dependency is Svelte 5. No SvelteKit, Tailwind, or Skeleton dependency is required for icons.

## Imports and package boundary

```sh
bun add --exact @lucide/svelte@1.77.0
```

Prefer canonical public per-icon default imports, such as `import Camera from '@lucide/svelte/icons/camera'`. Public root named imports, such as `import { Camera } from '@lucide/svelte'`, are also valid and can be tree-shaken. Per-icon imports keep the traversed module graph focused; they do not establish a measured bundle-size or build-speed advantage. Never import internal `dist` files. Root type-only imports are appropriate.

Static icon imports render inline SVG during SSR. No CSS import, Tailwind plugin, `@source`, icon font, DOM scanner, `createIcons`, `onMount`, or SSR workaround is needed. Use the scoped package and canonical icon names. For brand marks, use an authorized brand asset.

## Discover and verify an icon

1. Search the [official icon catalog](https://lucide.dev/icons/) by meaning, synonym, or category; open a candidate to confirm its actual shape and canonical label. The live catalog can be newer than the installed package.
2. Check the application's **installed** `@lucide/svelte` version and public declarations, not just a current website snippet. Follow `dist/lucide-svelte.d.ts` to `dist/icons/index.d.ts`; confirm the exact named export and its file mapping. Check aliases separately for renamed/deprecated names.
3. Follow that confirmed mapping to the public `./icons/*` export in `package.json`. For example, 1.77.0 declares `ArrowDown01` from `./arrow-down-0-1.svelte`; the public default-import path is `@lucide/svelte/icons/arrow-down-0-1`. The root alternative is `import { ArrowDown01 } from '@lucide/svelte'`.

The workflow is **catalog label → confirmed export/file mapping → public import slug**, not a guessed PascalCase-to-kebab-case conversion. Digits, acronyms, and historical aliases make mechanical conversion unreliable: `ArrowDownAZ` maps to `arrow-down-a-z`, while deprecated `ArrowDownAz` has a different alias entry. Do not build import paths from external strings.

For a warning icon, use the canonical `CircleExclamationPoint` export or `@lucide/svelte/icons/circle-exclamation-point`. The [1.68.0 rename](https://github.com/lucide-icons/lucide/releases/tag/1.68.0) introduced the `*-exclamation-point` names. `CircleAlert` and `@lucide/svelte/icons/circle-alert` still point to the same icon in 1.77.0, but are deprecated compatibility aliases, not new-code imports.

## Offline package inspection

Run this from the consuming application's directory after dependencies are installed. It resolves the installed package and reads its metadata without writing a file, using the network, or evaluating Svelte components:

```sh
bun run --no-install - <<'BUN'
import { realpathSync } from 'node:fs';
import { dirname, join } from 'node:path';

const entry = realpathSync(Bun.resolveSync('@lucide/svelte', process.cwd()));
const root = dirname(dirname(entry));
const pkg = await Bun.file(join(root, 'package.json')).json();
console.log('Package directory:', root);
console.log(JSON.stringify({
  version: pkg.version, peerDependencies: pkg.peerDependencies, exports: pkg.exports
}, null, 2));
BUN
```

Use the printed physical directory, not an assumed `node_modules` path: isolated installs may symlink the package, and `realpathSync` follows those links. In 1.77.0 the resolved entry is `dist/lucide-svelte.js`, so two parent directories locate the package root.

Inspect these files in that directory with an editor or text search:

| File | What to establish |
| --- | --- |
| `package.json` | Actual version, Svelte peer range, and allowed public entry points. In 1.77.0, `./icons/*` maps to `dist/icons/*.js` and `dist/icons/*.svelte.d.ts`. |
| `dist/lucide-svelte.d.ts` → `dist/icons/index.d.ts` | Exact canonical root exports and their file mappings; search meaning-related names, not only a guessed identifier. |
| `dist/aliases/index.d.ts` → `aliases.d.ts`, `prefixed.d.ts`, `suffixed.d.ts` | Historical, prefixed, and suffixed names. Read deprecation comments and follow the canonical replacement rather than adding a new alias-based import. |
| `dist/icons/<confirmed-slug>.js`, `.svelte.d.ts`, `.svelte` | Public default re-export, component props/type, and actual geometry. For example, `camera.js` re-exports the default from `camera.svelte`; the declaration confirms `Camera` accepts `LucideProps`. |
| `dist/types.d.ts`, `dist/Icon.svelte`, `dist/utils/hasA11yProp.js`, `dist/context.js` | Exact-version props, accessibility detection, and default/context behavior when documentation and observed rendering differ. |

If a candidate is absent, search canonical declarations and aliases before concluding it is unavailable. It may be renamed, added after the installed version, or removed; a catalog match does not prove this version exports it. Brand removals in v1 are not fixed by guessing another slug. Choose an available semantic icon, deliberately update the dependency, or obtain an authorized external brand asset as appropriate.

These `dist` paths are **inspection sources**, not application import paths. Continue importing through `@lucide/svelte`, `@lucide/svelte/context`, or the confirmed public `@lucide/svelte/icons/<slug>` entry. Neither filesystem presence nor internal `__iconData` declarations alone establish a public named export.

## Props and styling

| Input | Current behavior |
| --- | --- |
| `size` | Number or string; defaults to `24`; supplies width and height unless explicitly supplied. |
| `color` | Stroke color; defaults to `currentColor`, inheriting the surrounding theme foreground. |
| `strokeWidth` | Number or string; defaults to `2`. Prefer this spelling for component/context defaults. |
| `nonScalingStroke` | Defaults to `false`; applies `vector-effect="non-scaling-stroke"` to shapes, including when CSS sizes the SVG. |
| `class` | Ordinary class prop, combined with generated Lucide classes and context class. There is no `default-class` configuration prop or Tailwind conflict merger. |
| SVG attributes | Forwarded to the SVG; explicit raw attributes such as `stroke-width` are spread after generated attributes. |

Explicit component props override subtree defaults. CSS can override SVG presentation attributes: `class="size-5"` can determine dimensions despite `size={32}`; a global `.lucide` stroke/color rule can defeat explicit/context styling. Choose deliberate local utilities or context ownership, not blanket overrides. Conflicting utility classes do not have guaranteed last-token precedence.

With optional Skeleton CSS, its `.btn`/`.btn-icon` direct-child SVG rules may affect size. A wrapper changes that relationship. Check computed size, stroke, foreground contrast, and focus indicators in both schemes. Use `nonScalingStroke` for non-scaling strokes; deprecated `absoluteStrokeWidth` is not identical.

## Accessible icons and controls

- Name the button or link itself with visible text or `aria-label`; its icon stays decorative with `aria-hidden="true"`. Tooltips supplement names, not replace them.
- A standalone meaningful SVG needs `role="img"` and an accessible name (`aria-label`, or an instance-safe `aria-labelledby` referencing a nested `<title>`).
- Lucide skips generating its default `aria-hidden="true"` when the icon receives a child snippet (even if the snippet renders nothing) or when its forwarded props contain an own `aria-*`, `role`, or `title` property with a value other than `null` or `undefined`. For example, `aria-label={undefined}` neither disables automatic hiding nor names the icon. A non-nullish value can disable hiding without naming the icon: `aria-describedby` is a description, and a `title` attribute is not a nested SVG `<title>`. Set `aria-hidden="true"` explicitly on decorative icons.
- `focusable="false"` keeps the SVG itself out of legacy SVG focus behavior; the surrounding control remains keyboard accessible.

**File: `IconControls.svelte`**
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import Plus from '@lucide/svelte/icons/plus';
  import RotateCcw from '@lucide/svelte/icons/rotate-ccw';
  import CircleExclamationPoint from '@lucide/svelte/icons/circle-exclamation-point';

  let count = $state(0);
  let ready = $state(false);
  onMount(() => { ready = true; });
</script>

<section>
  <h2>Local counter</h2>
  <button type="button" disabled={!ready} onclick={() => count += 1}>
    <Plus aria-hidden="true" focusable="false" />
    Add one
  </button>
  <button type="button" aria-label="Reset counter" disabled={!ready} onclick={() => count = 0}>
    <RotateCcw aria-hidden="true" focusable="false" />
  </button>
  <p role="status">Count: {count}</p>
  <p>
    <CircleExclamationPoint role="img" aria-label="Warning" size={20} focusable="false" />
    This counter is local and resets when the component is recreated.
  </p>
</section>
```

The SVGs render during SSR; only the client-only controls wait for mount.

### Bits UI tooltip trigger

Follow [the overlay example](../examples/Overlays.svelte) for `Tooltip.Provider`, `Tooltip.Root`, and `Tooltip.Content`. Keep an icon decorative and name the actual button. If the default trigger button is adequate, put the icon inside it. If replacing it, pass names, handlers, and other attributes to `Tooltip.Trigger` and spread the resulting props onto the real button. Do not nest a button or overwrite generated handlers and ARIA relationships after spreading. See [composition](../examples/Composition.svelte) and the official [child snippet contract](https://www.bits-ui.com/docs/child-snippet/llms.txt).

**Markup fragment:** place inside the Bits tooltip root, with `Copy` imported from `@lucide/svelte/icons/copy`:

```svelte
<Tooltip.Trigger type="button" aria-label="Copy link">
  {#snippet child({ props })}
    <button {...props}><Copy aria-hidden="true" focusable="false" /></button>
  {/snippet}
</Tooltip.Trigger>
```

Wire the real copy action through `onclick` on `Tooltip.Trigger`. The name “Copy link” is present whether the tooltip is closed or open; use the tooltip for supplementary information, such as what kind of link is copied. Check hover, keyboard focus, Escape, and the description while open.

### Optional: existing Skeleton compound tooltip

For an existing [`@skeletonlabs/skeleton-svelte` 5.0.6 Tooltip](https://www.skeleton.dev/docs/svelte/framework-components/tooltip), the equivalent composition uses `element(attributes)`, not Bits' `child({ props })`, with a separate `Portal` and `Tooltip.Positioner`. Keep this as its own widget root; for new compound tooltip integrations, use the Bits pattern above. The example uses the application's existing Skeleton CSS/theme and Tailwind setup.

**File: `SkeletonIconTooltip.svelte`**
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import { Portal, Tooltip } from '@skeletonlabs/skeleton-svelte';
  import RotateCcw from '@lucide/svelte/icons/rotate-ccw';

  let count = $state(0);
  let ready = $state(false);
  onMount(() => { ready = true; });
</script>

<button type="button" class="btn preset-filled" disabled={!ready} onclick={() => count += 1}>
  Add one
</button>
<Tooltip positioning={{ placement: 'top' }} openDelay={200}>
  <Tooltip.Trigger
    type="button" class="btn-icon preset-tonal-primary" aria-label="Reset counter"
    disabled={!ready} onclick={() => count = 0}
  >
    {#snippet element(attributes)}
      <button {...attributes}>
        <RotateCcw aria-hidden="true" focusable="false" />
      </button>
    {/snippet}
  </Tooltip.Trigger>
  <Portal>
    <Tooltip.Positioner class="z-50">
      <Tooltip.Content class="card max-w-[min(var(--available-width,100vw),calc(100vw_-_2rem))] preset-filled-surface-100-900 p-3 shadow-xl">
        Only this local counter is affected.
      </Tooltip.Content>
    </Tooltip.Positioner>
  </Portal>
</Tooltip>
<p role="status">Count: {count}</p>
```

Pass button attributes and the action to `Tooltip.Trigger` before it merges them with the generated props. Spread those attributes on one real button and keep the icon its direct child. Add one, then focus or hover Reset counter, dismiss the supplementary tooltip with Escape, and activate Reset counter by keyboard. Verify the button stays named when closed and the panel fits a narrow viewport.

## Finite runtime selection

Use a finite typed whitelist of statically imported **component values**. Svelte 5 renders `<SelectedIcon />` directly; do not use legacy `svelte:component`, `SvelteComponentTyped`, a namespace/all-icon registry, or arbitrary user-derived `import()` paths. All runtime-reachable whitelist entries can remain in the bundle; tree-shaking cannot remove an entry merely because it is not selected initially.

For data-driven navigation, map validated keys to statically imported icons with `satisfies Record<string, LucideIcon>`. Narrow unknown keys with `Object.hasOwn` before indexing; an unknown key should leave a working text link. Generate reusable fragment targets with `$props.id()`, and validate external destinations separately.

**File: `RuntimeIconLinks.svelte`**
```svelte
<script lang="ts">
  import type { LucideIcon } from '@lucide/svelte';
  import House from '@lucide/svelte/icons/house';
  import Settings from '@lucide/svelte/icons/settings';

  const id = $props.id();
  const icons = { home: House, settings: Settings } satisfies Record<string, LucideIcon>;
  function isIconKey(key: string): key is keyof typeof icons {
    return Object.hasOwn(icons, key);
  }
  const items = [
    { icon: 'home', label: 'Overview', target: 'overview', text: 'Local overview content.' },
    { icon: 'settings', label: 'Preferences', target: 'preferences', text: 'No preferences are saved here.' },
    { icon: 'unknown', label: 'Additional information', target: 'info', text: 'Unknown keys retain usable text links.' }
  ];
</script>

<nav aria-label="On this page">
  <ul>
    {#each items as item (item.target)}
      <li>
        <a href={`#${id}-${item.target}`}>
          {#if isIconKey(item.icon)}
            {@const SelectedIcon = icons[item.icon]}
            <SelectedIcon aria-hidden="true" focusable="false" />
          {/if}
          {item.label}
        </a>
      </li>
    {/each}
  </ul>
</nav>
{#each items as item (item.target)}
  <section id={`${id}-${item.target}`}>
    <h2>{item.label}</h2>
    <p>{item.text}</p>
  </section>
{/each}
```

The raw strings model external data, but the destinations are local, real targets and work without client JavaScript. Mount two copies and confirm links target only their own instance.

See [advanced patterns](lucide-patterns.md) for a reactive typed consumer. Keep component values in Svelte modules; serialized SvelteKit load data carries validated keys and other serializable values, not component functions.

## Subtree defaults

`setLucideProps` from the public `@lucide/svelte/context` entry sets context during **component instance initialization**. Pass an object, not a getter/factory. Do not call it in a module script, load function, mutable global singleton, event callback, or `onMount`. Descendants look up the object from their nearest Lucide context; a later reassignment of a variable holding that object does not update the captured reference, and a plain object is not reactive. Use it for static defaults. Use [explicit reactive props](lucide-patterns.md#reactive-consumer) for runtime changes rather than depending on context object mutation. `currentColor` can still follow CSS theme changes.

Save these two files together and mount `IconDefaults.svelte`. Neither needs a Skeleton stylesheet:

**File: `IconDefaults.svelte`**
```svelte
<script lang="ts">
  import { setLucideProps } from '@lucide/svelte/context';
  import IconDefaultsChild from './IconDefaultsChild.svelte';

  setLucideProps({ size: 32, color: 'currentColor', strokeWidth: 1, class: 'local-defaults' });
</script>

<IconDefaultsChild />
```

**File: `IconDefaultsChild.svelte`**
```svelte
<script lang="ts">
  import Camera from '@lucide/svelte/icons/camera';
</script>

<p>
  <Camera aria-hidden="true" focusable="false" />
  Inherited: size 32 and stroke width 1.
</p>
<p>
  <Camera size={20} strokeWidth={2} aria-hidden="true" focusable="false" />
  Explicit: size 20 and stroke width 2; the context class still applies.
</p>
```

Inspect the dimensions, stroke, and classes outside styled buttons. Mount the child alone as a sibling of the provider, with no other Lucide context: its first camera uses Lucide's defaults of 24 and 2 without `local-defaults`.

## Custom icons and Lab boundary

The generic public `Icon` accepts **exactly one** of `icon: LucideIconData` or `iconNode: LucideIconNode[]`. Use `LucideIcon` for ordinary icon-component maps; the generic custom `Icon` has additional required data props. Avoid deprecated `IconNode` aliases. Keep custom geometry static and trusted, not arbitrary SVG/HTML from external input.

**File: `CustomIcon.svelte`**
```svelte
<script lang="ts">
  import { Icon, type LucideIconNode } from '@lucide/svelte';

  const iconNode: LucideIconNode[] = [
    ['circle', { cx: 12, cy: 12, r: 9 }],
    ['path', { d: 'M8 12h8M12 8v8' }]
  ];
</script>

<Icon {iconNode} size={32} role="img" aria-label="Addition symbol in a circle" focusable="false" />
```

See [advanced patterns](lucide-patterns.md) for composition, RTL, and custom data, including optional Lab data. Lab is a separate dependency, not needed for core icons.

## Troubleshooting

| Symptom | Diagnose and correct |
| --- | --- |
| “No default export” at the root, or “no exported member” at a per-icon path | Root components use named imports (`{ Camera }`); `@lucide/svelte/icons/camera` uses a default import (`Camera`). Confirm the exact public mapping; do not import an internal `.svelte`/`dist` path to bypass it. |
| A catalog icon or old name cannot resolve | Check the actual installed version, canonical declaration, alias replacement, and public per-icon file using the [discovery workflow](#discover-and-verify-an-icon). The live catalog, a different workspace package, or a removed brand may explain the mismatch. |
| `size` seems ignored, or a button icon changes size | Inspect computed `width`/`height`: Tailwind `size-*` and Skeleton direct-child button CSS can override SVG attributes. Keep the SVG a direct child where intended; remove conflicting utilities instead of assuming prop or class-token order wins. |
| Stroke or color differs from props/context | Inspect computed `stroke`, `stroke-width`, inherited `color`, raw SVG attributes, and global `.lucide` rules. CSS overrides presentation attributes; raw `stroke-width` overrides generated attributes. `currentColor` needs a suitable foreground. Use `nonScalingStroke` for CSS-resized non-scaling strokes; `absoluteStrokeWidth` is deprecated, not removed. |
| An icon is unexpectedly exposed, unnamed, or announced twice | A child snippet or an own non-nullish `aria-*`, `role`, or `title` prop stops Lucide from generating automatic hiding, but does not necessarily name the icon. Explicitly hide decorative SVGs and name the control; give meaningful SVGs `role="img"` plus a name. Check the accessibility tree, not only visual tooltips. |
| Defaults are missing or do not update | Set `setLucideProps` from `@lucide/svelte/context` during ancestor instance initialization with an object. Check subtree scope and explicit overrides. Pass reactive props for runtime changes. |
| Development traverses many modules, or a bundle is unexpectedly large | Check for namespace imports, an all-icon registry, or an oversized runtime map; use finite static imports. Root named imports are tree-shakeable, so distinguish traversed module graph from retained production output and inspect the actual bundle before claiming savings. |
| Props/types disagree with an example, or resolution differs by workspace | Read the resolved package metadata and lockfile in the consuming app; confirm the intended 1.77.0 package, Svelte 5 peer, and public export conditions. Match source/docs to that version before changing code; do not switch to deprecated `lucide-svelte` or add SSR workarounds. |

## Verification

1. Inspect SSR HTML for inline SVG; mount duplicate instances to check label and title associations and hydration warnings.
2. Inspect the accessibility tree: controls keep their names, decorative SVGs stay hidden, and meaningful SVGs appear as named images. Unknown icon keys leave working text controls.
3. On the tooltip trigger, check keyboard focus, hover, Escape, visible focus, and the trigger name when closed. Check the supplementary description when open and verify the tooltip fits a 320 CSS-pixel viewport.
4. Inspect computed dimensions, stroke width, `currentColor`, contrast, and focus in light, dark, and forced-color settings. Check selective mirroring in RTL.
5. Inspect the actual bundle before claiming size or speed improvements from import choices.

These are verification requirements, not a claim that every downstream project has passed them. See [sources and verification](sources.md) for recorded evidence.

Primary references: [official icon catalog](https://lucide.dev/icons/), [official Svelte guide](https://lucide.dev/guide/svelte/), [1.77.0 package metadata](https://registry.npmjs.org/@lucide/svelte/1.77.0), [public root declarations](https://unpkg.com/@lucide/svelte@1.77.0/dist/lucide-svelte.d.ts), [canonical export mappings](https://unpkg.com/@lucide/svelte@1.77.0/dist/icons/index.d.ts), [rename aliases](https://unpkg.com/@lucide/svelte@1.77.0/dist/aliases/aliases.d.ts), [per-icon public entry](https://unpkg.com/@lucide/svelte@1.77.0/dist/icons/camera.js), [per-icon declaration](https://unpkg.com/@lucide/svelte@1.77.0/dist/icons/camera.svelte.d.ts), [exact Icon implementation](https://unpkg.com/@lucide/svelte@1.77.0/dist/Icon.svelte), [public types](https://unpkg.com/@lucide/svelte@1.77.0/dist/types.d.ts), [context implementation](https://unpkg.com/@lucide/svelte@1.77.0/dist/context.js), [SVG construction](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/buildLucideIconNode.js), [automatic hiding detection](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/hasA11yProp.js), and [Skeleton button sizing](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/src/utilities/buttons.css).
