<script lang="ts">
  import { onMount } from "svelte";

  const id = $props.id();
  const sections = [
    { target: `${id}-overview`, label: "Overview" },
    { target: `${id}-library`, label: "Brief library" },
    { target: `${id}-notes`, label: "Studio notes" },
  ] as const;
  const [overview, library, notes] = sections;
  const briefs = [
    {
      id: "harbor", title: "Harbor wayfinding", owner: "Maya Chen", status: "In review",
      description: "A clear walking route from the ferry landing to the community hall.",
      next: "Check sign wording with the access group.",
    },
    {
      id: "seeds", title: "Seed library labels", owner: "Jonah Reed", status: "Ready",
      description: "Reusable packet labels for the spring seed exchange at the library.",
      next: "Print the approved labels on recycled stock.",
    },
    {
      id: "workshops", title: "Evening workshop series", owner: "Aisha Patel", status: "Draft",
      description: "A simple programme for three hands-on sessions in the makerspace.",
      next: "Confirm session titles with the facilitators.",
    },
    {
      id: "repair", title: "Repair café welcome guide", owner: "Theo Brooks", status: "Draft",
      description: "A friendly first-visit guide explaining what to bring and what to expect.",
      next: "Add the volunteer desk and step-free entrance details.",
    },
  ];
  const statuses = ["All", "Draft", "In review", "Ready"];
  let ready = $state(false);
  let draftQuery = $state("");
  let draftStatus = $state("All");
  let query = $state("");
  let status = $state("All");
  let searchInput: HTMLInputElement;

  const visible = $derived(briefs.filter((brief) =>
    (status === "All" || brief.status === status) &&
    `${brief.title} ${brief.owner} ${brief.description}`.toLowerCase().includes(query)
  ));

  onMount(() => { ready = true; });

  function applyFilters(event: SubmitEvent) {
    event.preventDefault();
    query = draftQuery.trim().toLowerCase();
    status = draftStatus;
  }

  function resetFilters() {
    draftQuery = query = "";
    draftStatus = status = "All";
    searchInput.focus();
  }
</script>

{#snippet sectionLinks()}
  <nav class="section-links" aria-label="Page sections">
    {#each sections as { target, label } (target)}
      <a href={`#${target}`}>{label}</a>
    {/each}
  </nav>
{/snippet}

<div class="workspace">
  <a class="skip-link action" href={`#${id}-main`}>Skip to content</a>
  <header class="masthead">
    <a class="wordmark" href={`#${overview.target}`}>Fieldnotes <span>/ Community studio</span></a>
    <span>Local example workspace</span>
  </header>

  <details class="mobile-navigation">
    <summary>Page navigation</summary>
    {@render sectionLinks()}
  </details>

  <div class="shell">
    <div class="sidebar">
      {@render sectionLinks()}
      <p>A shared place for clear briefs and thoughtful community projects.</p>
    </div>

    <main id={`${id}-main`} tabindex="-1">
      <section class="intro" id={overview.target} tabindex="-1" aria-labelledby={`${id}-title`}>
        <div>
          <p class="eyebrow">The community collection</p>
          <h1 id={`${id}-title`}>Small projects.<br />Lasting care.</h1>
          <p>Find a brief, see what needs attention, and keep the next step clear.</p>
          <a class="action primary" href={`#${library.target}`}>Browse the briefs</a>
        </div>
        <div class="panel principle">
          <p class="eyebrow">Working principle</p>
          <p><strong>Useful first. Beautiful through care.</strong></p>
          <p>Start with the people using the space, not with the deliverable.</p>
        </div>
      </section>

      <section id={library.target} tabindex="-1" aria-labelledby={`${id}-library-title`}>
        <h2 id={`${id}-library-title`}>Brief library</h2>
        <p>Search by project, owner, or description; combine with a status.</p>
        <form aria-label="Filter briefs" aria-describedby={`${id}-filter-help`} onsubmit={applyFilters}>
          <fieldset disabled={!ready}>
            <legend>Local brief filters</legend>
            <div class="filters">
              <label>
                Search briefs
                <input type="search" name="search" placeholder="Try harbor or Maya"
                  bind:this={searchInput} bind:value={draftQuery} />
              </label>
              <label>
                Status
                <select name="status" bind:value={draftStatus}>
                  {#each statuses as option (option)}
                    <option value={option}>{option}</option>
                  {/each}
                </select>
              </label>
              <button class="action primary" type="submit">Apply filters</button>
              <button class="action" type="button" onclick={resetFilters}>Reset filters</button>
            </div>
          </fieldset>
          <p id={`${id}-filter-help`} class="muted">
            {ready ? "Filters affect this local view only; nothing is saved." : "Filters become available when JavaScript loads."}
          </p>
        </form>
        <p role="status" aria-atomic="true">Showing {visible.length} of {briefs.length} local briefs.</p>
        <div class="brief-grid">
          {#each visible as brief (brief.id)}
            <article class="panel brief" aria-labelledby={`${id}-brief-${brief.id}`}>
              <div class="brief-meta">
                <span>{brief.owner}</span>
                <span class="badge">{brief.status}</span>
              </div>
              <h3 id={`${id}-brief-${brief.id}`}>{brief.title}</h3>
              <p>{brief.description}</p>
              <p class="next-step"><strong>Next step:</strong> {brief.next}</p>
            </article>
          {:else}
            <div class="panel empty-state">
              <h3>No briefs match these filters</h3>
              <p>Try a shorter search or choose All statuses.</p>
              <button class="action" type="button" onclick={resetFilters}>Clear filters and show all briefs</button>
            </div>
          {/each}
        </div>
      </section>

      <section class="notes" id={notes.target} tabindex="-1" aria-labelledby={`${id}-notes-title`}>
        <h2 id={`${id}-notes-title`}>Studio notes</h2>
        <p>Before review, describe the audience, check access needs, and write one concrete next step.
          A brief is ready when the people delivering it understand the same thing.</p>
      </section>
      <footer class="muted">Fieldnotes · Local example content, not a connected account.</footer>
    </main>
  </div>
</div>

<style>
  .workspace {
    color-scheme: var(--example-color-scheme, light dark);
    --canvas: var(--example-canvas, Canvas);
    --panel: var(--example-panel, Canvas);
    --ink: var(--example-text, CanvasText);
    --muted: var(--example-muted, CanvasText);
    --border: var(--example-border, CanvasText);
    --accent: var(--example-accent, Highlight);
    --on-accent: var(--example-on-accent, HighlightText);
    --focus: var(--example-focus, Highlight);
    --gutter: clamp(1rem, 4vw, 2.5rem);
    position: relative;
    max-inline-size: 88rem;
    margin-inline: auto;
    background: var(--canvas);
    color: var(--ink);
    font-family: system-ui, sans-serif;
    line-height: 1.55;
    overflow-wrap: anywhere;
  }

  @supports (color: light-dark(white, black)) {
    .workspace {
      --canvas: var(--example-canvas, light-dark(#f6f5f0, #151819));
      --panel: var(--example-panel, light-dark(#fff, #222728));
      --ink: var(--example-text, light-dark(#202b2a, #f1f5f4));
      --muted: var(--example-muted, light-dark(#4c5e5b, #b2c5c1));
      --border: var(--example-border, light-dark(#647772, #859894));
      --accent: var(--example-accent, light-dark(#165d57, #9ce2d8));
      --on-accent: var(--example-on-accent, light-dark(#fff, #102927));
      --focus: var(--example-focus, light-dark(#124944, #a8f3e7));
    }
  }

  h1, h2, h3, p { margin: 0; }
  h1, h2, h3 { line-height: 1.15; }
  h1 { font-size: clamp(2rem, 1.25rem + 3vw, 3.75rem); letter-spacing: -0.035em; }
  h2 { font-size: 1.5rem; }
  h3 { font-size: 1.15rem; }
  p { max-inline-size: 65ch; }
  p, .action { margin-block-start: 0.65rem; }
  .muted, .eyebrow, .brief-meta, .sidebar p, .masthead span { color: var(--muted); }
  .eyebrow { margin: 0 0 0.5rem; font-weight: 650; }
  a { color: inherit; text-decoration: underline; text-underline-offset: 0.18em; }

  .masthead {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem 1rem;
    padding: 0.65rem var(--gutter);
  }
  .masthead, .mobile-navigation { border-block-end: 1px solid var(--border); }
  .wordmark { display: inline-flex; flex-wrap: wrap; align-items: center; gap: 0 0.5rem; min-block-size: 2.75rem; font-weight: 700; }
  .wordmark span { font-weight: normal; }
  .mobile-navigation { padding: 0.35rem var(--gutter); }
  summary { box-sizing: border-box; min-block-size: 2.75rem; padding-block: 0.55rem; font-weight: 650; cursor: pointer; }
  .section-links { display: grid; gap: 0.25rem; }
  .section-links a { box-sizing: border-box; min-block-size: 2.75rem; padding: 0.55rem 0.75rem; }
  .section-links a:hover { background: var(--panel); }
  .shell { display: grid; grid-template-columns: minmax(0, 1fr); }
  .sidebar { display: none; padding: 1.75rem 1rem; border-inline-end: 1px solid var(--border); }
  .sidebar p { padding-inline: 0.75rem; }
  main { display: grid; gap: clamp(1.75rem, 5vw, 3rem); padding: 1.75rem var(--gutter); }
  .intro { display: grid; gap: 1.25rem; align-items: start; }
  .notes { padding-block-start: 1.25rem; border-block-start: 1px solid var(--border); }

  form { margin-block: 1rem; }
  fieldset { min-inline-size: 0; margin: 0; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; }
  legend { padding-inline: 0.25rem; }
  .filters, label { display: grid; gap: 0.5rem; }
  .filters { align-items: end; }
  label { min-inline-size: 0; }
  input, select, .action {
    box-sizing: border-box;
    min-inline-size: 0;
    max-inline-size: 100%;
    min-block-size: 2.75rem;
    padding: 0.45rem 0.7rem;
    border: 1px solid var(--border);
    border-radius: 0.4rem;
    background: var(--panel);
    color: var(--ink);
    font: inherit;
  }
  input, select { inline-size: 100%; }
  input::placeholder { color: var(--muted); opacity: 1; }
  .action { display: inline-flex; align-items: center; justify-content: center; font-weight: 650; white-space: normal; cursor: pointer; }
  .primary { border-color: var(--accent); background: var(--accent); color: var(--on-accent); }
  .filters .action { margin: 0; }
  .action:disabled { cursor: default; color: var(--muted); background: var(--canvas); border-color: var(--border); }
  .action:hover:not(:disabled) { text-decoration: underline; }

  .brief-grid { display: grid; gap: 1rem; margin-block-start: 0.75rem; }
  .panel { min-inline-size: 0; padding: 1rem; border: 1px solid var(--border); border-radius: 0.65rem; background: var(--panel); }
  .principle { border-inline-start: 0.25rem solid var(--accent); }
  .brief { display: flex; flex-direction: column; gap: 0.75rem; }
  .brief p { margin: 0; }
  .brief-meta { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.25rem 0.75rem; }
  .badge { padding: 0.1rem 0.45rem; border: 1px solid var(--border); border-radius: 0.4rem; }
  .brief .next-step { margin-block-start: auto; padding-block-start: 0.65rem; border-block-start: 1px solid var(--border); }
  .empty-state { grid-column: 1 / -1; }

  .skip-link { position: absolute; inset-block-start: 0; inset-inline-start: 0.75rem; z-index: 1; clip-path: inset(50%); }
  .skip-link:focus { clip-path: none; }
  :is(a, button, input, select, summary, main, section):focus-visible { outline: 2px solid var(--focus); outline-offset: 3px; }

  @media (min-width: 48rem) {
    .filters, .brief-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  }
  @media (min-width: 64rem) {
    .shell { grid-template-columns: minmax(12rem, 18%) minmax(0, 1fr); }
    .sidebar { display: block; }
    .mobile-navigation { display: none; }
    .intro { grid-template-columns: minmax(0, 1.5fr) minmax(0, 1fr); }
  }
  @media (forced-colors: active) {
    .principle { border-inline-start-color: CanvasText; }
    :is(a, button, input, select, summary, main, section):focus-visible { outline-color: Highlight; }
  }
</style>
