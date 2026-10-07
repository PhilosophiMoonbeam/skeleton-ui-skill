# Sources, compatibility evidence, and distribution

Verified authoring baseline: **2026-10-07**. This skill targets Skeleton **v3**, Svelte **5.57.2**, and SvelteKit **3.0.1**. It is a portable technical reference, not an upstream support statement or deployment/accessibility certification.

## Choose the authority before copying code

1. **For the application you are changing, inspect its resolved packages first.** The lockfile and installed package metadata determine what is available; a manifest range or a documentation title does not.
2. **For this baseline, exact published packages govern exports, props, types, CSS, peers, and engines.** Use version-qualified registry records and package files below. Read implementation source when declarations omit behavior.
3. **Use the archived `v3.skeleton.dev` pages for Skeleton v3 intent and examples.** Its installation guide documents Kit 2/Svelte 5/Tailwind 4 minimums; it does not establish Kit 3 certification. Adapt configuration through the Kit 3 migration guide and this skill's [setup](setup.md).
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
2. Read each package's `exports`/`types` fields to locate the public contract. For component `1.5.3`, start with `@skeletonlabs/skeleton-svelte/dist/index.d.ts`; use `dist/composed/index.d.ts` only for that subpath.
3. Follow a component's relative declarations to its `.svelte.d.ts` and `types.d.ts`. Inspect required props, snippet parameter tuples, callback payloads, bindability, and available child members. Follow imported Zag declarations through the **installed dependency version**, not current Zag docs, when inherited props matter.
4. Inspect the matching published `.svelte`/`.js` implementation for semantics, default classes, native inputs, event forwarding, and SSR behavior that declarations cannot show. Inspection does not make internal paths supported application imports.
5. Inspect core `dist/index.css`, `dist/optional/presets.css`, and the selected `dist/themes/*.css`; confirm real utilities, custom properties, and theme selectors. Inspect installed Svelte and Kit `types/index.d.ts` for framework signatures.
6. If installed versions differ from this baseline, compare only the affected contracts first. Keep the user's version/deployment constraints; do not silently upgrade packages to make a copied example work. If evidence is unavailable, state the exact unknown instead of inventing an export or asserting compatibility.

## Exact compatibility baseline and observed smoke

Skeleton's packages are **independently numbered**: core **`3.2.2`** pairs here with Svelte components **`1.5.3`**, not component version `3`. The component package's own metadata lists core `3.2.2` as a development dependency; its consumer peer is Svelte `^5.20.0`, while core's peer is Tailwind `^4.0.0`. Those records help establish the chosen pair, not Kit 3 runtime certification.

The isolated authoring fixture used this exact toolchain:

| Dependency/runtime | Observed version |
| --- | --- |
| Node | `24.15.0` |
| `svelte` / `@sveltejs/kit` | `5.57.2` / `3.0.1` |
| `@skeletonlabs/skeleton` / `@skeletonlabs/skeleton-svelte` | `3.2.2` / `1.5.3` |
| `vite` / `@sveltejs/vite-plugin-svelte` | `8.0.12` / `7.0.0` |
| `typescript` / `svelte-check` | `6.0.3` / `4.7.6` |
| `tailwindcss` / `@tailwindcss/vite` | `4.3.3` / `4.3.3` |
| `@sveltejs/adapter-auto` / `@tailwindcss/forms` | `8.0.0` / `0.5.11` |

Kit `3.0.1` requires Node `>=22.17` and peers on Svelte `^5.57.1`, Vite `^8.0.12`, and Svelte Vite plugin `^7.0.0`. Its TypeScript `^6.0.0` peer is **optional**: JavaScript-only projects need not add TypeScript. When TypeScript tooling is present, the baseline uses the published stable `6.0.3`; the peer range is not an instruction to install the unpublished exact `6.0.0`. Also satisfy every selected tool's engine range. See [setup](setup.md#version-contract) for pinned setup and registry links.

**Observed authoring checks on 2026-10-07:**

- `npm install` succeeded without forcing peer dependencies.
- The fixture extracted the documented Vite configuration, CSS, TypeScript configuration, and complete Svelte/TypeScript example fences from the references.
- `npm run check` checked **264 files with 0 errors and 0 warnings**.
- `npm run build` completed both server and client production builds. Adapter auto reported **no deployment target**.
- An SSR page rendered all six Skeleton recipes plus the Svelte/native examples.
- Real-browser smoke of the extracted examples exercised parent `bind:value` and derived length; native required validation and local Preview status; Tabs click/ArrowLeft activation; Accordion click/Space collapse; Switch Space activation and native `FormData`; Tooltip keyboard Tab exposure, `aria-describedby`, and Escape; Modal accessible title, initial focus, Shift+Tab containment, Escape/focus restoration, and local confirmation state; and Toaster creation/rendering.
- Styling smoke confirmed resolved Cerberus tokens, computed dark-mode color pairings, reduced-motion response, and no horizontal overflow at a 390px viewport; desktop/mobile screenshots were inspected.
- Production preview with JavaScript disabled rendered SSR markup and exercised native greeting whitespace validation plus successful `Hello, Grace!`. With JavaScript enabled, the enhanced action produced field `aria-invalid` on a server error and successful `Hello, Ada!`.
- The final hydrated browser error list was empty. Initial development dependency optimization had aborted module requests; a reload resolved that initial condition before the interactions above were exercised.

These observations apply to the authoring fixture and documented examples at the pinned baseline, not every exported component, every application, every browser, or all versions satisfying the peer ranges. They do not certify a full contrast audit, screen-reader/assistive-technology behavior, production adapters, hosting, or deployment. File selection/upload and other interactions not listed above are not claimed as tested. The published archived minimums and peer ranges are separate evidence from the checks actually exercised.

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

There is no universal agent-specific CLI or skill path prescribed here. Reload/refresh discovery only as the consumer host requires, and let the description/task router select this skill for relevant Skeleton v3 work; installing it does not require all UI tasks to use it. Installing the skill copies documentation, **not** application dependencies or a verified toolchain. Its bundled references remain useful offline; online sources are optional corroboration, while package installation requires the consumer's normal registry/cache access.
