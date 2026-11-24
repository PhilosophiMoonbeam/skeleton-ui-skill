# Bits UI fundamentals

Use native HTML where it covers the interaction. Use `bits-ui` for composite widgets and layered interactions, not for every element on the page. Bits UI supplies behavior and semantics; application CSS supplies presentation. Start with [setup](setup.md) and choose parts from the [component catalog](components.md). The links below are rolling upstream references; use the installed version's declarations and implementation to resolve differences. See [sources](sources.md).

## General documentation

| Official page (`llms.txt`) | Apply it |
| --- | --- |
| [Introduction](https://www.bits-ui.com/docs/introduction/llms.txt) | Choose a primitive for its interaction, not its demo styling. Keep ordinary links, buttons, fields, and tables native. |
| [Getting started](https://www.bits-ui.com/docs/getting-started/llms.txt) | Import component namespaces from `bits-ui`. Start from a complete anatomy, then apply `class` and `style` to parts that render elements. Follow the pinned commands in [setup](setup.md), not the upstream install snippet. |
| [Components overview](https://www.bits-ui.com/docs/components/llms.txt) | Find the widget, then open its individual component page for required parts, keyboard behavior, and each part's API. If this overview is empty, use the [upstream root index](https://www.bits-ui.com/llms.txt) or the [local catalog](components.md). |
| [Child snippet](https://www.bits-ui.com/docs/child-snippet/llms.txt) | Use `children` to customize contents; use `child` only to supply the actual element or forward to your own component. Spread every supplied prop onto the intended element. |
| [Dates and times](https://www.bits-ui.com/docs/dates/llms.txt) | Choose the date/time model and time zone before choosing a picker. Give `placeholder` the same model type as the value. |
| [Ref](https://www.bits-ui.com/docs/ref/llms.txt) | Use `bind:ref` on a rendered part when you need its DOM element. Keep refs nullable and pass custom IDs to the Bits part, not directly to its delegated element. |
| [State management](https://www.bits-ui.com/docs/state-management/llms.txt) | Check which state props are bindable. Use an ordinary binding for shared state and a function binding when the owner must validate or transform writes. |
| [Styling](https://www.bits-ui.com/docs/styling/llms.txt) | Style documented part selectors, state attributes, and CSS variables. Keep visible focus and use selectors or theme tokens that still apply after portalling. |
| [Transitions](https://www.bits-ui.com/docs/transitions/llms.txt) | Keep the default mount lifecycle for CSS animation. For Svelte transitions, use the documented `forceMount` and `child` pattern on the part, render conditionally, and transition its inner element. |
| [Migration guide](https://www.bits-ui.com/docs/migration-guide/llms.txt) | Recognize pre-v1 APIs; for a v1-to-v2 upgrade read the release notes and compare each installed prop type. Use the [migration checklist](migration.md) to preserve behavior. |
| [LLMs guide](https://www.bits-ui.com/docs/llms/llms.txt) | Use a per-page file for a specific component or question; use the root index to discover paths and the consolidated document only when broad coverage is needed. |

## Composition and ownership

- Read the documented anatomy before writing markup. `Root` usually owns interaction state and passes context to its parts; it does not always render a DOM node. Use the required parts rather than guessing subcomponents from another library. For example, `Accordion.Root` takes a `type` of `single` or `multiple` and contains `Item`, with `Header` and `Trigger` plus `Content`. Give items stable machine values and visible labels. Some primitives have a different shape; read their own page.
- Leave a bindable prop unset to use the part's default, or pass a value such as `open={false}` to set a starting value without syncing writes back to the caller. Bind the documented prop to instance-owned `$state` when siblings, form logic, or external controls need the live value (`bind:open`, `bind:value`, `bind:checked`). For controlled writes use `bind:value={getValue, setValue}` on a bindable prop; keep the setter as the single update path. Follow the component's value shape, including `type` discriminants. Do not assume a React-style `defaultValue` or `defaultOpen` prop.
- Use callbacks such as `onOpenChange`, `onValueChange`, and `onCheckedChange` for notifications or side effects. Inspect each signature: e.g., `Dialog` passes the requested boolean to `onOpenChange`, not a DOM event or `.detail` payload. A change callback is not a binding or cancellation hook; do not repeat the bound assignment in it. Read the owning state for work that must reflect accepted writes and programmatic updates.

## Delegation, refs, and styling

- Keep the default element when it is sufficient. `children` customizes content and can receive state (for example, a checkbox's checked state). When using `child`, put the rendered content inside the snippet; other children are not rendered by the default path. Spread `{...props}` on a semantic element, or forward those props through a wrapper to that element. Put custom IDs, classes, attributes, and handlers on the Bits part first so it can merge them. Do not overwrite generated IDs, ARIA attributes, keyboard handlers, or attachments in the delegated markup. See [Composition.svelte](../examples/Composition.svelte).
- A ref is the underlying DOM element, not a component instance. Use a type such as `HTMLButtonElement | null` with `$state` and `bind:ref`; read it after mount or in an interaction and account for unmounts. With delegation, the part's supplied props must reach the element for tracking and accessibility. A wrapper exposing its own DOM ref uses `$bindable(null)` and `bind:this` on its native element, or forwards `bind:ref` to the Bits part.
- For default rendering, pass classes directly or use global CSS for documented selectors such as `[data-accordion-trigger][data-state="open"]` and `[data-accordion-trigger][data-disabled]`. For scoped Svelte CSS, style your delegated element. Verify state values per part (not every widget uses `data-state`) and keep ARIA semantics separate from styling. Use documented CSS variables such as `--bits-select-anchor-width` instead of measuring the trigger yourself. See [styling](styling.md).
- With delegated floating content, spread `wrapperProps` on the unstyled outer positioning element and `props` on its inner content. Apply visual styles and transitions to the inner element. For a Svelte transition on a mount-managed surface, use the part's `forceMount` and the `open` snippet state to conditionally render the delegated DOM. Do not leave a closed surface interactive or wrap it in an unrelated outer `{#if}` that tears down the part before cleanup. Prefer the default lifecycle for CSS transitions, using `data-starting-style` and `data-ending-style` where the part documents them. Honor reduced motion and check Escape, focus restoration, and re-opening during an exit transition.

## Date and time state

Use immutable `@internationalized/date` values. `CalendarDate` is a date without time (`parseDate`); `CalendarDateTime` is a wall-clock date and time without a zone (`parseDateTime`); `ZonedDateTime` identifies a date and time in a named zone (`parseZonedDateTime` or `parseAbsolute` with a display zone). Use `Time` (`parseTime`) for a time of day without a date when the part accepts it. Do not convert a date-only value to an instant merely to format or submit it. For appointments, assign the domain time zone explicitly and decide how to handle ambiguous or skipped local times. Locale controls presentation, not the stored time zone.

Keep the selected `value` separate from the `placeholder` that supplies the model or the visible calendar when no value is selected. Reassign the result of `.set()` or `.add()` instead of mutating fields. At this baseline, `DateRange` and `TimeRange` allow `undefined` endpoints; do not submit an incomplete range as final. Parse and serialize at the application boundary and choose a deterministic initial date, locale, and zone for SSR; a server's local day can differ from the browser's.

## Utilities

| Official page (`llms.txt`) | Apply it |
| --- | --- |
| [BitsConfig](https://www.bits-ui.com/docs/utilities/bits-config/llms.txt) | Set `defaultLocale`, `defaultPortalTo`, or `dir` for a component subtree. Direct props override the nearest configured value; nested providers inherit unspecified values. Set matching HTML `dir` as needed: the provider does not render a direction-setting element. |
| [IsUsingKeyboard](https://www.bits-ui.com/docs/utilities/is-using-keyboard/llms.txt) | Read `new IsUsingKeyboard().current` when custom behavior must follow input modality. Use `:focus-visible` for presentation and never disable keyboard behavior based on the utility. Its shared state is not application or request state. |
| [mergeProps](https://www.bits-ui.com/docs/utilities/merge-props/llms.txt) | When composing props for one DOM element, use `mergeProps` instead of spreading objects that overwrite classes or handlers. Handlers run in argument order; `preventDefault()` stops later event handlers. Put the deciding handler first only when cancellation is intentional. |
| [Portal](https://www.bits-ui.com/docs/utilities/portal/llms.txt) | Use a documented component `.Portal` around the relevant layers; use the standalone `Portal` for other content. The default is `body`; set `to` to an existing selector or element when placement must stay under a specific theme or stacking context. With `disabled`, content renders inline. Enabled portals render in the browser, not in the server HTML at this baseline. Keep native form associations when changing DOM placement. |
| [useId](https://www.bits-ui.com/docs/utilities/use-id/llms.txt) | `useId()` uses a process-wide counter at `2.22.0`; reserve it for client-only IDs that do not need to match server output. Let Bits UI generate its IDs; use Svelte's `$props.id()` for your own hydration-stable instance IDs and derive suffixes for label, description, and error associations. |

## Type helpers

Import these helpers with `import type` from `bits-ui` and derive wrapper props from the exact part, not its root by default. Types do not forward snippets or make a prop bindable: implement the behavior you expose.

| Official page (`llms.txt`) | Apply it |
| --- | --- |
| [WithElementRef](https://www.bits-ui.com/docs/type-helpers/with-element-ref/llms.txt) | Use `WithElementRef<Props, HTMLButtonElement>` for a wrapper over a native button; expose `ref = $bindable(null)` and bind the corresponding element. |
| [WithoutChild](https://www.bits-ui.com/docs/type-helpers/without-child/llms.txt) | Use `WithoutChild<PartProps>` when callers can supply contents but the wrapper owns the rendered element. |
| [WithoutChildrenOrChild](https://www.bits-ui.com/docs/type-helpers/without-children-or-child/llms.txt) | Omit both snippets when the wrapper owns the element and contents, or reintroduce a snippet with the wrapper's own explicit contract. |
| [WithoutChildren](https://www.bits-ui.com/docs/type-helpers/without-children/llms.txt) | Use `WithoutChildren<PartProps>` when the wrapper supplies contents but leaves any supported element delegation available. |
