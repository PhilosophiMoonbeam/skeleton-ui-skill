<script lang="ts">
  import { CalendarDate, isSameDay, isWeekend, type DateValue } from '@internationalized/date';
  import { Calendar } from 'bits-ui';

  const id = $props.id();
  const locale = 'en-US';
  const initialDate = new CalendarDate(2027, 1, 13);
  const workshopClosure = new CalendarDate(2027, 1, 14);
  const dateFormat = new Intl.DateTimeFormat(locale, { dateStyle: 'full', timeZone: 'UTC' });
  let selectedDate = $state<DateValue | undefined>(initialDate);

  function isDateUnavailable(date: DateValue) {
    return isWeekend(date, locale) || isSameDay(date, workshopClosure);
  }

  const monthControl = 'btn-icon preset-filled-surface-200-800 size-11 border border-surface-600-400 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-success-800-200 motion-reduce:transition-none';
</script>

<!-- The host loads Tailwind, Skeleton core, and the Cerberus theme. -->
<section
  aria-labelledby={`${id}-title`}
  class="card mx-auto w-full max-w-md border border-surface-600-400 border-t-4 border-t-primary-800-200 bg-surface-50-950 px-3 py-4 text-surface-950-50 sm:px-5 sm:py-5"
>
  <header class="border-b border-surface-600-400 pb-4">
    <p class="text-xs font-semibold tracking-widest text-primary-800-200 uppercase">Northlight Studio · Print consultations</p>
    <h2 id={`${id}-title`} class="mt-2 font-serif text-2xl leading-tight tracking-tight sm:text-3xl">
      Choose an appointment day
    </h2>
    <p id={`${id}-availability`} class="mt-2 text-sm text-surface-700-300">
      The studio opens on weekdays. Crossed-out dates are unavailable.
    </p>
  </header>

  <Calendar.Root
    type="single"
    {locale}
    calendarLabel="Appointment availability"
    placeholder={initialDate}
    bind:value={selectedDate}
    {isDateUnavailable}
    weekStartsOn={1}
    weekdayFormat="short"
    disableDaysOutsideMonth
    fixedWeeks
    preventDeselect
    class="mt-3"
  >
    {#snippet children({ months, weekdays })}
      <Calendar.Header class="flex items-center justify-between gap-2">
        <Calendar.PrevButton class={monthControl}>
          {#snippet child({ props })}
            <button {...props} aria-label="Previous month">
              <svg aria-hidden="true" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m15 18-6-6 6-6" />
              </svg>
            </button>
          {/snippet}
        </Calendar.PrevButton>
        <Calendar.Heading class="text-center text-base font-semibold" />
        <Calendar.NextButton class={monthControl}>
          {#snippet child({ props })}
            <button {...props} aria-label="Next month">
              <svg aria-hidden="true" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m9 18 6-6-6-6" />
              </svg>
            </button>
          {/snippet}
        </Calendar.NextButton>
      </Calendar.Header>

      {#each months as month (month.value.toString())}
        <Calendar.Grid aria-describedby={`${id}-availability`} class="mt-2 w-full table-fixed border-separate border-spacing-1 text-center">
          <Calendar.GridHead>
            <Calendar.GridRow>
              {#each weekdays as weekday, column (column)}
                <Calendar.HeadCell class="pb-1 text-xs font-semibold text-surface-700-300">{weekday}</Calendar.HeadCell>
              {/each}
            </Calendar.GridRow>
          </Calendar.GridHead>
          <Calendar.GridBody>
            {#each month.weeks as week (week[0]?.toString())}
              <Calendar.GridRow>
                {#each week as date (date.toString())}
                  <Calendar.Cell {date} month={month.value} class="p-0">
                    <Calendar.Day
                      class={[
                        'relative grid h-10 w-full place-items-center rounded-base bg-surface-100-900 text-sm text-surface-950-50 tabular-nums',
                        'not-data-unavailable:not-data-disabled:not-data-selected:cursor-pointer not-data-unavailable:not-data-disabled:not-data-selected:hover:bg-surface-200-800',
                        'data-unavailable:cursor-not-allowed data-unavailable:text-surface-700-300 data-unavailable:line-through',
                        'data-disabled:bg-transparent data-disabled:text-surface-700-300 data-disabled:line-through',
                        'data-selected:not-data-disabled:preset-filled-primary-900-100 data-selected:not-data-disabled:font-bold',
                        'focus-visible:outline-2 focus-visible:outline-offset-1 focus-visible:outline-success-800-200'
                      ]}
                    >
                      {#snippet children({ day, selected, disabled })}
                        {day}
                        {#if selected && !disabled}
                          <svg class="absolute right-0.5 bottom-0.5 size-3" aria-hidden="true" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m2.5 6 2.3 2.3 4.7-4.7" />
                          </svg>
                        {/if}
                      {/snippet}
                    </Calendar.Day>
                  </Calendar.Cell>
                {/each}
              </Calendar.GridRow>
            {/each}
          </Calendar.GridBody>
        </Calendar.Grid>
      {/each}
    {/snippet}
  </Calendar.Root>

  <footer class="mt-3 border-t border-surface-600-400 pt-3">
    <output class="block">
      <span class="block text-xs font-semibold tracking-widest text-primary-800-200 uppercase">Selected day</span>
      {#if selectedDate}
        <time datetime={selectedDate.toString()} class="mt-1 block text-base font-semibold">
          {dateFormat.format(selectedDate.toDate('UTC'))}
        </time>
      {:else}
        <span class="mt-1 block text-base">None selected</span>
      {/if}
    </output>
    <p class="mt-1 text-sm text-surface-700-300">Sample availability only. No appointment is booked.</p>
  </footer>
</section>
