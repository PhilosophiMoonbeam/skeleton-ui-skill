![Skeleton UI — Svelte Agent Skills. A code-eyed skull in a celestial globe above an open reference book.](assets/skeleton-ui-skill.svg)

# Skeleton UI for Svelte — Agent Skill

An unofficial, version-qualified [Agent Skill](https://agentskills.io) for coding agents building with **Skeleton UI 5, Svelte 5, and SvelteKit**. Its reproducible greenfield baseline uses stable **SvelteKit 3.1.0**; compatible existing Kit 2 applications remain in scope without an unrequested migration.

Give a new agent session the API contracts, complete examples, and integration guidance it needs without relying on prior conversation context or mixing incompatible documentation versions.

## What this project provides

- **Task-based navigation:** a compact `SKILL.md` routes agents to the references needed for each task.
- **Version-aware implementation:** exact package pins, a runtime export catalog, and installed-type inspection help prevent invented APIs and mixed-major examples.
- **Complete examples:** eight standalone Skeleton component recipes, a responsive app-shell recipe, and Svelte and native form examples.
- **Application integration:** conditional Kit 3 `#lib` configuration, Svelte runes and native bindings, SSR, hydration, request isolation, instance-safe associations, and native or enhanced server forms with raw failed-value preservation.
- **Visual composition:** existing-style calibration before markup, hierarchy, spacing, density, realistic content states, and narrow/wide screenshot review for polished pages.
- **Practical verification:** keyboard, focus, responsive layout, and accessibility checks, with explicit limits on the recorded evidence.

This repository contains skill documentation, not a component library or application template. React is outside its scope.

## Install and use the skill

Run this command from the project where you want to use the skill:

```sh
npx skills add PhilosophiMoonbeam/skeleton-ui-skill
```

Follow the [skills CLI](https://github.com/vercel-labs/skills) prompts to select your coding agents and installation method.

1. Open [the skill entrypoint](skills/skeleton-svelte/SKILL.md) to browse its workflow and task router.
2. Refresh skill discovery if your coding agent requires it.
3. Ask the agent to use `skeleton-svelte` for a relevant Skeleton task. It should inspect the application's resolved versions before applying the examples.

Example request:

> Use the skeleton-svelte skill to add accessible tabs to this SvelteKit application. Check installed versions first, preserve the existing toolchain, and verify keyboard interaction in the browser.

Installing the skill copies documentation; it does not install application dependencies. The bundled references support offline reading and inspection of installed package declarations and source. Package installation still requires the application's normal registry or cache access.

## Compatibility boundary

The frozen reference baseline is:

| Package | Version |
| --- | --- |
| `@skeletonlabs/skeleton` | `5.0.1` |
| `@skeletonlabs/skeleton-svelte` | `5.0.1` |
| `svelte` | `5.57.2` |
| `@sveltejs/kit` | `3.1.0` |
| `tailwindcss` | `4.3.3` |

Both Skeleton packages are pinned to `5.0.1`; use current v5 CSS imports, compound anatomy, providers, and callback contracts rather than older APIs.

See [setup](skills/skeleton-svelte/references/setup.md) for the complete pinned toolchain, Node and peer requirements, and configuration. Skeleton 5 does not itself require Kit 3. Preserve an existing application's compatible versions, adapter, and conventions. For different versions, inspect matching documentation and installed packages; do not upgrade or downgrade merely to fit this skill.

## Reference guide

| Reference | Contents |
| --- | --- |
| [Setup](skills/skeleton-svelte/references/setup.md) | Exact pins, existing-app and greenfield paths, conditional Kit 3 configuration, current CSS imports, and shared-source detection |
| [Migration](skills/skeleton-svelte/references/migration.md) | Staged Skeleton 2/3-to-4-to-5 cutover, v4.15.2 starting point, CLI limits, and separately requested Kit 3 migration |
| [Components](skills/skeleton-svelte/references/components.md) | Current runtime exports, compound anatomy, providers, declaration links, and native-first alternatives |
| [Recipes](skills/skeleton-svelte/references/recipes.md) | Complete tabs, accordion, switch, tooltip, dialog, toast, combobox, and pagination examples |
| [Styling](skills/skeleton-svelte/references/styling.md) | Themes, tokens, presets, responsive layout, dark mode, and motion |
| [Design](skills/skeleton-svelte/references/design.md) | Visual brief, composition, responsive app-shell recipe, and screenshot review |
| [Accessibility](skills/skeleton-svelte/references/accessibility.md) | Instance-safe semantics, local-only/no-JavaScript preview limits, validation feedback, and keyboard/focus checks |
| [SvelteKit](skills/skeleton-svelte/references/sveltekit.md) | Runes, native bindings, SSR, hydration, request isolation, and native/enhanced server actions preserving raw failed values |
| [Sources](skills/skeleton-svelte/references/sources.md) | Primary sources, compatibility evidence, maintenance, and distribution |

## Evidence and limits

The [current baseline and observed evidence](skills/skeleton-svelte/references/sources.md#exact-compatibility-baseline-and-observed-evidence) records an isolated exact-version installation of 130 packages without forced peers. Eighteen complete documented components were extracted; `npm run check` checked 945 files with 0 errors and 0 warnings, and client/server production builds passed. `skills-ref validate` passed, as did structural checks of 99 local links and 45 fences across 11 Markdown files. A consumer type proof accepted 31 components, 200 listed anatomy members, and 30 helper exports.

Chromium **155.0.8059.84** production-preview checks exercised all eight recipes, providers, repeated-instance associations, native utilities, and native/enhanced forms—including exact failed-value preservation and no-JavaScript behavior. The responsive shell had no overflow at **320, 375, 768, and 1280 CSS px**; narrow/wide screenshots, theme/motion changes, and stable Kit 3 shallow-navigation/state persistence were checked. Browser-discovered Combobox overlap/viewport overflow and inaccessible default pagination anchors were corrected and reverified. See the linked evidence for exact scenarios and limits.

These checks are not exhaustive browser coverage or a full accessibility audit. No deployment or production-adapter verification is recorded: `adapter-auto` found no production target, and the build emitted an environmental `NO_COLOR`/`FORCE_COLOR` warning. Compilation and local interaction do not certify accessibility, server persistence, or SSR request isolation. Follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) for the application being changed and report only actual results.

## Contribute

Keep revisions terse and complete. Preserve technical qualifications, source attribution, and runnable examples. For API or version changes, follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) and update affected references and routing together.

Check skill structure with the Agent Skills [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref) validator:

```sh
skills-ref validate skills/skeleton-svelte
```

Structural validation does not replace application checks or browser verification. This project is unofficial and is not an upstream Skeleton support statement.
