<script lang="ts">
  import { AlertDialog, Dialog, LinkPreview, Popover, Tooltip } from 'bits-ui';

  const id = $props.id();
  const retentionId = `${id}-retention`;
  const optionsId = `${id}-display-options`;
  let drafts = $state([{ name: 'April release notes', summary: 'Highlights from the April release.' }]);
  let deleteOpen = $state(false);
  let showDescriptions = $state(true);
  let showCount = $state(false);
  let draftsHeading: HTMLHeadingElement;
  let cancelDelete = $state<HTMLButtonElement | null>(null);

  function deleteDraft() {
    drafts = [];
    // AlertDialog.Action does not close the dialog on its own.
    deleteOpen = false;
  }
</script>

<h2 tabindex="-1" bind:this={draftsHeading}>Release drafts</h2>

<Dialog.Root>
  <Dialog.Trigger type="button">About drafts</Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay class="backdrop" />
    <Dialog.Content class="surface modal">
      <Dialog.Title level={2}>About drafts</Dialog.Title>
      <Dialog.Description>Drafts are kept separate from published release notes.</Dialog.Description>
      <Dialog.Close type="button">Close about drafts</Dialog.Close>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>

<Popover.Root>
  <Popover.Trigger>Display options</Popover.Trigger>
  <Popover.Portal>
    <Popover.Content class="surface floating" sideOffset={8} align="start" aria-labelledby={optionsId}>
      <h3 id={optionsId}>Display options</h3>
      <p><label><input type="checkbox" bind:checked={showDescriptions} /> Show draft descriptions</label></p>
      <Popover.Close type="button">Done</Popover.Close>
    </Popover.Content>
  </Popover.Portal>
</Popover.Root>

<Tooltip.Provider delayDuration={300}>
  <Tooltip.Root>
    <Tooltip.Trigger type="button" aria-pressed={showCount} onclick={() => (showCount = !showCount)}>
      Show draft count
    </Tooltip.Trigger>
    <Tooltip.Portal>
      <Tooltip.Content class="surface floating" sideOffset={8}>
        Counts only drafts in this list.
      </Tooltip.Content>
    </Tooltip.Portal>
  </Tooltip.Root>
</Tooltip.Provider>

{#if showCount}
  <p>Draft count: {drafts.length}</p>
{/if}

<AlertDialog.Root bind:open={deleteOpen}>
  {#each drafts as draft (draft.name)}
    <p><strong>{draft.name}</strong>{#if showDescriptions} — {draft.summary}{/if}</p>
    <AlertDialog.Trigger type="button">Delete {draft.name}</AlertDialog.Trigger>
  {:else}
    <p>No drafts remain.</p>
  {/each}
  <AlertDialog.Portal>
    <AlertDialog.Overlay class="backdrop" />
    <AlertDialog.Content
      class="surface modal"
      onOpenAutoFocus={(event) => {
        if (!cancelDelete) return;
        event.preventDefault();
        cancelDelete.focus();
      }}
      onCloseAutoFocus={(event) => {
        // After deletion the trigger is gone. On Cancel, let Bits UI restore focus.
        if (drafts.length) return;
        event.preventDefault();
        draftsHeading.focus();
      }}
    >
      <AlertDialog.Title level={2}>Delete April release notes?</AlertDialog.Title>
      <AlertDialog.Description>This removes the draft from the list and cannot be undone.</AlertDialog.Description>
      <AlertDialog.Cancel type="button" bind:ref={cancelDelete}>Cancel</AlertDialog.Cancel>
      <AlertDialog.Action type="button" onclick={deleteDraft}>Delete draft</AlertDialog.Action>
    </AlertDialog.Content>
  </AlertDialog.Portal>
</AlertDialog.Root>

<p>
  <LinkPreview.Root openDelay={300}>
    <LinkPreview.Trigger href={`#${retentionId}`}>
      {#snippet child({ props })}
        <!-- Keep the destination a native link; the preview is supplementary. -->
        {@const { role, 'aria-haspopup': hasPopup, 'aria-expanded': expanded, 'aria-controls': controls, ...anchorProps } = props}
        <a {...anchorProps}>Read the draft retention policy</a>
      {/snippet}
    </LinkPreview.Trigger>
    <LinkPreview.Portal>
      <LinkPreview.Content class="surface floating" sideOffset={8}>
        Published notes are kept separately.
      </LinkPreview.Content>
    </LinkPreview.Portal>
  </LinkPreview.Root>
</p>
<h3 id={retentionId} tabindex="-1">Draft retention policy</h3>
<p>Deleting a draft removes only the unpublished copy. Published notes are kept separately.</p>

<style>
  :global(.backdrop[data-dialog-overlay]),
  :global(.backdrop[data-alert-dialog-overlay]) {
    position: fixed;
    inset: 0;
    z-index: 20;
    background: rgb(0 0 0 / 55%);
  }

  :global(.surface:is([data-dialog-content], [data-alert-dialog-content], [data-popover-content], [data-link-preview-content], [data-tooltip-content])) {
    box-sizing: border-box;
    max-inline-size: min(28rem, calc(100vw - 2rem));
    padding: 1rem;
    border: 1px solid;
    border-radius: 0.5rem;
    background: Canvas;
    color: CanvasText;
  }

  :global(.modal[data-dialog-content]),
  :global(.modal[data-alert-dialog-content]) {
    position: fixed;
    inset: 50% auto auto 50%;
    z-index: 21;
    width: 28rem;
    max-height: calc(100dvh - 2rem);
    overflow: auto;
    transform: translate(-50%, -50%);
  }

  :global(.floating:is([data-popover-content], [data-link-preview-content], [data-tooltip-content])) {
    z-index: 10;
  }
</style>
