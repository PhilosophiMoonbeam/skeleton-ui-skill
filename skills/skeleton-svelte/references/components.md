# Skeleton 5 component selection

Targets **`@skeletonlabs/skeleton@5.0.6`** and **`@skeletonlabs/skeleton-svelte@5.0.6`** with inherited **Zag 1.48.0**, Svelte **5.59.1**, Tailwind **4.3.5**, and SvelteKit **3.4.0** as the exact baseline (support floor **3.1.0**). The CSS-native layer styles semantic HTML; optional framework components add Zag-backed interaction (with structural helpers such as AppBar, Navigation, Portal, and LocaleProvider). Use native controls when their behavior is sufficient. Neither layer persists data or guarantees an accessible application without correct names, content, contrast, and integration.

## Functional components: root import

Import runtime values from `@skeletonlabs/skeleton-svelte`. Roots are callable components: `<Tabs>`, not `<Tabs.Root>`. The 31 component roots below include structural helpers and beta components; this is the published runtime inventory, not a count of documentation pages. The root reexport paths and runtime names are unchanged from 5.0.1; inherited props and behaviors can change without adding exports. Anatomy columns are representative, not exhaustive. See [complete recipes](recipes.md) and installed declarations for exact props.

### Layout, navigation, and disclosure

| Export | Choose for / representative anatomy |
| --- | --- |
| `AppBar` | Header composition: `.Toolbar`, `.Lead`, `.Headline`, `.Trail`. |
| `Navigation` | Navigation shell: `.Header`, `.Content`, `.Group`, `.Label`, `.Menu`, `.Trigger`, `.TriggerAnchor`, `.TriggerText`, `.Footer`. Use real anchors for destinations; the rail gap unit is corrected in the shipped CSS. |
| `Tabs` | Local panels: `.List`, `.Trigger`, `.Indicator`, `.Content`; matching string values. Tab can leave the list immediately after arrow/Home/End navigation without focus snapping back. Programmatic selection does not navigate links; actual anchor triggers preserve modified clicks. |
| `Accordion` | Stateful disclosure groups: `.Item`, `.ItemTrigger`, `.ItemIndicator`, `.ItemContent`; actual HTML headings wrap triggers. |
| `Collapsible` | One disclosure: `.Trigger`, `.Indicator`, `.Content`. `disabled` now disables the default button trigger natively; preserve that behavior when replacing its element. |
| `Pagination` | Count-based page controls: `.FirstTrigger`, `.PrevTrigger`, `.Item`, `.Ellipsis`, `.NextTrigger`, `.LastTrigger`, `.Context`; consumer slices or fetches rows. Default mode is `button`, but `.Item` renders an anchor. `type="link"` configures generated attributes, not the trigger tags; see [link boundaries](recipes.md#pagination-controlled-local-table). |
| `Steps` | Multi-step workflow: `.List`, `.Item`, `.Trigger`, `.Indicator`, `.Separator`, `.Content`, `.PrevTrigger`, `.NextTrigger`. `aria-current="step"` is on the current trigger, not the item; style item state with `data-current`, `data-complete`, or `data-incomplete`. Not a routing or validation engine. |
| `Carousel` | Slide browsing: `.ItemGroup`, `.Item`, `.Control`, `.PrevTrigger`, `.NextTrigger`, `.IndicatorGroup`, `.Indicator`, `.AutoplayTrigger`, `.ProgressText`. Prefer user-controlled movement; apply the [pause and static-content policy](accessibility.md#contrast-motion-and-scale) to autoplay. |
| `TreeView` | Hierarchical selection/navigation: `.Tree`, `.Label`, `.NodeProvider`, `.Branch`, `.BranchControl`, `.BranchText`, `.BranchIndicator`, `.BranchContent`, `.BranchIndentGuide`, `.Item`; `createTreeViewCollection`. |
| `Marquee` **beta** | Continuous content: `.Viewport`, `.Content index`, `.Edge side`, `.Context`; render copies using `api().contentCount`. `autoFill` and `pauseOnInteraction` are supported. Provide a pause policy and respect reduced motion; do not make moving content the only access to information. |

### Input and selection

| Export | Choose for / representative anatomy |
| --- | --- |
| `Switch` | Boolean preference: `.Control` → `.Thumb`, `.Label`, `.HiddenInput`. Root is already a label. |
| `SegmentedControl` | Mutually exclusive options: `.Label`, `.Control`, `.Indicator`, `.Item`, `.ItemText`, `.ItemHiddenInput`. |
| `ToggleGroup` | Toggle buttons: `.Item`; distinct from radio-style segmented selection. |
| `Slider` | Numeric range: `.Label`, `.ValueText`, `.Control`, `.Track`, `.Range`, `.Thumb`, `.HiddenInput`, `.MarkerGroup`, `.Marker`. Name each thumb. |
| `RatingGroup` | Rating input/read-only score: `.Label`, `.Control`, `.Item`, `.HiddenInput`. |
| `TagsInput` | Editable strings: `.Label`, `.Control`, `.Input`, `.Item`, `.ItemPreview`, `.ItemText`, `.ItemInput`, `.ItemDeleteTrigger`, `.ClearTrigger`, `.HiddenInput`. |
| `FileUpload` | File selection/validation: `.Label`, `.Dropzone`, `.Trigger`, `.HiddenInput`, `.ItemGroup`, `.Item`, `.ItemName`, `.ItemSizeText`, `.ItemDeleteTrigger`, `.ClearTrigger`. Selection is not server upload. |
| `Combobox` | Searchable selection: `.Label`, `.Control`, `.Input`, `.Trigger`, `.ClearTrigger`, `.Positioner`, `.Content`, `.Item`, `.ItemText`, `.ItemIndicator`; `useListCollection`. The app filters; the machine announces results or no results and accepts `loading` and `translations`. Do not announce the same results separately. |
| `Listbox` | Persistent option list: `.Label`, `.Input`, `.Content`, `.ItemGroup`, `.ItemGroupLabel`, `.Item`, `.ItemText`, `.ItemIndicator`; collection-driven. Multi-selection ranges keep their anchor through hover and Shift+arrow reversal; horizontal/grid arrows mirror in RTL, and typeahead accepts lowercase `a`. |
| `DatePicker` | Calendar selection: `.Label`, `.Control`, `.Input`, `.Trigger`, `.Positioner`, `.Content`, `.View`, `.ViewControl`, `.PrevTrigger`, `.ViewTrigger`, `.NextTrigger`, `.Table`; `parseDate` constructs date values. Space selects the focused date; the calendar grid is named for the visible month in `locale`, and `translations.placeholder` reaches the input. Year cells outside the viewed decade are selectable unless bounds disallow them; range input commits stay with the edited field. |

Use native `<input>`, `<select>`, `<textarea>`, checkbox, radio, date, file, or range elements for simpler requirements. Include the relevant hidden-input anatomy when a framework control must participate in native form submission.

### Display, floating content, and feedback

| Export | Choose for / representative anatomy |
| --- | --- |
| `Avatar` | Image/fallback: `.Image`, `.Fallback`. |
| `Progress` | Both linear `.Label`, `.ValueText`, `.Track`, `.Range` and circular `.Circle`, `.CircleTrack`, `.CircleRange` anatomy. Name the progressbar; a visible percentage alone is not a name. Report actual progress, not an interpolated presentation value; use the installed indeterminate contract when progress is unknown. |
| `QrCode` **beta** | QR output: `.Frame`, `.Pattern`, `.Overlay`, `.DownloadTrigger`, `.Context`, `.Provider`; factory `useQrCode`. Shipped CSS includes the [upstream Firefox output fix](https://github.com/skeletonlabs/skeleton/releases/tag/@skeletonlabs%2Fskeleton-common@5.0.4); no application workaround or local Firefox verification is implied. Preserve a readable text/link alternative. |
| `Tooltip` | Supplemental noninteractive help: `.Trigger`, `.Positioner`, `.Content`, optional `.Arrow`/`.ArrowTip`. |
| `Popover` | Interactive contextual surface: `.Trigger`, `.Positioner`, `.Content`, `.Title`, `.Description`, `.CloseTrigger`, `.Arrow`, `.ArrowTip`. |
| `Dialog` | Modal confirmation or styled drawer: `.Trigger`, `.Backdrop`, `.Positioner`, `.Content`, `.Title`, `.Description`, `.CloseTrigger`. Keep default modal focus behavior; immediate Escape and non-modal focus return have upstream fixes. |
| `Menu` | Action menu: `.Trigger`/`.ContextTrigger`, `.Positioner`, `.Content`, `.Item`, `.OptionItem`, `.TriggerItem`, `.ItemText`, `.ItemIndicator`, `.ItemGroup`, `.Separator`. Not ordinary site navigation. `initialFocusEl`/`finalFocusEl` customize focus; for anchor items, Enter selects and closes, modified Enter preserves link behavior, and selection details expose `modifiers`. Do not navigate an anchor a second time from `onSelect`. |
| `FloatingPanel` | Movable/resizable window: `.Trigger`, `.Positioner`, `.Content`, `.Header`, `.Title`, `.DragTrigger`, `.Control`, `.StageTrigger`, `.CloseTrigger`, `.Body`, `.ResizeTrigger`. Use `z-index: var(--z-index)` on the positioner to retain machine stacking. Plan small-screen behavior and [non-drag alternatives](accessibility.md#focus-visibility-and-drag-alternatives), not only drag handles. |
| `Toast` | Notifications: `.Group` with a toast-record children snippet; root `<Toast {toast}>`, `.Message`, `.Title`, `.Description`, `.ActionTrigger`, `.CloseTrigger`; store factory `createToaster`. `update(id, updater)` reads current props, even for queued toasts. Dismissing a focused toast moves focus to the next toast or back to the previously focused element. |
| `Portal` | Render floating anatomy outside clipping ancestors. Explicitly wrap positioners/backdrops where appropriate and preserve generated stacking styles. Nested dismissable layers now close only their own descendants on parent dismissal; test Escape, outside interaction, and focus with the actual portal layout. |
| `LocaleProvider` **beta** | `<LocaleProvider locale="en-US">` and `.Context` provide locale and derived LTR/RTL direction without a DOM wrapper. Does not translate application strings or set document `lang`/`dir`; application owns those attributes. |

## Styled native elements: core CSS, no component imports

Core CSS is framework-agnostic. Classes style elements; they do not add validation, persistence, focus management, or JavaScript dismissal.

| Family | Semantic use |
| --- | --- |
| `btn`, `btn-icon`, `btn-group`; size variants | `<button type="button">` for actions, `<a href>` for destinations; name icon-only buttons. |
| `badge`, `badge-icon`, `chip`, `chip-icon` | Static status text or semantic buttons/links when actionable. |
| `card` | Appropriate article/section/container; anchor/button cards receive interactive hover styling without `card-hover`. |
| `fieldset`, `legend`, `label`, `input`, `select`, `textarea`, `checkbox`, `radio`, `progress`, `meter` | Native labeled form/display elements; `field-*` sizing and `field-group` for single-row input compositions. Forms utilities require `@plugin '@tailwindcss/forms';`. |
| `table-wrap`, `table` | Scroll wrapper and semantic table with caption, headers, cells; not a data grid. |
| `dialog` **beta** | Native `<dialog>`; `showModal()` supplies modal/top-layer behavior, `close()` dismisses. Supply hydration-stable title/description IDs. Invoker commands and newer light-dismiss features depend on browser support. |
| `disclosure`, `disclosure-content`, `disclosure-group` **beta** | Native `<details><summary>…</summary>…</details>` for simple disclosure; a shared, per-instance `name` creates an exclusive group where supported. |
| `placeholder`, `placeholder-circle` | Decorative loading shapes; announce loading separately. Optional pulse must respect reduced motion. |
| Borders and semantic typography | Use `border-t`/`border-l` for dividers and actual headings, anchors, quotations, code, and related semantic elements for typography. |

Prefer native dialog/details when their behavior meets the requirement, and framework Dialog/Accordion when application-controlled composition or richer state behavior is needed. Native modal dialogs already contain modal focus; framework Dialog is not required merely for that capability.

## Six supported composition patterns

1. **Composed roots:** use root imports and their declared anatomy. Match values and include required labels/hidden inputs. No `/composed` subpath is exported in 5.0.6.
2. **Class and state styling:** use `class` on concrete anatomy and documented state attributes such as `data-[state=active]:…` on Tabs.Trigger or `data-[state=checked]:…` on Switch.Control. Keep focus indicators. Import the package's root stylesheet with `@import '@skeletonlabs/skeleton-svelte';` alongside core/theme CSS; do not rely on removed style props. Dialog/Tooltip roots are context wrappers, not arbitrary-attribute DOM containers.
3. **Element attributes and snippets:** an `element(attributes)` snippet replaces internal markup. Spread **all** supplied attributes onto the replacement element to preserve roles, IDs, events, hidden state, and keyboard behavior. Keep valid semantics; do not nest a button inside a trigger. Ordinary children are not universally API snippets: use `.Context` with `children(api)` and call `api()` for current state.
4. **Transitions:** default motion-free content is valid. For a Svelte transition on Accordion.ItemContent, use an element snippet with `{#if !attributes.hidden}` around `<div {...attributes} transition:slide={{ duration }}>`. This is a **partial fragment**, not standalone markup. Plain content remains mounted but hidden; the conditional version unmounts after exit. Initialize duration to zero, subscribe to `matchMedia('(prefers-reduced-motion: reduce)')` only after mount, keep zero for reduced motion, and remove the listener on teardown. CSS media rules alone do not configure JavaScript transitions.
5. **Props and callbacks:** use data-in/callback-out, e.g. Switch `checked`/`onCheckedChange(e.checked)`, Accordion `value: string[]`/`onValueChange(e.value)`, Tabs `value`/`onValueChange(e.value)`. Do not assume library state props are bindable; native inputs retain normal Svelte bindings. Uncontrolled defaults are available only where declared.
6. **Providers:** `useTooltip`, `useTabs`, and the corresponding `use<Name>` factories expose API **getters**. Supply an SSR/hydration-stable `$props.id()` and reactive props getter when controlling state. Pass the getter to `.Provider`, not its result; call `tooltip().setOpen(true)` for imperative access. Own machines/stores per component or layout/request, not in mutable server-module singletons.

The following complete example combines provider and element replacement without extra interaction wrappers.

**File: `ProviderTooltip.svelte`**
```svelte
<script lang="ts">
  import { Portal, Tooltip, useTooltip } from '@skeletonlabs/skeleton-svelte';
  const id = $props.id();
  const tooltip = useTooltip(() => ({ id, openDelay: 200 }));
</script>

<Tooltip.Provider value={tooltip}>
  <Tooltip.Trigger>
    {#snippet element(attributes)}
      <button {...attributes} type="button" class="btn preset-tonal-primary">Keyboard help</button>
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

### Lucide inside a concrete trigger

Lucide icons belong inside the trigger's actual button, not a nested control.
Keep the SVG a direct child for Skeleton sizing; forward all trigger attributes,
name the control once, and keep its icon decorative. The complete
[`IconTooltip.svelte` example](lucide.md#accessible-icons-and-controls) implements
this pattern with hydration gating for the JavaScript-only tooltip, not for
Lucide's SSR rendering. The text-only provider example above needs no icon dependency.

## If the desired component is absent

There is no `Drawer`, `Stepper`, `Select`, `Checkbox`, `Radio`, `Alert`, `Clipboard`, or `PinInput` root export. Use native HTML where suitable, styled Dialog for a drawer, or a separately installed library with its own verified version. Names are `QrCode`, `Steps`, `SegmentedControl`, `RatingGroup`, `Dialog`, and `Toast`; linear and circular progress both use `Progress`.

Other runtime exports are `useAccordion`, `useAvatar`, `useCarousel`, `useCollapsible`, `useCombobox`, `useDatePicker`, `useDialog`, `useFileUpload`, `useFloatingPanel`, `useListbox`, `useMarquee`, `useMenu`, `usePagination`, `usePopover`, `useProgress`, `useQrCode`, `useRatingGroup`, `useSegmentedControl`, `useSlider`, `useSteps`, `useSwitch`, `useTabs`, `useTagsInput`, `useToggleGroup`, `useTooltip`, `useTreeView`, `useListCollection`, `createToaster`, `createTreeViewCollection`, and `parseDate`. Prop interfaces are type exports, not runtime values.

## Offline installed-types lookup

1. Confirm core/component **5.0.6** in lockfile and installed package metadata. The Svelte package exports only `.` with types, import, Svelte, and **style** conditions (`dist/index.d.ts`, `dist/index.js`, `dist/index.css`); core exports `src/index.css` and `themes/*`, not optional presets.
2. Follow `dist/index.d.ts` → `components/<kebab-name>/index.d.ts` → `modules/anatomy.d.ts` for real runtime members; read `anatomy/*.svelte.d.ts` for props and bindable metadata.
3. Read shipped `anatomy/*.svelte` and `modules/provider.svelte.js` for rendered tags, element snippets, attribute merging, context/getter usage, portals, and lifecycle. Check the actual installed version rather than copying an unrelated major.
4. Follow inherited `@zag-js/<primitive>` declarations; this baseline uses Zag **1.48.0**, not a direct application dependency. Omitted props and Skeleton's own wrappers matter. For example, the public `useListCollection` helper returns `ListCollection<T, never>`; existing inferred collection calls do not need rewriting.
5. For styles inspect core `src/index.css`, its imported component CSS, and Svelte `dist/index.css`. Core already includes presets. Keep the global setup in [installation](setup.md) aligned.

Sources: [official fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md), [official framework index](https://www.skeleton.dev/llms-svelte.txt), [5.0.6 runtime exports](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.js), [5.0.6 declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/index.d.ts), [package export map](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/package.json), [core CSS](https://unpkg.com/@skeletonlabs/skeleton@5.0.6/src/index.css), [Zag 1.48.0 releases](https://github.com/chakra-ui/zag/releases?q=1.48.0), [QrCode](https://www.skeleton.dev/docs/svelte/framework-components/qr-code.md), [Marquee](https://www.skeleton.dev/docs/svelte/framework-components/marquee.md), [LocaleProvider](https://www.skeleton.dev/docs/svelte/framework-components/locale-provider.md), [native dialogs](https://www.skeleton.dev/docs/svelte/tailwind-components/dialogs.md), [native disclosures](https://www.skeleton.dev/docs/svelte/tailwind-components/disclosures.md).
