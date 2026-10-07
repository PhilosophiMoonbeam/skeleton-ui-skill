# Runnable Skeleton v3 / Svelte 5 recipes

These examples target core **3.2.2**, component package **1.5.3**, Svelte **5.57.2**, and SvelteKit **3.0.1**. Each `svelte` fence is a **complete standalone component**, with its filename identified above the fence. They need the application's global Skeleton/Tailwind CSS, theme, component `@source`, optional presets, and (for native form styling) `@tailwindcss/forms`; no icon package is required. Mount any example in a page or copy its complete contents to `+page.svelte`.

## State, callbacks, and snippets

The stable root components use ordinary props plus callback props. Their published Svelte declarations expose no bindable state props. A controlled prop must be updated from its callback; otherwise the UI keeps the supplied state. `defaultValue`, `defaultChecked`, or `defaultOpen` are alternatives where the inherited primitive supports them and application-owned state is unnecessary.

| Component | Controlled prop | Callback payload | Content composition |
| --- | --- | --- | --- |
| `Tabs` | `value: string` | `onValueChange(e)` → `e.value: string` | `list()` and `content()`; controls/panels contain ordinary children |
| `Accordion` | `value: string[]` | `onValueChange(e)` → `e.value: string[]` | `.Item` requires `control()`; optional `panel()` and `lead()` |
| `Switch` | `checked: boolean` | `onCheckedChange(e)` → `e.checked: boolean` | ordinary children become its label |
| `Popover`, `Tooltip`, `Modal` | `open: boolean` | `onOpenChange(e)` → `e.open: boolean` | `trigger()` and `content()`; the component creates the trigger button |

Named snippets declared directly inside a component are passed as props of the same name. They are not legacy `slot="..."` elements. No-argument `Snippet` takes `()`; `Combobox`'s `item: Snippet<[T]>` takes one data item, and `Slider`'s `mark: Snippet<[number]>` takes a numeric marker. Native inputs still use normal Svelte `bind:value`, `bind:checked`, or `bind:group`.

Sources: [published Skeleton types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/), [Tabs inherited types](https://unpkg.com/@zag-js/tabs@1.18.3/dist/index.d.ts), [Accordion inherited types](https://unpkg.com/@zag-js/accordion@1.18.3/dist/index.d.ts), [Switch inherited types](https://unpkg.com/@zag-js/switch@1.18.3/dist/index.d.ts).

## Tabs: controlled local panels

**File: `TabsExample.svelte` — complete component.** `list` holds controls; `content` holds panels with matching values. Tabs root accepts `translations.listLabel` to name its tablist; do not pass unsupported root HTML attributes. These are local panels, not route links.

```svelte
<script lang="ts">
  import { Tabs } from '@skeletonlabs/skeleton-svelte';
  let selected = $state('overview');
</script>

<section class="space-y-4">
  <h2 class="h2">Project details</h2>
  <Tabs
    value={selected}
    onValueChange={(e) => (selected = e.value)}
    translations={{ listLabel: 'Project details' }}
  >
    {#snippet list()}
      <Tabs.Control value="overview">Overview</Tabs.Control>
      <Tabs.Control value="activity">Activity</Tabs.Control>
    {/snippet}
    {#snippet content()}
      <Tabs.Panel value="overview"><p>Project overview.</p></Tabs.Panel>
      <Tabs.Panel value="activity"><p>Recent project activity.</p></Tabs.Panel>
    {/snippet}
  </Tabs>
  <p>Selected panel: {selected}</p>
</section>
```

Interaction contract: click Activity to show its panel. Focus a tab and use Left/Right arrows; the default automatic activation changes the selected tab with focus. Home/End move to first/last. For manual activation, use supported `activationMode="manual"`; then Enter/Space activates the focused tab. Keep `.Control` as the interactive element; do not nest buttons or links inside it or replace generated keyboard handlers.

Sources: [archived Tabs example](https://v3.skeleton.dev/docs/components/tabs/svelte), [1.5.3 Tabs types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Tabs/types.d.ts), [Zag 1.18.3 contract](https://unpkg.com/@zag-js/tabs@1.18.3/dist/index.d.ts), [ARIA Tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/).

## Accordion: collapsible FAQ

**File: `AccordionExample.svelte` — complete component.** Set `headingLevel` to fit the document outline; the item creates that heading and a real trigger button itself.

```svelte
<script lang="ts">
  import { Accordion } from '@skeletonlabs/skeleton-svelte';
  let expanded = $state<string[]>(['billing']);
</script>

<section class="space-y-4">
  <h2 class="h2">Frequently asked questions</h2>
  <Accordion value={expanded} onValueChange={(e) => (expanded = e.value)} collapsible>
    <Accordion.Item value="billing" headingLevel={3}>
      {#snippet control()}When am I billed?{/snippet}
      {#snippet panel()}<p>Billing occurs on the first day of each month.</p>{/snippet}
    </Accordion.Item>
    <Accordion.Item value="cancel" headingLevel={3}>
      {#snippet control()}Can I cancel?{/snippet}
      {#snippet panel()}<p>You can cancel from your account settings.</p>{/snippet}
    </Accordion.Item>
  </Accordion>
  <p>Expanded sections: {expanded.join(', ') || 'none'}</p>
</section>
```

Enter/Space toggles a focused header; arrow/Home/End navigation is supplied by the primitive. `collapsible` allows an empty array; add `multiple` to let both panels stay open. Do not wrap `control()` in another button or add a competing click handler.

Sources: [archived Accordion](https://v3.skeleton.dev/docs/components/accordion/svelte), [1.5.3 item types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Accordion/types.d.ts), [ARIA Accordion pattern](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/).

## Switch and native inputs: one state model, two APIs

**File: `PreferencesForm.svelte` — complete component.** Native binding and Skeleton callback state can coexist. The Switch's children supply its visible accessible label, and its `name` reaches the hidden form input. Unchecked checkbox-like controls are omitted from native `FormData`.

```svelte
<script lang="ts">
  import { Switch } from '@skeletonlabs/skeleton-svelte';
  let displayName = $state('Ada');
  let frequency = $state('weekly');
  let notifications = $state(false);
  let submitted = $state('');

  function submit(event: SubmitEvent) {
    event.preventDefault();
    const form = event.currentTarget as HTMLFormElement;
    const data = new FormData(form);
    submitted = `${data.get('displayName')} / ${data.get('frequency')} / notifications: ${data.has('notifications')}`;
  }
</script>

<form class="max-w-md space-y-4" onsubmit={submit}>
  <label class="label">
    <span class="label-text">Display name</span>
    <input class="input" name="displayName" required bind:value={displayName} />
  </label>
  <label class="label">
    <span class="label-text">Summary frequency</span>
    <select class="select" name="frequency" bind:value={frequency}>
      <option value="daily">Daily</option>
      <option value="weekly">Weekly</option>
    </select>
  </label>
  <Switch
    name="notifications"
    checked={notifications}
    onCheckedChange={(e) => (notifications = e.checked)}
  >Enable notifications</Switch>
  <p>Notifications: {notifications ? 'on' : 'off'}</p>
  <button type="submit" class="btn preset-filled-primary-500">Review preferences</button>
  <p role="status">{submitted}</p>
</form>
```

Tab to the switch and press Space: the boolean and displayed state must change together. Do not put an extra `<label>` around Switch (it already renders one), use `bind:checked` on Switch, or simulate it with a clickable div. The submit handler only reviews local form data; replace it with a real SvelteKit form action when persistence is needed.

Sources: [archived Switch](https://v3.skeleton.dev/docs/components/switch/svelte), [published Switch source](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Switch/Switch.svelte), [archived forms](https://v3.skeleton.dev/docs/tailwind/forms), [Svelte bindings](https://svelte.dev/docs/svelte/bind).

## Floating help: tooltip

**File: `FloatingHelp.svelte` — complete component.** Tooltip supplies supplemental, noninteractive text. It creates its own trigger button: the snippet holds button **contents**, not another button.

```svelte
<script lang="ts">
  import { Tooltip } from '@skeletonlabs/skeleton-svelte';
</script>

<Tooltip
  triggerAriaLabel="Keyboard shortcut help"
  triggerBase="btn preset-tonal-primary"
  contentBase="card bg-surface-100-900 p-3 shadow-xl"
  positioning={{ placement: 'top' }}
  openDelay={200}
  zIndex="50"
>
  {#snippet trigger()}Keyboard shortcuts{/snippet}
  {#snippet content()}Press Tab to move between controls.{/snippet}
</Tooltip>
```

Hover or focus the trigger to reveal help; Escape dismisses it. Do not add `<Portal>`: no such export exists, and Tooltip renders its positioner in place. An ancestor's overflow can clip Tooltip; inspect the actual surrounding layout rather than assuming a wrapper API exists.

For click-triggered, interactive floating content, v3 also exports `Popover` with `trigger()`/`content()`, `open` plus `onOpenChange(e.open)`, and internal portalling. Do not assume adding title/description IDs is sufficient to name its generated dialog: the pinned Zag popover checks for those elements on machine entry, while Skeleton conditionally mounts content only when open. For a reliably named interactive surface, use the Modal recipe below or an appropriate separately installed headless primitive whose title/description composition is explicitly supported. Do not put interactive controls in Tooltip to bypass that limitation.

Sources: [archived floating integration](https://v3.skeleton.dev/docs/integrations/popover/svelte), [Tooltip source](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Tooltip/Tooltip.svelte), [Popover source](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Popover/Popover.svelte), [pinned Zag popover implementation](https://unpkg.com/@zag-js/popover@1.18.3/dist/index.js).

## Dialog strategy: Modal, including drawer styling

**File: `ConfirmModal.svelte` — complete component.** Use the exported `Modal`, not an invented `Dialog` import. A controlled state drives both built-in and application dismissals. Title/description IDs are supplied because a plain heading snippet does not automatically become the primitive's title element.

```svelte
<script lang="ts">
  import { Modal } from '@skeletonlabs/skeleton-svelte';
  const uid = $props.id();
  let open = $state(false);
  let archived = $state(false);
</script>

<Modal
  {open}
  onOpenChange={(e) => (open = e.open)}
  ids={{ title: `${uid}-title`, description: `${uid}-description` }}
  triggerAriaLabel="Open archive confirmation"
  triggerBase="btn preset-tonal-primary"
  contentBase="card bg-surface-100-900 p-6 space-y-4 shadow-xl w-full max-w-md"
>
  {#snippet trigger()}Archive project{/snippet}
  {#snippet content()}
    <h2 id={`${uid}-title`} class="h2">Archive this project?</h2>
    <p id={`${uid}-description`}>This example changes local state only.</p>
    <div class="flex justify-end gap-3">
      <button type="button" class="btn preset-tonal-primary" onclick={() => (open = false)}>
        Cancel
      </button>
      <button
        type="button"
        class="btn preset-filled-primary-500"
        onclick={() => { archived = true; open = false; }}
      >Confirm archive</button>
    </div>
  {/snippet}
</Modal>
<p role="status">{archived ? 'Project archived in this example.' : 'Project is active.'}</p>
```

The inherited dialog defaults trap focus, prevent background interaction/scrolling, close on Escape/outside interaction, and restore focus. Preserve them unless the interaction specification explicitly requires otherwise. Open with keyboard, cycle Tab/Shift+Tab inside, dismiss with Escape, and confirm focus returns to the trigger. For a real mutation, await the actual result and show success only after it succeeds.

The v3 docs implement **drawers using Modal**: set `positionerJustify="justify-start"`, clear `positionerAlign`/`positionerPadding`, give `contentBase` a sidebar width and full-screen height, and use `transitionsPositionerIn/Out` with an `x` offset matching the sidebar width. Retain dialog naming, close controls, and focus behavior. No separate `Drawer` export is needed. For interfaces this wrapper cannot express, the archive also documents separately installed headless Svelte integrations; do not assume their current APIs are part of Skeleton.

Sources: [archived Modal/drawer examples](https://v3.skeleton.dev/docs/integrations/popover/svelte#modal), [Modal source](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Modal/Modal.svelte), [dialog 1.18.3 types](https://unpkg.com/@zag-js/dialog@1.18.3/dist/index.d.ts), [archived Bits UI integration](https://v3.skeleton.dev/docs/headless/bits-ui).

## Toast strategy: create a store and mount a renderer

**File: `ToastExample.svelte` — complete component.** This intentionally scopes the store to this component instance; it is a local notification demonstration, not a server-shared mutable singleton.

```svelte
<script lang="ts">
  import { Toaster, createToaster } from '@skeletonlabs/skeleton-svelte';
  const toaster = createToaster({ placement: 'bottom-end' });
</script>

<Toaster {toaster} />
<button
  type="button"
  class="btn preset-filled-primary-500"
  onclick={() => toaster.info({
    title: 'Notification example',
    description: 'Triggered by the notification button.'
  })}
>Show notification</button>
```

The official reusable pattern is a `createToaster()` reference shared by client consumers and **one `<Toaster {toaster}>` in the root layout**. For a SvelteKit app, keep user-specific notification state out of request-shared server modules; a layout-owned store distributed via Svelte context is an option when SSR isolation matters. Trigger notifications from client event handlers. Use `.success`, `.warning`, `.error`, `.info`, or `.create({ type, title, description })`; no `<Toast.Root>` or external Portal is required. Keep permanent errors and actionable details inline as well, rather than relying solely on a temporary toast.

Sources: [archived toast setup and methods](https://v3.skeleton.dev/docs/components/toast/svelte), [Toaster props](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Toast/types.d.ts), [SvelteKit shared-state guidance](https://svelte.dev/docs/kit/state-management#Avoid-shared-state-on-the-server).
