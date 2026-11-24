<script lang="ts">
  import { CalendarDate, type DateValue } from '@internationalized/date';
  import { DateRangeField, DateRangePicker, RangeCalendar, type DateRange, type Month } from 'bits-ui';

  const id = $props.id();
  const locale = 'en-US';
  const maintenanceDay = new CalendarDate(2026, 9, 8);
  const reportDay = new CalendarDate(2026, 9, 14);
  const checkInDay = new CalendarDate(2026, 9, 21);
  let maintenance = $state<DateRange>({ start: maintenanceDay, end: maintenanceDay.add({ days: 2 }) });
  let report = $state<DateRange>({ start: reportDay, end: reportDay.add({ days: 4 }) });
  let stay = $state<DateRange>({ start: checkInDay, end: checkInDay.add({ days: 3 }) });
  let pickerPanel = $state<HTMLElement | null>(null);
  let submitted = $state('No ranges reviewed yet.');

  function focusPickerDay(event: Event) {
    // Bits UI 2.22 searches the document by default. Limit focus to this picker.
    if (event.defaultPrevented) return;
    event.preventDefault();
    requestAnimationFrame(() => {
      const day = pickerPanel?.querySelector<HTMLElement>('[data-bits-day][tabindex="0"]');
      (day ?? pickerPanel)?.focus({ preventScroll: true });
    });
  }
</script>

<!-- DateRangePicker.Calendar supplies the same context as RangeCalendar.Root. -->
{#snippet calendarGrid(months: Month<DateValue>[], weekdays: string[], label: string)}
  <RangeCalendar.Header class="month-bar">
    <RangeCalendar.PrevButton>Previous</RangeCalendar.PrevButton>
    <RangeCalendar.Heading />
    <RangeCalendar.NextButton>Next</RangeCalendar.NextButton>
  </RangeCalendar.Header>
  {#each months as month (month.value.toString())}
    <RangeCalendar.Grid aria-label={label}>
      <RangeCalendar.GridHead>
        <RangeCalendar.GridRow>
          {#each weekdays as day, column (column)}
            <RangeCalendar.HeadCell>{day}</RangeCalendar.HeadCell>
          {/each}
        </RangeCalendar.GridRow>
      </RangeCalendar.GridHead>
      <RangeCalendar.GridBody>
        {#each month.weeks as week (week[0]?.toString())}
          <RangeCalendar.GridRow>
            {#each week as date (date.toString())}
              <RangeCalendar.Cell {date} month={month.value}>
                <RangeCalendar.Day class="day">{date.day}</RangeCalendar.Day>
              </RangeCalendar.Cell>
            {/each}
          </RangeCalendar.GridRow>
        {/each}
      </RangeCalendar.GridBody>
    </RangeCalendar.Grid>
  {/each}
{/snippet}

<!-- Both range components use the same Input and Segment implementations. -->
{#snippet endpoint(Input: typeof DateRangeField.Input, type: 'start' | 'end', name: string, label: string)}
  {@const labelId = `${id}-${name}`}
  <div>
    <span id={labelId}>{label}</span>
    <Input {type} {name} class="date-input">
      {#snippet children({ segments })}
        {#each segments as { part, value }, index (part + index)}
          <DateRangeField.Segment {part}>
            {#snippet child({ props })}
              <!-- Keep Bits' segment name and identify its start or end field. -->
              <span {...props} aria-labelledby={part === 'literal' ? undefined : `${props.id} ${labelId}`}>
                {value}
              </span>
            {/snippet}
          </DateRangeField.Segment>
        {/each}
      {/snippet}
    </Input>
  </div>
{/snippet}

<div class="date-ranges">
  <!-- A persistent calendar lets operators see the full maintenance window. -->
  <h2>Maintenance window</h2>
  <p>Choose the first and last maintenance days. Use the arrow keys to move and Enter to select.</p>
  <RangeCalendar.Root
    {locale}
    calendarLabel="Maintenance calendar"
    weekdayFormat="short"
    placeholder={maintenanceDay}
    bind:value={maintenance}
  >
    {#snippet children({ months, weekdays })}
      {@render calendarGrid(months, weekdays, 'Maintenance dates')}
    {/snippet}
  </RangeCalendar.Root>
  <p>
    <output>
      Maintenance start: {maintenance?.start?.toString() ?? 'Not selected'};
      end: {maintenance?.end?.toString() ?? 'Not selected'}
    </output>
  </p>

  <form onsubmit={(event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const value = (name: string) => data.get(name) || 'Not entered';
    submitted = `Report: ${value('report-start')} to ${value('report-end')}. Stay: ${value('stay-start')} to ${value('stay-end')}.`;
  }}>
    <!-- Use segments alone when the reporting period is already known. -->
    <DateRangeField.Root {locale} granularity="day" placeholder={reportDay} bind:value={report}>
      <DateRangeField.Label>Reporting dates</DateRangeField.Label>
      <div class="endpoints">
        {@render endpoint(DateRangeField.Input, 'start', 'report-start', 'Report start date')}
        {@render endpoint(DateRangeField.Input, 'end', 'report-end', 'Report end date')}
      </div>
    </DateRangeField.Root>

    <!-- Offer a floating calendar when guests may need to browse before choosing. -->
    <DateRangePicker.Root
      {locale}
      calendarLabel="Hotel stay calendar"
      weekdayFormat="short"
      granularity="day"
      placeholder={checkInDay}
      bind:value={stay}
    >
      <DateRangePicker.Label>Hotel stay dates</DateRangePicker.Label>
      <div class="endpoints">
        {@render endpoint(DateRangePicker.Input, 'start', 'stay-start', 'Stay check-in date')}
        {@render endpoint(DateRangePicker.Input, 'end', 'stay-end', 'Stay check-out date')}
        <DateRangePicker.Trigger>Open stay calendar</DateRangePicker.Trigger>
      </div>
      <DateRangePicker.Content
        bind:ref={pickerPanel}
        class="calendar-panel"
        sideOffset={6}
        aria-label="Choose hotel stay dates"
        onOpenAutoFocus={focusPickerDay}
      >
        <DateRangePicker.Calendar>
          {#snippet children({ months, weekdays })}
            {@render calendarGrid(months, weekdays, 'Stay dates')}
          {/snippet}
        </DateRangePicker.Calendar>
      </DateRangePicker.Content>
    </DateRangePicker.Root>

    <button type="submit">Review ranges</button>
    <p><output>{submitted}</output></p>
  </form>
</div>

<style>
  .date-ranges :global(.month-bar) {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
    max-inline-size: 18rem;
  }

  .date-ranges :global(.day) {
    display: grid;
    place-items: center;
    min-inline-size: 2rem;
    min-block-size: 2rem;
  }

  .date-ranges :global(.day[data-disabled]) {
    opacity: 0.55;
  }

  .date-ranges :global(.day[data-selected]),
  .date-ranges :global(.day[data-highlighted]) {
    background: color-mix(in srgb, Highlight 20%, Canvas);
  }

  .date-ranges :global(.day[data-selection-start]),
  .date-ranges :global(.day[data-selection-end]) {
    background: Highlight;
    color: HighlightText;
    font-weight: bold;
  }

  .endpoints {
    display: flex;
    flex-wrap: wrap;
    align-items: end;
    gap: 0.75rem;
    margin-block: 0.25rem 0.75rem;
  }

  .date-ranges :global(.date-input) {
    display: flex;
  }

  .date-ranges :global([data-segment]:focus-visible),
  .date-ranges :global(.day:focus-visible) {
    outline: 2px solid CanvasText;
    outline-offset: 1px;
  }

  .date-ranges :global(.calendar-panel) {
    z-index: 1;
    padding: 0.75rem;
    border: 1px solid CanvasText;
    background: Canvas;
    color: CanvasText;
  }
</style>
