# Sources, compatibility evidence, and distribution

Reference baseline as of **2026-10-18**: Skeleton core and Svelte components
**5.0.1**, Svelte **5.57.2**, SvelteKit **3.1.0**, Tailwind CSS **4.3.3**.
Exact packages establish API and dependency contracts, not upstream certification
of every application, deployment, or accessibility requirement.

## Choose the authority before copying code

1. **Inspect the application's resolved packages first.** Lockfile and installed
   metadata determine availability; manifest ranges and documentation titles do not.
2. **Use exact published packages for exports, declarations, CSS, peers, and
   engines.** Read implementation when types omit behavior. Internal inspection
   paths are not supported application import specifiers.
3. **Use current official Skeleton v5 documentation for intent and examples.**
   Check examples against the installed version. Archived v4 documentation is
   staged migration evidence, not the v5 destination API.
4. **Use version-appropriate official framework documentation.** Rolling pages
   can change; compare signatures with exact installed Svelte/Kit/Tailwind packages.
   Skeleton 5 does not itself require Kit 3: preserve compatible existing Kit 2
   applications unless their migration is requested.
5. **Treat search, Context7, and supplied research as discovery/secondary sources.**
   Follow underlying sources and resolve conflicts using exact package evidence.
   Scores, labels, statistics, and prose do not establish API compatibility.

## Primary-source map by task

| Task | Primary sources | How to use them |
| --- | --- | --- |
| Establish versions and dependency contracts | Registry: [core 5.0.1](https://registry.npmjs.org/@skeletonlabs/skeleton/5.0.1), [components 5.0.1](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/5.0.1), [Svelte 5.57.2](https://registry.npmjs.org/svelte/5.57.2), [Kit 3.1.0](https://registry.npmjs.org/@sveltejs/kit/3.1.0), [Tailwind 4.3.3](https://registry.npmjs.org/tailwindcss/4.3.3) | Read `version`, `exports`, peers, optional peers, and engines. Development dependencies are not consumer requirements. |
| Install Skeleton 5 | Official [SvelteKit installation](https://www.skeleton.dev/docs/svelte/get-started/installation/sveltekit.md) and [core API](https://www.skeleton.dev/docs/svelte/get-started/core-api.md) | Use current CSS imports and theme activation; apply Kit 3 setup only when targeting Kit 3. |
| Migrate older Skeleton applications | Official [v4-to-v5 migration](https://www.skeleton.dev/docs/svelte/get-started/migrate-from-v4.md); archived [v3-to-v4](https://v4.skeleton.dev/docs/svelte/get-started/migrate-from-v3) and [v2-to-v4](https://v4.skeleton.dev/docs/svelte/get-started/migrate-from-v2); exact [CLI source](https://unpkg.com/skeleton@5.0.1/dist/index.mjs) | Reach functional v4.15.2 before v5. CLI transformations do not replace manual component, Svelte-peer, field-group, and caller migration. See [migration](migration.md). |
| Select exports and component anatomy | Exact [package metadata](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.1/package.json), [runtime index](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.1/dist/index.js), [declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.1/dist/index.d.ts); official [fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md) and [Svelte documentation index](https://www.skeleton.dev/llms-svelte.txt) | Follow public exports into their declarations/source. Root is the public component entrypoint; `/composed` is not exported. See [components](components.md). |
| Resolve state, callbacks, and floating anatomy | Official [Tabs](https://www.skeleton.dev/docs/svelte/framework-components/tabs.md), [Accordion](https://www.skeleton.dev/docs/svelte/framework-components/accordion.md), [Switch](https://www.skeleton.dev/docs/svelte/framework-components/switch.md), [Tooltip](https://www.skeleton.dev/docs/svelte/framework-components/tooltip.md), [Dialog](https://www.skeleton.dev/docs/svelte/framework-components/dialog.md), [Toast](https://www.skeleton.dev/docs/svelte/framework-components/toast.md) | Verify callbacks, bindability, providers, and element snippets against shipped declarations. See [recipes](recipes.md). |
| Style themes, native controls, and presets | Official [themes](https://www.skeleton.dev/docs/svelte/design/themes), [colors](https://www.skeleton.dev/docs/svelte/design/colors), [presets](https://www.skeleton.dev/docs/svelte/tailwind-utilities/presets), [forms](https://www.skeleton.dev/docs/svelte/tailwind-components/forms.md); exact [core CSS](https://unpkg.com/@skeletonlabs/skeleton@5.0.1/src/index.css), [presets CSS](https://unpkg.com/@skeletonlabs/skeleton@5.0.1/src/utilities/presets.css), [Cerberus](https://unpkg.com/@skeletonlabs/skeleton@5.0.1/src/themes/cerberus.css), [framework CSS](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.1/dist/index.css) | Separate core/native CSS from optional framework behavior. Presets are included in core; form utilities require the forms plugin. See [styling](styling.md). |
| Compose responsive pages | Official [typography](https://www.skeleton.dev/docs/svelte/design/typography), [spacing](https://www.skeleton.dev/docs/svelte/design/spacing), [responsive design](https://tailwindcss.com/docs/responsive-design) | Apply [design](design.md), then inspect actual narrow/wide rendering; a recipe is not an exported AppShell component. |
| Configure Tailwind 4 | Official [Vite installation](https://tailwindcss.com/docs/installation/using-vite), [class detection](https://tailwindcss.com/docs/detecting-classes-in-source-files), [dark mode](https://tailwindcss.com/docs/dark-mode), [upgrade guide](https://tailwindcss.com/docs/upgrade-guide); exact [Vite plugin metadata](https://registry.npmjs.org/@tailwindcss/vite/4.3.3) | Use complete class strings and stylesheet-relative shared-source paths. Framework CSS replaces the old Skeleton distribution scan, not all uses of `@source`. |
| Write Svelte 5 state and lifecycle | Official [migration](https://svelte.dev/docs/svelte/v5-migration-guide), [$state](https://svelte.dev/docs/svelte/$state), [$derived](https://svelte.dev/docs/svelte/$derived), [$effect](https://svelte.dev/docs/svelte/$effect), [$props](https://svelte.dev/docs/svelte/$props), [snippets](https://svelte.dev/docs/svelte/snippet), [lifecycle](https://svelte.dev/docs/svelte/lifecycle-hooks); exact [types](https://unpkg.com/svelte@5.57.2/types/index.d.ts) | Use instance-owned state and hydration-stable IDs; distinguish browser-only lifecycle from SSR. |
| Configure or migrate Kit 3 | Official [stable Kit 3 migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3), [environment variables](https://svelte.dev/docs/kit/environment-variables); exact [Kit declarations](https://unpkg.com/@sveltejs/kit@3.1.0/types/index.d.ts) | Confirm Vite configuration, `$app/tsconfig`, `#lib`, `$app/env`, `$app/state`, navigation, and enhancement signatures. Preserve Kit 2 configuration when not migrating. |
| Implement isolated SSR and native/progressive forms | Official [state management](https://svelte.dev/docs/kit/state-management), [load](https://svelte.dev/docs/kit/load), [server-only modules](https://svelte.dev/docs/kit/server-only-modules), [form actions](https://svelte.dev/docs/kit/form-actions) | Keep user data out of server singletons; preserve native POST and raw failed text. See [SvelteKit integration](sveltekit.md). |
| Evaluate interaction and accessibility | WAI [modal dialogs](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [labels](https://www.w3.org/WAI/tutorials/forms/labels/), [form notifications](https://www.w3.org/WAI/tutorials/forms/notifications/), [status messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html) | These are requirements/guidance, not passed checks. Use [accessibility](accessibility.md). |
| Distribute the skill | [Agent Skills specification](https://agentskills.io/specification) | Preserve directory naming, string metadata, relative references, and progressive disclosure. |

Version-qualified registry URLs describe published metadata; UNPKG exposes the
same published package files. If unavailable, inspect the installed copy or the
registry record's `dist.tarball`, not an unversioned `latest` substitute.

## Secondary research and corrections

The supplied Gemini research, [Architectural Evolution and Design System
Engineering in Skeleton v5](https://share.gemini.google/2iTB8QXtd8cZ), informed
research questions, not API authority. Its shared page redirected to
[Gemini's canonical share](https://gemini.google.com/share/0b64a27b7a4e).
The following corrections also apply when official prose conflicts with packages:

- Accordion uses `value: string[]`, `onValueChange`, and `e.value`, not
  `open/onOpenChange/e.change`. The exported step component is `Steps`, not `Stepper`.
- Export spelling is `QrCode`, not `QRCode`. Verify names from runtime exports,
  not documentation-navigation totals or assumed component counts.
- `createToaster` creates a store, not an enforced process singleton. Keep stores
  instance-owned; share through layout context when needed, with one renderer per
  store. Never put user-specific notification queues in a mutable SSR singleton.
- Tokens, contrast assignments, OKLCH, and framework components do not guarantee
  accessibility. Measure rendered contrast and test keyboard/focus behavior.
- Do not treat preview/beta labels, browser-support tables, utility/property/theme
  totals, adoption statistics, or trend claims as stable package contracts. Use
  versioned evidence for relevant features and test target browsers. Local preview
  examples do not establish persistence or production readiness.
- Provider factories need required IDs; element snippets must forward supplied
  attributes. Custom example presets and corner tokens do not imply shipped
  utilities or automatic global geometry. See the relevant component/style guide.

## Offline installed-package inspection

1. Read manifest, lockfile, and installed metadata through the actual workspace
   dependency layout, including symlinks. Record resolved versions and overrides;
   preserve package manager and lockfile.
2. Read `exports`/`types`. In component 5.0.1, start at `dist/index.d.ts` and
   `dist/index.js`, then follow relative declarations and source. Inspect required
   props, callback payloads, snippet tuples, child members, and bindability.
3. Follow inherited Zag contracts through the installed dependency version, not
   rolling Zag documentation. Read implementation for rendered tags, hidden/native
   inputs, default styling, event forwarding, and lifecycle behavior.
4. Inspect core `src/index.css`, its imported utilities, and `src/themes/*.css`,
   plus Svelte package `dist/index.css`. Core exports only its root, themes, and
   package metadata; `/optional/presets` is obsolete. Inspect installed Svelte/Kit
   `types/index.d.ts` for framework contracts.
5. Compare only affected contracts when versions differ. Do not silently change
   dependencies to fit an example. Name missing evidence rather than inventing APIs.

## Exact compatibility baseline and observed evidence

| Dependency/runtime | Exact baseline |
| --- | --- |
| Node / npm observed during installation | `24.15.0` / `12.2.0` |
| `@skeletonlabs/skeleton` / `@skeletonlabs/skeleton-svelte` | `5.0.1` / `5.0.1` |
| `svelte` / `@sveltejs/kit` | `5.57.2` / `3.1.0` |
| `vite` / `@sveltejs/vite-plugin-svelte` | `8.3.4` / `7.3.1` |
| `typescript` / `svelte-check` | `6.0.3` / `4.7.7` |
| `tailwindcss` / `@tailwindcss/vite` | `4.3.3` / `4.3.3` |
| `@sveltejs/adapter-auto` / `@tailwindcss/forms` | `8.0.0` / `0.5.11` |

Core requires Tailwind `^4.0.0`; components require Svelte `^5.40.0`. Kit 3.1.0
requires Node `>=22.17`, Svelte `^5.57.1`, Vite `^8.0.12`, and Svelte Vite plugin
`^7.0.0`; TypeScript `^6.0.0` is optional. Combined tool engines permit maintained
Node 22 from 22.17 or Node 24+; use a maintained compatible release. JavaScript-only
apps need not add TypeScript. Preserve the application's production adapter.
These pins and peers do not certify every version in their ranges.

**Observed checks on this exact baseline (2026-10-18):**

- The isolated installation added 130 packages without forced peers, using the
  exact versions above.
- Eighteen complete documented components were extracted into the fixture.
  `npm run check` checked 945 files with 0 errors and 0 warnings.
- Client and server production builds passed. `adapter-auto` found no production
  target; the environment emitted a `NO_COLOR`/`FORCE_COLOR` warning.
- `skills-ref validate` passed. Structural checks covered 11 Markdown files,
  99 local links, and 45 code fences with no failures.
- A consumer type proof accepted the catalog's 31 components, 200 listed anatomy
  members, and 30 helper exports. This establishes type availability, not runtime
  coverage of every export.

**Observed browser interactions:** Chromium **155.0.8059.84**, production preview:

| Scenario | Observed result |
| --- | --- |
| Tabs | Click, ArrowLeft, Home, and End updated focus, panels, and controlled state. |
| Accordion | Click selected cancel; Space collapsed the controlled value to none. |
| Switch/native form | Space changed state; `FormData` omitted unchecked notifications and included checked notifications as `on`. |
| Tooltip | Focus exposed portalled help with matching `aria-describedby`; Escape hid it. |
| Dialog | Title/description, initial Cancel focus, Tab containment, Escape focus restoration, Cancel, local confirmation, and 320px viewport fit passed. |
| Toast | The instance-owned group rendered title/description; Enter on its named Close removed it before auto-expiry. |
| Combobox | Keyboard selection, true empty results, full-list reopening, pointer/Space Clear, and disjoint controls passed. Open and closed popups fit 320px; controls had no overflow at 320, 375, and 1280px. |
| Pagination | Native page buttons accepted Enter; row slices, last-page boundaries, size reset, zero/one-row states, and parent-form non-submission passed. |
| Provider/custom element | Explicit-ID Tooltip provider, forwarded button attributes, getter state, and Escape worked. |
| Repeated instances | 55 IDs were unique; labels resolved; second Tabs/ProfilePreview/Dialog state remained isolated; Summary links focused their own heading. |
| Native field groups | Both documented grouped-field labels focused their own inputs; coordinated `field-xl`/`btn-xl` controls measured 42px high. |
| Native dialog/disclosure | `showModal`, Escape, dialog-form results, and independent exclusive disclosure groups worked. |
| Theme/motion | Light/dark pairings and independent local-scheme brand colors changed; application reduced-motion rules disabled native transitions. |
| Svelte state | Native parent binding updated the derived counter; route state rendered; media changes updated mounted state. |
| Server forms | Enhanced failure retained spaces and focused the invalid field. Native HTML POSTs preserved spaces and all 81 overlength characters; valid, missing, and file values followed the declared policy. |
| No JavaScript | Required validation, failed/successful native POSTs, disabled local previews/filters, four SSR briefs, and native navigation worked. |
| Responsive shell | Apply/reset/search/status/empty states, skip-link focus, and mobile section links worked; no overflow at 320/375/768/1280px. Narrow/wide screenshots were inspected. |
| Kit 3 navigation | Shallow address-bar metadata stayed distinct from rendered `page.url`; `refreshAll()` worked; persisted state survived reload. |

The hydrated preview had no recorded runtime or hydration errors. Script requests
were deliberately blocked in the no-JavaScript run; protocol inspection reported
`blockedReason: csp`, with no loading failures after JavaScript was re-enabled.
These observations do not certify a full contrast, forced-colors, text-zoom, or
screen-reader audit, every exported/beta component, framework file-upload or
monorepo runtime, concurrent authenticated-session isolation, or deployment.
`adapter-auto` had no production target. Local confirmations do not establish
persistence; historical v3 checks were not relabeled as v5 evidence.

## Maintenance and future re-verification

1. Record date, runtime, package manager, exact resolved versions, lockfile, and
   workspace configuration. Do not generalize one fixture to an entire peer range.
2. Compare exact metadata, exports, declarations, source, and CSS with current v5
   docs. Use archives only for authorized staged migration. Review engines,
   optional peers, adapters, public entrypoints, tokens, and source detection.
3. Update every affected example, caller, reference, and task route together.
   Remove obsolete APIs rather than retaining compatibility shims.
4. In an authorized disposable fixture or application workflow, install without
   forced peers; extract complete documented examples/configuration. Run project
   checks and production build after edits finish. Record actual commands, results,
   warnings, and failures; do not predict counts.
5. Exercise hydration, repeated-instance associations, callback state, providers,
   keyboard/focus, overlays, responsive/theme/mode rendering, native/enhanced forms,
   raw failed values, and no-JavaScript behavior as applicable. Report browser and
   exact interactions; visual checks do not certify accessibility.
6. Verify request isolation, production adapter, and deployment target separately
   when required. Record unavailable checks and remaining limits explicitly.

## Portable distribution and installation

Distribute the entire `skeleton-svelte/` directory with `SKILL.md` and `references/`
intact. Follow the consumer host's documented skill-discovery instructions; retain
its directory name, relative links, and filenames. Do not ship only `SKILL.md`,
flatten references, or depend on authoring-workspace absolute paths.

There is no universal host-specific installation path in this format. Refresh
host discovery only when required. Installing the skill copies documentation,
not application dependencies or a verified toolchain, and does not mandate its use
for unrelated UI work. Bundled references and installed-package inspection work
offline; dependency installation uses the application's normal registry/cache.
