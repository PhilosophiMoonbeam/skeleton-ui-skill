# Decide whether to migrate UI behavior

Preserve working components unless a concrete requirement justifies a change. For new UI, start with native HTML and use Bits UI when a headless primitive is needed. Neither adopting this skill nor adding a Bits UI widget requires replacing a working Skeleton widget.

- **Keep Skeleton:** Retain compatible components, providers and themes. Use [Skeleton UI](skeleton.md) for maintenance and the optional [Skeleton major-version upgrade](skeleton-migration.md) only when upgrading Skeleton is the goal.
- **Change interaction library:** For an intentional switch, [replace widgets by intent](#replace-wrappers-by-intent) with native HTML or Bits UI. A Skeleton major upgrade is not a prerequisite to replacing its components. If retaining Skeleton CSS, handle any change to its version separately.

## Identify the starting point

1. Read the consuming app's manifest, resolved lockfile, and installed packages. Search application and shared-package imports, re-exports, wrappers, CSS, providers, hosts, tests, and stories. Find actual callers before removing anything.
2. Identify the resolved Skeleton or Bits UI major before reading migration docs. Old `initializeStores`, `getModalStore`, `getDrawerStore`, and `getToastStore` imports identify historical contracts, not current API. Check the source of similarly named application stores.
3. Keep a compatible Svelte 5 app, its package manager, framework and adapter. Keep the current resolved versions when their peers match the intended change. If a peer does not match, scope the prerequisite separately; do not force installation, batch unrelated upgrades or disable SSR.

## Separate framework prerequisites

Standalone Svelte needs no Kit. The `>=3.1.0` floor is for this skill's [Kit-specific guidance](sveltekit.md), not a peer requirement of Bits UI or Skeleton. Do not upgrade a functioning Kit app solely for a UI change. If applying this skill's Kit 3 instructions to an older app, first scope a separate framework migration; Kit `3.0` is below that guidance's floor, and Kit 2 is only an intermediate when targeting Kit 3.

1. If Svelte itself must change major versions, follow the [Svelte 5 migration guide](https://svelte.dev/docs/svelte/v5-migration-guide) and coordinate it with the app's framework, Vite and Svelte plugin peers. Do not upgrade the deployment adapter, runtime or TypeScript unless their contracts require it for the chosen target. Kit `3.4.0` and `svelte-check@4.7.8` do not accept TypeScript 7; see the [version contract](setup.md#version-contract) for peer and production-runtime details.
2. For a scoped **Kit 2 → 3** change, follow [Kit's migration guide](https://svelte.dev/docs/kit/migrating-to-sveltekit-3): first reach the latest compatible Kit 2 release to expose targeted deprecations. In the Bun-owned workspace, after checking lifecycle hooks such as `prepare` (`bun --bun svelte-kit sync` for the target Kit), the pinned command is `bunx --bun sv@1.7.0 migrate sveltekit-3 --install bun`. Use `--no-install` **instead of** `--install bun` to review generated changes before installing. Do not introduce a second lockfile to use these commands.
3. The [shipped migrator](https://unpkg.com/sv@1.7.0/dist/bin.mjs) writes `@sveltejs/kit: ^3.0.0` and can change other toolchain ranges; it does not establish the exact `3.4.0` baseline. Review every generated change and resulting peer against the intended supported Kit release. Check moved Vite configuration and `svelte.config.*` removal, `$app/tsconfig`, `#lib` paths with explicit extensions, and remaining `$app/environment` and `$app/stores` callers. `$app/env` replaces the former namespace; use read-only rune-reactive `$app/state` instead of the removed Kit stores. Apply only relevant [Kit changes](sveltekit.md#verify-the-project-before-changing-it); keep the deployment target and application behavior.

## Replace wrappers by intent

| Existing behavior | Replacement and equivalence check |
| --- | --- |
| Ordinary action, form field, route navigation, or data table | Use a native button, input, select, link, or table. Preserve label, field name, submit/reset behavior, active route, captions, and headings as applicable. |
| Disclosure, tabs, or grouped controls | Use native `details`/`summary` for a simple disclosure. For a composite widget, follow Bits UI's documented `Root` and parts. Preserve item identity, selection cardinality, disabled behavior, and keyboard navigation. Tabs switch panels; they do not replace route links. |
| Modal, confirmation, or modal drawer | Use Bits UI `Dialog` or `AlertDialog` as appropriate when a native dialog is insufficient. Preserve the title, description, initial focus, containment, allowed dismissal, and focus return. A drawer's placement is styling; do not make an always-visible navigation region modal. Keep async confirmation open on failure. |
| Anchored menu, chooser, or supplemental hint | Use the matching Bits UI pattern rather than one general popup. Preserve keyboard and pointer opening, outside interaction, Escape, disabled items, selection, and anchor placement. A tooltip adds a hint; it is not the trigger's accessible name or a container for controls. |
| Toast or other transient feedback | Bits UI has no Toast primitive. Keep a working [Skeleton Toast](skeleton.md) when a queue, timing, or dismissal is required. Switch to persistent inline feedback only if it meets the requirement. |
| Layout shell or visual wrapper | Use landmarks and application CSS. If retaining Skeleton core, use its documented theme and preset CSS. Replace selectors coupled to the old wrapper DOM with application classes or documented Bits UI part/state attributes. |

Move entire widget roots. If both libraries remain, keep their parts, providers, generated attributes and callback contracts separate. Share domain state and theme tokens, not internal widget state. Compare old and new behavior before removing the last caller, host, import or stylesheet.

## Upgrade a Bits UI v1 implementation

Start with the official [Bits UI migration guide](https://www.bits-ui.com/docs/migration-guide/llms.txt) to identify pre-v1 patterns a wrapper may still carry. That guide documents `0.x` → `1.x+`, not the full v1-to-v2 delta. For v1 → v2, read the [upstream changelog](https://github.com/huntabyte/bits-ui/blob/main/packages/bits-ui/CHANGELOG.md) from the published `2.1.0` major changes through the target version. The v2 line raised the Svelte peer to `^5.33.0` and made `@internationalized/date` a required peer. Use the exact reference pins in [setup](setup.md) when establishing the reference stack; check the resolved peers before changing an existing app.

- Compare each used part and wrapper against the source and target declarations. For example, update Slider wrappers relying on the deprecated `thumbs`/`ticks` snippet values to `thumbItems`/`tickItems`; verify the resulting labels and range behavior. Do not copy a removal called out for pre-v1 code if the destination reintroduced the part: `Select.Value` is exported at `2.22.0`.
- Remove any `asChild`, `builders`, `el`, transition-prop, or `let:` compatibility code that still implements a pre-v1 contract. Use `child` with incoming props on the real element, `bind:ref` for DOM refs, `children` for contents, and the documented mount/transition pattern. For delegated floating content, keep the two elements for `wrapperProps` and `props`.

## Behavior-equivalence checklist

- **State:** Preserve initial and externally updated values, single versus multiple selection, reset, and domain effects. Bind only bindable props; use function bindings for controlled writes. Inspect callback argument types instead of forwarding old event objects or `.detail`. Remove duplicate updates, not application validation.
- **Semantics and focus:** Use named controls with visible focus, stable associations, and instance-safe `$props.id()` for authored IDs. Exercise Tab, Space/Enter, Escape, and the pattern's arrow keys. Verify open, select, cancel, close, focus return, and disabled/invalid states with keyboard and pointer.
- **Forms:** Verify native `FormData` names and values, including multiple, absent, and disabled selections. Retain Enter to submit, reset and validation, and any existing progressive enhancement. Compare generated inputs before adding your own to avoid duplicate entries. Move portalled form controls only if they keep their form owner.
- **Portals and motion:** Preserve placement, stacking, theme inheritance, dismissal, and scroll behavior. Check narrow viewports, nested overlays, reduced motion, and close/reopen during an exit. Closed layers must not remain accessible or interactive.
- **Hydration and cleanup:** Keep state instance-owned and confirm repeated instances do not share IDs, selection, or focus. In Kit, preserve request isolation and any existing no-JavaScript path. Remove obsolete providers, shims, packages, stylesheets, and aliases only after their last caller is migrated. Retain the Skeleton stylesheet and providers if any surviving widgets depend on them.

## Migrate Lucide to the current Svelte package

If the app uses deprecated `lucide-svelte`, the optional reference target is `@lucide/svelte@1.77.0`, independently versioned from either widget library. Use [Lucide's migration guide](https://lucide.dev/guide/svelte/migration) and the [local icon guide](lucide.md) to inventory imports, re-exports, wrappers and runtime icon maps, migrate their callers, then remove the old dependency and obsolete aliases.

- Use canonical public imports, such as `House` (`@lucide/svelte/icons/house`), `CircleExclamationPoint` in place of `AlertCircle`/`CircleAlert`, and `CircleQuestionMark` in place of `HelpCircle`/`CircleHelp`. Root named imports are also public. Check the [exact aliases](https://unpkg.com/@lucide/svelte@1.77.0/dist/aliases/aliases.d.ts), not a guessed path or an all-icon namespace.
- Review `absoluteStrokeWidth` calls individually. It is deprecated, not removed, and its numeric sizing formula is not the same as `nonScalingStroke`'s SVG vector effect. Check stroke and size after switching; keep `strokeWidth` for normal stroke control.
- For generated icon component values, use the public `LucideIcon` type and [finite runtime selection](lucide.md#finite-runtime-selection), not legacy Svelte class-based types or `<svelte:component>`. Generic `Icon` requires `icon` or `iconNode`; it is a different contract. Build shared defaults through [component-subtree context](lucide.md#subtree-defaults), not a module singleton or a getter API copied from a widget provider.
- Lucide 1.x removed brand icons. Use authorized brand SVGs instead of guessing replacement names. Preserve accessible control names and decorative SVG semantics. Static Svelte imports already render inline SVG in SSR; remove iconfont or DOM-scanner work only if it belonged to the replaced implementation.
