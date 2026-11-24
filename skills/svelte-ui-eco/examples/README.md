# Run the Svelte examples

Use the [Bits UI catalog](../references/components.md) to find an example for a primitive. Each `.svelte` file is a standalone component, not a complete application or a server integration.

## Install and mount

Use an existing Svelte 5 app. The checked examples target Svelte **5.59.1**. All examples except [ResponsiveShell.svelte](ResponsiveShell.svelte) and [NativeForm.svelte](NativeForm.svelte) use Bits UI **2.22.0**. With Bun **1.4.5**, run `bun add --exact bits-ui@2.22.0` for those examples. If the app imports `@internationalized/date` (as `Dates.svelte`, `DateRanges.svelte`, and `Times.svelte` do), declare it directly with `bun add --exact @internationalized/date@3.12.4`. See [setup](../references/setup.md).

Copy `ChoiceInputs.svelte` into your app. Mount it from `src/App.svelte` in a standalone app, or from `src/routes/+page.svelte` in SvelteKit. This snippet assumes the example is beside the mounting file; adjust the import path if you put it elsewhere.

```svelte
<script lang="ts">
  import ChoiceInputs from './ChoiceInputs.svelte';
</script>

<ChoiceInputs />
```

Start the app with its usual development script (typically `bun run dev`). Use Tab and the relevant arrow, Enter, Space, and Escape keys as well as pointer input. For form examples, submit, change values, reset, and submit again to inspect the payload; local form output does not save anything remotely.

For existing Skeleton apps, use the separate [Skeleton recipes](../references/skeleton-recipes.md). For optional icon examples, see [Lucide patterns](../references/lucide-patterns.md). Neither dependency is required by the standalone `.svelte` files here.

## Troubleshoot

- **Module or prop errors:** check the package versions in the app's lockfile and compare the code with the installed declarations before copying from rolling docs.
- **Unstyled controls:** Bits UI is headless. The examples include only the CSS they need; app-wide resets can change the appearance or erase focus outlines. Restore visible focus and check the [styling reference](../references/styling.md).
- **Hidden or clipped floating content:** interact with the trigger after hydration, then inspect the portal target and the app's overflow and stacking styles. Keep the component's positioning properties intact.
- **Unexpected payload or reset:** inspect `FormData`, including repeated names and omitted values. Keep generated inputs or manual inputs, not both for the same field. See the [form recipe](../references/recipes.md).
