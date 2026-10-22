![Skeleton UI — Svelte Agent Skills. A code-eyed skull in a celestial globe above an open reference book.](assets/skeleton-ui-skill.svg)

# Skeleton UI + SvelteKit + Tailwind CSS + Lucide — Agent Skill

An unofficial, opinionated [Agent Skill](https://agentskills.io) for building applications with **Skeleton UI, SvelteKit, Tailwind CSS, and Lucide together**. This is a holistic four-part stack resource, not just a component or icon catalog: it connects design-system controls, utility styling, and useful icons with application structure, server rendering, forms, accessibility, and verification.

The guidance is packaged as the **`skeleton-svelte`** skill. It targets **Skeleton UI 5, Svelte 5, SvelteKit 3.1+, and Tailwind CSS 4**, with **`@lucide/svelte@1.61.0`** as the preferred optional icon package. The exact framework baseline and independently observed icon pin are documented below. Older framework conventions appear only as migration or avoidance context.

Its opinions favor native semantics, coherent theme tokens, modern framework patterns, progressive enhancement, and evidence from actual behavior. Use icons where they help comprehension, not as forced decoration or a dependency in every recipe. Give a new agent session the contracts, complete examples, and integration guidance it needs without relying on prior conversation context or mixing incompatible documentation versions.

## What this project provides

- **Task-based navigation:** a compact `SKILL.md` routes agents to the references needed for each task.
- **Version-aware implementation:** exact package pins, a runtime export catalog, and installed-type inspection help prevent invented APIs and mixed-major examples.
- **Complete examples:** eight standalone Skeleton component recipes, a responsive app-shell recipe, and Svelte and native form examples.
- **Application integration:** modern Kit configuration and `#lib` imports, Svelte runes and native bindings, SSR, hydration, request isolation, instance-safe associations, and native or enhanced server forms with raw failed-value preservation.
- **Integrated styling:** Skeleton themes and semantic tokens alongside Tailwind's CSS-first utilities, source detection, responsive layouts, and color-scheme behavior.
- **Integrated icons:** discover Lucide icons and verify resolved exports, inspect packages offline, and diagnose SVG/CSS or naming problems. Core guidance covers accessible controls and finite selection; deeper patterns cover a reactive typed consumer, fill/composition, RTL, custom data, and optional Lucide Lab. Skeleton owns control behavior; icons do not replace semantics or labels.
- **Visual composition:** existing-style calibration before markup, hierarchy, spacing, density, realistic content states, and narrow/wide screenshot review for polished pages.
- **Progressive motion:** current Svelte motion classes, reduced-motion handling, optional route continuity, and CSS/browser constraints without making animation application state.
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
3. Ask the agent to use `skeleton-svelte` for a relevant task in this stack—from a component, theme, or accessible icon control to page composition, SSR, or forms. It should inspect the application's resolved versions and use the selected reference before applying examples.

Example request:

> Use the skeleton-svelte skill to build an accessible preferences page in this Skeleton UI + SvelteKit + Tailwind CSS + Lucide application. Use the existing theme and Lucide only where icons aid comprehension, preserve compatible tooling, retain native form submission with server validation, and verify responsive layout and keyboard interaction.

Installing the skill copies documentation; it does not install application dependencies. The bundled references support offline reading and inspection of installed package declarations and source. Package installation still requires the application's normal registry or cache access. Add `@lucide/svelte@1.61.0` only when using icons; [setup](skills/skeleton-svelte/references/setup.md#lucide-when-icons-are-useful) gives the exact optional command.

## Compatibility boundary

The frozen framework baseline and independently observed optional icon pin are:

| Package | Version |
| --- | --- |
| `@skeletonlabs/skeleton` | `5.0.1` |
| `@skeletonlabs/skeleton-svelte` | `5.0.1` |
| `svelte` | `5.57.2` |
| `@sveltejs/kit` | `3.1.0` |
| `tailwindcss` | `4.3.3` |
| `@lucide/svelte` (optional icons) | `1.61.0` |

Both Skeleton packages are pinned to `5.0.1`; use current v5 CSS imports, compound anatomy, providers, and callback contracts rather than older APIs. Lucide's `@lucide/svelte@1.61.0` is independently versioned and declares a Svelte `^5` peer.

See [setup](skills/skeleton-svelte/references/setup.md) for the pinned toolchain, Node and peer requirements, optional icon installation, and configuration. Prefer canonical per-icon default imports; root named imports are also public and valid. Kit 3.1+ is this skill's target regardless of Skeleton's broader upstream compatibility. Older apps need a scoped prerequisite migration, not a legacy implementation. Preserve compatible adapters and unrelated work; verify matching APIs for later releases rather than assuming the tested baseline certifies them.

## Reference guide

| Reference | Contents |
| --- | --- |
| [Setup](skills/skeleton-svelte/references/setup.md) | Exact pins, optional Lucide installation, Kit 3.1+ existing-app and greenfield paths, modern configuration, CSS imports, and shared-source detection |
| [Migration](skills/skeleton-svelte/references/migration.md) | Prerequisite framework migration and staged Skeleton 2/3-to-4-to-5 cutover, v4.15.2 starting point, and CLI limits |
| [Components](skills/skeleton-svelte/references/components.md) | Current runtime exports, compound anatomy, providers, declaration links, and native-first alternatives |
| [Recipes](skills/skeleton-svelte/references/recipes.md) | Complete tabs, accordion, switch, tooltip, dialog, toast, combobox, and pagination examples |
| [Lucide](skills/skeleton-svelte/references/lucide.md) | Discovery/export verification, offline inspection, focused troubleshooting, public imports, SVG props, accessible controls, finite selection, and static subtree defaults |
| [Lucide patterns](skills/skeleton-svelte/references/lucide-patterns.md) | Optional typed reactive consumer, fill/composition, directional icons, custom icon data, and the additional pinned Lab example |
| [Styling](skills/skeleton-svelte/references/styling.md) | Themes, tokens, presets, CSS-first extensions, responsive layout, dark mode, and cumulative browser support |
| [Design](skills/skeleton-svelte/references/design.md) | Visual brief, purposeful feedback, performance constraints, responsive app-shell recipe, and screenshot review |
| [Accessibility](skills/skeleton-svelte/references/accessibility.md) | Instance-safe semantics, native-preview limits, validation feedback, focus, continuous-motion controls, and non-drag alternatives |
| [SvelteKit](skills/skeleton-svelte/references/sveltekit.md) | Runes, motion/navigation lifecycle, SSR, hydration, request isolation, and native/enhanced server actions preserving raw failed values |
| [Sources](skills/skeleton-svelte/references/sources.md) | Primary sources, compatibility evidence, maintenance, and distribution |

## Evidence and limits

The [original baseline evidence](skills/skeleton-svelte/references/sources.md#exact-compatibility-baseline-and-observed-evidence) preserves the initial v5 migration checks. The [supplemental validation](skills/skeleton-svelte/references/sources.md#supplemental-validation--2026-10-18) records independent review of all 13 research sections, a fresh exact-version installation, **926 checked files with 0 errors and 0 warnings**, and successful client/server production builds. Skill-format and local link/fence validation passed.

Chromium **155.0.8059.84** production-preview checks cover the original component/form/responsive scenarios and 15 supplemental groups: Spring state and cancellation, reduced motion before and after hydration, native/shallow/history navigation, skipped and failed view transitions, unsupported-API fallback, CSS-first utilities, runtime variables, and native/enhanced form regressions. New CSS-extension screenshots were inspected at **1280px dark** and **320px light**; the narrow page had no horizontal overflow. See the linked evidence for exact scenarios and limits.

The Lucide integration has its own [dated validation](skills/skeleton-svelte/references/sources.md#lucide-validation--2026-10-22), covering all six icon example files, SSR, control names, theme/sizing boundaries, finite selection, responsive popups, and production tree-shaking. Targeted light/dark automated accessibility checks passed; they do not constitute a full accessibility audit.

The [review expansion](skills/skeleton-svelte/references/sources.md#lucide-review-expansion--source-evidence-and-verification-boundary)
separately verifies six added component files: reactive typed consumers,
composition, selective RTL, custom data, and optional `@lucide/lab@0.7.0`.
It records no-JavaScript rendering, a corrected dark-mode form contrast defect,
and manual review of the select-caret contrast warning; historical checks are
not reused as proof for these additions.

These checks are not exhaustive browser coverage or a full accessibility audit. No deployment or production-adapter verification is recorded: `adapter-auto` found no production target, and the build emitted an environmental `NO_COLOR`/`FORCE_COLOR` warning. Compilation and local interaction do not certify accessibility, server persistence, or SSR request isolation. Follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) for the application being changed and report only actual results.

## Contribute

Keep revisions terse and complete. Preserve technical qualifications, source attribution, and runnable examples. For API or version changes, follow the [re-verification workflow](skills/skeleton-svelte/references/sources.md#maintenance-and-future-re-verification) and update affected references and routing together.

Check skill structure with the Agent Skills [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref) validator:

```sh
skills-ref validate skills/skeleton-svelte
```

Structural validation does not replace application checks or browser verification. This project is unofficial and is not an upstream Skeleton support statement.
