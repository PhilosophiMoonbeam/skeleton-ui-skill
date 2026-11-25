![svelte-ui-eco emblem: a code-eyed skull in a celestial globe above an open reference book.](assets/svelte-ui-eco.svg)

# svelte-ui-eco

An unofficial [Agent Skill](https://agentskills.io) for designing and building accessible Svelte 5 interfaces. It ships guidance and runnable examples, not a component library or application template.

Start with the user task and the look and feel it calls for. Use native HTML when it does the job, then choose the smallest stack that fits:

- **Existing app:** Keep its visual style and working components. A visual refresh is not a reason to change libraries.
- **New product with no design system:** If Tailwind fits the project, start with Tailwind 4 and Skeleton core. Calibrate a theme on one real screen, then add Skeleton's styled Svelte components where they fit. Don't install Bits UI by default.
- **Custom markup or interaction:** Choose Bits UI when its unstyled components are a better fit. Style them with app CSS, Tailwind, or Skeleton core if you want its themes and tokens.

Tailwind provides styling utilities; Skeleton core adds theme tokens and presets for choices such as colors, typography, and component treatments. Skeleton's separate Svelte package supplies styled widgets with managed behavior. Bits UI supplies behavior such as keyboard navigation and focus management, but the app supplies the look. A demo's colors, type, and layout are design choices, not reasons to install its interaction library. The two widget libraries are independent: share theme tokens and app values, but let one library own each widget.

## Install the skill

Run from the project where you want to use the skill:

```sh
bunx --bun skills@latest add PhilosophiMoonbeam/svelte-ui-eco --skill svelte-ui-eco
```

Follow the [skills CLI](https://github.com/vercel-labs/skills) prompts to select your coding agents. Refresh skill discovery if your agent requires it. Installation does not add application dependencies.

> Use svelte-ui-eco to build a studio booking page. Make choosing an available appointment the main task, with warm neutral surfaces and one accent for the selection. Stack the calendar and time slots on phones; put them side by side when space allows. Make dates keyboard-navigable, distinguish unavailable dates without relying on color, and keep the selected date and time visible before submission. Check the keyboard path and show an inline error or a clear confirmation after submission.

## Compatibility

Standalone modern Svelte 5 is supported. SvelteKit 3.1+ applies only to Kit-specific guidance; Kit 3.4.0 is the exact reference version, not the minimum. Retain a compatible existing toolchain and inspect the application's resolved versions before adapting examples.

| Package or tool | Reference version | Role |
| --- | --- | --- |
| Bun | 1.4.5 | Repository tooling and installation examples |
| Svelte | 5.59.1 | Framework |
| Bits UI | 2.22.0 | Headless behavior for custom markup or interactions |
| `@internationalized/date` | 3.12.4 | Date and time examples only |
| `@sveltejs/kit` | 3.4.0 | Kit-specific guidance only |
| `@skeletonlabs/skeleton` | 5.0.6 | Tailwind-based themes, tokens, and presets |
| `@skeletonlabs/skeleton-svelte` | 5.0.6 | Styled widgets with Zag-backed behavior |
| `tailwindcss` | 4.3.5 | Styling utilities and the base for Skeleton core |
| `@lucide/svelte` | 1.77.0 | Optional icons |

## Find the right guidance

Start with the [skill entrypoint](skills/svelte-ui-eco/SKILL.md) and its task router. Use [Design](skills/svelte-ui-eco/references/design.md) to set the visual brief before choosing libraries, [setup](skills/svelte-ui-eco/references/setup.md) for dependency choices, and [migration](skills/svelte-ui-eco/references/migration.md) when replacing old wrappers.

Use the [Bits UI catalog](skills/svelte-ui-eco/references/components.md) to find native alternatives or headless primitives. Use the [Skeleton UI guide](skills/svelte-ui-eco/references/skeleton.md) for styled widgets, including Toast, Carousel, and FileUpload. The [recipes](skills/svelte-ui-eco/references/recipes.md) and [example mounting guide](skills/svelte-ui-eco/examples/README.md) include standalone examples that do not require Skeleton, Tailwind, or Lucide. For a hybrid, see the [local themed Bits Calendar](skills/svelte-ui-eco/examples/ThemedCalendar.svelte) and [Skeleton's upstream integration guide](https://www.skeleton.dev/docs/svelte/integrations/bits-ui); the upstream guide illustrates the styling approach, not the current version pins.

Use the [Skeleton recipes](skills/svelte-ui-eco/references/skeleton-recipes.md) and [version-specific upgrade guide](skills/svelte-ui-eco/references/skeleton-migration.md) when maintaining a Skeleton app. The examples index includes a responsive shell and a native form. Historical runtime observations are kept separately from current API guidance.

Check installed declarations before applying a rolling documentation example. See [sources](skills/svelte-ui-eco/references/sources.md) for upstream links and evidence limits.

## Contribute

From the repository root, use Bun 1.4.5:

```sh
bun install --frozen-lockfile
bun run check
bun run check:examples
skills-ref validate skills/svelte-ui-eco
```

Use the Agent Skills [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref) validator for package structure. Repository checks do not replace browser verification: exercise the affected keyboard, focus, layout, and form behavior and report only what you observed.
