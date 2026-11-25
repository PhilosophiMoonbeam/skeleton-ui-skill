# Optional Skeleton 5 recipes

Use these recipes when [Skeleton is the right fit](skeleton.md#choose-a-foundation-and-widget-owner), whether adopting its styled components in a new product or maintaining an existing one. Use native HTML when sufficient; adopt a headless primitive when you need to own its design or when its behavior fits better.

**Setup:** The eight standalone TypeScript components target Svelte **5.59.1**, Tailwind **4.3.5**, and `@skeletonlabs/skeleton` / `@skeletonlabs/skeleton-svelte` **5.0.6** (inherited Zag **1.48.0**). Use the [Skeleton installation and CSS order](skeleton.md#add-styled-skeleton-components) and [activate the imported theme](setup.md#load-the-stylesheet-and-activate-an-optional-theme); put the theme on `<html>` so the default body portals inherit it. The form, Combobox, and Pagination examples use Skeleton native form styles: `bun add --dev --exact @tailwindcss/forms@0.5.11`, then add `@plugin '@tailwindcss/forms';` after the global CSS imports. No icons or Bits UI imports are needed. Save a fence as its stated filename inside the app's Tailwind scan and import and render it in a Svelte page or route. The demos use local state, reset on recreation, and make no server mutations.

- [Tabs](#tabs-controlled-local-panels) · [Accordion](#accordion-collapsible-faq) · [Switch](#switch-and-native-inputs-one-state-model-two-apis)
- [Tooltip](#floating-help-tooltip) · [Dialog/drawer](#dialog-strategy-dialog-including-drawer-styling) · [Toast](#toast-strategy-create-a-store-and-mount-a-renderer)
- [Combobox](#combobox-searchable-local-selection) · [Pagination](#pagination-controlled-local-table)

## State, callbacks, and snippets

Use props and callbacks, not `bind:` on framework state. Keep names, state updates, contrast, validation, fetching, and persistence application-owned. These examples start floating widgets closed; see the [composition contracts](skeleton.md#composition-contracts) for snippets, theme inheritance, SSR, and stable IDs.

| Component | Controlled prop | Callback payload |
| --- | --- | --- |
| Tabs | `value: string` | `onValueChange(e)` → `e.value` |
| Accordion | `value: string[]` | `onValueChange(e)` → `e.value` |
| Switch | `checked: boolean` | `onCheckedChange(e)` → `e.checked` |
| Tooltip, Popover, Dialog | `open: boolean` | `onOpenChange(e)` → `e.open` |
| Combobox | `value: string[]` | `onValueChange(e)` → `e.value` |
| Pagination | `page: number`, `pageSize: number` | `onPageChange(e)` → `e.page` / `e.pageSize`; `onPageSizeChange(e)` → `e.pageSize` |

## Tabs: controlled local panels

**File: `TabsExample.svelte`**

```svelte
<script lang="ts">
  import { Tabs } from '@skeletonlabs/skeleton-svelte';
  let selected = $state('overview');
</script>

<section class="space-y-4">
  <h2 class="h2">Project details</h2>
  <Tabs value={selected} onValueChange={(e) => (selected = e.value)}>
    <Tabs.List aria-label="Project details">
      <Tabs.Trigger value="overview">Overview</Tabs.Trigger>
      <Tabs.Trigger value="activity">Activity</Tabs.Trigger>
      <Tabs.Indicator />
    </Tabs.List>
    <Tabs.Content value="overview"><p>Project overview.</p></Tabs.Content>
    <Tabs.Content value="activity"><p>Recent project activity.</p></Tabs.Content>
  </Tabs>
  <p>Selected panel: {selected}</p>
</section>
```

Match trigger and panel values; these are local panels, not route links. Click Activity or use Left/Right and Home/End while focused. The default activation follows focus; `activationMode="manual"` uses Enter/Space. Tab out after an arrow, Home, or End and check focus does not snap back. Try two instances to check that their associations do not cross. Compare [upstream Tabs](https://www.skeleton.dev/docs/svelte/framework-components/tabs.md) and the [ARIA Tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/).

## Accordion: collapsible FAQ

**File: `AccordionExample.svelte`**

```svelte
<script lang="ts">
  import { Accordion } from '@skeletonlabs/skeleton-svelte';
  let expanded = $state<string[]>(['billing']);
</script>

<section class="space-y-4">
  <h2 class="h2">Frequently asked questions</h2>
  <Accordion value={expanded} onValueChange={(e) => (expanded = e.value)} collapsible>
    <Accordion.Item value="billing">
      <h3><Accordion.ItemTrigger>When am I billed?</Accordion.ItemTrigger></h3>
      <Accordion.ItemContent><p>Billing occurs on the first day of each month.</p></Accordion.ItemContent>
    </Accordion.Item>
    <Accordion.Item value="cancel">
      <h3><Accordion.ItemTrigger>Can I cancel?</Accordion.ItemTrigger></h3>
      <Accordion.ItemContent><p>You can cancel from your account settings.</p></Accordion.ItemContent>
    </Accordion.Item>
  </Accordion>
  <p>Expanded sections: {expanded.join(', ') || 'none'}</p>
</section>
```

Use real headings without changing the trigger button. Enter/Space toggles a header; Up/Down and Home/End move the focus. `collapsible` allows none; add `multiple` for independent expansion. Default content stays mounted while hidden; conditional rendering changes state retention (see [composition](skeleton.md#composition-contracts)). For simpler behavior use [native disclosures](styling.md#native-dialogs-disclosures-and-decorative-geometry). See [upstream Accordion](https://www.skeleton.dev/docs/svelte/framework-components/accordion.md).

## Switch and native inputs: one state model, two APIs

**File: `PreferencesForm.svelte`**

```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import { Switch } from '@skeletonlabs/skeleton-svelte';
  let displayName = $state('Ada');
  let frequency = $state('weekly');
  let notifications = $state(false);
  let submitted = $state('');
  let ready = $state(false);
  onMount(() => { ready = true; });

  function submit(event: SubmitEvent) {
    event.preventDefault();
    const data = new FormData(event.currentTarget as HTMLFormElement);
    submitted = `${data.get('displayName')} / ${data.get('frequency')} / notifications: ${data.has('notifications')}`;
  }
</script>

<form class="max-w-md space-y-4" onsubmit={submit}>
  <label class="label">
    <span>Display name</span>
    <input class="input" name="displayName" required bind:value={displayName} />
  </label>
  <label class="label">
    <span>Summary frequency</span>
    <select class="select" name="frequency" bind:value={frequency}>
      <option value="daily">Daily</option>
      <option value="weekly">Weekly</option>
    </select>
  </label>
  <Switch name="notifications" checked={notifications} onCheckedChange={(e) => (notifications = e.checked)}>
    <Switch.Control><Switch.Thumb /></Switch.Control>
    <Switch.Label>Enable notifications</Switch.Label>
    <Switch.HiddenInput />
  </Switch>
  <p>Notifications: {notifications ? 'on' : 'off'}</p>
  <button type="submit" disabled={!ready} class="btn preset-filled-primary-500">Review preferences</button>
  <p role="status">{submitted}</p>
  <p class="text-sm">JavaScript is required to review this local form; nothing is saved.</p>
</form>
```

Click the switch label or press Space; review the form checked and unchecked. `Switch` is already a label; do not wrap it in another. `.HiddenInput` participates in submission, and unchecked is omitted from `FormData`. Native inputs use Svelte bindings. The local submit button waits for hydration to prevent a default GET from exposing values before its handler runs. For persistence use a real [Kit form action](sveltekit.md#native-form-actions-with-progressive-enhancement) instead. See [upstream Switch](https://www.skeleton.dev/docs/svelte/framework-components/switch.md) and the [native controls guide](styling.md#optional-skeleton-classes-for-native-markup).

## Floating help: tooltip

**File: `FloatingHelp.svelte`**

```svelte
<script lang="ts">
  import { Portal, Tooltip } from '@skeletonlabs/skeleton-svelte';
</script>

<Tooltip positioning={{ placement: 'top' }} openDelay={200}>
  <Tooltip.Trigger type="button" class="btn preset-tonal-primary">Keyboard shortcuts</Tooltip.Trigger>
  <Portal>
    <Tooltip.Positioner class="z-50 max-w-[var(--available-width)]">
      <Tooltip.Content class="card preset-filled-surface-100-900 p-3 shadow-xl">
        Press Tab to move between controls.
      </Tooltip.Content>
    </Tooltip.Positioner>
  </Portal>
</Tooltip>
```

Hover or focus to show help; Escape dismisses it. Leave essential instructions visible and keep focus treatment. If adapting this to toggle `disabled`, check that the first hover after re-enabling works. Use a [Popover](https://www.skeleton.dev/docs/svelte/framework-components/popover.md) or Dialog for interactive content, not a tooltip. See [upstream Tooltip](https://www.skeleton.dev/docs/svelte/framework-components/tooltip.md) and the [optional icon-trigger contract](skeleton.md#composition-contracts).

## Dialog strategy: Dialog, including drawer styling

**File: `ConfirmDialog.svelte`**

```svelte
<script lang="ts">
  import { Dialog, Portal } from '@skeletonlabs/skeleton-svelte';
  let { drawer = false }: { drawer?: boolean } = $props();
  let open = $state(false);
  let archived = $state(false);
</script>

<Dialog {open} onOpenChange={(e) => (open = e.open)}>
  <Dialog.Trigger type="button" class="btn preset-tonal-primary">Archive project</Dialog.Trigger>
  <Portal>
    <Dialog.Backdrop class="fixed inset-0 z-50 bg-black/50" />
    <Dialog.Positioner class={drawer
      ? 'fixed inset-0 z-50 flex justify-start'
      : 'fixed inset-0 z-50 flex items-center justify-center overflow-y-auto p-4'}>
      <Dialog.Content class={drawer
        ? 'card preset-filled-surface-100-900 h-dvh w-full max-w-sm space-y-4 overflow-y-auto rounded-none p-6 shadow-xl'
        : 'card preset-filled-surface-100-900 max-h-[calc(100dvh-2rem)] w-full max-w-md space-y-4 overflow-y-auto p-6 shadow-xl'}>
        <Dialog.Title class="h2">Archive this project?</Dialog.Title>
        <Dialog.Description>This example changes local state only.</Dialog.Description>
        <div class="flex flex-wrap justify-end gap-3">
          <Dialog.CloseTrigger type="button" class="btn preset-tonal-primary">Cancel</Dialog.CloseTrigger>
          <button type="button" class="btn preset-filled-primary-500" onclick={() => { archived = true; open = false; }}>
            Confirm archive
          </button>
        </div>
      </Dialog.Content>
    </Dialog.Positioner>
  </Portal>
</Dialog>
<p role="status">{archived ? 'Project archived in this example.' : 'Project is active.'}</p>
```

Render `<ConfirmDialog />` for the centered modal or `<ConfirmDialog drawer />` for a start-aligned drawer with the same semantics and no motion. Open by keyboard, check initial Cancel focus, Tab/Shift+Tab containment, immediate Escape, Cancel, confirmation, and focus return. Title and Description supply associations; keep the modal defaults. If a more complex confirmation needs an explicit initial target, pass `initialFocusEl={() => cancelButton}` referencing the actual element; `null` uses the default, whereas `false` skips the initial move. Announce success only after any real mutation succeeds.

This flat example uses a local z-index convention. For nested floating surfaces preserve generated layer data/styles on their concrete anatomy and coordinate each positioner; do not copy the same z-index onto every layer. Test Escape on the child first and mouse/touch outside presses and sibling switching. See [upstream Dialog](https://www.skeleton.dev/docs/svelte/framework-components/dialog.md), [layer stacking](https://github.com/chakra-ui/zag/pull/3426), and the [native dialog alternative](styling.md#native-dialogs-disclosures-and-decorative-geometry).

## Toast strategy: create a store and mount a renderer

**File: `ToastExample.svelte`**

```svelte
<script lang="ts">
  import { Portal, Toast, createToaster } from '@skeletonlabs/skeleton-svelte';
  const toaster = createToaster({ placement: 'bottom-end' });
</script>

<Portal>
  <Toast.Group {toaster} class="z-[60]">
    {#snippet children(toast)}
      <Toast {toast} class="card preset-filled-surface-100-900 flex max-w-sm items-start gap-4 p-4 shadow-xl">
        <Toast.Message>
          <Toast.Title class="font-bold">{toast.title}</Toast.Title>
          <Toast.Description>{toast.description}</Toast.Description>
        </Toast.Message>
        <Toast.CloseTrigger type="button" class="btn preset-tonal-primary" aria-label="Close notification">
          Close
        </Toast.CloseTrigger>
      </Toast>
    {/snippet}
  </Toast.Group>
</Portal>
<button type="button" class="btn preset-filled-primary-500" onclick={() => toaster.info({
  title: 'Notification example',
  description: 'Triggered by the notification button.'
})}>Show notification</button>
```

Activate **Show notification**; dismiss with **Close** (accessible name **Close notification**), including by keyboard. The Group children snippet receives a record, not an API getter. Check focus moves to the next toast when a focused toast is dismissed and returns to the previous control after the last; check paused timers resume after leaving the group. Keep essential details inline. For a toast action use `.ActionTrigger`; `duration: Infinity` opts out of auto-expiry.

For updates keep the ID from `toaster.create({ type: 'info', title: 'Working' })`; `.info()`, `.success()`, `.warning()`, and `.error()` are typed `void` in this release. `toaster.update(id, (current) => ({ description: ((current.description ?? '') + ' Complete.').trim() }))` derives a patch even for a queued toast. Each store is independent. For app-wide notices own one in a layout instance, distribute via context, and mount one `Toast.Group` for it. Do not mutate a server-module singleton or announce from SSR. See [upstream Toast](https://www.skeleton.dev/docs/svelte/framework-components/toast.md) and [the pinned store types](https://unpkg.com/@zag-js/toast@1.48.0/dist/toast.types.d.ts).

## Combobox: searchable local selection

**File: `SearchableCombobox.svelte`**

```svelte
<script lang="ts">
  import { Combobox, Portal, useListCollection } from '@skeletonlabs/skeleton-svelte';
  const noResults = 'No matching projects.';
  const projects = [
    { label: 'Atlas design system', value: 'atlas', category: 'Design' },
    { label: 'Beacon dashboard', value: 'beacon', category: 'Analytics' },
    { label: 'Cedar documentation', value: 'cedar', category: 'Content' },
    { label: 'Delta storefront', value: 'delta', category: 'Commerce' }
  ];
  let items = $state(projects);
  let selected = $state<string[]>([]);
  const collection = $derived(useListCollection({
    items,
    itemToString: (item) => item.label,
    itemToValue: (item) => item.value
  }));
  const selectedProject = $derived(projects.find((project) => project.value === selected[0]));
</script>

<section class="max-w-md space-y-4">
  <h2 class="h2">Choose a project</h2>
  <Combobox
    {collection}
    value={selected}
    translations={{ noResults }}
    onValueChange={(e) => (selected = e.value)}
    onInputValueChange={(e) => {
      const query = e.inputValue.trim().toLowerCase();
      items = projects.filter((project) => project.label.toLowerCase().includes(query));
    }}
    onOpenChange={(e) => { if (e.open && e.reason !== 'input-change') items = projects; }}
    positioning={{ placement: 'bottom-start', sameWidth: true }}
  >
    <Combobox.Label>Project</Combobox.Label>
    <Combobox.Control class="grid grid-cols-[minmax(0,1fr)_auto_auto] items-center gap-2">
      <Combobox.Input class="input min-w-0 w-full" placeholder="Search projects" />
      <Combobox.Trigger type="button" class="btn static inset-auto h-auto w-auto transform-none preset-tonal-primary" aria-label="Show project options">Show</Combobox.Trigger>
      <Combobox.ClearTrigger type="button" class="btn h-auto w-auto preset-tonal-primary" aria-label="Clear project selection">Clear</Combobox.ClearTrigger>
    </Combobox.Control>
    <Portal>
      <Combobox.Positioner class="z-50 max-w-[var(--available-width)]">
        <Combobox.Content class="card preset-filled-surface-100-900 max-h-72 overflow-y-auto p-2 shadow-xl">
          {#each items as project (project.value)}
            <Combobox.Item item={project} class="flex items-center justify-between gap-3 rounded-base p-2 data-[highlighted]:preset-tonal-primary">
              <Combobox.ItemText>{project.label}</Combobox.ItemText>
              <span class="text-sm">{project.category}</span>
              <Combobox.ItemIndicator>Selected</Combobox.ItemIndicator>
            </Combobox.Item>
          {:else}
            <li aria-hidden="true" class="p-2">{noResults}</li>
          {/each}
        </Combobox.Content>
      </Combobox.Positioner>
    </Portal>
  </Combobox>
  <p>Selected project: {selectedProject ? `${selectedProject.label} (${selectedProject.value})` : 'none'}</p>
</section>
```

Type `bea`, then ArrowDown/Enter; try Clear, reopen for the full list, leave with Tab after selection, and try Escape immediately on reopening. An unmatched query renders no options. The empty row is visual: the machine announces the result count or `translations.noResults`, so do not add a second live region. The selected record is looked up in the complete dataset, not the visible list. Values, not labels or typed text, are identities.

The [5.0.6 Trigger CSS](https://unpkg.com/@skeletonlabs/skeleton-common@5.0.6/src/components/combobox.css) assumes a square icon button absolutely positioned in the input. This recipe resets position, inset, transform, width, and height for the separate text button; the grid lets the input shrink and the positioner caps the reference-width popup at `--available-width`. Check narrow viewport fit, list rather than page scrolling, and contrast of highlighted/selected text in both schemes.

The app owns remote fetching and errors. Pass `loading` while waiting (`aria-busy` and a loading announcement), suppress the visual empty row then, and localize `translations.resultsCount(count)`, `translations.noResults`, and `translations.loading`. Use empty values (a function returning `''` for `resultsCount`) to suppress individual messages if needed. For real anchor options, keep modified Enter behaving like a modified click; `navigate` and `onSelect` receive `modifiers`, so avoid duplicate navigation. See [upstream Combobox](https://www.skeleton.dev/docs/svelte/framework-components/combobox.md) and [Zag announcements and link behavior](https://github.com/chakra-ui/zag/releases/tag/@zag-js%2Fcombobox@1.47.0).

If the choices do not need filtering, use a [styled native select](styling.md#optional-skeleton-classes-for-native-markup).

## Pagination: controlled local table

**File: `PaginatedProjects.svelte`**

```svelte
<script lang="ts">
  import { Pagination } from '@skeletonlabs/skeleton-svelte';
  const projects = Array.from({ length: 23 }, (_, index) => ({
    id: index + 1,
    name: `Project ${String(index + 1).padStart(2, '0')}`,
    status: index % 3 === 0 ? 'In review' : 'Active'
  }));
  let page = $state(1);
  let pageSize = $state(5);
  const totalPages = $derived(Math.max(1, Math.ceil(projects.length / pageSize)));
  const currentPage = $derived(Math.min(Math.max(1, page), totalPages));
  const start = $derived((currentPage - 1) * pageSize);
  const visibleProjects = $derived(projects.slice(start, start + pageSize));

  function changePageSize(size: number) {
    pageSize = size;
    page = 1;
  }
</script>

<section class="space-y-4">
  <h2 class="h2">Project directory</h2>
  <div class="table-wrap">
    <table class="table">
      <caption class="p-3 text-start">Local projects</caption>
      <thead><tr><th scope="col">ID</th><th scope="col">Project</th><th scope="col">Status</th></tr></thead>
      <tbody>
        {#each visibleProjects as project (project.id)}
          <tr><td>{project.id}</td><td>{project.name}</td><td>{project.status}</td></tr>
        {:else}
          <tr><td colspan="3">No projects.</td></tr>
        {/each}
      </tbody>
    </table>
  </div>
  <div class="flex flex-wrap items-center justify-between gap-4">
    <label class="label">
      <span>Rows per page</span>
      <select class="select w-fit" value={String(pageSize)} onchange={(e) => changePageSize(Number(e.currentTarget.value))}>
        <option value="5">5</option><option value="10">10</option><option value="20">20</option>
      </select>
    </label>
    <Pagination count={projects.length} page={currentPage} {pageSize}
      onPageChange={(e) => (page = e.page)} onPageSizeChange={(e) => changePageSize(e.pageSize)}
      translations={{ rootLabel: 'Project pages' }} class="flex flex-wrap gap-2">
      <Pagination.FirstTrigger type="button" disabled={currentPage <= 1} class="btn preset-tonal-primary">First</Pagination.FirstTrigger>
      <Pagination.PrevTrigger type="button" disabled={currentPage <= 1} class="btn preset-tonal-primary">Previous</Pagination.PrevTrigger>
      <Pagination.Context>
        {#snippet children(api)}
          {#each api().pages as entry, index}
            {#if entry.type === 'page'}
              <button {...api().getItemProps(entry)} type="button" class="btn preset-tonal-primary data-[selected]:preset-filled-primary-500">{entry.value}</button>
            {:else}
              <Pagination.Ellipsis {index}>…</Pagination.Ellipsis>
            {/if}
          {/each}
        {/snippet}
      </Pagination.Context>
      <Pagination.NextTrigger type="button" disabled={currentPage >= totalPages} class="btn preset-tonal-primary">Next</Pagination.NextTrigger>
      <Pagination.LastTrigger type="button" disabled={currentPage >= totalPages} class="btn preset-tonal-primary">Last</Pagination.LastTrigger>
    </Pagination>
  </div>
  <p role="status">
    {#if projects.length === 0}
      0 results
    {:else}
      Page {currentPage} of {totalPages}: rows {start + 1}–{start + visibleProjects.length} of {projects.length}
    {/if}
  </p>
</section>
```

Pass the complete count and render the slice yourself. Next shows 6–10; Last shows 21–23; choosing size 20 resets to page 1 and Last then shows 21–23 on page 2. Empty data keeps boundaries disabled and announces “0 results”. If adapting to mutable data, commit the clamped page when replacing the data so a later count increase cannot restore an obsolete requested page. The native picker owns size selection; the widget neither renders a picker nor fetches rows.

5.0.6 defaults the machine to `button` mode, but `Pagination.Item` renders an anchor and its element snippet is anchor-typed. The example uses a real button with `api().getItemProps(entry)`, preserving the `type: 'page'` discriminant on the entry and `type="button"` on the element. Controls are individually tabbable, not a roving arrow-key list. Prev/Next wrappers forward generated button attributes; First/Last only wire clicks, so they need explicit `type` and disabled boundaries.

For URL paging, set `type="link"` and `getPageUrl({ page, pageSize })` on the root. Use `Pagination.Item` as an anchor for numbers. For boundaries, use real anchors via `.Context` with `api().getFirstTriggerProps()`, `getPrevTriggerProps()`, `getNextTriggerProps()`, and `getLastTriggerProps()`; the wrappers do not switch tag, and First/Last do not forward link attributes. At a disabled boundary keep `role="link"` and `aria-disabled="true"` with no `href` or added tab stop. See [upstream Pagination](https://www.skeleton.dev/docs/svelte/framework-components/pagination.md), [5.0.6 anatomy](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.6/dist/components/pagination/modules/anatomy.d.ts), [pinned link attributes](https://unpkg.com/@zag-js/pagination@1.48.0/dist/pagination.connect.js), and [native table styling](styling.md#optional-skeleton-classes-for-native-markup).
