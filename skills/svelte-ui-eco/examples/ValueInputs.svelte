<script lang="ts">
  import { PinInput, RatingGroup, REGEXP_ONLY_DIGITS, Slider, Toggle, ToggleGroup } from "bits-ui";

  const id = $props.id();
  const pinLength = 4;
  const maxRating = 5;
  const minSize = 12;
  const maxSize = 28;

  let pin = $state("");
  let rating = $state(0);
  let size = $state(16);
  let showPreview = $state(true);
  let formats = $state<string[]>([]);

  function updateSize(event: Event & { currentTarget: HTMLInputElement }) {
    const input = event.currentTarget;
    if (input.validity.valid && !Number.isNaN(input.valueAsNumber)) size = input.valueAsNumber;
  }
</script>

<div class="values">
  <section>
    <h2>Practice PIN</h2>
    <label for={`${id}-pin`}>Four-digit practice PIN</label>
    <div>
      <PinInput.Root
        inputId={`${id}-pin`}
        maxlength={pinLength}
        pattern={REGEXP_ONLY_DIGITS}
        autocomplete="off"
        bind:value={pin}
        class="pin"
      >
        {#snippet children({ cells })}
          {#each cells as cell, index (index)}
            <PinInput.Cell {cell} class="cell" aria-hidden="true">
              {cell.char ?? ""}
              {#if cell.hasFakeCaret}<span class="caret"></span>{/if}
            </PinInput.Cell>
          {/each}
        {/snippet}
      </PinInput.Root>
    </div>
    <p>{pin.length} of {pinLength} digits entered. The practice PIN is not submitted.</p>
  </section>

  <section>
    <h2 id={`${id}-rating`}>Delivery rating</h2>
    <RatingGroup.Root
      aria-labelledby={`${id}-rating`}
      aria-valuetext={(value, max) => `${value} out of ${max} stars`}
      max={maxRating}
      hoverPreview={false}
      bind:value={rating}
      class="rating"
    >
      {#snippet children({ items })}
        {#each items as { index, state } (index)}
          <RatingGroup.Item {index} class="star">
            <span aria-hidden="true">{state === "active" ? "★" : "☆"}</span>
          </RatingGroup.Item>
        {/each}
      {/snippet}
    </RatingGroup.Root>
    <p>Selected rating: {rating} out of {maxRating} stars.</p>
  </section>

  <section>
    <h2>Text preview</h2>
    <p id={`${id}-size`}>Preview text size</p>
    <Slider.Root type="single" min={minSize} max={maxSize} step={1} trackPadding={10} bind:value={size} class="slider">
      <span class="track"><Slider.Range class="range" /></span>
      <Slider.Thumb index={0} aria-labelledby={`${id}-size`} aria-valuetext={`${size} pixels`} class="thumb" />
    </Slider.Root>
    <p>
      <label for={`${id}-pixels`}>Text size (pixels)</label>
      <input
        id={`${id}-pixels`}
        type="number"
        min={minSize}
        max={maxSize}
        step={1}
        value={size}
        oninput={updateSize}
        onblur={(event) => {
          const input = event.currentTarget;
          if (input.valueAsNumber !== size) input.value = String(size);
        }}
      />
    </p>
    <Toggle.Root bind:pressed={showPreview} aria-controls={`${id}-preview`} class="press">Show preview</Toggle.Root>
    <p id={`${id}-format`}>Text formatting</p>
    <ToggleGroup.Root type="multiple" bind:value={formats} aria-labelledby={`${id}-format`}>
      <ToggleGroup.Item value="bold" class="press">Bold</ToggleGroup.Item>
      <ToggleGroup.Item value="italic" class="press">Italic</ToggleGroup.Item>
      <ToggleGroup.Item value="underline" class="press">Underline</ToggleGroup.Item>
    </ToggleGroup.Root>
    <p
      id={`${id}-preview`}
      hidden={!showPreview}
      style:font-size={`${size}px`}
      class:bold={formats.includes("bold")}
      class:italic={formats.includes("italic")}
      class:underlined={formats.includes("underline")}
    >
      Your shipment is ready for pickup.
    </p>
  </section>
</div>

<style>
  .values :global(.pin),
  .values :global(.rating) {
    display: inline-flex;
    gap: 0.25rem;
  }

  .values :global(.cell) {
    display: grid;
    position: relative;
    place-items: center;
    inline-size: 2rem;
    block-size: 2.5rem;
    border: 1px solid;
  }

  .values :global(.pin:focus-within) {
    outline: 2px solid currentColor;
    outline-offset: 2px;
  }

  .values :global(.cell[data-active]) {
    outline: 2px solid currentColor;
    outline-offset: -2px;
  }

  .caret {
    inline-size: 1px;
    block-size: 1em;
    background: currentColor;
  }

  .values :global(.star) {
    padding: 0.25rem;
    font-size: 1.5rem;
    cursor: pointer;
  }

  .values :global(.slider) {
    display: flex;
    position: relative;
    align-items: center;
    max-inline-size: 18rem;
    block-size: 2rem;
    touch-action: none;
  }

  .track {
    position: relative;
    inline-size: 100%;
    block-size: 0.375rem;
    background: GrayText;
  }

  .values :global(.range) {
    block-size: 100%;
    background: Highlight;
  }

  .values :global(.thumb) {
    inline-size: 18px;
    block-size: 18px;
    border: 1px solid CanvasText;
    border-radius: 50%;
    background: Canvas;
  }

  .values :global(.press[data-state="on"]) {
    background: Highlight;
    color: HighlightText;
  }

  .bold { font-weight: bold; }
  .italic { font-style: italic; }
  .underlined { text-decoration: underline; }
</style>
