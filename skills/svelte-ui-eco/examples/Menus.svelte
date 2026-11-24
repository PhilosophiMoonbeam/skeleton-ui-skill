<script lang="ts">
  import { Command, ContextMenu, DropdownMenu, Menubar, Toolbar } from "bits-ui";

  const id = $props.id();
  const sample = "Check the station entrance before the site visit.\n\nMeet at the ticket hall at 09:00.";
  let draft = $state(sample);
  let showWordCount = $state(false);
  let formatting = $state<string[]>([]);
  let status = $state("");
  const wordCount = $derived(draft.match(/\S+/g)?.length ?? 0);

  function addFollowUp() {
    const line = "Follow-up: Confirm the delivery window.";
    draft += draft && !draft.endsWith("\n") ? `\n${line}` : line;
    status = "Follow-up line added.";
  }

  function removeBlankLines() {
    const text = draft.split("\n").filter((line) => line.trim()).join("\n");
    status = text === draft ? "No blank lines to remove." : "Blank lines removed.";
    draft = text;
  }

  function restoreSample() {
    draft = sample;
    status = "Sample text restored.";
  }

  const previewActions = [
    { label: "Add follow-up line", run: addFollowUp },
    { label: "Remove blank lines", run: removeBlankLines },
  ];
</script>

<section aria-labelledby={`${id}-title`}>
  <h2 id={`${id}-title`}>Site visit brief editor</h2>
  <p>These commands change the draft or its preview. Changes stay on this page.</p>

  <Menubar.Root aria-label="Brief editor menu">
    <Menubar.Menu value="edit">
      <Menubar.Trigger>Edit</Menubar.Trigger>
      <Menubar.Portal>
        <Menubar.Content class="brief-menu" align="start" sideOffset={4}>
          <Menubar.Item class="brief-menu-item" onSelect={restoreSample}>
            Restore sample text
          </Menubar.Item>
        </Menubar.Content>
      </Menubar.Portal>
    </Menubar.Menu>
    <Menubar.Menu value="view">
      <Menubar.Trigger>View</Menubar.Trigger>
      <Menubar.Portal>
        <Menubar.Content class="brief-menu" align="start" sideOffset={4}>
          <Menubar.CheckboxItem class="brief-menu-item" bind:checked={showWordCount}>
            {#snippet children({ checked })}
              Show word count{#if checked} <span aria-hidden="true">✓</span>{/if}
            {/snippet}
          </Menubar.CheckboxItem>
        </Menubar.Content>
      </Menubar.Portal>
    </Menubar.Menu>
  </Menubar.Root>

  <h3>Command search</h3>
  <Command.Root label="Find a command">
    <label for={`${id}-search`}>Find a command</label>
    <Command.Input id={`${id}-search`} />
    <Command.List aria-label="Matching commands">
      <Command.Viewport>
        <Command.Empty>No matching commands.</Command.Empty>
        {#each previewActions as action (action.label)}
          <Command.Item class="brief-command" value={action.label} onSelect={action.run}>
            {action.label}
          </Command.Item>
        {/each}
        <Command.Item class="brief-command" value="Restore sample text" onSelect={restoreSample}>
          Restore sample text
        </Command.Item>
      </Command.Viewport>
    </Command.List>
  </Command.Root>

  <h3><label for={`${id}-draft`}>Draft text</label></h3>
  <textarea id={`${id}-draft`} rows={5} bind:value={draft}></textarea>
  {#if showWordCount}
    <p>{wordCount} {wordCount === 1 ? "word" : "words"}</p>
  {/if}

  <h3 id={`${id}-preview`}>Brief preview</h3>
  <Toolbar.Root aria-label="Preview toolbar">
    <Toolbar.Group type="multiple" aria-label="Preview formatting" bind:value={formatting}>
      <Toolbar.GroupItem class="brief-format" value="bold">Bold</Toolbar.GroupItem>
      <Toolbar.GroupItem class="brief-format" value="italic">Italic</Toolbar.GroupItem>
    </Toolbar.Group>
    <Toolbar.Button onclick={() => (formatting = [])}>Reset formatting</Toolbar.Button>
  </Toolbar.Root>

  <p id={`${id}-preview-help`}>Right-click the preview or use Preview actions.</p>
  <ContextMenu.Root>
    <ContextMenu.Trigger
      role="group"
      tabindex={0}
      aria-labelledby={`${id}-preview`}
      aria-describedby={`${id}-preview-help`}
    >
      <div class="preview" class:bold={formatting.includes("bold")} class:italic={formatting.includes("italic")}>
        {draft.trim() ? draft : "The draft is empty."}
      </div>
    </ContextMenu.Trigger>
    <ContextMenu.Portal>
      <ContextMenu.Content class="brief-menu" aria-label="Preview context actions">
        {#each previewActions as action (action.label)}
          <ContextMenu.Item class="brief-menu-item" onSelect={action.run}>
            {action.label}
          </ContextMenu.Item>
        {/each}
      </ContextMenu.Content>
    </ContextMenu.Portal>
  </ContextMenu.Root>

  <DropdownMenu.Root>
    <DropdownMenu.Trigger>Preview actions</DropdownMenu.Trigger>
    <DropdownMenu.Portal>
      <DropdownMenu.Content class="brief-menu" aria-label="Preview actions" align="start" sideOffset={4}>
        {#each previewActions as action (action.label)}
          <DropdownMenu.Item class="brief-menu-item" onSelect={action.run}>
            {action.label}
          </DropdownMenu.Item>
        {/each}
      </DropdownMenu.Content>
    </DropdownMenu.Portal>
  </DropdownMenu.Root>
  <p role="status">{status}</p>
</section>

<style>
  textarea {
    box-sizing: border-box;
    inline-size: min(100%, 36rem);
  }

  .preview {
    border: 1px solid currentColor;
    margin-block: 0.5rem;
    overflow-wrap: anywhere;
    padding: 0.5rem;
    white-space: pre-wrap;
  }

  .bold {
    font-weight: bold;
  }

  .italic {
    font-style: italic;
  }

  :global(.brief-format[data-state="on"]) {
    font-weight: bold;
    text-decoration: underline;
  }

  :global(.brief-menu) {
    z-index: 10;
    background: Canvas;
    color: CanvasText;
    border: 1px solid currentColor;
    padding: 0.25rem;
  }

  :global(.brief-menu-item),
  :global(.brief-command) {
    cursor: pointer;
    padding: 0.25rem 0.5rem;
  }

  :global(.brief-menu-item[data-highlighted]),
  :global(.brief-command[data-selected]) {
    background: Highlight;
    color: HighlightText;
  }
</style>
