# Use Skeleton UI selectively

Bits UI is an independent headless Svelte library. Skeleton provides a Tailwind-based design system (`@skeletonlabs/skeleton`) and a separate package of styled, Zag-backed Svelte components (`@skeletonlabs/skeleton-svelte`). Neither component library depends on the other. Skeleton core CSS can style native or Bits UI markup through themes, tokens, and utility classes; it does not apply Skeleton's widget styles to Bits UI automatically.

## Choose the smallest change

- **Existing Skeleton app:** keep compatible widgets, theme CSS, and providers. Use the same widget family for adjacent work unless a requirement warrants a change. No migration is required to use this skill.
- **New custom widget:** use native HTML if sufficient, then prefer Bits UI when it covers the behavior. Choose a Skeleton component instead when the app already follows its design system or when its built-in behavior avoids a custom implementation.
- **Both packages in one app:** use separate widget roots. Do not interchange trigger/content parts, context providers, controlled callbacks, or generated ARIA props. Share app state and theme tokens, not internal widget state. Verify focus, Escape, stacking, and theme inheritance when overlay systems meet.

Open the [runtime inventory](#runtime-inventory) to find a Skeleton export, the [composition contracts](#composition-contracts) to customize one, or the [optional recipes](skeleton-recipes.md) for complete components.

## Add styled Skeleton components

For a Bun-managed app using the reference versions, install both packages if they are not present. Check the [component manifest](https://registry.npmjs.org/@skeletonlabs%2Fskeleton-svelte/5.0.6) for the resolved Svelte peer (`^5.40.0` at 5.0.6). Bits UI is not part of this installation.

```sh
bun add --dev --exact @skeletonlabs/skeleton@5.0.6 @skeletonlabs/skeleton-svelte@5.0.6
```

Use the existing [Tailwind/Vite configuration](setup.md#global-css-and-dependency-scanning). In that global stylesheet, load the component CSS after core and before the chosen theme. Keep a single import per stylesheet; set `data-theme` to the imported theme on the relevant ancestor, including the portal destination if needed. Importing the framework stylesheet replaces the old manual Skeleton `dist` scan; continue registering any shared app source outside Tailwind's automatic scan.

```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';
@import '@skeletonlabs/skeleton/themes/cerberus';
```

**Core only** supplies framework-agnostic Tailwind tokens, themes, presets, and classes for semantic HTML; it adds no validation, persistence, focus management, or dismissal. See the [local native class guide](styling.md#optional-skeleton-classes-for-native-markup), including [native dialog and disclosure](styling.md#native-dialogs-disclosures-and-decorative-geometry), and upstream [Badges](https://www.skeleton.dev/docs/svelte/tailwind-components/badges.md), [Chips](https://www.skeleton.dev/docs/svelte/tailwind-components/chips.md), and [Placeholders](https://www.skeleton.dev/docs/svelte/tailwind-components/placeholders.md). Add the forms plugin only if using Skeleton's documented styled native form classes.

**Framework package** supplies Svelte roots, anatomy, factories, and their stylesheet. Native controls remain the simpler choice when their behavior is enough. Include the relevant hidden-input anatomy when a Skeleton widget must submit through a native form. Neither layer handles application data or guarantees accessible names, content, contrast, and integration.

## Capabilities beyond the Bits UI catalog

| Need | Skeleton component | Check before shipping |
| --- | --- | --- |
| Transient notification queue | [Toast](https://www.skeleton.dev/docs/svelte/framework-components/toast.md) | Create a `createToaster` instance and mount one `Toast.Group` for it. Keep essential information in persistent UI; check pause, dismissal, and focus. |
| Slides with navigation and indicators | [Carousel](https://www.skeleton.dev/docs/svelte/framework-components/carousel.md) | Prefer manual navigation. Verify keyboard controls and provide a pause mechanism if slides advance automatically. |
| File picker with dropzone and removable selections | [FileUpload](https://www.skeleton.dev/docs/svelte/framework-components/file-upload.md) | Keep a keyboard-operable picker. The component selects files; upload and server validation remain application work. |
| Editable tokens | [TagsInput](https://www.skeleton.dev/docs/svelte/framework-components/tags-input.md) | Check add, edit, remove, duplicate handling, and submitted values. |
| Multi-step progress and controls | [Steps](https://www.skeleton.dev/docs/svelte/framework-components/steps.md) | Keep validation, authorization, and navigation in application code. |
| Managed hierarchical items | [TreeView](https://www.skeleton.dev/docs/svelte/framework-components/tree-view.md) | Reserve it for a real tree interaction; verify arrow navigation, expansion, and selection. Use ordinary links for simple navigation. |
| Scannable code with optional download | [QrCode](https://www.skeleton.dev/docs/svelte/framework-components/qr-code.md) | Verify the encoded destination and retain a readable link or text alternative. |

## Runtime inventory

This is the 31-component root inventory of [`@skeletonlabs/skeleton-svelte@5.0.6`](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.js), including structural helpers and the entries marked **beta** in the 5.0.6-era catalog. It is not a count of documentation pages: linear and circular progress share `Progress`, and helpers like `Portal` count as components. Links are upstream Svelte documentation; anatomy is representative, not exhaustive. Check installed types if current docs differ.

### Layout, navigation, and disclosure

| Root | Purpose and representative anatomy |
| --- | --- |
| [`AppBar`](https://www.skeleton.dev/docs/svelte/framework-components/app-bar.md) | Header: `.Toolbar`, `.Lead`, `.Headline`, `.Trail`. |
| [`Navigation`](https://www.skeleton.dev/docs/svelte/framework-components/navigation.md) | Navigation shell: `.Header`, `.Content`, `.Group`, `.Label`, `.Menu`, `.Trigger`, `.TriggerAnchor`, `.TriggerText`, `.Footer`. Use real anchors for destinations. |
| [`Tabs`](https://www.skeleton.dev/docs/svelte/framework-components/tabs.md) | Local panels: `.List`, `.Trigger`, `.Indicator`, `.Content` with matching strings. Programmatic selection does not navigate an anchor; physical activations should preserve modified clicks. |
| [`Accordion`](https://www.skeleton.dev/docs/svelte/framework-components/accordion.md) | Disclosure group: `.Item`, `.ItemTrigger`, `.ItemIndicator`, `.ItemContent`. Wrap triggers in actual headings. |
| [`Collapsible`](https://www.skeleton.dev/docs/svelte/framework-components/collapsible.md) | Single disclosure: `.Trigger`, `.Indicator`, `.Content`. Preserve native button disabling if replacing the default trigger. |
| [`Pagination`](https://www.skeleton.dev/docs/svelte/framework-components/pagination.md) | Count-based paging: `.FirstTrigger`, `.PrevTrigger`, `.Item`, `.Ellipsis`, `.NextTrigger`, `.LastTrigger`, `.Context`. The app slices or fetches rows; [choose the correct button/link anatomy](skeleton-recipes.md#pagination-controlled-local-table). |
| [`Steps`](https://www.skeleton.dev/docs/svelte/framework-components/steps.md) | Workflow: `.List`, `.Item`, `.Trigger`, `.Indicator`, `.Separator`, `.Content`, `.PrevTrigger`, `.NextTrigger`. `aria-current="step"` is on the trigger; the item has `data-current`, `data-complete`, or `data-incomplete`. It does not route or validate. |
| [`Carousel`](https://www.skeleton.dev/docs/svelte/framework-components/carousel.md) | Slides: `.ItemGroup`, `.Item`, `.Control`, `.PrevTrigger`, `.NextTrigger`, `.IndicatorGroup`, `.Indicator`, `.AutoplayTrigger`, `.ProgressText`. Prefer user-controlled movement. |
| [`TreeView`](https://www.skeleton.dev/docs/svelte/framework-components/tree-view.md) | Hierarchy: `.Tree`, `.Label`, `.NodeProvider`, `.Branch`, `.BranchControl`, `.BranchText`, `.BranchIndicator`, `.BranchContent`, `.BranchIndentGuide`, `.Item`; `createTreeViewCollection`. |
| [`Marquee`](https://www.skeleton.dev/docs/svelte/framework-components/marquee.md) **beta** | Continuous content: `.Viewport`, `.Content` with `index`, `.Edge` with `side`, `.Context`; render copies from `api().contentCount`. `autoFill` and `pauseOnInteraction` are supported. Provide static access, pause, and [reduced motion](accessibility.md#contrast-motion-and-scale). |

### Input and selection

| Root | Purpose and representative anatomy |
| --- | --- |
| [`Switch`](https://www.skeleton.dev/docs/svelte/framework-components/switch.md) | Boolean: `.Control` → `.Thumb`, `.Label`, `.HiddenInput`; the root is already a label. |
| [`SegmentedControl`](https://www.skeleton.dev/docs/svelte/framework-components/segmented-control.md) | Radio-style choice: `.Label`, `.Control`, `.Indicator`, `.Item`, `.ItemText`, `.ItemHiddenInput`. |
| [`ToggleGroup`](https://www.skeleton.dev/docs/svelte/framework-components/toggle-group.md) | Toggle buttons: `.Item`; not radio-style segmented selection. |
| [`Slider`](https://www.skeleton.dev/docs/svelte/framework-components/slider.md) | Numeric range: `.Label`, `.ValueText`, `.Control`, `.Track`, `.Range`, `.Thumb`, `.HiddenInput`, `.MarkerGroup`, `.Marker`. Name each thumb. |
| [`RatingGroup`](https://www.skeleton.dev/docs/svelte/framework-components/rating-group.md) | Rating input or read-only score: `.Label`, `.Control`, `.Item`, `.HiddenInput`. |
| [`TagsInput`](https://www.skeleton.dev/docs/svelte/framework-components/tags-input.md) | Editable tokens: `.Label`, `.Control`, `.Input`, `.Item`, `.ItemPreview`, `.ItemText`, `.ItemInput`, `.ItemDeleteTrigger`, `.ClearTrigger`, `.HiddenInput`. |
| [`FileUpload`](https://www.skeleton.dev/docs/svelte/framework-components/file-upload.md) | File selection: `.Label`, `.Dropzone`, `.Trigger`, `.HiddenInput`, `.ItemGroup`, `.Item`, `.ItemName`, `.ItemSizeText`, `.ItemDeleteTrigger`, `.ClearTrigger`. It does not upload. |
| [`Combobox`](https://www.skeleton.dev/docs/svelte/framework-components/combobox.md) | Searchable selection: `.Label`, `.Control`, `.Input`, `.Trigger`, `.ClearTrigger`, `.Positioner`, `.Content`, `.Item`, `.ItemText`, `.ItemIndicator`; `useListCollection`. The app filters; the widget announces results and supports `loading` and `translations`. |
| [`Listbox`](https://www.skeleton.dev/docs/svelte/framework-components/listbox.md) | Persistent option list: `.Label`, `.Input`, `.Content`, `.ItemGroup`, `.ItemGroupLabel`, `.Item`, `.ItemText`, `.ItemIndicator`. Range selection keeps its anchor across hover and Shift+arrow reversal; horizontal/grid arrows mirror in RTL and typeahead accepts lowercase `a`. |
| [`DatePicker`](https://www.skeleton.dev/docs/svelte/framework-components/date-picker.md) | Calendar: `.Label`, `.Control`, `.Input`, `.Trigger`, `.Positioner`, `.Content`, `.View`, `.ViewControl`, `.PrevTrigger`, `.ViewTrigger`, `.NextTrigger`, `.Table`; `parseDate` constructs values. Space selects the focused date; the grid is named for the visible month in `locale` and `translations.placeholder` reaches the input. Off-decade years are selectable unless out of bounds; range edits commit to the edited field. |

### Display, floating content, and feedback

| Root | Purpose and representative anatomy |
| --- | --- |
| [`Avatar`](https://www.skeleton.dev/docs/svelte/framework-components/avatar.md) | Image and fallback: `.Image`, `.Fallback`. |
| `Progress` | [Linear](https://www.skeleton.dev/docs/svelte/framework-components/progress-linear.md): `.Label`, `.ValueText`, `.Track`, `.Range`; [circular](https://www.skeleton.dev/docs/svelte/framework-components/progress-circular.md): `.Circle`, `.CircleTrack`, `.CircleRange`. Name the progressbar and report actual progress; use its indeterminate contract when unknown. |
| [`QrCode`](https://www.skeleton.dev/docs/svelte/framework-components/qr-code.md) **beta** | Scannable output: `.Frame`, `.Pattern`, `.Overlay`, `.DownloadTrigger`, `.Context`, `.Provider`; `useQrCode`. Keep a readable alternative. |
| [`Tooltip`](https://www.skeleton.dev/docs/svelte/framework-components/tooltip.md) | Supplemental noninteractive help: `.Trigger`, `.Positioner`, `.Content`, optional `.Arrow`, `.ArrowTip`. |
| [`Popover`](https://www.skeleton.dev/docs/svelte/framework-components/popover.md) | Interactive contextual surface: `.Trigger`, `.Positioner`, `.Content`, `.Title`, `.Description`, `.CloseTrigger`, `.Arrow`, `.ArrowTip`. |
| [`Dialog`](https://www.skeleton.dev/docs/svelte/framework-components/dialog.md) | Modal or styled drawer: `.Trigger`, `.Backdrop`, `.Positioner`, `.Content`, `.Title`, `.Description`, `.CloseTrigger`. Preserve default modal focus behavior; the inherited version includes fixes for immediate Escape and nonmodal focus return. |
| [`Menu`](https://www.skeleton.dev/docs/svelte/framework-components/menu.md) | Action menu: `.Trigger`, `.ContextTrigger`, `.Positioner`, `.Content`, `.Item`, `.OptionItem`, `.TriggerItem`, `.ItemText`, `.ItemIndicator`, `.ItemGroup`, `.Separator`. `initialFocusEl`/`finalFocusEl` customize focus. Preserve modified Enter on anchors; `onSelect` exposes `modifiers`, but should not navigate an anchor twice. |
| [`FloatingPanel`](https://www.skeleton.dev/docs/svelte/framework-components/floating-panel.md) | Movable/resizable window: `.Trigger`, `.Positioner`, `.Content`, `.Header`, `.Title`, `.DragTrigger`, `.Control`, `.StageTrigger`, `.CloseTrigger`, `.Body`, `.ResizeTrigger`. Use `z-index: var(--z-index)` on the positioner; plan small-screen fit and [non-drag alternatives](accessibility.md#focus-visibility-and-drag-alternatives). |
| [`Toast`](https://www.skeleton.dev/docs/svelte/framework-components/toast.md) | Notifications: `.Group` hands a toast record to its children snippet; `<Toast {toast}>`, `.Message`, `.Title`, `.Description`, `.ActionTrigger`, `.CloseTrigger`; `createToaster`. |
| [`Portal`](https://www.skeleton.dev/docs/svelte/framework-components/portal.md) | Places floating anatomy outside clipping ancestors. Supports `target` and `disabled`; see the portal contract below. |
| [`LocaleProvider`](https://www.skeleton.dev/docs/svelte/framework-components/locale-provider.md) **beta** | `<LocaleProvider locale="en-US">` and `.Context` provide locale and derived direction without a DOM wrapper. The app still owns translation and document `lang`/`dir`. |

There is no `Drawer`, `Stepper`, `Select`, `Checkbox`, `Radio`, `Alert`, `Clipboard`, or `PinInput` root in 5.0.6. Do not import a name inferred from another major or from Zag. Use the root names above, native controls, or the [default Bits UI decision](components.md) for a new widget.

## Composition contracts

1. **Anatomy and state.** Import callable roots (`<Tabs>`, not `<Tabs.Root>`); keep named parts under the same root and match trigger/content values. Controlled props are data in, callback details are data out: Tabs uses `value: string` and `onValueChange(e)` → `e.value`; Accordion uses `value: string[]` and the same callback, not `open`/`onOpenChange`; Switch uses `checked` and `onCheckedChange(e)` → `e.checked`. Verify defaults per root and do not assume bindability. Native inputs still use ordinary Svelte bindings.
2. **Snippets and transitions.** `element(attributes)` overrides the concrete tag; spread all supplied attributes on the real semantic element to preserve IDs, roles, hidden state, and handlers. This is not Bits UI's `child` snippet. Ordinary children do not receive a machine API; use `.Context` with `children(api)` and call `api()` for current state. `Toast.Group` instead passes a toast record. Accordion content stays mounted but hidden unless you deliberately replace it: an `element` snippet can render `<div {...attributes} transition:slide={{ duration }}>…</div>` inside `{#if !attributes.hidden}`, unmounting after exit. Keep duration zero until mounted, subscribe to `prefers-reduced-motion` on the client, and clean up the listener; CSS alone cannot set a Svelte transition duration.
3. **Portals, themes, and SSR.** Wrap the actual floating positioner/backdrop as appropriate. `Portal` defaults to `document.body` in the browser, carries Svelte context, and does not carry DOM-derived theme, scheme, or scoped ancestor selectors. Put theme/scheme on `<html>` or choose a `target` within the correct scope. `disabled` renders inline; the default portal also renders inline on the server without a browser target. Its client effect mounts into the target. Start closed with stable initial state; use `$props.id()` for custom associations and read browser-only targets after mount. Preserve generated styles/attributes and verify Escape, outside clicks, focus return, and layer order in the actual layout, especially with nested overlays or different widget families.
4. **Providers.** Factories such as `useTooltip` and `useTabs` return getters. Pass a stable ID from `$props.id()` and a reactive props getter for controlled state; pass the returned getter as `.Provider`'s `value`, not its result. Call it for imperatives (`tooltip().setOpen(true)`). Own machines and stores per component or layout instance, not a mutable server-module singleton. A provider replaces its matching root; a `Toast.Group` renderer and its store use a different contract.
5. **Class and state.** Style real anatomy via `class` and documented attributes, e.g. `data-[state=active]:…` on `Tabs.Trigger` and `data-[state=checked]:…` on `Switch.Control`. Keep focus indicators. Dialog and Tooltip roots are context wrappers, not arbitrary-attribute DOM elements; place classes on their triggers, content, or positioners. Do not copy removed per-part style props.
6. **Icon triggers.** Use a decorative Lucide SVG as a direct child of the actual button, either as ordinary trigger children or inside a replacement button that receives all `element` attributes. Never nest a button. Pass `type="button"` and the accessible name on the trigger; `aria-hidden="true"` and `focusable="false"` belong on the decorative icon. Do not rely on the tooltip for the name or gate Lucide rendering on mount: any readiness gate applies to the JavaScript interaction, not the SVG. See [Lucide semantics](lucide.md#accessible-icons-and-controls); its Bits snippet syntax is separate.

**File: `ProviderTooltip.svelte`** (same global setup as the [optional recipes](skeleton-recipes.md)):

```svelte
<script lang="ts">
  import { Portal, Tooltip, useTooltip } from '@skeletonlabs/skeleton-svelte';
  const id = $props.id();
  const tooltip = useTooltip(() => ({ id, openDelay: 200 }));
</script>

<Tooltip.Provider value={tooltip}>
  <Tooltip.Trigger type="button" class="btn preset-tonal-primary">
    {#snippet element(attributes)}
      <button {...attributes}>Keyboard help</button>
    {/snippet}
  </Tooltip.Trigger>
  <Portal>
    <Tooltip.Positioner class="z-50">
      <Tooltip.Content class="card preset-filled-surface-100-900 p-3 shadow-xl">
        Press Tab to move between controls.
      </Tooltip.Content>
    </Tooltip.Positioner>
  </Portal>
</Tooltip.Provider>
<p>Help is {tooltip().open ? 'open' : 'closed'}.</p>
```

Focus or hover the button and press Escape to check that the getter tracks the widget. The [upstream fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md) cover the patterns; check exact installed declarations for names and callback details when a prose example drifts.

## Installed types and package boundaries

1. Read the app manifest, resolved lockfile, and installed package metadata through the workspace's dependency layout. The 5.0.6 component package exports only `.` with types, import, Svelte, and style conditions (`dist/index.d.ts`, `dist/index.js`, `dist/index.css`). No `/composed` subpath exists. Core exports `src/index.css` through its root, `themes/*`, and metadata; presets are already in core, not a separate import.
2. Follow `dist/index.d.ts` or `dist/index.js` → `components/<kebab-name>/index.d.ts` or `index.js` → `modules/anatomy.d.ts` for callable roots and named parts. Read `anatomy/*.svelte.d.ts` for required props, snippets, and bindable metadata. Internal file paths are for inspection, not application imports.
3. Read `anatomy/*.svelte` and `modules/provider.svelte.js` for actual tags, attribute merging, getter/context behavior, lifecycle, and event forwarding. For inherited behavior, use the resolved `@zag-js/<primitive>` declarations/source (Zag **1.48.0** in 5.0.6), not a direct app dependency. Account for the wrapper's omitted or narrowed props. The public `useListCollection` helper returns `ListCollection<T, never>` in this release; inferred calls do not need rewriting.
4. For styles, inspect core `src/index.css` and its imports plus Svelte `dist/index.css`, which imports Common at the base layer. The bundled Navigation rail gap and QrCode Firefox output fixes do not need application workarounds: [Common 5.0.3](https://github.com/skeletonlabs/skeleton/releases/tag/@skeletonlabs%2Fskeleton-common@5.0.3), [5.0.4](https://github.com/skeletonlabs/skeleton/releases/tag/@skeletonlabs%2Fskeleton-common@5.0.4).

Other runtime exports: `useAccordion`, `useAvatar`, `useCarousel`, `useCollapsible`, `useCombobox`, `useDatePicker`, `useDialog`, `useFileUpload`, `useFloatingPanel`, `useListbox`, `useMarquee`, `useMenu`, `usePagination`, `usePopover`, `useProgress`, `useQrCode`, `useRatingGroup`, `useSegmentedControl`, `useSlider`, `useSteps`, `useSwitch`, `useTabs`, `useTagsInput`, `useToggleGroup`, `useTooltip`, `useTreeView`, `useListCollection`, `createToaster`, `createTreeViewCollection`, and `parseDate`. Prop interfaces are type-only exports.

Sources: [Svelte docs index](https://www.skeleton.dev/llms-svelte.txt), [5.0.6 public declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.d.ts), [component export map](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/package.json), [exact Portal source](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/components/portal/anatomy/root.svelte), [core CSS](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/src/index.css). For an upgrade, use the upstream guide for the installed major, such as [v4 to v5](https://www.skeleton.dev/docs/svelte/get-started/migrate-from-v4.md), and verify rendered behavior. For a deliberate change of interaction library, see [migration](migration.md).
