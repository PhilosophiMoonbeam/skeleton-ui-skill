# Skeleton v3 component selection

This catalog targets **`@skeletonlabs/skeleton@3.2.2`** and **`@skeletonlabs/skeleton-svelte@1.5.3`**, not the current Skeleton major. The component package is versioned independently. Its [published root declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/index.d.ts) list every root export; all functional rows below appear there. Examples use Svelte 5 snippets and callback props.

## Functional components: root import

Import named components from `@skeletonlabs/skeleton-svelte`. A dot does not imply a universal compound API: only the members listed below exist on the corresponding v3 root component. Use [recipes](recipes.md) for complete runnable examples.

### Layout, navigation, and disclosure

| Export / supported members | Choose for | v3 API shape and primary source |
| --- | --- | --- |
| `AppBar` | Application header and toolbar | `children` is the center snippet; `lead`, `trail`, `headline` are optional snippets. [Docs](https://v3.skeleton.dev/docs/components/app-bar/svelte) |
| `Navigation`, `.Rail`, `.Bar`, `.Tile` | Navigation rail or compact bar | `Navigation` itself is the rail. Tile `href` creates an anchor; otherwise it is a button. Root `onValueChange` receives a **string ID**, not `{ value }`. [Docs](https://v3.skeleton.dev/docs/components/navigation/svelte), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Navigation/types.d.ts) |
| `Tabs`, `.Control`, `.Panel` | Switch between related local panels | Root `list` and `content` snippets; control and panel share a string `value`. Controlled state uses `onValueChange(details.value)`. [Docs](https://v3.skeleton.dev/docs/components/tabs/svelte) |
| `Accordion`, `.Item` | Expandable FAQ or disclosure sections | Root value is `string[]`; each item requires a `control` snippet and accepts optional `panel` and `lead` snippets. Set `collapsible` to allow all items to close; set `multiple` for independent expansion. [Docs](https://v3.skeleton.dev/docs/components/accordion/svelte) |
| `Pagination` | Page controls for a data set | Requires full `data: unknown[]`. Controlled `page` is one-based; `pageSize` is numeric. `onPageChange(details.page)` changes the page; the application renders its own slice and safely resets or clamps the page when size changes. [Complete recipe](recipes.md#pagination-controlled-local-table), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Pagination/types.d.ts) |

Use real links for destinations, not Tabs or selected navigation buttons as a substitute for routing. Keep labels present and preserve the components' generated roles, IDs, focus management, and keyboard handlers.

### Input and selection

| Export / supported members | Choose for | v3 API shape and primary source |
| --- | --- | --- |
| `Switch` | Immediate boolean preference | `checked` plus `onCheckedChange(details.checked)`; visible `children` label. Optional `inactiveChild`/`activeChild` snippets. [Docs](https://v3.skeleton.dev/docs/components/switch/svelte) |
| `Segment`, `.Item` | A small mutually exclusive option set | Radio-group semantics; matching item string values, root `value` plus `onValueChange(details.value)` (string or null). `labelledby` names the group. [Docs](https://v3.skeleton.dev/docs/components/segment/svelte), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Segment/types.d.ts) |
| `Slider` | Numeric value or multi-thumb range | Numeric-array `value`, `onValueChange(details.value)`; optional numeric `markers` and `mark: Snippet<[number]>`. Name each thumb with inherited `aria-label: string[]` or `aria-labelledby: string[]`. [Docs](https://v3.skeleton.dev/docs/components/slider/svelte), [Zag types](https://unpkg.com/@zag-js/slider@1.18.3/dist/index.d.ts) |
| `Rating` | Numeric rating input or read-only score | Numeric `value`, `onValueChange(details.value)`; `label`, `iconEmpty`, `iconHalf`, `iconFull` snippets. [Docs](https://v3.skeleton.dev/docs/components/rating/svelte) |
| `TagsInput` | Editable tokens or tags | String-array `value`, `onValueChange(details.value)`; `placeholder` and optional `buttonDelete` snippet. [Docs](https://v3.skeleton.dev/docs/components/tags-input/svelte) |
| `FileUpload` | File picker with drag and drop and a file list | File state and validation come from Zag. `onApiReady(api)` exposes operations; `FileUploadApi` is a root-exported **type**, not a component. Selection does not upload to a server. [Docs](https://v3.skeleton.dev/docs/components/file-upload/svelte), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/FileUpload/types.d.ts) |
| `Combobox` | Search or typeahead selection | `data` is an array of `{ label: string, value: string }` (extra fields allowed); labels must be unique in this wrapper's keyed list. Controlled selection is `value: string[]` plus `onValueChange(details.value)`. `label` names the input; `item: Snippet<[T]>` customizes options. Built-in filtering works unless its input/open callbacks are overridden. [Complete recipe](recipes.md#combobox-searchable-local-selection), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Combobox/types.d.ts) |

Use styled native inputs for plain text, textareas, selects, checkboxes, radio buttons, dates, or simple file or range inputs. These are not imported Svelte components.

### Display, floating content, and feedback

| Export | Choose for | v3 API shape and primary source |
| --- | --- | --- |
| `Avatar` | User image with initials fallback | **Flat root API:** required `name`, optional `src` and `srcset`, optional fallback `children` snippet. The root API has no `Avatar.Image`. [Docs](https://v3.skeleton.dev/docs/components/avatar/svelte), [types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Avatar/types.d.ts) |
| `Progress` | Linear progress, including indeterminate loading | Numeric `value` for determinate progress; optional `children` label snippet. [Docs](https://v3.skeleton.dev/docs/components/progress/svelte) |
| `ProgressRing` | Circular progress | Numeric `value`, optional `label`/`showLabel`; `children` for interior content. [Docs](https://v3.skeleton.dev/docs/components/progress-ring/svelte) |
| `Popover` | Click-triggered contextual content, including interactive controls | `trigger`/`content` snippets, `open` plus `onOpenChange(details.open)`, `positioning`; trigger is already a button. [Integration docs](https://v3.skeleton.dev/docs/integrations/popover/svelte#popover) |
| `Tooltip` | Supplemental short hint on hover/focus | `trigger`/`content` snippets, `open` plus `onOpenChange(details.open)` if controlled, `positioning`. Do not put essential instructions or interactive controls in the tooltip. [Integration docs](https://v3.skeleton.dev/docs/integrations/popover/svelte#tooltip) |
| `Modal` | Dialog, confirmation, or drawer presentation | `trigger`/`content` snippets, `open` plus `onOpenChange(details.open)`; inherited dialog focus/dismissal props. A drawer is **styled Modal**, not a `Drawer` export. [Integration docs](https://v3.skeleton.dev/docs/integrations/popover/svelte#modal) |
| `Toaster` + `createToaster` | Transient notifications | `const toaster = createToaster(options)`; render `<Toaster {toaster}>`; call `toaster.info/success/warning/error` or `.create`. There is no root `Toast` component export. [Docs](https://v3.skeleton.dev/docs/components/toast/svelte) |

The four floating components are documented under **Integrations → Popover**, not `/docs/components/<name>/svelte`. The archive describes them as a temporary solution maintained for production use through v3. Their implementations differ: `Popover` portals its positioner internally (unless `portalled` is false); `Modal` internally portals its backdrop and positioner; `Tooltip` renders its positioner in place. `Combobox` also manages its own positioning. **There is no exported `Portal` wrapper to add indiscriminately.** See the [published component source](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/) when diagnosing clipping or focus behavior. `zIndex` is a raw CSS **string**, such as `"50"`, not `"z-50"` or a number.

## Styled native elements: core CSS, no component imports

These utilities are present in [core 3.2.2 CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css). They style HTML; they do not add application state, validation, dismissal, or ARIA behavior.

| Family / utility classes | Semantic element and selection rule | v3 source |
| --- | --- | --- |
| Buttons: `btn`, `btn-icon`, `btn-group`; `btn-sm/base/lg`, `btn-icon-sm/base/lg` | `<button type="button">` for actions, `<a href>` for links. Icon-only buttons need an accessible name. | [Buttons](https://v3.skeleton.dev/docs/tailwind/buttons) |
| Badges: `badge`, `badge-icon` | Usually `<span>` for a short status/count. | [Badges](https://v3.skeleton.dev/docs/tailwind/badges) |
| Cards: `card`, `card-hover` | `<article>`, `<section>`, or `<div>` according to meaning; `card-hover` does not make a container interactive. | [Cards](https://v3.skeleton.dev/docs/tailwind/cards) |
| Chips: `chip`, `chip-icon` | Static `<span>`, or a properly named `<button>`/`<a>` when actionable. | [Chips](https://v3.skeleton.dev/docs/tailwind/chips) |
| Forms: `fieldset`, `legend`, `label`, `label-text`, `input`, `input-ghost`, `select`, `textarea`, `checkbox`, `radio`, `progress` | Corresponding native HTML elements; associate labels and use `name`/`value` for submission. Native progress is an alternative to functional `Progress`. | [Forms](https://v3.skeleton.dev/docs/tailwind/forms) |
| Input groups: `input-group`, `ig-cell`, `ig-input`, `ig-select`, `ig-btn` | Wrapper plus native text input/select/button; arrange cells with grid utilities and retain an accessible input label. | [Forms: groups](https://v3.skeleton.dev/docs/tailwind/forms#groups) |
| Tables: `table-wrap`, `table` | Scroll wrapper and semantic `<table>` with caption, headers, and cells; not a data-grid component. | [Tables](https://v3.skeleton.dev/docs/tailwind/tables) |
| Dividers: `hr`, `vr` | `<hr>` for horizontal thematic break; decorative vertical `<span class="vr">` with explicit height. | [Dividers](https://v3.skeleton.dev/docs/tailwind/dividers) |
| Loading placeholders: `placeholder`, `placeholder-circle` | Decorative containers; add `animate-pulse` if wanted and communicate loading separately to assistive technology. | [Placeholders](https://v3.skeleton.dev/docs/tailwind/placeholders) |
| Typography: `h1`–`h6`, `anchor`, `blockquote`, `kbd`, `pre`, `code`, `ins`, `del`, `mark` | Use corresponding semantic elements; utility names do not set heading level or turn text into links. | [Typography](https://v3.skeleton.dev/docs/design/typography), [exact CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css) |

Form utilities require the official `@tailwindcss/forms` plugin (`@plugin '@tailwindcss/forms';` after the Tailwind import). Color and preset classes are separate from these structural classes; recipes assume the theme and optional preset stylesheet are installed.

## Optional composed subpath: alpha, not the root API

`@skeletonlabs/skeleton-svelte/composed` exists in 1.5.3, but the archived documentation explicitly marks its two components **alpha and not intended for production use**. This is not a reason to copy current-major compound APIs into root imports.

| Composed export | Exact members in 1.5.3 | Sources |
| --- | --- | --- |
| `Accordion` | `.Item`, `.Heading`, `.Trigger`, `.Indicator`, `.Content` | [Archived alpha docs](https://v3.skeleton.dev/docs/components-composed/accordion/svelte), [published anatomy](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/composed/accordion/modules/anatomy.d.ts) |
| `Avatar` | `.Image`, `.Fallback` | [Archived alpha docs](https://v3.skeleton.dev/docs/components-composed/avatar/svelte), [published anatomy](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/composed/avatar/modules/anatomy.d.ts) |

Neither subpath exports `Avatar.Root`. For production recipes here, use the stable root API.

## If the desired component is absent

The pinned root does **not** export `Alert`, `Dialog`, `Drawer`, `Select`, `Checkbox`, `Radio`, `Clipboard`, `PinInput`, `Portal`, or `useListCollection`. Use styled native markup where suitable, `Modal` for dialogs or drawers, or a separately installed headless Svelte library when richer behavior is needed. The archive documents [Bits UI](https://v3.skeleton.dev/docs/headless/bits-ui) and [Melt UI](https://v3.skeleton.dev/docs/headless/melt-ui) integrations; their APIs and versions are independent of Skeleton. Do not invent Skeleton exports or assume current headless-library examples match an older installed version.

## Offline installed-types lookup

1. Confirm that the lockfile and installed `@skeletonlabs/skeleton-svelte/package.json` resolve to **1.5.3**, and core resolves to **3.2.2**. The component package's root export resolves to `dist/index.d.ts`; `/composed` resolves to `dist/composed/index.d.ts`.
2. Open `node_modules/@skeletonlabs/skeleton-svelte/dist/index.d.ts`. Follow the selected component's `index.d.ts`/`*.svelte.d.ts` to see supported dot members and bindable-prop metadata.
3. Read `dist/components/<Component>/types.d.ts`. `Snippet` means a no-argument snippet unless its tuple says otherwise (e.g. `Combobox`'s `item: Snippet<[T]>`). Style props such as `classes`/`contentBase` are not a universal forwarded HTML `class` API.
4. Follow inherited `@zag-js/<primitive>` declarations in that package's `package.json`/`dist/index.d.ts`. Skeleton 1.5.3 pins its Zag dependencies to **1.18.3**. `extends Omit<...>` is part of the API: for example, root Tabs omits `id` and `orientation` even though Zag supports them.
5. Check shipped `*.svelte` source for rendered tags, callback merging, portal behavior, and `$bindable`. The stable root components shown in the recipes have no bindable state props; use controlled values and callbacks, not `bind:value`/`bind:checked` on them. Native inputs can use Svelte bindings.
6. For styling, inspect core `dist/index.css` and `dist/optional/presets.css`. When offline, installed types and source take precedence over remembered current-site examples.
