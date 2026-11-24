# Accessibility and browser verification

Use native HTML where it meets the interaction. Use [Bits UI](bits-ui.md) for managed keyboard, selection, focus, and overlay behavior. CSS classes, including optional Skeleton classes, change appearance, not roles, names, disabled behavior, validation, or focus management.

## Preserve native semantics and names

- Use `<button type="button">` for an action, `<button type="submit">` for submission, and `<a href="…">` for navigation. `btn` does not make a `div` keyboard-operable. Native buttons already support Space and Enter; do not add duplicate key handlers.
- Keep meaningful heading levels and landmarks (`main`, navigation, sections with headings). Visual `h1`–`h6` classes do not change semantic levels.
- Provide visible labels. An explicit `label[for]` needs the control's exact, unique `id`; use `$props.id()` with suffixes for reusable Svelte components. Wrapping one control in its label also works. A placeholder or hover-only title does not replace the label.
- Retain useful native attributes: correct `type`, `name`, `autocomplete`, `required`, and input constraints. Use `fieldset`/`legend` for related radio/checkbox groups.
- Icon-only buttons need a stable accessible name, such as `aria-label="Close settings"`; hide purely decorative icons from assistive technology. Do not rely on a tooltip for the only name.
- Preserve table structure: `caption`, `thead`, `tbody`, `th scope="col"` and `th scope="row"` where appropriate. Do not put `thead` inside `tbody`, even if a copied demonstration does so. Put actions in cells and make repeated names specific (“View Alice's profile”).
- Do not remove focus outlines without an equally visible replacement. Use the natural document order; avoid positive `tabindex`, nested buttons/links, and visual reordering that disagrees with keyboard order.
- `.disabled` changes appearance, not native disabled semantics or keyboard behavior. Use `disabled` on supported controls; `aria-disabled` alone needs deliberate prevention of activation and an appropriate focus policy. Do not imply a disabled link still navigates safely.
- `field-group` joins controls visually; preserve each label and use a real `fieldset`/`legend` when a semantic group is needed. Label a `<meter>` and supply correct bounds plus a readable value; it is a measurement, not a progress indicator.

See [WAI Labeling Controls](https://www.w3.org/WAI/tutorials/forms/labels/) and [WAI Tables](https://www.w3.org/WAI/tutorials/tables/).

## Lucide icons and control names

Prefer Lucide when an icon improves recognition; labels remain the primary explanation. Apply these rules to the actual rendered SVG and control:

- **Labeled button or link:** keep the icon decorative with `aria-hidden="true"` and retain the visible action/destination text. For an icon-only control, put its accessible name on the button or link, not the SVG; use specific wording such as “Close settings.” A tooltip is supplementary, not the only name. Do not move control state or relationships such as `aria-expanded` or `aria-controls` onto the icon.
- **Default hiding is conditional:** in `@lucide/svelte@1.77.0`, automatic `aria-hidden="true"` applies only with no child snippet and no own, non-nullish `aria-*`, `role`, or `title` prop. A child snippet or one of those supplied props disables automatic hiding but does not establish a useful name or role. A prop set to `undefined` or `null` does not count. Keep decorative icons explicitly hidden when adding attributes or children. `focusable="false"` may be used to keep SVG itself out of focus, but it neither names nor disables the enclosing control.
- **Standalone meaningful icon:** use `role="img"` with an explicit `aria-label`, or associate a nested `<title>` through `aria-labelledby`. Name its contextual meaning, not its shape. A `title` string attribute is not a nested `<title>` element. Prefer visible text if meaning would otherwise be ambiguous.
- **IDs only for associations:** `aria-label` needs no ID. If using `aria-labelledby`, generate a unique, hydration-stable title ID with `$props.id()` in component instance initialization and reference that exact ID. Never reuse a fixed title ID across repeated icons.
- **Rendering and interaction:** check meaningful icon contrast, forced colors, focus visibility, and the actual button/link target size, not just SVG dimensions. Keep status understandable without color alone. Static icons need no motion machinery; if an icon is animated, preserve its meaning in a static reduced-motion alternative.

See [Lucide](lucide.md) for named controls, computed styling, and verification.

Sources: [Lucide Svelte accessibility](https://lucide.dev/guide/svelte/advanced/accessibility), [pinned default-hidden inference](https://unpkg.com/@lucide/svelte@1.77.0/dist/utils/hasA11yProp.js), [pinned icon rendering](https://unpkg.com/@lucide/svelte@1.77.0/dist/Icon.svelte), [Svelte instance IDs](https://svelte.dev/docs/svelte/$props#$props.id()).

## Validation, errors, and status

Validate on the server for persisted operations; client constraints improve interaction but are not a trust boundary. Keep submitted values when returning errors. Associate field help and error text through `aria-describedby`; set `aria-invalid="true"` only when validation finds an error, not on every untouched required field.

Describe errors in text, identify the affected field, and explain how to correct it. A red border alone is insufficient. For multiple errors, offer a summary with links to invalid controls. After submission, focus the summary or first invalid field as appropriate; do not fight native browser validation focus.

For a dynamically updated nonurgent result, use a persistent `role="status"` region and update its text. Use `role="alert"` sparingly for important dynamically added errors; do not announce every keystroke. Keep success and error messages visible long enough to read. A transient toast must not be the only place to recover from a failed submission. Static content on initial page load and dynamically updated content have different announcement behavior: test with assistive technology, not just an accessibility tree snapshot.

For asynchronous work, show a pending state promptly, prevent unintended duplicate submissions, and preserve entered values on failure. Report success only after confirmation; an explicit optimistic flow needs rollback. Keep errors near the affected controls and expose waiting/result messages without moving focus to decorative feedback. Do not invent progress percentages or delay completion to finish an animation. `role="status"` already implies polite announcements.

For an asynchronous Bits UI `Combobox`, label the input and preserve generated input, listbox, and item relationships. Keep waiting, empty, and failed states visibly distinct; if you add status announcements, check for duplication and interruption during keyboard navigation.

Sources: [WAI Form Notifications](https://www.w3.org/WAI/tutorials/forms/notifications/), [WCAG Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html).

## Standalone native form

[NativeForm.svelte](../examples/NativeForm.svelte) is a complete local profile preview. Copy it into an existing Svelte 5.59.1 app and render `<NativeForm />` from a page, or mount it twice to exercise reusable IDs. It needs only Svelte, not Bits UI, Skeleton, Tailwind, or a server. The scoped palette works without a theme; see [optional theming](design.md#optional-theming) to adapt it.

The form has visible labels and help, native required text and email inputs, autocomplete hints, a length limit, and native submit and reset buttons. It deliberately uses `novalidate` so its submit handler can show linked errors together rather than competing with browser validation popups. It checks the email input's native validity, rejects an empty or whitespace-only display name, and trims its outer whitespace for the preview without modifying the input. The length limit includes spaces. Failed submissions preserve the entered values and any last successful preview.

Errors appear beside the corresponding fields and in a summary that receives focus after rendering. Summary links take the user to the invalid controls. Only a field that failed its most recent validation gets `aria-invalid` and an error reference in addition to its help reference. The example revalidates on submission, not while typing. If browser messages meet your needs, keep native interactive validation instead of implementing a parallel notification path. `$props.id()` keeps label, help, error, and fragment associations unique and stable across server render and hydration. Success is reported in a persistent status region with the actual submitted preview; it does not move focus. **Reset preview** clears the native inputs, errors, and output, then returns focus to **Display name**.

The local handlers send no request and write no storage. Until mounting, the disabled fieldset and visible explanation make clear that the preview is unavailable. For a persisted operation, use [native form actions with progressive enhancement](sveltekit.md#native-form-actions-with-progressive-enhancement) or your existing server route: validate submitted data on the server, return actionable errors and retained values, and report success only after the write succeeds.

**Checks to perform:** Submit the empty form and activate each summary link. Try spaces for the display name and `sam` for email; confirm the controls retain those entries and expose text errors. Submit ` Sam ` and `sam@example.com` to show `Sam` and the entered email, then reset and check focus and cleared output. Mount two instances and submit or reset one without affecting the other; verify both sets of label and error links after hydration. With JavaScript disabled, verify that the preview cannot be submitted and that the reason is visible.

## Managed interactions and native alternatives

Use Bits UI `Dialog` for a managed modal and `AlertDialog` for a consequential prompt that needs an explicit response. Provide a visible title, concise description where helpful, and a working close or cancel action. Prefer the least destructive initial action for destructive confirmations. A live `role="alert"` announces an important update; it is not an `alertdialog` and must not capture focus. See [overlays](../examples/Overlays.svelte).

For a simple native `<dialog>`, `showModal()` provides top-layer modality; `show()` and the `open` attribute do not. Use `close()` or a `method="dialog"` form to close it. Styling does not confer modality. Check animation, newer invoker attributes, and light-dismiss support separately from basic dialog support; keep an explicit dismissal and an ordinary route or inline path for essential content when necessary.

For a modal dialog, verify all of these:

- Opening moves focus inside to an appropriate element. For complex content, the title or introductory static text may be a better initial focus target than the first action; destructive flows generally favor the least destructive action.
- Tab and Shift+Tab remain within the open modal. Background content is inert to keyboard and pointer interaction, not merely dimmed.
- Escape closes it; provide an obvious keyboard-operable close or cancel button.
- Closing normally restores focus to the invoking control, or to a logical successor if that control was removed.
- The dialog has an accessible name through its visible title (`aria-labelledby`) or an explicit label. Use `aria-modal="true"` only when the implementation actually enforces modality. Avoid flattening complex dialog content into one huge `aria-describedby` announcement.

Keep Bits UI's generated props on the real elements, including event handlers, IDs, and ARIA relationships. Use native links inside `<nav>` for page navigation; a native `<details>`/`<summary>` disclosure can expose compact navigation without Escape or a focus trap. Preserve its keyboard behavior and marker. Give exclusive `details name` groups separate names when independently mounted.

| Need | Pattern and checks |
| --- | --- |
| Supplementary help | Use Bits UI `Tooltip` with a provider. Name the trigger independently; verify description, hover and focus exposure, hover persistence over content, Escape dismissal, and retained trigger focus. Use `Popover` or `Dialog` for interactive content. Keep essential instructions visible. See [overlays](../examples/Overlays.svelte). |
| Action menu | Use Bits UI `DropdownMenu`. Check Enter/Space to open, arrows within the menu, activation, Escape, and return to the trigger. Do not apply menu roles to ordinary site navigation. See [menus](../examples/Menus.svelte). |
| In-page peer panels | Use Bits UI `Tabs`. Name the tab list; check arrow, Home and End navigation, matching selected tab and panel, and Tab/Shift+Tab out of the list. With manual activation, verify Enter/Space selects the focused tab. See [disclosure and navigation](../examples/DisclosureNavigation.svelte). |
| Choice or state | Use native select, radios, checkboxes, or a single native `button[aria-pressed]` when sufficient. For managed selection use the appropriate Bits UI `Select`, `Combobox`, `RadioGroup`, or `ToggleGroup`. Verify name, selected/pressed/checked state, navigation, and submitted values. See [choice inputs](../examples/ChoiceInputs.svelte) and [combobox](../examples/Combobox.svelte). |

In the shipped Overlays example with Bits UI 2.22, hovering made `[data-tooltip-content]` visible and set the named trigger's `aria-describedby` to that element's exact ID, even though the DOM had no `[role="tooltip"]`. For this pinned example, check visibility, the exact description target, an unchanged accessible name, and Escape dismissal from the focused trigger rather than relying on a role query alone. Preserve the generated association without adding a duplicate label.

See the [component catalog](components.md), [recipes](recipes.md), and [example mounting guide](../examples/README.md). Compare the result with [APG Modal Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [Alert Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/alertdialog/), and [Tooltip](https://www.w3.org/WAI/ARIA/apg/patterns/tooltip/).

## Focus visibility and drag alternatives

Sticky headers/footers, banners, and floating panels must not entirely hide a component when it receives keyboard focus (WCAG 2.4.11, AA). Keep both the control and its focus indicator visible; account for overlays in scroll layout, for example with appropriate `scroll-padding`. Test narrow and zoomed layouts, not only the default viewport. The criterion assesses user-movable content in its initial position; user-opened content has a limited allowance when the focused component can be revealed without advancing focus. Neither allowance justifies an invisible focus indicator.

For authored drag interactions, provide equivalent functionality with a **single pointer without dragging** (2.5.7, AA), unless dragging is essential or the unmodified interaction belongs to the browser. Click/tap buttons, menus, or numeric inputs can provide alternatives for moving, sorting, resizing, or setting a value. Keyboard shortcuts alone do **not** meet this requirement; test keyboard access separately. A swipe is not a suitable non-drag alternative.

Expose the same positions or sizes through click/tap controls, not just a maximize button that skips intermediate choices. Check reachability at small sizes; prefer inline content when floating behavior adds no value.

See [WCAG Focus Not Obscured (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum.html) and [Dragging Movements](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html).

## Contrast, motion, and scale

Theme contrast tokens are a starting point, not evidence that every composite design passes. Measure the rendered foreground/background in each theme and scheme. Text normally needs at least **4.5:1**; qualifying large text needs **3:1**. Meaningful authored control/state indicators need **3:1** against adjacent colors. Check focus rings, placeholders, outlined borders when needed to identify a control, icons, and text over glass/gradients/images. Opacity can break otherwise suitable token pairings. Do not encode state solely through hue; accompany color with text or another meaningful cue.

Respect `prefers-reduced-motion` for nonessential motion, including custom CSS and Svelte transitions. A CSS media rule cannot cancel every JavaScript-driven animation; condition the transition or animation mechanism itself when needed. Preserve feedback with a static indicator or lower-motion alternative rather than hiding the result.

Global CSS fragment: application-owned decorative motion plus optional native dialog/disclosure transitions. Keep JavaScript-driven motion handling separate:

```css
@media (prefers-reduced-motion: reduce) {
  .decorative-motion,
  .animate-dialog,
  .animate-dialog::backdrop {
    animation: none;
    transition: none;
  }
  .disclosure summary { transition: none; }
  .disclosure::details-content { transition: none; }
}
```

Autostarting movement, blinking, or scrolling lasting **more than five seconds** alongside other content needs a way to pause, stop, or hide it unless essential (2.2.2, A). Autostarting **auto-updating information has no five-second exception**; provide pause, stop, hide, or update-frequency control unless essential. Hover/focus-only pausing is insufficient if movement resumes when the user moves away. Provide a visible keyboard- and pointer-operable pause control; make all meaningful items available in a static reduced-motion alternative.

Avoid flashing effects. Content must not flash more than **three times in any one-second period** unless below the defined general-flash and red-flash thresholds (2.3.1, A). A short duration, pause button, or reduced-motion option does not excuse an unsafe flash. Inspect all simultaneous effects and looping media; do not judge safety by animation duration alone.

Distinguish these requirements from AAA: **44 × 44 CSS pixels** is Target Size Enhanced (2.5.5, with exceptions); disabling nonessential interaction-triggered motion is Animation from Interactions (2.3.3); keeping the entire focused component unobscured is 2.4.12. Focus Appearance (2.4.13) adds minimum indicator area and focused/unfocused contrast requirements, not an AA rule that every outline must be 2px. Continue honoring reduced motion and using generous targets when targeting AA.

See [WCAG Pause, Stop, Hide](https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html), [Three Flashes or Below Threshold](https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html), and [Focus Appearance](https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html).

Check zoom, text enlargement, narrow layouts, and platform high-contrast/forced-colors settings. Do not shrink text or controls merely to fit an intended screenshot. Measure interactive targets: WCAG 2.2 AA requires at least **24 × 24 CSS pixels** or a qualifying spacing/other exception; **44 × 44** is a stronger touch-friendly design target, not the AA minimum. Recheck rendered dimensions whenever `--spacing`, `field-*`, `btn-*`, or element-size tokens change. `--default-outline-width` is configurable, not an enforced accessibility guardrail: retain visible focus, including when overflow, rounded corners, and forced colors affect its rendering.

Treat masks and corner shapes as progressive decoration. Apply masking to a separate decorative layer, never essential text, the only informative image, the accessible name, or a focusable target's outline. Unsupported masking can leave an element unmasked; a supported but empty, failed, or unsupported-format mask resource can instead hide it completely. Do not rely on that resource as an essential-content fallback. Keep unmasked meaningful content available, and verify failed resources as well as unsupported CSS. Corner-shape utilities require nonzero radius; retain useful rounded fallback geometry and do not convey state through corner shape alone. Theme corner tokens do not automatically reshape all controls. Avoid animating blur, masks, or corner geometry unless requested and with a static reduced-motion alternative.

Sources: [WCAG Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html), [WCAG Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html), [WCAG Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html), [MDN reduced motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion), [Spacing](https://www.skeleton.dev/docs/svelte/design/spacing), [Masks](https://www.skeleton.dev/docs/svelte/tailwind-utilities/masks), [mask resource failure](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/mask-image), [Corner shapes](https://www.skeleton.dev/docs/svelte/tailwind-utilities/corner-shapes).

## Concrete verification checklist

Perform these checks in the actual supported browsers after implementation; the tooltip hover observation above does not replace this checklist. This is a focused implementation checklist, not a complete WCAG audit or certification.

1. **Keyboard only:** Follow the entire flow with Tab and Shift+Tab. Confirm visible, ordered focus, including behind sticky content, and native activation keys. Exercise menu, tab, and selection contracts above. After navigating tabs with arrows or Home/End, immediately Tab or Shift+Tab away and verify focus does not jump back.
2. **Modal/tooltip/disclosure:** Exercise opening, Escape, close/cancel, focus restoration, background inertness, tooltip focus exposure, hover persistence, and accessible names. Try a removed trigger and long dialog content. Check dialog behavior independently of newer light-dismiss/invoker support. Test disclosure keyboard toggling with and without animation support and independent grouping across instances.
3. **Form:** Activate labels and submit empty, whitespace-only, overlength, invalid, and valid values under the declared policy. Check error association and focus, exact failed-value retention, keyboard behavior for selects/radios, autocomplete and native mobile inputs. Verify server failures separately from browser constraints, with and without enhancement. Mount two reusable instances and confirm each label/help/error resolves only its own control. For asynchronous flows, try slow success/failure and repeated activation: pending feedback must be prompt, duplicate requests prevented under the declared policy, entered data preserved, and success truthful.
4. **Accessibility tree and assistive technology:** Inspect names, roles, values, selected/expanded states, heading levels, label associations, and table headers. With a supported screen reader and browser, listen for errors, status updates, selection changes, and dialog titles; check for omissions and duplicate announcements.
5. **Responsive/visual:** Check narrow and wide viewports, 200% text enlargement and reflow at 320 CSS pixels, long labels, forced colors and reduced motion both before mount and after preference changes. Measure target sizes/spacing and rendered contrast in both schemes for every active theme, including default, focus, selected, invalid and disabled states. Disabled controls are contrast-exempt, not permission to obscure their state. Check static fallbacks for unsupported blur/corner/mask CSS and failed mask resources; essential content and focus must remain visible.
6. **SSR/hydration:** Hard reload with slow JavaScript and an opposite persisted mode. Check first-paint flash, matching server and client markup, console hydration warnings, navigation behavior, and browser-only storage access. Check essential native form and navigation behavior without JavaScript; enhanced widgets may require JavaScript but must not falsely appear functional before hydration.
7. **Optional styling pipeline:** If using theme CSS, verify theme/mode, computed `color-scheme`, and stylesheet imports. If using Tailwind, confirm complete literal classes and source detection. See [styling.md](styling.md).
8. **Motion and dragging:** Pause continuous or auto-updating content and move focus/pointer elsewhere; it must stay paused until resumed. Check all meaningful items remain available without motion. Complete every authored drag action with clicks/taps alone and then with keyboard controls independently.
9. **RTL:** Switch the actual direction boundary, not just text alignment. Verify reading order, logical layout, composite arrow keys, popup placement, and selectively mirrored icons. See [design.md](design.md) and [Lucide patterns](lucide-patterns.md).
