<script lang="ts">
  import { Collapsible, mergeProps } from 'bits-ui';

  const id = $props.id();
  const hintId = `${id}-delivery-hint`;
  let verified = $state(false);
  let open = $state(false);
  let message = $state('Confirm the recipient before opening delivery instructions.');

  function checkRecipient(event: MouseEvent | KeyboardEvent) {
    if (verified) return;
    event.preventDefault();
    message = 'Delivery instructions are locked until you confirm the recipient.';
  }

  function updateRecipient(event: Event & { currentTarget: HTMLInputElement }) {
    verified = event.currentTarget.checked;
    if (!verified) open = false;
    message = verified ? 'Delivery instructions are available.' : 'Recipient confirmation removed.';
  }

  const recipientGuard = {
    onclick: checkRecipient,
    onkeydown: (event: KeyboardEvent) => {
      // Leave Tab and unrelated keys alone.
      if (event.key === 'Enter' || event.key === ' ') checkRecipient(event);
    },
  };
</script>

<h2>Delivery instructions</h2>
<label>
  <input type="checkbox" checked={verified} onchange={updateRecipient} />
  I confirmed the recipient
</label>
<p id={hintId} role="status">{message}</p>

<Collapsible.Root bind:open>
  <Collapsible.Trigger id={`${id}-delivery-trigger`} aria-describedby={hintId}>
    {#snippet child({ props })}
      <!-- The guard runs first. A prevented event never reaches the Bits UI handler. -->
      <button {...mergeProps(recipientGuard, props)}>
        {open ? 'Hide delivery instructions' : 'Show delivery instructions'}
      </button>
    {/snippet}
  </Collapsible.Trigger>
  <Collapsible.Content id={`${id}-delivery-content`}>
    <p>Leave the parcel with the front desk and ask for a signed receipt.</p>
  </Collapsible.Content>
</Collapsible.Root>
