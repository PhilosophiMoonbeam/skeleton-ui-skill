# Sources, version baseline, and distribution

Standalone modern Svelte 5 is supported. The table pins reference versions for the different paths, not a dependency list. SvelteKit-specific guidance applies to Kit `>=3.1.0`; `3.4.0` is the exact reference version, not a minimum or a dependency of standalone examples. See [setup](setup.md) to select and configure the appropriate stack.

| Package or runtime | Exact baseline | Role |
| --- | --- | --- |
| [`bits-ui`](https://registry.npmjs.org/bits-ui/2.22.0) | `2.22.0` | Independent headless primitives for bespoke markup or a better interaction fit |
| [`svelte`](https://registry.npmjs.org/svelte/5.59.1) | `5.59.1` | Framework and compiler |
| [`@internationalized/date`](https://registry.npmjs.org/@internationalized/date/3.12.4) | `3.12.4` | Bits UI peer; import its models for date and time widgets |
| [Bun](https://github.com/oven-sh/bun/releases/tag/bun-v1.4.5) | `1.4.5` | Reference runtime and package manager |
| [`@sveltejs/kit`](https://registry.npmjs.org/@sveltejs/kit/3.4.0) | `3.4.0` | Kit applications only |
| [`tailwindcss`](https://registry.npmjs.org/tailwindcss/4.3.5) | `4.3.5` | Styling utilities and Skeleton core peer |
| [`@skeletonlabs/skeleton`](https://registry.npmjs.org/@skeletonlabs%2Fskeleton/5.0.6) | `5.0.6` | Tailwind-based CSS, theme tokens, and presets; no widget behavior |
| [`@skeletonlabs/skeleton-svelte`](https://registry.npmjs.org/@skeletonlabs%2Fskeleton-svelte/5.0.6) | `5.0.6` | Styled Svelte widgets with Zag-backed behavior; no Bits UI dependency. See [Skeleton UI](skeleton.md). |
| [`@lucide/svelte`](https://registry.npmjs.org/@lucide/svelte/1.77.0) | `1.77.0` | Optional icons |

## Choose the authority

1. Read the application's manifest, resolved lockfile, and installed package metadata. Resolve from the consuming workspace; manifest ranges are not installed versions.
2. Prefer exact `exports`, declarations, source, and CSS for API and behavior. For Bits UI, start at the public entrypoint and follow the [2.22.0 declarations](https://unpkg.com/bits-ui@2.22.0/dist/index.d.ts) into the relevant part. Inspect the implementation for bindability, callbacks, generated markup, form inputs, and mount behavior. Internal inspection paths are not public imports.
3. Use official documentation to learn anatomy, usage, and design intent. Rolling docs can describe releases newer than the app's; check each relevant contract against the resolved package. Search and Context7 are discovery tools, not authorities for exact APIs.
4. If the network is unavailable, use the installed package and lockfile. For published evidence, read versioned package files or retrieve the registry record's `dist.tarball` for that exact version, not `latest`.

## Primary sources

| Need | Use |
| --- | --- |
| Bits UI machine-readable documentation | [Official LLM guide](https://www.bits-ui.com/docs/llms), [root endpoint index](https://www.bits-ui.com/llms.txt), [full consolidated documentation](https://www.bits-ui.com/docs/llms.txt). Choose the individual `/docs/.../llms.txt` file for a targeted implementation. See [fundamentals](bits-ui.md) and the [component catalog](components.md). |
| Bits UI release changes | [Upstream changelog](https://github.com/huntabyte/bits-ui/blob/main/packages/bits-ui/CHANGELOG.md) and [migration guide](https://www.bits-ui.com/docs/migration-guide/llms.txt); check the specific source and target versions. See [migration](migration.md). |
| Svelte or Kit integration | [Svelte 5 docs](https://svelte.dev/docs/svelte/overview), [SvelteKit docs](https://svelte.dev/docs/kit/introduction), and [Kit 3 migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3). Check matching release types for non-baseline apps. See [SvelteKit integration](sveltekit.md) for Kit-only guidance. |
| Date and time models | [Adobe's `@internationalized/date` docs](https://react-spectrum.adobe.com/internationalized/date/index.html); check Bits UI's exact value and placeholder types as well. |
| Skeleton UI | Official [fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals.md), [Svelte LLM index](https://www.skeleton.dev/llms-svelte.txt), [core CSS API](https://www.skeleton.dev/docs/svelte/get-started/core-api.md), [themes](https://www.skeleton.dev/docs/svelte/design/themes.md), and [presets](https://www.skeleton.dev/docs/svelte/tailwind-utilities/presets.md). Use [Skeleton UI](skeleton.md) for framework components and [styling](styling.md) for CSS. |
| Skeleton styling with Bits UI behavior | [Skeleton's official Bits UI integration](https://www.skeleton.dev/docs/svelte/integrations/bits-ui) illustrates styling Bits Calendar parts with classes and state selectors. Its Skeleton v3 setup, older minimums, and Kit-specific `$lib` paths are not the pinned baseline. Check installed contracts and see the [local themed Calendar](../examples/ThemedCalendar.svelte) and [mounting guide](../examples/README.md) for standalone adaptation. |
| Tailwind CSS | [Vite setup](https://tailwindcss.com/docs/installation/using-vite) and [class detection](https://tailwindcss.com/docs/detecting-classes-in-source-files). |
| Optional icons | [Lucide's Svelte docs](https://lucide.dev/guide/svelte/) and [icon catalog](https://lucide.dev/icons/); check the resolved public exports. See [Lucide](lucide.md). |
| Accessibility | [ARIA Authoring Practices patterns](https://www.w3.org/WAI/ARIA/apg/patterns/) and [WAI form guidance](https://www.w3.org/WAI/tutorials/forms/); check the composed UI rather than assuming the primitive establishes conformance. See [accessibility](accessibility.md). |

## Historical Skeleton and Lucide evidence

Read the bundled [verification history](verification-history.md) for the exact pre-cutover package matrix, source and release findings, Bun and browser results, and what those runs did not cover. They did not verify Bits UI or the current examples, and none were rerun for this record. The immutable [original sources record at `45028e7`](https://github.com/PhilosophiMoonbeam/svelte-ui-eco/blob/45028e7f041716748d2261aba7f3bbe90b930a27/skills/skeleton-svelte/references/sources.md) and [pre-cutover references](https://github.com/PhilosophiMoonbeam/svelte-ui-eco/tree/45028e7f041716748d2261aba7f3bbe90b930a27/skills/skeleton-svelte/references) provide provenance. For active Skeleton projects, start with [Skeleton UI](skeleton.md).

## Maintain the baseline

- For a version update, compare peer ranges, public exports, prop shapes, CSS, and release changes. Update affected examples, references, and dependency instructions together. Preserve the consuming app's package manager and lockfile; do not force peer mismatches.
- Use the Bun workflow in [setup](setup.md) for reference fixtures. After edits, run the application's checks and production build. Exercise keyboard and focus, repeated instances, overlays, native form submission and validation, and hydration where relevant. Test styling combinations and Kit enhancement, no-JavaScript behavior, or deployment only where applicable. Record exact versions, commands, results, and limits; these source links are not runtime or accessibility certification.

## Distribute the skill

Keep the whole `skills/svelte-ui-eco/` directory together: `SKILL.md`, `references/`, and `examples/`. Preserve filenames and relative links and follow the host's documented discovery mechanism and the [Agent Skills specification](https://agentskills.io/specification). Do not flatten the bundle or copy only `SKILL.md`. Installing the skill does not install application dependencies.
