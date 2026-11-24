<script lang="ts">
  import { CalendarDate, type DateValue } from '@internationalized/date';
  import { Calendar, DateField, DatePicker, type Month } from 'bits-ui';

  const locale = 'en-US';
  const deliveryDay = new CalendarDate(2026, 9, 14);
  const invoiceDay = new CalendarDate(2026, 9, 15);
  const appointmentDay = new CalendarDate(2026, 9, 16);
  let delivery = $state<DateValue | undefined>(deliveryDay);
  let invoice = $state<DateValue | undefined>(invoiceDay);
  let appointment = $state<DateValue | undefined>(appointmentDay);
  let pickerPanel = $state<HTMLElement | null>(null);
  let submitted = $state('No dates reviewed yet.');

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

<!-- DatePicker.Calendar supplies the same context as Calendar.Root to these parts. -->
{#snippet calendarGrid(months: Month<DateValue>[], weekdays: string[], label: string)}
  <Calendar.Header class="month-bar">
    <Calendar.PrevButton>Previous</Calendar.PrevButton>
    <Calendar.Heading />
    <Calendar.NextButton>Next</Calendar.NextButton>
  </Calendar.Header>
  {#each months as month (month.value.toString())}
    <Calendar.Grid aria-label={label}>
      <Calendar.GridHead>
        <Calendar.GridRow>
          {#each weekdays as day, column (column)}
            <Calendar.HeadCell>{day}</Calendar.HeadCell>
          {/each}
        </Calendar.GridRow>
      </Calendar.GridHead>
      <Calendar.GridBody>
        {#each month.weeks as week (week[0]?.toString())}
          <Calendar.GridRow>
            {#each week as date (date.toString())}
              <Calendar.Cell {date} month={month.value}>
                <Calendar.Day class="day">{date.day}</Calendar.Day>
              </Calendar.Cell>
            {/each}
          </Calendar.GridRow>
        {/each}
      </Calendar.GridBody>
    </Calendar.Grid>
  {/each}
{/snippet}

<div class="dates">
  <!-- Keep the grid visible when choosing a delivery day is the main task. -->
  <h2>Delivery schedule</h2>
  <Calendar.Root
    type="single"
    {locale}
    calendarLabel="Delivery calendar"
    weekdayFormat="short"
    placeholder={deliveryDay}
    bind:value={delivery}
  >
    {#snippet children({ months, weekdays })}
      {@render calendarGrid(months, weekdays, 'Delivery dates')}
    {/snippet}
  </Calendar.Root>
  <p><output>Delivery date: {delivery?.toString() ?? 'Not selected'}</output></p>

  <form onsubmit={(event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    submitted = `Invoice: ${data.get('invoice-date') || 'Not entered'}. Appointment: ${data.get('appointment-date') || 'Not entered'}.`;
  }}>
    <!-- A known invoice date can be typed without opening a calendar. -->
    <DateField.Root {locale} granularity="day" placeholder={invoiceDay} bind:value={invoice}>
      <DateField.Label>Invoice date</DateField.Label>
      <DateField.Input name="invoice-date" class="date-input">
        {#snippet children({ segments })}
          {#each segments as { part, value }, index (part + index)}
            <DateField.Segment {part}>{value}</DateField.Segment>
          {/each}
        {/snippet}
      </DateField.Input>
    </DateField.Root>

    <!-- For an appointment, allow either typing a date or browsing the month. -->
    <DatePicker.Root
      {locale}
      calendarLabel="Appointment calendar"
      weekdayFormat="short"
      granularity="day"
      placeholder={appointmentDay}
      bind:value={appointment}
    >
      <DatePicker.Label>Appointment date</DatePicker.Label>
      <DatePicker.Input name="appointment-date" class="date-input">
        {#snippet children({ segments })}
          {#each segments as { part, value }, index (part + index)}
            <DatePicker.Segment {part}>{value}</DatePicker.Segment>
          {/each}
          <DatePicker.Trigger>Open appointment calendar</DatePicker.Trigger>
        {/snippet}
      </DatePicker.Input>
      <DatePicker.Content
        bind:ref={pickerPanel}
        class="calendar-panel"
        sideOffset={6}
        aria-label="Choose an appointment date"
        onOpenAutoFocus={focusPickerDay}
      >
        <DatePicker.Calendar>
          {#snippet children({ months, weekdays })}
            {@render calendarGrid(months, weekdays, 'Appointment dates')}
          {/snippet}
        </DatePicker.Calendar>
      </DatePicker.Content>
    </DatePicker.Root>

    <button type="submit">Review dates</button>
    <p><output>{submitted}</output></p>
  </form>
</div>

<style>
  .dates :global(.month-bar) {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
    max-inline-size: 18rem;
  }

  .dates :global(.day) {
    display: grid;
    place-items: center;
    min-inline-size: 2rem;
    min-block-size: 2rem;
  }

  .dates :global(.day[data-disabled]) {
    opacity: 0.55;
  }

  .dates :global(.day[data-selected]) {
    background: Highlight;
    color: HighlightText;
    font-weight: bold;
  }

  .dates :global(.date-input) {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    margin-block: 0.25rem 0.75rem;
  }

  .dates :global(.date-input button) {
    margin-inline-start: 0.5rem;
  }

  .dates :global([data-segment]:focus-visible),
  .dates :global(.day:focus-visible) {
    outline: 2px solid CanvasText;
    outline-offset: 1px;
  }

  .dates :global(.calendar-panel) {
    z-index: 1;
    padding: 0.75rem;
    border: 1px solid CanvasText;
    background: Canvas;
    color: CanvasText;
  }
</style>
