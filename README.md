# Skeleton UI for Svelte — Agent Skill

An unofficial, version-qualified [Agent Skill](https://agentskills.io) for coding agents building with **Skeleton UI v3, Svelte 5, and SvelteKit 3**.

Give a new agent session the API contracts, complete examples, and integration guidance it needs without relying on prior conversation context or mixing incompatible documentation versions.

## What this project provides

- **Task-based navigation:** a compact `SKILL.md` routes agents to the references needed for each task.
- **Version-aware implementation:** exact package pins, a runtime export catalog, and installed-type inspection help prevent invented APIs and mixed-major examples.
- **Complete examples:** six standalone Skeleton component recipes, plus Svelte and native form examples.
- **Application integration:** themes, Tailwind CSS, Svelte runes, SSR, hydration, request isolation, and native or enhanced server forms.
- **Practical verification:** keyboard, focus, responsive layout, and accessibility checks, with explicit limits on the recorded evidence.

This repository contains skill documentation, not a component library or application template. React is outside its scope.

## Use the skill

1. Open [the skill entrypoint](skills/skeleton-svelte/SKILL.md) to browse its workflow and task router.
2. Copy the entire [`skills/skeleton-svelte/`](skills/skeleton-svelte/) directory into a skill location supported by your coding agent. Follow that host's discovery instructions; there is no universal installation path or CLI.
3. Preserve the directory name, `SKILL.md`, and `references/` structure. Refresh skill discovery if your host requires it.
4. Ask the agent to use `skeleton-svelte` for a relevant Skeleton task. It should inspect the application's resolved versions before applying the examples.

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
| [Setup](skills/skeleton-svelte/references/setup.md) | Exact pins, scaffolding, Kit 3 configuration, global CSS, and source scanning |
| [Migration](skills/skeleton-svelte/references/migration.md) | v2-to-v3 cutover, removed APIs, mixed-version traps, and offline inspection |
| [Components](skills/skeleton-svelte/references/components.md) | Runtime exports, API shapes, declaration links, and styled native alternatives |
| [Recipes](skills/skeleton-svelte/references/recipes.md) | Complete tabs, accordion, switch, tooltip, modal, and toast examples |
| [Styling](skills/skeleton-svelte/references/styling.md) | Themes, tokens, presets, responsive layout, dark mode, and motion |
| [Accessibility](skills/skeleton-svelte/references/accessibility.md) | Semantics, forms, validation feedback, and keyboard and focus checks |
| [SvelteKit](skills/skeleton-svelte/references/sveltekit.md) | Runes, snippets, SSR, hydration, request isolation, and server actions |
| [Sources](skills/skeleton-svelte/references/sources.md) | Primary sources, compatibility evidence, maintenance, and distribution |

## Evidence and limits

The [recorded authoring checks](skills/skeleton-svelte/references/sources.md#exact-compatibility-baseline-and-observed-smoke) include installation without forced peers, type checking, production builds, and browser interaction with the documented examples at the pinned baseline.

These checks are not upstream certification, exhaustive component or browser coverage, a full accessibility audit, or deployment proof. Agents must verify the application they change and report only checks they actually performed.

## Contribute

Keep revisions terse and complete. Preserve technical qualifications, source attribution, and runnable examples. For API or version changes, follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) and update affected references and routing together.

Check skill structure with the Agent Skills [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref) validator:

```sh
skills-ref validate skills/skeleton-svelte
```

Structural validation does not replace application checks or browser verification. This project is unofficial and is not an upstream Skeleton support statement.
