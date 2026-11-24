<script lang="ts">
  import { onMount, tick } from "svelte";

  const id = $props.id();
  const nameId = `${id}-name`;
  const emailId = `${id}-email`;
  const nameLimit = 60;

  type Profile = { displayName: string; email: string };
  let ready = $state(false);
  let errors = $state<Partial<Profile>>({});
  let preview = $state<Profile | null>(null);
  let cleared = $state(false);
  let summary = $state<HTMLElement>();
  let nameInput: HTMLInputElement;
  let emailInput: HTMLInputElement;

  onMount(() => { ready = true; });

  async function updatePreview(event: SubmitEvent & { currentTarget: HTMLFormElement }) {
    event.preventDefault();
    const values = new FormData(event.currentTarget);
    const displayName = String(values.get("displayName") ?? "").trim();
    const email = String(values.get("email") ?? "");
    const nextErrors: Partial<Profile> = {};

    if (!displayName) {
      nextErrors.displayName = "Enter a display name that is not just spaces.";
    } else if (nameInput.value.length > nameLimit) {
      nextErrors.displayName = `Use no more than ${nameLimit} characters, including spaces.`;
    }

    if (emailInput.validity.valueMissing) {
      nextErrors.email = "Enter an email address.";
    } else if (emailInput.validity.typeMismatch) {
      nextErrors.email = "Enter an email address in the form name@example.com.";
    }

    errors = nextErrors;
    if (nextErrors.displayName || nextErrors.email) {
      await tick();
      summary?.focus();
    } else {
      preview = { displayName, email };
      cleared = false;
    }
  }

  async function resetPreview() {
    errors = {};
    preview = null;
    cleared = true;
    // The form's native reset restores the inputs; wait before moving focus.
    await tick();
    nameInput.focus();
  }
</script>

<section class="profile" aria-labelledby={`${id}-title`}>
  <h2 id={`${id}-title`}>Profile preview</h2>
  <p id={`${id}-notice`}>
    {ready
      ? "This preview stays on this page. Nothing is sent or saved. Use sample data."
      : "JavaScript is required to update the preview. Nothing is sent or saved."}
  </p>

  <form novalidate aria-describedby={`${id}-notice`} onsubmit={updatePreview} onreset={resetPreview}>
    {#if errors.displayName || errors.email}
      <section class="error-summary" aria-labelledby={`${id}-errors-title`} tabindex="-1" bind:this={summary}>
        <h3 id={`${id}-errors-title`}>Correct the following before updating the preview</h3>
        <ul>
          {#if errors.displayName}<li><a href={`#${nameId}`}>Display name: {errors.displayName}</a></li>{/if}
          {#if errors.email}<li><a href={`#${emailId}`}>Email: {errors.email}</a></li>{/if}
        </ul>
      </section>
    {/if}

    <fieldset disabled={!ready}>
      <legend>Preview details</legend>
      <div class="field">
        <label for={nameId}>Display name (required)</label>
        <input id={nameId} name="displayName" type="text" required maxlength={nameLimit}
          autocomplete="nickname" bind:this={nameInput}
          aria-invalid={errors.displayName ? "true" : undefined}
          aria-describedby={`${nameId}-help${errors.displayName ? ` ${nameId}-error` : ""}`} />
        <p id={`${nameId}-help`}>Use up to {nameLimit} characters, including spaces.</p>
        {#if errors.displayName}<p class="field-error" id={`${nameId}-error`}>{errors.displayName}</p>{/if}
      </div>
      <div class="field">
        <label for={emailId}>Email (required)</label>
        <input id={emailId} name="email" type="email" required autocomplete="email"
          bind:this={emailInput} aria-invalid={errors.email ? "true" : undefined}
          aria-describedby={`${emailId}-help${errors.email ? ` ${emailId}-error` : ""}`} />
        <p id={`${emailId}-help`}>For example, sam@example.com.</p>
        {#if errors.email}<p class="field-error" id={`${emailId}-error`}>{errors.email}</p>{/if}
      </div>
      <div class="actions">
        <button class="primary" type="submit">Update preview</button>
        <button type="reset">Reset preview</button>
      </div>
    </fieldset>
  </form>

  <div class="result">
    <h3>Local preview</h3>
    <div role="status" aria-atomic="true">
      {#if preview}
        <p>Preview updated. Nothing was sent or saved.</p>
        <dl>
          <dt>Display name</dt><dd>{preview.displayName}</dd>
          <dt>Email</dt><dd>{preview.email}</dd>
        </dl>
      {:else if cleared}
        <p>Preview cleared.</p>
      {:else}
        <p>No preview yet.</p>
      {/if}
    </div>
  </div>
</section>

<style>
  .profile {
    color-scheme: var(--example-color-scheme, light dark);
    --canvas: var(--example-canvas, Canvas);
    --panel: var(--example-panel, Canvas);
    --ink: var(--example-text, CanvasText);
    --muted: var(--example-muted, CanvasText);
    --border: var(--example-border, CanvasText);
    --accent: var(--example-accent, Highlight);
    --on-accent: var(--example-on-accent, HighlightText);
    --focus: var(--example-focus, Highlight);
    --error: var(--example-error, CanvasText);
    box-sizing: border-box;
    max-inline-size: 36rem;
    padding: clamp(1rem, 4vw, 1.5rem);
    border: 1px solid var(--border);
    border-radius: 0.65rem;
    background: var(--canvas);
    color: var(--ink);
    font-family: system-ui, sans-serif;
    line-height: 1.5;
    overflow-wrap: anywhere;
  }
  @supports (color: light-dark(white, black)) {
    .profile {
      --canvas: var(--example-canvas, light-dark(#f6f5f0, #151819));
      --panel: var(--example-panel, light-dark(#fff, #222728));
      --ink: var(--example-text, light-dark(#202b2a, #f1f5f4));
      --muted: var(--example-muted, light-dark(#4c5e5b, #b2c5c1));
      --border: var(--example-border, light-dark(#647772, #859894));
      --accent: var(--example-accent, light-dark(#165d57, #9ce2d8));
      --on-accent: var(--example-on-accent, light-dark(#fff, #102927));
      --focus: var(--example-focus, light-dark(#124944, #a8f3e7));
      --error: var(--example-error, light-dark(#922724, #ffbcb7));
    }
  }
  h2, h3, p, dl, dd { margin: 0; }
  h2 { font-size: 1.5rem; }
  h3 { font-size: 1.125rem; }
  h2 + p, h3 + div, p + dl { margin-block-start: 0.5rem; }
  .profile > p, .field p { color: var(--muted); }
  form, .result { margin-block-start: 1rem; }
  fieldset {
    display: grid;
    gap: 1rem;
    min-inline-size: 0;
    margin: 0;
    padding: 0.75rem;
    border: 1px solid var(--border);
    border-radius: 0.4rem;
  }
  legend { padding-inline: 0.25rem; }
  .field { display: grid; gap: 0.25rem; min-inline-size: 0; }
  label, dt { font-weight: 650; }
  input, button {
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
  input { inline-size: 100%; }
  button { cursor: pointer; font-weight: 650; white-space: normal; }
  button:disabled { cursor: default; color: var(--muted); background: var(--canvas); border-color: var(--border); }
  button:hover:not(:disabled) { text-decoration: underline; }
  .primary { background: var(--accent); color: var(--on-accent); border-color: var(--accent); }
  .actions { display: flex; flex-wrap: wrap; gap: 0.75rem; }
  input[aria-invalid="true"] { border-color: var(--error); }
  .field .field-error { color: var(--error); font-weight: 650; }
  .error-summary, .result { background: var(--panel); padding: 0.75rem; }
  .error-summary { border-inline-start: 0.25rem solid var(--error); margin-block-end: 1rem; }
  .error-summary ul { margin-block: 0.5rem 0; padding-inline-start: 1.25rem; }
  .error-summary a { color: var(--error); text-decoration: underline; }
  :is(button, input, a):focus-visible, .error-summary:focus { outline: 2px solid var(--focus); outline-offset: 3px; }
  dd + dt { margin-block-start: 0.5rem; }

  @media (forced-colors: active) {
    :is(button, input, a):focus-visible, .error-summary:focus { outline-color: Highlight; }
  }
</style>
