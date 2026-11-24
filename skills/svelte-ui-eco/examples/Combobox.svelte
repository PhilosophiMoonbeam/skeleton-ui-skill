<script lang="ts">
  import { Combobox } from "bits-ui";

  const id = $props.id();
  const warehouses = [
    { value: "den-01", label: "Denver" },
    { value: "pdx-01", label: "Portland" },
    { value: "phx-01", label: "Phoenix" },
    { value: "sea-01", label: "Seattle" },
  ];
  let value = $state("");
  let query = $state("");
  let open = $state(false);
  let input = $state<HTMLInputElement | null>(null);
  let submitted = $state("");

  const selectedLabel = $derived(warehouses.find((warehouse) => warehouse.value === value)?.label);
  const matches = $derived.by(() => {
    const filter = query.trim().toLowerCase();
    return filter ? warehouses.filter((warehouse) => warehouse.label.toLowerCase().includes(filter)) : warehouses;
  });

  function search(event: Event & { currentTarget: HTMLInputElement }) {
    query = event.currentTarget.value;
    value = "";
    open = true;
  }

  function clear() {
    value = "";
    query = "";
    submitted = "";
    input?.focus();
    open = true;
  }

  function submit(event: SubmitEvent & { currentTarget: HTMLFormElement }) {
    event.preventDefault();
    submitted = String(new FormData(event.currentTarget).get("warehouse") ?? "");
  }
</script>

<form onsubmit={submit}>
  <p id={`${id}-help`}>Type to filter. Use the arrow keys and Enter to choose a warehouse.</p>
  <label for={`${id}-warehouse`}>Pickup warehouse</label>
  <Combobox.Root
    type="single"
    name="warehouse"
    required
    items={warehouses}
    allowDeselect={false}
    inputValue={selectedLabel ?? query}
    bind:value
    bind:open
    onValueChange={() => (query = "")}
  >
    <Combobox.Input
      id={`${id}-warehouse`}
      bind:ref={input}
      aria-describedby={`${id}-help`}
      aria-required="true"
      autocomplete="off"
      placeholder="Search by city"
      oninput={search}
    />
    <Combobox.Trigger type="button" aria-label="Browse warehouses">▾</Combobox.Trigger>
    <Combobox.Portal>
      <Combobox.Content class="warehouse-example-popup" sideOffset={4} aria-label="Pickup warehouses">
        <Combobox.Viewport>
          {#each matches as { value: warehouseValue, label } (warehouseValue)}
            <Combobox.Item value={warehouseValue} {label} class="warehouse-example-option">
              {#snippet children({ selected })}
                {label} <span aria-hidden="true">{selected ? "✓" : ""}</span>
              {/snippet}
            </Combobox.Item>
          {:else}
            <div class="empty" role="status">No warehouses match.</div>
          {/each}
        </Combobox.Viewport>
      </Combobox.Content>
    </Combobox.Portal>
  </Combobox.Root>
  <button type="button" onclick={clear}>Clear warehouse</button>

  <p>Selected warehouse: {selectedLabel ?? "None"}</p>
  <button type="submit">Inspect pickup choice</button>
  <p>Submitted warehouse ID: <output>{submitted || "No submission yet."}</output></p>
</form>

<style>
  :global(.warehouse-example-popup) {
    z-index: 10;
    min-inline-size: var(--bits-combobox-anchor-width);
    max-block-size: var(--bits-combobox-content-available-height);
    padding: 0.25rem;
    border: 1px solid;
    background: Canvas;
    color: CanvasText;
  }

  .empty,
  :global(.warehouse-example-option) {
    padding: 0.375rem 0.5rem;
  }

  :global(.warehouse-example-option[data-highlighted]) {
    background: Highlight;
    color: HighlightText;
  }
</style>
