# Migrate UI behavior to Bits UI

Replace the interaction, not the component name. Use native HTML where it meets the same requirements; use Bits UI for composite widgets and layered interactions. Optional Skeleton core CSS can remain a styling dependency. Use [setup](setup.md) for supported pins, [fundamentals](bits-ui.md) for shared APIs, and the [component catalog](components.md) to select the destination anatomy.

## Identify the starting point

1. Read the consuming app's manifest, resolved lockfile, and installed packages. Search application and shared-package imports, re-exports, wrappers, CSS, providers, hosts, tests, and stories. Find actual callers before removing anything.
2. Treat `@skeletonlabs/skeleton-svelte`, old `initializeStores` or `getModalStore`/`getDrawerStore`/`getToastStore` imports, and legacy framework CSS imports as recognition and removal signals. Confirm the source of any similarly named application store. Do not install an intermediate UI stack or migrate through older wrapper generations.
3. Keep the existing compatible Svelte 5 app, its package manager, and its framework and adapter. Bits UI does not require Kit. The `>=3.1.0` floor applies only to [Kit-specific guidance](sveltekit.md); do not upgrade an existing Kit app solely for this UI change. If the app's Svelte or another peer does not satisfy the selected version, identify the mismatch and scope the prerequisite separately. Do not force installation or disable SSR.

## Replace wrappers by intent

| Existing behavior | Replacement and equivalence check |
| --- | --- |
| Ordinary action, form field, route navigation, or data table | Use a native button, input, select, link, or table. Preserve label, field name, submit/reset behavior, active route, captions, and headings as applicable. |
| Disclosure, tabs, or grouped controls | Use native `details`/`summary` for a simple disclosure. For a composite widget, follow Bits UI's documented `Root` and parts. Preserve item identity, selection cardinality, disabled behavior, and keyboard navigation. Tabs switch panels; they do not replace route links. |
| Modal, confirmation, or modal drawer | Use Bits UI `Dialog` or `AlertDialog` as appropriate when a native dialog is insufficient. Preserve the title, description, initial focus, containment, allowed dismissal, and focus return. A drawer's placement is styling; do not make an always-visible navigation region modal. Keep async confirmation open on failure. |
| Anchored menu, chooser, or supplemental hint | Use the matching Bits UI pattern rather than one general popup. Preserve keyboard and pointer opening, outside interaction, Escape, disabled items, selection, and anchor placement. A tooltip adds a hint; it is not the trigger's accessible name or a container for controls. |
| Toast or other transient feedback | Bits UI has no Toast primitive. Use an inline status message when appropriate. If a transient queue remains necessary, keep it application-owned with deliberate announcement priority, labeled dismissal, and pause/timing behavior. Do not move focus for routine updates or store user queues in a shared server singleton. |
| Layout shell or visual wrapper | Use landmarks and application CSS. If retaining Skeleton core, use its documented theme and preset CSS. Replace selectors coupled to the old wrapper DOM with application classes or documented Bits UI part/state attributes. |

## Upgrade a Bits UI v1 implementation

Start with the official [Bits UI migration guide](https://www.bits-ui.com/docs/migration-guide/llms.txt) to identify pre-v1 patterns a wrapper may still carry. That guide documents `0.x` → `1.x+`, not the full v1-to-v2 delta. For v1 → v2, read the [upstream changelog](https://github.com/huntabyte/bits-ui/blob/main/packages/bits-ui/CHANGELOG.md) from the published `2.1.0` major changes through the target version. The v2 line raised the Svelte peer to `^5.33.0` and made `@internationalized/date` a required peer. Use the exact reference pins in [setup](setup.md) when establishing the reference stack; check the resolved peers before changing an existing app.

- Compare each used part and wrapper against the source and target declarations. For example, update Slider wrappers relying on the deprecated `thumbs`/`ticks` snippet values to `thumbItems`/`tickItems`; verify the resulting labels and range behavior. Do not copy a removal called out for pre-v1 code if the destination reintroduced the part: `Select.Value` is exported at `2.22.0`.
- Remove any `asChild`, `builders`, `el`, transition-prop, or `let:` compatibility code that still implements a pre-v1 contract. Use `child` with incoming props on the real element, `bind:ref` for DOM refs, `children` for contents, and the documented mount/transition pattern. For delegated floating content, keep the two elements for `wrapperProps` and `props`.

## Behavior-equivalence checklist

- **State:** Preserve initial and externally updated values, single versus multiple selection, reset, and domain effects. Bind only bindable props; use function bindings for controlled writes. Inspect callback argument types instead of forwarding old event objects or `.detail`. Remove duplicate updates, not application validation.
- **Semantics and focus:** Use named controls with visible focus, stable associations, and instance-safe `$props.id()` for authored IDs. Exercise Tab, Space/Enter, Escape, and the pattern's arrow keys. Verify open, select, cancel, close, focus return, and disabled/invalid states with keyboard and pointer.
- **Forms:** Verify native `FormData` names and values, including multiple, absent, and disabled selections. Retain Enter to submit, reset and validation, and any existing progressive enhancement. Compare generated inputs before adding your own to avoid duplicate entries. Move portalled form controls only if they keep their form owner.
- **Portals and motion:** Preserve placement, stacking, theme inheritance, dismissal, and scroll behavior. Check narrow viewports, nested overlays, reduced motion, and close/reopen during an exit. Closed layers must not remain accessible or interactive.
- **Hydration and cleanup:** Keep state instance-owned and confirm repeated instances do not share IDs, selection, or focus. In Kit, preserve request isolation and any existing no-JavaScript path. Migrate every consumer, then remove obsolete providers, shims, component packages, framework stylesheets, and import aliases. Keep unrelated stores, CSS processing, and dependencies.

## Migrate Lucide to the current Svelte package

If the app already imports `lucide-svelte`, use [Lucide's migration guide](https://lucide.dev/guide/svelte/migration) and [the local icon guide](lucide.md) to replace its imports with `@lucide/svelte`. Preserve icon meaning, named controls, and decorative SVG semantics; then remove the old dependency. Icons are optional and do not supply interaction behavior.
