# Skeleton UI for Svelte — Agent Skill

An unofficial, version-qualified [Agent Skill](https://agentskills.io) for coding agents building with **Skeleton UI v3, Svelte 5, and SvelteKit 3**.

Give a new agent session the API contracts, complete examples, and integration guidance it needs without relying on prior conversation context or mixing incompatible documentation versions.

## What this project provides

- **Task-based navigation:** a compact `SKILL.md` routes agents to the references needed for each task.
- **Version-aware implementation:** exact package pins, a runtime export catalog, and installed-type inspection help prevent invented APIs and mixed-major examples.
- **Complete examples:** eight standalone Skeleton component recipes, a responsive app-shell recipe, and Svelte and native form examples.
- **Application integration:** Kit 3 `#lib` configuration, Svelte runes and native bindings, SSR, hydration, request isolation, instance-safe associations, and native or enhanced server forms with raw failed-value preservation.
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
| `@skeletonlabs/skeleton` | `3.2.2` |
| `@skeletonlabs/skeleton-svelte` | `1.5.3` |
| `svelte` | `5.57.2` |
| `@sveltejs/kit` | `3.0.1` |
| `tailwindcss` | `4.3.3` |

Skeleton's core and Svelte component packages use independent version numbers. Skeleton v3 does **not** mean component package version `3`.

See [setup](skills/skeleton-svelte/references/setup.md) for the complete toolchain, Node and peer requirements, and configuration. Preserve an existing application's working versions. For a different Skeleton major or API, use matching documentation or an explicitly agreed migration; do not upgrade or downgrade merely to fit this skill.

## Reference guide

| Reference | Contents |
| --- | --- |
| [Setup](skills/skeleton-svelte/references/setup.md) | Exact pins, scaffolding, Kit 3 configuration and `#lib/*` mapping, global CSS, and source scanning |
| [Migration](skills/skeleton-svelte/references/migration.md) | v2-to-v3 cutover, explicit Kit 3 import/configuration migration, removed APIs, and offline inspection |
| [Components](skills/skeleton-svelte/references/components.md) | Runtime exports, API shapes, declaration links, and styled native alternatives |
| [Recipes](skills/skeleton-svelte/references/recipes.md) | Complete tabs, accordion, switch, tooltip, modal, toast, combobox, and pagination examples |
| [Styling](skills/skeleton-svelte/references/styling.md) | Themes, tokens, presets, responsive layout, dark mode, and motion |
| [Design](skills/skeleton-svelte/references/design.md) | Visual brief, composition, responsive app-shell recipe, and screenshot review |
| [Accessibility](skills/skeleton-svelte/references/accessibility.md) | Instance-safe semantics, local-only/no-JavaScript preview limits, validation feedback, and keyboard/focus checks |
| [SvelteKit](skills/skeleton-svelte/references/sveltekit.md) | Runes, native bindings, SSR, hydration, request isolation, and native/enhanced server actions preserving raw failed values |
| [Sources](skills/skeleton-svelte/references/sources.md) | Primary sources, compatibility evidence, maintenance, and distribution |

## Evidence and limits

The current [third-pass verification](skills/skeleton-svelte/references/sources.md#third-pass-verification) records exact-target installation without forced peers, type checking of 273 files with 0 errors and 0 warnings, client/server production builds, skill validation, and structural checks. Real Chromium interactions covered all eight Skeleton recipes, repeated instance associations, native bindings, local previews, native/enhanced server-form value preservation, no-JavaScript behavior, theme changes, and the responsive app shell at 320, 375, 768, and 1280 CSS pixels. The [second-pass authoring checks](skills/skeleton-svelte/references/sources.md#exact-compatibility-baseline-and-observed-smoke) remain historical evidence; neither record automatically covers future edits.

Coverage is limited to one Chromium version, not an exhaustive component catalog or a full contrast, forced-colors, text-zoom, or screen-reader audit. No deployment/adapter target, file-upload/monorepo runtime, or concurrent authenticated-session verification is claimed. The successful build reported no supported production adapter target; visual checks do not certify accessibility. Agents must verify the application they change and report only checks they actually performed.

## Contribute

Keep revisions terse and complete. Preserve technical qualifications, source attribution, and runnable examples. For API or version changes, follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) and update affected references and routing together.

Check skill structure with the Agent Skills [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref) validator:

```sh
skills-ref validate skills/skeleton-svelte
```

Structural validation does not replace application checks or browser verification. This project is unofficial and is not an upstream Skeleton support statement.
