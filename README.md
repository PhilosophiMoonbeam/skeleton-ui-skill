![svelte-ui-eco emblem: a code-eyed skull in a celestial globe above an open reference book.](assets/svelte-ui-eco.svg)

# svelte-ui-eco

An unofficial [Agent Skill](https://agentskills.io) for building accessible Svelte 5 interfaces with native HTML and Bits UI, with optional Skeleton CSS, Tailwind CSS, and Lucide.

Use native HTML when it provides the interaction you need. Use Bits UI for managed behavior such as focus, keyboard navigation, selection, or layered overlays. Keep styling and icons separate from interaction. This project ships guidance and runnable examples, not a component library or an application template.

## Install the skill

Run from the project where you want to use the skill:

```sh
bunx --bun skills@latest add PhilosophiMoonbeam/svelte-ui-eco --skill svelte-ui-eco
```

Follow the [skills CLI](https://github.com/vercel-labs/skills) prompts to select your coding agents. Refresh skill discovery if your agent requires it. Installation does not add application dependencies.

> Use svelte-ui-eco to build accessible account preferences. Keep the existing visual style, use native controls where they fit, and use Bits UI for the confirmation dialog. Verify form submission and keyboard focus.

## Compatibility

Standalone modern Svelte 5 is supported. SvelteKit 3.1+ applies only to Kit-specific guidance; Kit 3.4.0 is the exact reference version, not the minimum. Retain a compatible existing toolchain and inspect the application's resolved versions before adapting examples.

| Package or tool | Reference version | Role |
| --- | --- | --- |
| Bun | 1.4.5 | Repository tooling and installation examples |
| Svelte | 5.59.1 | Framework |
| Bits UI | 2.22.0 | Sole recommended headless interaction layer |
| `@internationalized/date` | 3.12.4 | Date and time examples only |
| `@sveltejs/kit` | 3.4.0 | Kit-specific guidance only |
| `@skeletonlabs/skeleton` | 5.0.6 | Optional CSS and themes |
| `tailwindcss` | 4.3.5 | Optional CSS utilities |
| `@lucide/svelte` | 1.77.0 | Optional icons |

## Find the right guidance

Start with the [skill entrypoint](skills/svelte-ui-eco/SKILL.md) and follow its task router. Open [setup](skills/svelte-ui-eco/references/setup.md) for dependency and integration decisions, and [migration](skills/svelte-ui-eco/references/migration.md) when replacing old wrappers.

The [component catalog](skills/svelte-ui-eco/references/components.md) maps native alternatives and Bits UI anatomy across forms and selection, navigation, overlays and feedback, display, and date/time controls. The [recipes](skills/svelte-ui-eco/references/recipes.md) and [example mounting guide](skills/svelte-ui-eco/examples/README.md) connect those contracts to standalone components. Examples do not require Skeleton, Tailwind, or Lucide. The entrypoint also routes design, styling, icons, accessibility, SSR, and server form tasks directly to their references.

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

## Serve the archive privately

From the repository root on a host with Docker Compose and [Tailscale Serve](https://tailscale.com/docs/reference/tailscale-cli/serve) HTTPS enabled:

```sh
docker compose up --build -d --wait
tailscale serve --bg --https=11454 http://127.0.0.1:38110
tailscale serve status
```

From an authorized tailnet device, use the HTTPS origin shown by `tailscale serve status` and append `/svelte-ui-eco.tar.gz`. Use Serve, not Funnel, to keep the archive off the public internet. Rebuild with the same Compose command when the package changes.

Remove only this Serve endpoint and stop the Compose project:

```sh
tailscale serve --bg --https=11454 off
docker compose down
```
