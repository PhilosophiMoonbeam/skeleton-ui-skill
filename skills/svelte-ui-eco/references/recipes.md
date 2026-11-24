# Cross-component recipes

Use the [component catalog](components.md) to choose anatomy and find runnable examples. The patterns below cover the state and behavior an application must supply.

## Submit and reset a real form

1. Use a real `<form>` and a native submit button. Give each submitted control a `name`. Use the Bits component's documented named-input support where available; otherwise serialize the model through native inputs. Never emit both a generated input and a manual input for the same value.
2. Inspect `FormData` from the form, not from the display state. Disabled controls and unchecked native checkboxes are omitted; read repeated names with `getAll()`. Submit stable option IDs, not labels or a Combobox query. Preserve leading zeros in codes. Serialize dates, times, and range endpoints explicitly according to the server contract; do not implicitly turn a date-only value into a timestamp.
3. Give each field one source of truth. On reset, restore the application-owned model to its initial values in the form's `reset` handler, and reset any associated query, transient selection, or feedback as appropriate. Let native inputs reset unless the app intentionally takes responsibility for resetting the entire form. Submit again to check that the reset UI and actual payload agree.
4. For persistence, post to a real endpoint or a [SvelteKit form action](sveltekit.md). Validate the payload on the server; render field errors beside their controls and associate them with the fields. Announce success only after the mutation succeeds. Use native controls or an explicit fallback for a workflow that must remain usable before hydration or without JavaScript.

Try [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) and [ValueInputs.svelte](../examples/ValueInputs.svelte). The examples can demonstrate local transport without saving to a server.

## Adapt disclosure and overlays without losing focus

- Prefer CSS to rearrange one set of controls. Use one model for the selection and open state; two live copies can create duplicate tab stops, IDs, and form names. Keep custom associations instance-specific with `$props.id()`.
- On narrow screens, wrap simple links and actions or reveal them with a disclosure. Do not map route links to tabs or a site navigation list to Menubar. If a layout change removes the focused trigger or content, close the obsolete surface and put focus on a sensible visible element.
- Style a modal Dialog as a side sheet when a small screen needs a full-height surface. Keep the title, close button, focus containment, and return target. For a contextual surface that should not trap focus, use Popover. Constrain both surfaces to the viewport and scroll long content inside them.
- Use the primitive's portal and layering support where needed, rather than moving nodes or overriding generated positioning. In a Dialog containing another overlay, verify that Escape dismisses the inner layer first, focus returns to the appropriate trigger, and the dialog remains usable after outside interaction. Test keyboard, touch, zoom, and reduced motion.

See [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte), [Overlays.svelte](../examples/Overlays.svelte), and the [accessibility reference](accessibility.md).

## Scope date picker opening focus when calendars coexist

In pinned Bits UI 2.22.0, DatePicker and DateRangePicker's default opening focus can search the whole document. Leave it alone unless you can reproduce focus landing in an unrelated calendar when multiple grids are mounted.

[Dates.svelte](../examples/Dates.svelte) and [DateRanges.svelte](../examples/DateRanges.svelte) each render two grids. Their `onOpenAutoFocus` handlers cancel only the opening default with `event.preventDefault()`. On the next animation frame they query the opening picker's bound `Content` ref for its roving day (`[data-bits-day][tabindex="0"]`) and focus it without scrolling, falling back to the content itself. Leave close autofocus and dismissal behavior intact.

With both grids mounted, open from the trigger with Enter or Space and check that focus lands in the picker that opened. Use arrow keys to move within that grid and Enter or Space to select a date or both range endpoints. Reopen if selection closed the picker, then press Escape and check that it closes and focus returns to its trigger.

## Own async filtering independently from selection

1. Separate editable query, selected ID, and the option list. Use the [Combobox](https://www.bits-ui.com/docs/components/combobox/llms.txt) input handler for user edits rather than treating every displayed label change as a search. Keep the selected record or label available when results no longer contain it.
2. Debounce requests if needed. Cancel superseded requests and ignore stale completions, including after clear or unmount. Render only results for the active query. Keep stable values and keys as items update; clearing the query does not implicitly change the selection unless that is the intended behavior.
3. Distinguish loading, error, and an empty successful result. Do not render an empty result until the current request completes. Mark the relevant region busy while it updates, and make errors and retry controls reachable without treating them as options.
4. Check what the installed primitive already announces. Do not echo its built-in selection or highlight announcements. If the app needs to announce asynchronous loading or result availability, give each transition one owner; keep visual hints out of any second live region and do not place non-options in the option list. Test stale responses and the zero-result case with a screen reader.

[Combobox.svelte](../examples/Combobox.svelte) provides a local filtering baseline. The same model separates remote results from the selected value.

## Preserve semantics when composing anatomy

When replacing markup with a [child snippet](https://www.bits-ui.com/docs/child-snippet/llms.txt), spread the generated `props` onto the actual interactive element. Pass custom handlers and classes through component props or merge them without replacing generated handlers. Do not nest interactive elements; use explicit button types inside forms. Where documented, use bindable state or a getter/setter binding for controlled behavior rather than syncing two stores. Apply styles to documented state attributes and keep visible focus.

See [Composition.svelte](../examples/Composition.svelte), [Bits UI usage](bits-ui.md), and the [styling reference](styling.md).
