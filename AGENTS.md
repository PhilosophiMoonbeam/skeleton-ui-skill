# Agent Instructions

Use the latest Bun instead of Node wherever applicable. Use Biome for repository linting and formatting.

## Unofficial Svelte UI Agent Skill

Start with [svelte-ui-eco](skills/svelte-ui-eco/SKILL.md) and the [Agent Skills specification](skills/SKILLS_SPEC.md).

Start from the user task and [visual brief](skills/svelte-ui-eco/references/design.md). Keep the app's working components and design system, and use native HTML when sufficient. For a new product with no visual system, if Tailwind is acceptable, start with Tailwind 4, Skeleton core, and a calibrated theme. Add Skeleton's styled, Zag-backed Svelte widgets where they fit; don't install Bits UI by default. Choose Bits UI when bespoke markup or its managed behavior fits better, and style it with app CSS, Tailwind, or optional Skeleton core. Share theme tokens and app-owned values, not widget internals; each widget has one interaction owner. See [setup](skills/svelte-ui-eco/references/setup.md).

The reference baseline is Bun 1.4.5, Svelte 5.59.1, Bits UI 2.22.0, and `@internationalized/date` 3.12.4. Standalone Svelte does not require Kit; Kit-specific guidance starts at SvelteKit 3.1 (reference 3.4.0). Reference versions are 5.0.6 for both Skeleton packages, 4.3.5 for Tailwind CSS, and 1.77.0 for `@lucide/svelte`.

- Bits UI: [documentation](https://www.bits-ui.com/docs/introduction), [LLM access guide](https://www.bits-ui.com/docs/llms), and [index](https://www.bits-ui.com/llms.txt). Follow the relevant component page's `/llms.txt` link instead of loading the whole corpus.
- Skeleton UI: [fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals), [Svelte LLM index](https://www.skeleton.dev/llms-svelte.txt), and [local component guide](skills/svelte-ui-eco/references/skeleton.md).
- For further discovery, see your `find-docs` skill. Prefer the resolved installed declarations and source when they differ from rolling documentation.

<!-- beads-integration:start -->
## Planning Work - Beads bootstrap

Use `bd` for all project task tracking, not TodoWrite, TaskCreate, or Markdown TODO lists. Read your available `beads` skill. Run `bd prime` when Beads context is missing or stale. Keep persistent project knowledge in Beads with `bd remember`, not `MEMORY.md` or ad hoc memory files.
<!-- beads-integration:end -->

<!-- trail:start -->
## Trail — repo context graph

This repo is indexed in `graft/`: small linked markdown nodes that explain each
system and carry exact file:line spans, kept in sync with the code through git.

For ANY task here — understanding how something works, finding where code lives,
or scoping a change — get context from the graph before grepping or opening
source files. Re-ask freely (it's cheap) and reuse literal identifiers you
already have (symbol, error string, file name) as the query. New to this repo?
Run `trail map` first — a token-budgeted orientation (dir clusters, hubs,
hotspots), no LLM, no key.

- Run `trail ask "<your question>" --source` → ranked nodes with the relevant
  code spans inlined (each hit's ≤8-line crux by default; `--full` for whole
  definitions when the crux isn't enough). Match the tool to the task shape:
  for understanding or editing, the top node IS the answer — cite its
  `covers:` file:line spans and edit straight from `--source`. For
  exhaustive tasks ("every occurrence / every caller of this pattern"), ranked
  results are top-N, not complete — run `trail grep "<literal>"` instead
  (exhaustive over indexed files, grouped by enclosing symbol), falling back
  to raw `grep -rn` only for unindexed files.
- `trail skeleton <file>` → every definition's signature + span, ~10× cheaper
  than reading the file; use it to skim an API surface.
- `trail callers <symbol>` gives precomputed, exact edges — who calls this.
  Add `--direction out` for what it calls, or `--depth N` to walk
  transitively for the full blast radius. For structural questions, skip
  ranking and use this directly.
- Or browse: `graft/INDEX.md` lists every node; follow the links.
- Monorepos and folders of multiple repos rank fairly across sub-projects —
  hits carry `[scope/]` labels naming which one they're from. Narrow with
  `trail ask "<task>" --in <scope>/` once you know where you're working.

If a returned span is truncated ("+N more lines"), open the file at that exact
range before finalizing. Only open source files when a node genuinely lacks a
needed detail, and then at the exact file:line the node points to — never
re-read whole files.

After big code changes, refresh the graph with `trail build` (deterministic,
no API key, $0).
<!-- trail:end -->

<!-- resource-lifecycle:start -->
## Resource lifecycle and disk usage

Reuse compatible build trees, dependency caches, environments and development
containers without compromising isolation; avoid per-run clones and copies.
Treat per-run resources as disposable unless persistence is explicitly required.
Namespace or label owned containers, volumes, worktrees, browser profiles and
scratch; register cleanup before acquisition, clean up on success, failure and
interruption, and reconcile verified inactive leftovers on startup. Replacing
owned disposable containers must retire the old containers and anonymous volumes;
remove named volumes only with verified ownership and explicit disposable status.
Preserve active/shared services, persistent data, secrets, unique work and required
backups; never use broad host-wide pruning. Put large scratch on verified
disk-backed storage, not RAM-backed `/tmp`. Set size, age and count budgets for
caches, logs, captures and retained runs; keep compact evidence, bound concurrency,
verify cleanup and space afterward, and report intentional retention with its
purpose and expiry.
<!-- resource-lifecycle:end -->
