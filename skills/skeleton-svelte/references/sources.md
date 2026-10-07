# Sources, compatibility evidence, and distribution

Authoring baseline verified **2026-10-07**: Skeleton **v3**, Svelte **5.57.2**, and SvelteKit **3.0.1**. Exact metadata establishes the version contract; the isolated fixture observations below cover the current documented examples. Neither is an upstream support statement or certification of deployment or accessibility.

## Choose the authority before copying code

1. **For the application you are changing, inspect its resolved packages first.** The lockfile and installed package metadata determine what is available; a manifest range or a documentation title does not.
2. **For this baseline, exact published packages govern exports, props, types, CSS, peers, and engines.** Use version-qualified registry records and package files below. Read implementation source when declarations omit behavior.
3. **Use the archived `v3.skeleton.dev` pages for Skeleton v3 intent and examples.** Its installation guide lists minimum majors Kit 2, Svelte 5, and Tailwind 4; that table is not evidence of Kit 3 runtime certification. For the pinned Kit 3 target, use its exact metadata/types and [setup](setup.md); preserve a different existing toolchain unless migration is requested.
4. **Treat rolling framework documentation as contextual guidance.** `svelte.dev` and `tailwindcss.com` pages may evolve after this date. Check the relevant major and confirm signatures against the exact installed versions.
5. **Treat search and Context7 snippets as discovery, not version proof.** Current `skeleton.dev` material and even a Context7 result resolved under a v3 library identifier can contain v4/v5 APIs. Follow its underlying source URL and compare the import subpath, exports, props, and examples with the exact v3 package before using it. A high source score or a version label is not sufficient.

For example, unavailable root imports such as `Portal`, `Dialog`, or `useListCollection` are a signal to compare declarations, not to install a later Skeleton major. Conversely, dotted names are not universally later-major APIs: root v3 `Accordion.Item` exists, and the **separate alpha** `/composed` entrypoint has Avatar/Accordion families. Do not blend those APIs. See [migration](migration.md#avoid-v4v5-compound-api-traps).

## Primary-source map by task

| Task | Precise primary sources | How to use them |
| --- | --- | --- |
| Establish package versions and peer contracts | Registry: [core 3.2.2](https://registry.npmjs.org/@skeletonlabs/skeleton/3.2.2), [components 1.5.3](https://registry.npmjs.org/@skeletonlabs/skeleton-svelte/1.5.3), [Svelte 5.57.2](https://registry.npmjs.org/svelte/5.57.2), [Kit 3.0.1](https://registry.npmjs.org/@sveltejs/kit/3.0.1) | Read `version`, `exports`, `peerDependencies`, `peerDependenciesMeta`, and `engines`; do not confuse development dependencies with consumer requirements. |
| Install Skeleton v3 or migrate v2 | Archived [SvelteKit installation](https://v3.skeleton.dev/docs/get-started/installation/sveltekit) and [v2 migration](https://v3.skeleton.dev/docs/get-started/migrate-from-v2) | Preserve v3 CSS/import conventions, but apply Kit 3 configuration separately. A migration script is not a complete component-prop conversion. |
| Select a component or resolve an API mismatch | Exact [root declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/index.d.ts), [root runtime index](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/index.js), and [composed declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/composed/index.d.ts); [component map](components.md) links each family | Follow the export's relative declaration/source paths; root and `/composed` are distinct contracts. Do not import package internals just because you can inspect them. |
| Resolve controlled state, callbacks, and snippets | Archived [Accordion](https://v3.skeleton.dev/docs/components/accordion/svelte), [Tabs](https://v3.skeleton.dev/docs/components/tabs/svelte), [Switch](https://v3.skeleton.dev/docs/components/switch/svelte), and [toast](https://v3.skeleton.dev/docs/components/toast/svelte); exact [Switch types](https://unpkg.com/@skeletonlabs/skeleton-svelte@1.5.3/dist/components/Switch/types.d.ts) | Compare callback payloads and snippet names with declarations rather than translating v2 dispatched events mechanically. |
| Decide whether an experimental API is appropriate | Archived [composed Avatar](https://v3.skeleton.dev/docs/components-composed/avatar/svelte) and [composed Accordion](https://v3.skeleton.dev/docs/components-composed/accordion/svelte) | These pages explicitly mark the composed features alpha and not intended for production. Prefer root APIs unless the task explicitly calls for alpha. |
| Style themes, tokens, presets, and native controls | Archived [core API](https://v3.skeleton.dev/docs/get-started/core-api), [themes](https://v3.skeleton.dev/docs/design/themes), [colors](https://v3.skeleton.dev/docs/design/colors), [presets](https://v3.skeleton.dev/docs/design/presets), [forms](https://v3.skeleton.dev/docs/tailwind/forms), and [mode](https://v3.skeleton.dev/docs/guides/mode) | Pair descriptions with exact core [CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/index.css), [presets CSS](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/optional/presets.css), and [Cerberus theme](https://unpkg.com/@skeletonlabs/skeleton@3.2.2/dist/themes/cerberus.css). Theme import and `data-theme` activation are separate. |
| Compose a polished responsive page or app shell | Archived [layouts](https://v3.skeleton.dev/docs/guides/layouts), [typography](https://v3.skeleton.dev/docs/design/typography), and [spacing](https://v3.skeleton.dev/docs/design/spacing); official [responsive design](https://tailwindcss.com/docs/responsive-design) | Use [design](design.md) for composition decisions and the complete responsive app-shell recipe. These are design guidance, not a claim that Skeleton exports an `AppShell` component. Verify utilities against installed CSS and inspect the rendered result. |
| Configure Tailwind 4 scanning and mode | Official [Vite installation](https://tailwindcss.com/docs/installation/using-vite), [class detection](https://tailwindcss.com/docs/detecting-classes-in-source-files), [dark mode](https://tailwindcss.com/docs/dark-mode), and [v4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide); exact [Vite plugin metadata](https://registry.npmjs.org/@tailwindcss/vite/4.3.3) | Register component sources relative to the actual stylesheet, use complete class strings, and distinguish Tailwind 4 instructions from Tailwind 3 config/plugins. |
| Write Svelte 5 components and reusable state | Official [v5 migration](https://svelte.dev/docs/svelte/v5-migration-guide), [$state](https://svelte.dev/docs/svelte/$state), [$derived](https://svelte.dev/docs/svelte/$derived), [$effect](https://svelte.dev/docs/svelte/$effect), [$props](https://svelte.dev/docs/svelte/$props), [snippets](https://svelte.dev/docs/svelte/snippet), and [lifecycle](https://svelte.dev/docs/svelte/lifecycle-hooks); exact [Svelte declarations](https://unpkg.com/svelte@5.57.2/types/index.d.ts) | Use runes/snippets/callback props for these examples; confirm effect and lifecycle SSR behavior rather than assuming browser code runs on the server. |
| Configure or migrate Kit 3 | Official [Kit 3 migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3), specifically [$app/tsconfig](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig) and [$app/forms](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-forms); exact [Kit declarations](https://unpkg.com/@sveltejs/kit@3.0.1/types/index.d.ts) | Kit 2 tutorials can be wrong for Kit 3: Vite plugin configuration replaces `svelte.config.*`; `$app/tsconfig` needs explicit include/exclude; `#lib`, `$app/env`, `$app/state`, and enhance's `refreshAll` differ from familiar older APIs. |
| Implement request-isolated SSR and native/progressive forms | Official [state management](https://svelte.dev/docs/kit/state-management), [load](https://svelte.dev/docs/kit/load), [server-only modules](https://svelte.dev/docs/kit/server-only-modules), [environment variables](https://svelte.dev/docs/kit/environment-variables), and [form actions](https://svelte.dev/docs/kit/form-actions) | Keep request/user data out of module singletons; check exact Kit declarations for action, redirect, and enhance signatures. See [SvelteKit integration](sveltekit.md). |
| Verify interaction and accessibility expectations | W3C WAI [modal dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [form labels](https://www.w3.org/WAI/tutorials/forms/labels/), [form notifications](https://www.w3.org/WAI/tutorials/forms/notifications/), and [status messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html) | These are behavior/semantics guidance, not evidence that an implementation passed. Exercise the browser checklist in [accessibility](accessibility.md). |
| Package or distribute the skill | [Agent Skills specification](https://agentskills.io/specification), especially [directory structure](https://agentskills.io/specification#directory-structure) and [file references](https://agentskills.io/specification#file-references) | Preserve `SKILL.md` metadata and relative reference paths. The format does not define a universal host-specific installation command. |

The version-qualified registry URLs identify package metadata; version-qualified UNPKG links expose the corresponding published package files, not a separate API authority. If a CDN is unavailable, use the installed copy or the registry record's `dist.tarball`. Do not replace an exact URL with an unversioned `latest` URL.

## Offline installed-package inspection

No network or documentation service is required for the bundled patterns or for inspecting dependencies already installed in the consumer project.

1. Read the application's manifest, lockfile, and installed `package.json` files through its real workspace dependency layout (including package-manager symlinks). Record **resolved** versions and any relevant patches/overrides. Respect the existing package manager; do not create another lockfile.
2. Read each package's `exports`/`types` fields to locate the public contract. For component `1.5.3`, inspect the installed file `dist/index.d.ts` from the package directory; use `dist/composed/index.d.ts` only to inspect that subpath. These are inspection paths, not public application import specifiers.
3. Follow a component's relative declarations to its `.svelte.d.ts` and `types.d.ts`. Inspect required props, snippet parameter tuples, callback payloads, bindability, and available child members. Follow imported Zag declarations through the **installed dependency version**, not current Zag docs, when inherited props matter.
4. Inspect the matching published `.svelte`/`.js` implementation for semantics, default classes, native inputs, event forwarding, and SSR behavior that declarations cannot show. Inspection does not make internal paths supported application imports.
5. Inspect core `dist/index.css`, `dist/optional/presets.css`, and the selected `dist/themes/*.css`; confirm real utilities, custom properties, and theme selectors. Inspect installed Svelte and Kit `types/index.d.ts` for framework signatures.
6. If installed versions differ from this baseline, compare only affected contracts. Keep the user's version/deployment constraints; retrieve version-matched documentation and do not silently upgrade or downgrade to make an example work. Use `/composed` only for explicitly requested alpha work. If evidence is unavailable, state the exact unknown instead of inventing an export or asserting compatibility.

## Exact compatibility baseline and observed smoke

Skeleton's packages are **independently numbered**: this baseline pairs core **`3.2.2`** with Svelte components **`1.5.3`**. Skeleton v3 does not imply component version `3`. The component package's metadata lists core `3.2.2` as a development dependency, not a consumer peer requirement. Its consumer peer is Svelte `^5.20.0`; core's peer is Tailwind `^4.0.0`. These records help establish the chosen pair and its peer requirements. They do not certify Kit 3 runtime compatibility.

The isolated second-pass fixture used this exact toolchain:

| Dependency/runtime | Observed version |
| --- | --- |
| Node | `24.15.0` |
| `svelte` / `@sveltejs/kit` | `5.57.2` / `3.0.1` |
| `@skeletonlabs/skeleton` / `@skeletonlabs/skeleton-svelte` | `3.2.2` / `1.5.3` |
| `vite` / `@sveltejs/vite-plugin-svelte` | `8.0.12` / `7.0.0` |
| `typescript` / `svelte-check` | `6.0.3` / `4.7.6` |
| `tailwindcss` / `@tailwindcss/vite` | `4.3.3` / `4.3.3` |
| `@sveltejs/adapter-auto` / `@tailwindcss/forms` | `8.0.0` / `0.5.11` |

Kit `3.0.1` requires Node `>=22.17` and has peer requirements for Svelte `^5.57.1`, Vite `^8.0.12`, and Svelte Vite plugin `^7.0.0`. Its TypeScript `^6.0.0` peer is **optional**: JavaScript-only projects need not add TypeScript. When TypeScript tooling is present, the baseline pins `6.0.3`; a peer range is not an exact-version installation instruction. Also satisfy every selected tool's engine range. See [setup](setup.md#version-contract) for pinned setup and registry links.

**Observed second-pass checks on 2026-10-07:**

- `skills-ref validate skills/skeleton-svelte` passed. Structural checks confirmed valid local reference paths and balanced Markdown fences.
- `npm install` succeeded without forcing peer dependencies.
- The fixture extracted the documented Vite configuration, CSS, TypeScript configuration, root layout, 15 complete Svelte examples, and the greeting server action. Each example had its own route; the global stylesheet enabled the documented forms plugin.
- `npm run check` checked **267 files with 0 errors and 0 warnings**.
- `npm run build` completed server and client production builds. Adapter auto reported **no deployment target**.
- Production-preview browser checks exercised Tabs click/ArrowLeft activation, Accordion click/Space toggling, Switch Space activation and native `FormData`, Tooltip keyboard exposure/`aria-describedby`/Escape, and Toaster rendering. Modal checks confirmed its accessible title, initial focus, Shift+Tab containment, Escape dismissal, restored trigger focus, and local confirmation.
- Combobox keyboard search/selection displayed Beacon's label and value; its dropdown reopened the full list. Pagination rendered the initial, next, and last row slices, disabled the next-page boundary control, and reset to page 1 when the size changed from 5 to 20.
- App-shell filters produced one search result, two Draft results, and an empty state; reset restored four briefs. Mobile navigation toggled with Space, followed a real section link, and remained expanded. The skip link focused `main`.
- App-shell layout checks found no horizontal overflow at **320, 375, 768, and 1280px**. Desktop/mobile screenshots were inspected. Computed Cerberus tokens, light/dark pairing changes, and the reduced-motion example's media-query response were observed.
- Native required validation blocked an empty local preview; valid input updated its explicitly local status. The native wrapper's derived length and route-state pathname updated/rendered as documented.
- With JavaScript disabled, SSR rendered four briefs with disabled filters and working disclosure navigation. Native greeting POSTs returned **400** for whitespace and **200** with `Hello, Grace!` for valid input. Enhanced submission exposed `aria-invalid` on the server error and returned `Hello, Ada!` on success.
- The hydrated browser error list was empty.

These observations cover the extracted fixture and listed interactions, not every exported component, application, browser, or version satisfying peer ranges. They do not certify a full contrast audit, screen-reader or assistive-technology behavior, production adapters, hosting, or deployment. Parent binding, file upload, monorepo installation, and interactions not listed above are not claimed as exercised in this pass. Archived minimums and peer ranges remain separate evidence from runtime checks. Re-run relevant gates and browser interactions after future changes.

## Third-pass verification

Observed **2026-10-07** in a disposable fixture; this record supplements, rather than replaces, the second-pass history above. Resolved versions: Node `24.15.0`, npm `12.2.0`, core `3.2.2`, Svelte components `1.5.3`, Svelte `5.57.2`, Kit `3.0.1`, Vite `8.0.12`, Svelte Vite plugin `7.0.0`, TypeScript `6.0.3`, **svelte-check `4.6.0`** (second pass: `4.7.6`), Tailwind and its Vite plugin `4.3.3`, forms `0.5.11`, adapter-auto `8.0.0`. These are observed versions, not latest-release claims.

- **Fixture and installation:** extracted the exact documented Vite configuration, TypeScript configuration, Kit layout, and global CSS with forms enabled. Mounted all 15 complete non-layout Svelte examples and the greeting action, plus repeated ProfilePreview/Summary and NameField parent-binding routes. The setup mapping `#lib/*` → `./src/lib/*` and `$app/env` browser import compiled and mounted. `npm install --no-audit --no-fund` installed 110 packages without forced peers.
- **Type/build evidence:** `npm run check` (`svelte-kit sync && svelte-check --tsconfig ./tsconfig.json`) checked **273 files, 0 errors, 0 warnings**. The check and `npm run build` passed again after the PreferencesForm correction; both client/server production builds completed. Adapter-auto found no supported production target; Node emitted a `NO_COLOR`/`FORCE_COLOR` environment warning, not an application or type error.
- **Skill structure:** `skills-ref validate skills/skeleton-svelte` passed after final routing/provenance integration. A Python structural check covered all 10 skill Markdown files and README links, resolved local targets and anchors, and found balanced fences.

**Runtime evidence:** real Chromium `Chrome/154.0.8037.97` against production preview; the hydrated browser error list was empty.

- Tabs: Activity click, then ArrowLeft returned Overview. Accordion: Cancel click, then Space closed to none. Switch: native checkbox Space changed notifications; `FormData` reported `true`. Combobox: typing `bea`, ArrowDown, and Enter selected Beacon dashboard (`beacon`).
- Tooltip: keyboard focus exposed described-by content; Escape dismissed it. Modal: title `Archive this project?`, description, initial Cancel focus, Shift+Tab containment, Escape restoring the Archive project trigger, and local confirmation status were observed. Toast activation rendered title and description.
- Pagination: initial rows 1–5, Next 6–10, Last 21–23, disabled Next at the boundary; size 20 reset to page 1/rows 1–20, then Last showed page 2/rows 21–23.
- Repeated ProfilePreview before repair reproduced duplicate `preview-title`/`name`/`help` IDs, an unnamed second input, and both labels targeting the first form. After repair, IDs were unique, both labels resolved their own forms, and changing the second left the first `Not set`. Repeated Summary had unique IDs and heading associations; its second fragment link focused the second heading. NameField parent binding showed `Maya` and the derived `4/80` counter. RouteLocation displayed the current route; ReducedMotion responded to enabled and disabled media preferences.
- Native required validation blocked empty local preview submission; `Grace` updated local-only status. Greeting native POST: whitespace returned 400 and retained exact spaces; an 81-character name returned 400 and retained all 81 characters; ` Grace ` returned 200 and `Hello, Grace!`. Before repair, native POST lost whitespace input to `''`. Enhanced whitespace errors retained spaces, associated help/error content, and focused the invalid input; success returned `Hello, Ada!`.
- Fieldnotes: Harbor search returned 1 brief, Draft 2, no match an empty state, and reset 4. Mobile Space opened disclosure; a real library section link worked and disclosure stayed open. The skip link focused `main`.
- With JavaScript disabled: four briefs rendered, shell filters were disabled with an explanation, native disclosure worked, and ProfilePreview input/submit were disabled. Greeting native whitespace POST retained its value, error association, and Edit name link.
- PreferencesForm before repair submitted local values through a native GET without JavaScript. After repair, its submit button remained disabled and Enter did not change the URL; after hydration, Space and submission still returned `Ada / weekly / notifications: true`.

**Visual evidence:** no page horizontal overflow at **320, 375, 768, and 1280 CSS px**; sidebar/mobile disclosure switched as expected. Cerberus light/dark computed schemes and article colors switched. Narrow and wide screenshots were inspected.

**Limits:** one Chromium version; no full contrast, forced-colors, text-zoom, or screen-reader audit, exhaustive component catalog, deployment/adapter-target proof, file-upload or monorepo runtime test, or concurrent authenticated-session test. Visual checks do not certify accessibility.

## Skill Creator review verification

Observed **2026-10-07**; this check covers the revised entrypoint and motion-free Modal recipe, not a repeat of the full fixture above.

- An independent read-only forward test produced concrete responses for an existing Kit 2 card restyle, a local archive confirmation, and greenfield Kit 3 setup. It preserved the existing app's versions/routes, selected the pinned Modal contract, and distinguished metadata from execution evidence. It identified the recipe's missing reduced-motion handling; the revised example disables its JavaScript fly/fade transitions.
- `skills-ref validate skills/skeleton-svelte` passed. Local file/section links and balanced fences were checked across all 10 skill Markdown files.
- A disposable fixture extracted the documented setup configuration and revised `ConfirmModal.svelte`, mounting two instances. The toolchain matched the third-pass versions above. `npm install --no-audit --no-fund` installed 110 packages without forced peers; `npm run check` returned 0 errors and 0 warnings; `npm run build` completed client/server builds. Adapter-auto found no production target.
- Chromium **153.0.8010.12** production-preview checks passed at **375 and 1280 CSS px**, each with `prefers-reduced-motion: reduce` and `no-preference`: keyboard opening, initial Cancel focus, Tab/Shift+Tab containment, Escape/Cancel/outside dismissal, trigger focus restoration, distinct instance title/description IDs, isolated local confirmation, and reset on reload. Overlay animation inspection found no nonzero fly/fade durations. No page overflow or browser errors/warnings were observed; narrow/wide screenshots were inspected.

Limits: one Chromium version and the changed recipe only; no full accessibility audit, animated drawer implementation, production deployment, or repeat verification of unchanged examples.

## Maintenance and future re-verification

When updating this skill or integrating different versions:

1. Record the date, runtime, package manager, resolved versions, lockfile, and relevant workspace configuration. Do not broaden the tested claim to an entire major or peer range.
2. Fetch exact registry metadata and compare installed exports/types/source with the archived guidance. Recheck engines, optional peers, adapter compatibility, root versus composed APIs, CSS exports, theme tokens, and scanning paths relevant to the change.
3. Read the target Svelte/Kit/Tailwind migration instructions. Update all affected reference examples and task-routing guidance together; do not retain obsolete imports or a compatibility shim merely to preserve old copied code.
4. In a disposable integration fixture or the consumer's authorized workflow, install without bypassing peers and extract the **complete** documented examples plus configuration. Run the project's established check and production build once the changes are complete; record actual commands, counts, warnings, and failures.
5. Exercise the rendered examples in a real browser: hydration, controlled state, keyboard/focus, overlays, responsive/theme/mode styling, file selection, and native/enhanced form behavior as applicable. Use [accessibility](accessibility.md) for the detailed checklist; report browser/version and exactly which interactions were observed.
6. Verify the actual deployment adapter/target and request isolation separately when required. Update this evidence section with results and remaining limits; a compilation-only pass must remain described as such.

## Portable distribution and installation

Distribute the **entire `skeleton-svelte/` directory**, containing `SKILL.md` and its `references/` directory. Copy that intact directory into a skill location supported by the consumer's agent/host, following that host's documented discovery instructions. Keep the directory name `skeleton-svelte` aligned with the frontmatter `name`; preserve relative links and reference filenames. Do not distribute only `SKILL.md`, flatten the references, or rely on the authoring workspace's absolute paths.

This reference prescribes no universal agent-specific CLI or skill path. Reload or refresh discovery only as the consumer host requires, and let the description and task router select this skill for relevant Skeleton v3 work. Installing it does not require all UI tasks to use it. Installing the skill copies documentation, **not** application dependencies or a verified toolchain. Its bundled references remain useful offline; online sources are optional corroboration, while package installation requires the consumer's normal registry or cache access.
