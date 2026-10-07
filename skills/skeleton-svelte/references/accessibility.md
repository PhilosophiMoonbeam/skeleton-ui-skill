# Accessibility and browser verification

Skeleton's [core 3.2.2 CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css) styles native elements; arbitrary containers do not gain semantics, validation policy, or focus management from classes. Use semantic HTML and verify actual behavior. This is distinct from the separately versioned Svelte components and their individual interaction contracts. The [v3 Forms page](https://v3.skeleton.dev/docs/tailwind/forms) calls for browser/platform validation; the [v3 Tables page](https://v3.skeleton.dev/docs/tailwind/tables) recommends links or buttons inside cells rather than interactive rows. Archive examples are not an accessibility certification: retain their useful styles, not malformed table structure or placeholder links.

## Preserve native semantics and names

- Use `<button type="button">` for an action, `<button type="submit">` for submission, and `<a href="…">` for navigation. `btn` does not make a `div` keyboard-operable. Native buttons already support Space and Enter; do not add duplicate key handlers.
- Keep meaningful heading levels and landmarks (`main`, navigation, sections with headings). Visual `h1`–`h6` classes do not change semantic levels.
- Provide visible labels. An explicit `<label for="email">` needs an exactly matching, unique input `id`. Wrapping one control in a label is also valid. A placeholder or hover-only title is not a substitute.
- Retain useful native attributes: correct `type`, `name`, `autocomplete`, `required`, and input constraints. Use `fieldset`/`legend` for related radio/checkbox groups.
- Icon-only buttons need a stable accessible name, such as `aria-label="Close settings"`; hide purely decorative icons from assistive technology. Do not rely on a tooltip for the only name.
- Preserve table structure: `caption`, `thead`, `tbody`, `th scope="col"` and `th scope="row"` where appropriate. Do not put `thead` inside `tbody`, even if a copied demonstration does so. Put actions in cells and make repeated names specific (“View Alice's profile”).
- Do not remove focus outlines without an equally visible replacement. Use the natural document order; avoid positive `tabindex`, nested buttons/links, and visual reordering that disagrees with keyboard order.

Sources: [WAI Labeling Controls](https://www.w3.org/WAI/tutorials/forms/labels/), [v3 Buttons](https://v3.skeleton.dev/docs/tailwind/buttons), [v3 Typography](https://v3.skeleton.dev/docs/design/typography), [v3 Tables](https://v3.skeleton.dev/docs/tailwind/tables).

## Validation, errors, and status

Validate on the server for persisted operations; client constraints improve interaction but are not a trust boundary. Keep submitted values when returning errors. Associate field help and error text through `aria-describedby`; set `aria-invalid="true"` only when validation finds an error, not on every untouched required field.

Describe errors in text, identify the affected field, and explain how to correct it. A red border alone is insufficient. For multiple errors, offer a summary with links to invalid controls. After submission, focus the summary or first invalid field as appropriate; do not fight native browser validation focus.

For a dynamically updated nonurgent result, use a persistent `role="status"` region and update its text. Use `role="alert"` sparingly for important dynamically added errors; do not announce every keystroke. Keep success and error messages visible long enough to read. A transient toast must not be the only place to recover from a failed submission. Static content on initial page load and dynamically updated content have different announcement behavior: test with assistive technology, not just an accessibility tree snapshot.

Sources: [WAI Form Notifications](https://www.w3.org/WAI/tutorials/forms/notifications/), [WCAG Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html).

## Standalone styled local form recipe

This complete `ProfilePreview.svelte` component updates a **local preview**, not an account or server. It requires JavaScript and the global Skeleton theme/preset imports and forms plugin described in [styling.md](styling.md); controls remain disabled until mounting, so the unenhanced form cannot send the name through a native submission. Native `required` and `maxlength` constraints run before the `submit` handler. The local policy preserves entered whitespace and accepts whitespace-only text: `required` rejects an empty string, not a blank-looking one. For nonblank or persisted values, use the explicit validation policy in [sveltekit.md](sveltekit.md#native-form-actions-with-progressive-enhancement), not this preview as persistence.

**File: `ProfilePreview.svelte`**

```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  const uid = $props.id();
  let ready = $state(false);
  let preview = $state('Not set');
  let status = $state('');

  onMount(() => { ready = true; });

  function updatePreview(event: SubmitEvent & { currentTarget: HTMLFormElement }) {
    event.preventDefault();
    const value = new FormData(event.currentTarget).get('displayName');
    preview = typeof value === 'string' ? value : '';
    status = `Preview updated to ${preview}. Nothing was saved to a server.`;
  }
</script>

<section class="card preset-filled-surface-100-900 space-y-4 p-4" aria-labelledby={`${uid}-title`}>
  <h2 id={`${uid}-title`} class="h3">Display name preview</h2>
  <form onsubmit={updatePreview} class="space-y-4">
    <div class="space-y-2">
      <label class="label-text" for={`${uid}-name`}>Display name (required)</label>
      <input
        id={`${uid}-name`}
        name="displayName"
        type="text"
        class="input"
        autocomplete="nickname"
        required
        maxlength="60"
        disabled={!ready}
        aria-describedby={`${uid}-help`}
      />
      <p id={`${uid}-help`} class="text-sm">Use up to 60 characters, including spaces. JavaScript is required; nothing is sent or saved.</p>
    </div>
    <button type="submit" disabled={!ready} class="btn preset-filled-primary-500">Update preview</button>
  </form>
  <dl>
    <dt class="font-bold">Preview name</dt>
    <dd>{preview}</dd>
  </dl>
  <p role="status" aria-atomic="true">{status}</p>
</section>
```

`$props.id()` gives each instance a unique, hydration-stable ID; suffixes keep its title, label and help associations local. This example retains native validation rather than creating custom error state. For application validation failures, add visible field errors and `aria-invalid` only after validation returns a result.

Sources: [v3 Forms](https://v3.skeleton.dev/docs/tailwind/forms), [v3 Presets](https://v3.skeleton.dev/docs/design/presets), [exact Svelte 5.57.2 IDs/lifecycle types](https://unpkg.com/svelte@5.57.2/types/index.d.ts), [Svelte event attributes](https://svelte.dev/docs/svelte/basic-markup#Events), [WAI Notifications](https://www.w3.org/WAI/tutorials/forms/notifications/).

## Modal and tooltip interaction contracts

Do not import v2 modal stores or assume current compound-component APIs exist in v3. Native classes do not implement a modal. Use a native modal dialog or an accessible headless implementation compatible with the installed framework. Preserve the library's trigger and content wiring rather than rebuilding only its appearance.

For a modal dialog, verify all of these:

- Opening moves focus inside to an appropriate element. For complex content, the title or introductory static text may be a better initial focus target than the first action; destructive flows generally favor the least destructive action.
- Tab and Shift+Tab remain within the open modal. Background content is inert to keyboard and pointer interaction, not merely dimmed.
- Escape closes it; provide an obvious keyboard-operable close or cancel button.
- Closing normally restores focus to the invoking control, or to a logical successor if that control was removed.
- The dialog has an accessible name through its visible title (`aria-labelledby`) or an explicit label. Use `aria-modal="true"` only when the implementation actually enforces modality. Avoid flattening complex dialog content into one huge `aria-describedby` announcement.

For tooltip-like help, verify hover **and keyboard focus** expose it, Escape dismisses it, and focus stays on the trigger. Associate tooltip text through `aria-describedby`; the tooltip itself has `role="tooltip"` and no focusable content. Keep it visible while the pointer moves over its content. If it contains links/buttons, it is an interactive popup, not a tooltip; use the appropriate dialog/popover interaction model. Essential instructions should be visible without opening a tooltip. The APG tooltip pattern is explicitly a work in progress, not a finalized component certification.

Sources: [APG Modal Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [APG Tooltip](https://www.w3.org/WAI/ARIA/apg/patterns/tooltip/).

For simple mobile page navigation, a native `<details>`/`<summary>` disclosure can avoid a modal entirely. Retain its native keyboard behavior and marker; put real links inside a named `<nav>`. It is not an ARIA `menu`, does not trap focus, and does not require Escape dismissal. See the responsive shell in [design.md](design.md). If choosing an overlay instead, implement the full modal contract above.

## Contrast, motion, and scale

Theme contrast tokens are a starting point, not evidence that every composite design passes. Measure the rendered foreground/background in each theme and scheme. Text normally needs at least **4.5:1**; qualifying large text needs **3:1**. Meaningful authored control/state indicators need **3:1** against adjacent colors. Check focus rings, placeholders, outlined borders when needed to identify a control, icons, and text over glass/gradients/images. Opacity can break otherwise suitable token pairings. Do not encode state solely through hue; accompany color with text or another meaningful cue.

Respect `prefers-reduced-motion` for nonessential motion, including custom CSS and Svelte transitions. A CSS media rule cannot cancel every JavaScript-driven animation; condition the transition or animation mechanism itself when needed. Preserve feedback with a static indicator or lower-motion alternative rather than hiding the result.

Example global override for an application-owned decorative animation class:

```css
@media (prefers-reduced-motion: reduce) {
  .decorative-motion {
    animation: none;
    transition: none;
  }
}
```

Check zoom, text enlargement, narrow layouts, and platform high-contrast/forced-colors settings. Do not shrink text or controls merely to fit an intended screenshot. Measure interactive targets: WCAG 2.2 AA requires at least **24 × 24 CSS pixels** or a qualifying spacing/other exception; **44 × 44** is a stronger touch-friendly design target, not the AA minimum. Recheck rendered dimensions whenever `--spacing` changes.

Sources: [WCAG Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html), [WCAG Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html), [WCAG Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html), [MDN reduced motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion), [v3 Spacing](https://v3.skeleton.dev/docs/design/spacing).

## Concrete verification checklist

Perform these checks in the actual supported browsers after implementation; this reference does not claim they have already been run.

1. **Keyboard only:** Use Tab and Shift+Tab through the whole flow. Confirm visible, ordered focus, button activation with Enter and Space, and link activation with Enter. Verify that menus, tabs, and other widgets retain the chosen library's keyboard contract. Check for unintended traps; a modal intentionally contains focus until dismissal.
2. **Modal/tooltip:** Exercise opening, Escape, close/cancel, focus restoration, background inertness, tooltip focus exposure, hover persistence, and accessible names. Try a removed trigger and long dialog content.
3. **Form:** Activate labels and submit empty, whitespace-only, overlength, invalid, and valid values under the declared policy. Check error association and focus, exact failed-value retention, keyboard behavior for selects/radios, autocomplete and native mobile inputs. Verify server failures separately from browser constraints, with and without enhancement. Mount two reusable instances and confirm each label/help/error resolves only its own control.
4. **Screen reader/accessibility tree:** Inspect names, roles, heading levels, label association and table headers; use a real screen reader to hear error/status changes. Ensure icons and toasts are neither unnamed nor needlessly announced twice.
5. **Responsive/visual:** Check narrow and wide viewports, 200% text enlargement and reflow at 320 CSS pixels, long labels, forced colors and reduced motion both before mount and after preference changes. Measure target sizes/spacing and rendered contrast in both schemes for every active theme, including default, focus, selected, invalid and disabled states. Disabled controls are contrast-exempt, not permission to obscure their state.
6. **SSR/hydration:** Hard reload with slow JavaScript and an opposite persisted mode. Check first-paint flash, matching server and client markup, console hydration warnings, navigation behavior, and browser-only storage access. Check essential native form and navigation behavior without JavaScript; enhanced widgets may require JavaScript but must not falsely appear functional before hydration.
7. **Tailwind/theme pipeline:** Confirm the correct `data-theme`, mode selector and computed `color-scheme`; global CSS loading; forms plugin; presets import; component source path; and complete literal class names. Use [styling.md](styling.md)'s debugging sequence rather than replacing broken tokens with random hardcoded colors.

Sources: [v3 Forms browser support](https://v3.skeleton.dev/docs/tailwind/forms), [APG Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [WAI Notifications](https://www.w3.org/WAI/tutorials/forms/notifications/), [v3 Dark Mode](https://v3.skeleton.dev/docs/guides/mode), [Svelte lifecycle](https://svelte.dev/docs/svelte/lifecycle-hooks).
