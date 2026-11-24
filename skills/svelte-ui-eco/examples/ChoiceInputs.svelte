<script lang="ts">
  import { Checkbox, Label, RadioGroup, Select, Switch } from "bits-ui";

  const id = $props.id();
  const frequencies = [
    { value: "daily", label: "Daily" },
    { value: "weekly", label: "Weekly" },
    { value: "monthly", label: "Monthly" },
  ];
  const defaults = { tips: false, channel: "email", frequency: "weekly", reminders: false };
  let tips = $state(defaults.tips);
  let channel = $state(defaults.channel);
  let frequency = $state(defaults.frequency);
  let reminders = $state(defaults.reminders);
  let submitted = $state("");

  function submit(event: SubmitEvent & { currentTarget: HTMLFormElement }) {
    event.preventDefault();
    submitted = JSON.stringify(Object.fromEntries(new FormData(event.currentTarget)));
  }

  function reset(event: Event) {
    // Reset the bound state, not just the inputs that mirror it.
    event.preventDefault();
    tips = defaults.tips;
    channel = defaults.channel;
    frequency = defaults.frequency;
    reminders = defaults.reminders;
    submitted = "";
  }
</script>

<form class="choices" onsubmit={submit} onreset={reset}>
  <fieldset>
    <legend>Notification preferences</legend>

    <div class="row">
      <Checkbox.Root id={`${id}-tips`} name="tips" value="yes" bind:checked={tips} class="check">
        <span aria-hidden="true">{tips ? "✓" : ""}</span>
      </Checkbox.Root>
      <Label.Root for={`${id}-tips`}>Send product tips</Label.Root>
    </div>

    <p id={`${id}-channel`}>Delivery channel</p>
    <RadioGroup.Root name="channel" aria-labelledby={`${id}-channel`} orientation="horizontal" bind:value={channel}>
      <RadioGroup.Item value="email" class="choice">Email</RadioGroup.Item>
      <RadioGroup.Item value="sms" class="choice">Text message</RadioGroup.Item>
    </RadioGroup.Root>

    <div class="row">
      <Label.Root for={`${id}-frequency`}>Digest frequency</Label.Root>
      <Select.Root type="single" name="frequency" items={frequencies} bind:value={frequency}>
        <Select.Trigger id={`${id}-frequency`} type="button">
          <Select.Value placeholder="Choose a frequency" /> <span aria-hidden="true">▾</span>
        </Select.Trigger>
        <Select.Portal>
          <Select.Content class="choice-example-popup" sideOffset={4} aria-label="Digest frequencies">
            <Select.Viewport>
              {#each frequencies as { value, label } (value)}
                <Select.Item {value} {label} class="choice-example-option">
                  {#snippet children({ selected })}
                    {label} <span aria-hidden="true">{selected ? "✓" : ""}</span>
                  {/snippet}
                </Select.Item>
              {/each}
            </Select.Viewport>
          </Select.Content>
        </Select.Portal>
      </Select.Root>
    </div>

    <div class="row">
      <Switch.Root id={`${id}-reminders`} name="reminders" value="yes" bind:checked={reminders} class="switch">
        <Switch.Thumb class="switch-thumb" aria-hidden="true" />
      </Switch.Root>
      <Label.Root for={`${id}-reminders`}>Enable reminders</Label.Root>
    </div>
  </fieldset>

  <p>Unchecked tips and reminders are omitted. Reset restores the defaults and clears the last submission.</p>
  <button type="submit">Inspect preferences</button>
  <button type="reset">Reset preferences</button>
  <p>Submitted form data: <output>{submitted || "No submission yet."}</output></p>
</form>

<style>
  .row {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .choices :global(.check) {
    inline-size: 1.5rem;
    block-size: 1.5rem;
  }

  .choices :global(.choice[data-state="checked"]) {
    background: Highlight;
    color: HighlightText;
    font-weight: bold;
  }

  .choices :global(.switch) {
    display: inline-flex;
    padding: 0.125rem;
    inline-size: 2.5rem;
    border: 1px solid currentColor;
    border-radius: 1rem;
  }

  .choices :global(.switch[data-state="checked"]) {
    justify-content: flex-end;
    background: Highlight;
    color: HighlightText;
  }

  .choices :global(.switch-thumb) {
    inline-size: 1rem;
    block-size: 1rem;
    border-radius: 50%;
    background: currentColor;
  }

  :global(.choice-example-popup) {
    z-index: 10;
    min-inline-size: var(--bits-select-anchor-width);
    max-block-size: var(--bits-select-content-available-height);
    padding: 0.25rem;
    border: 1px solid;
    background: Canvas;
    color: CanvasText;
  }

  :global(.choice-example-option) {
    padding: 0.375rem 0.5rem;
  }

  :global(.choice-example-option[data-highlighted]) {
    background: Highlight;
    color: HighlightText;
  }
</style>
