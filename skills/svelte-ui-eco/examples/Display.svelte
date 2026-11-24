<script lang="ts">
  import { AspectRatio, Avatar, Button, Meter, Progress, ScrollArea, Separator } from 'bits-ui';

  const id = $props.id();
  const clips = [
    { name: 'Harbor Arrival.MOV', megabytes: 92 },
    { name: 'Lighthouse Wide.MOV', megabytes: 84 },
    { name: 'Breakwater.MOV', megabytes: 76 },
    { name: 'Beacon Detail.MOV', megabytes: 62 },
    { name: 'Tide Pools.MOV', megabytes: 54 },
    { name: 'Harbor Departure.MOV', megabytes: 52 },
  ];
  const storageUsed = clips.reduce((total, clip) => total + clip.megabytes, 0);
  const storageBudget = 600;

  let prepared = $state<string[]>([]);
  const complete = $derived(prepared.length === clips.length);

  function prepareNext() {
    const clip = clips.at(prepared.length);
    if (clip) prepared.push(clip.name.toLowerCase().replaceAll(' ', '-'));
  }
</script>

<section class="panel" aria-labelledby="{id}-title">
  <h2 id="{id}-title">Harbor footage</h2>
  <div class="credit">
    <!-- The editor has no profile image; the adjacent name identifies her. -->
    <Avatar.Root class="avatar" aria-hidden="true">
      <Avatar.Fallback>MC</Avatar.Fallback>
    </Avatar.Root>
    <span>Edited by Maya Chen</span>
  </div>

  <figure>
    <AspectRatio.Root ratio={16 / 9}>
      <svg
        width="100%"
        height="100%"
        viewBox="0 0 320 240"
        preserveAspectRatio="xMidYMid slice"
        role="img"
        aria-label="A lighthouse above the harbor at dusk"
      >
        <path fill="#eeb39b" d="M0 0h320v240H0z" />
        <path fill="#356975" d="M0 139h320v101H0z" />
        <circle cx="73" cy="93" r="24" fill="#fff1ba" />
        <path fill="#294f53" d="m0 195 67-15 93 6 55-60 105 39v75H0z" />
        <path fill="#fff9ea" d="M221 85h13l6 49h-25z" />
        <path fill="#773b45" d="M218 79h19v10h-19zm-2 30h21l2 9h-24z" />
      </svg>
    </AspectRatio.Root>
    <figcaption>Cover preview: 4:3 artwork cropped to 16:9.</figcaption>
  </figure>

  <p><span id="{id}-storage">Source storage</span>: {storageUsed} of {storageBudget} MB</p>
  <Meter.Root
    class="track"
    value={storageUsed}
    max={storageBudget}
    aria-labelledby="{id}-storage"
    aria-valuetext="{storageUsed} of {storageBudget} megabytes"
  >
    <div class="fill" style:width="{(storageUsed / storageBudget) * 100}%"></div>
  </Meter.Root>

  <Separator.Root class="separator" />

  <h3 id="{id}-queue">Filename queue</h3>
  <p>Prepare lowercase, hyphenated names without changing the source files.</p>
  <ScrollArea.Root type="auto" class="scroll-area">
    <ScrollArea.Viewport class="viewport" role="region" aria-labelledby="{id}-queue" tabindex={0}>
      <ol>
        {#each clips as clip, index (clip.name)}
          <li>
            {clip.name}:
            {#if prepared[index]}
              <code>{prepared[index]}</code>
            {:else}
              Pending
            {/if}
          </li>
        {/each}
      </ol>
    </ScrollArea.Viewport>
    <ScrollArea.Scrollbar class="scrollbar" orientation="vertical" aria-hidden="true">
      <ScrollArea.Thumb class="thumb" />
    </ScrollArea.Scrollbar>
  </ScrollArea.Root>

  <p id="{id}-progress">Filename preparation</p>
  <Progress.Root
    class="track"
    value={prepared.length}
    max={clips.length}
    aria-labelledby="{id}-progress"
    aria-valuetext="{prepared.length} of {clips.length} filenames prepared"
  >
    <div class="fill" style:width="{(prepared.length / clips.length) * 100}%"></div>
  </Progress.Root>
  <p role="status">
    {prepared.length} of {clips.length} filenames prepared.
    {#if complete}
      Batch ready.
    {:else if prepared.length}
      Latest: <code>{prepared.at(-1)}</code>.
    {/if}
  </p>
  <!-- Keep focus on the button at completion. prepareNext also guards the action. -->
  <Button.Root type="button" onclick={prepareNext} aria-disabled={complete}>
    Prepare next filename
  </Button.Root>
</section>

<style>
  .panel {
    max-inline-size: 34rem;
    --track: color-mix(in srgb, currentColor 18%, transparent);
  }

  .credit {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .panel :global(.avatar) {
    display: grid;
    place-items: center;
    inline-size: 2rem;
    block-size: 2rem;
    border: 1px solid;
    border-radius: 50%;
  }

  figure {
    margin: 0;
  }

  svg {
    display: block;
  }

  .panel :global(.track) {
    block-size: 0.6rem;
    border: 1px solid;
    background: var(--track);
  }

  .fill {
    block-size: 100%;
    background: currentColor;
  }

  .panel :global(.separator) {
    border-block-start: 1px solid;
    margin-block: 1.25rem;
  }

  .panel :global(.scroll-area) {
    overflow: hidden;
  }

  .panel :global(.viewport) {
    max-block-size: 6rem;
  }

  .panel :global(.viewport:focus-visible) {
    outline: 2px solid;
    outline-offset: -2px;
  }

  ol {
    margin: 0;
    padding: 0.25rem 1.25rem 0.25rem 1.6rem;
    overflow-wrap: anywhere;
  }

  li + li {
    margin-block-start: 0.4rem;
  }

  .panel :global(.scrollbar) {
    inline-size: 0.75rem;
    background: var(--track);
    touch-action: none;
    user-select: none;
  }

  .panel :global(.thumb) {
    inline-size: 100%;
    background: currentColor;
  }

  .panel :global(button[aria-disabled='true']) {
    color: GrayText;
  }
</style>
