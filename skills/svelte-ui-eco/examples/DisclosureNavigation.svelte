<script lang="ts">
  import { Accordion, Collapsible, NavigationMenu, Pagination, Tabs } from "bits-ui";

  const id = $props.id();
  const guideId = `${id}-reading-guide`;
  const reviewId = `${id}-review-brief`;
  const queueId = `${id}-reading-queue`;

  const records = [
    "Station access plan",
    "Bus stop inventory",
    "Evening service map",
    "Weekend ridership counts",
    "Passenger survey findings",
    "Draft accessibility notes",
  ];
</script>

<section aria-labelledby={`${id}-title`}>
  <h2 id={`${id}-title`}>Transit study reading workspace</h2>

  <NavigationMenu.Root aria-label="Reading workspace">
    <NavigationMenu.List>
      <NavigationMenu.Item value="review" openOnHover={false}>
        <NavigationMenu.Trigger>Study resources</NavigationMenu.Trigger>
        <NavigationMenu.Content>
          <ul>
            <li><NavigationMenu.Link href={`#${guideId}`}>Reading guide</NavigationMenu.Link></li>
            <li><NavigationMenu.Link href={`#${reviewId}`}>Review brief</NavigationMenu.Link></li>
          </ul>
        </NavigationMenu.Content>
      </NavigationMenu.Item>
      <NavigationMenu.Item value="queue">
        <NavigationMenu.Link href={`#${queueId}`}>Reading queue</NavigationMenu.Link>
      </NavigationMenu.Item>
    </NavigationMenu.List>
  </NavigationMenu.Root>

  <h3 id={guideId} tabindex="-1">Reading guide</h3>
  <Accordion.Root type="single" value="scope">
    <Accordion.Item value="scope">
      <Accordion.Header level={4}>
        <Accordion.Trigger>Study scope</Accordion.Trigger>
      </Accordion.Header>
      <Accordion.Content>
        <p>The study covers bus and rail connections within a ten-minute walk of Central Station.</p>
      </Accordion.Content>
    </Accordion.Item>
    <Accordion.Item value="evidence">
      <Accordion.Header level={4}>
        <Accordion.Trigger>Evidence to verify</Accordion.Trigger>
      </Accordion.Header>
      <Accordion.Content>
        <p>Check the published operating hours against the evening service map and flag mismatches.</p>
      </Accordion.Content>
    </Accordion.Item>
  </Accordion.Root>

  <Collapsible.Root>
    <Collapsible.Trigger>Editorial notes</Collapsible.Trigger>
    <Collapsible.Content>
      <p>Use stop names from the bus stop inventory and cite the source date for each count.</p>
    </Collapsible.Content>
  </Collapsible.Root>

  <h3 id={reviewId} tabindex="-1">Review brief</h3>
  <Tabs.Root value="summary">
    <Tabs.List aria-labelledby={reviewId}>
      <Tabs.Trigger value="summary" class="reading-view">Summary</Tabs.Trigger>
      <Tabs.Trigger value="checklist" class="reading-view">Review checklist</Tabs.Trigger>
    </Tabs.List>
    <Tabs.Content value="summary">
      <p>Compare step-free routes to the station and flag transfers that require crossing a busy street.</p>
    </Tabs.Content>
    <Tabs.Content value="checklist">
      <ul>
        <li>Verify lift operating hours.</li>
        <li>Check the walking route between the bus stop and the ticket hall.</li>
      </ul>
    </Tabs.Content>
  </Tabs.Root>

  <h3 id={queueId} tabindex="-1">Reading queue</h3>
  <Pagination.Root count={records.length} perPage={2}>
    {#snippet children({ pages, range, currentPage })}
      <p role="status">Showing records {range.start}–{range.end} of {records.length}.</p>
      <ol start={range.start}>
        {#each records.slice(range.start - 1, range.end) as record (record)}
          <li>{record}</li>
        {/each}
      </ol>
      <nav aria-label="Reading queue pages">
        <Pagination.PrevButton>Previous page</Pagination.PrevButton>
        {#each pages as page (page.key)}
          {#if page.type === "ellipsis"}
            <span aria-hidden="true">…</span>
          {:else}
            <Pagination.Page
              {page}
              aria-current={page.value === currentPage ? "page" : undefined}
              class="reading-page"
            >
              {page.value}
            </Pagination.Page>
          {/if}
        {/each}
        <Pagination.NextButton>Next page</Pagination.NextButton>
      </nav>
    {/snippet}
  </Pagination.Root>
</section>

<style>
  section :global(.reading-view[aria-selected="true"]),
  section :global(.reading-page[aria-current="page"]) {
    font-weight: bold;
    text-decoration: underline;
  }
</style>
