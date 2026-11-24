<script lang="ts">
  import { Time } from '@internationalized/date';
  import { TimeField, TimeRangeField, type TimeRange } from 'bits-ui';

  const id = $props.id();
  const locale = 'en-US';
  const appointmentTime = new Time(15, 30);
  const openingTime = new Time(9, 0);
  let appointment = $state<Time | undefined>(appointmentTime);
  let hours = $state<TimeRange<Time>>({ start: openingTime, end: new Time(17, 30) });
  let submitted = $state('No times reviewed yet.');

  const endpoints = [
    { type: 'start', name: 'opens-at', label: 'Office opening time' },
    { type: 'end', name: 'closes-at', label: 'Office closing time' }
  ] as const;
</script>

<form class="times" onsubmit={(event) => {
  event.preventDefault();
  const data = new FormData(event.currentTarget);
  const value = (name: string) => data.get(name) || 'Not entered';
  submitted = `Appointment: ${value('appointment-time')}. Office hours: ${value('opens-at')} to ${value('closes-at')}.`;
}}>
  <h2>Set local times</h2>
  <p>These times have no date or time zone. Use the arrow keys to adjust each segment.</p>

  <!-- A 12-hour field exposes an editable AM/PM segment for the appointment. -->
  <TimeField.Root {locale} hourCycle={12} granularity="minute" placeholder={appointmentTime} bind:value={appointment}>
    <TimeField.Label>Appointment time</TimeField.Label>
    <TimeField.Input name="appointment-time" class="time-input">
      {#snippet children({ segments })}
        {#each segments as { part, value }, index (part + index)}
          <TimeField.Segment {part}>{value}</TimeField.Segment>
        {/each}
      {/snippet}
    </TimeField.Input>
  </TimeField.Root>

  <!-- A same-day business schedule needs separately named opening and closing times. -->
  <TimeRangeField.Root {locale} hourCycle={24} granularity="minute" placeholder={openingTime} bind:value={hours}>
    <TimeRangeField.Label>Office hours</TimeRangeField.Label>
    <div class="endpoints">
      {#each endpoints as { type, name, label } (type)}
        {@const labelId = `${id}-${type}`}
        <div>
          <span id={labelId}>{label}</span>
          <TimeRangeField.Input {type} {name} class="time-input">
            {#snippet children({ segments })}
              {#each segments as { part, value }, index (part + index)}
                <TimeRangeField.Segment {part}>
                  {#snippet child({ props })}
                    <!-- Keep Bits' segment name and identify its start or end field. -->
                    <span {...props} aria-labelledby={part === 'literal' ? undefined : `${props.id} ${labelId}`}>
                      {value}
                    </span>
                  {/snippet}
                </TimeRangeField.Segment>
              {/each}
            {/snippet}
          </TimeRangeField.Input>
        </div>
      {/each}
    </div>
  </TimeRangeField.Root>

  <button type="submit">Review times</button>
  <p><output>{submitted}</output></p>
</form>

<style>
  .times :global(.time-input) {
    display: flex;
    white-space: pre;
    margin-block: 0.25rem 0.75rem;
  }

  .endpoints {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
  }

  .times :global([data-segment]:focus-visible) {
    outline: 2px solid CanvasText;
    outline-offset: 1px;
  }
</style>
