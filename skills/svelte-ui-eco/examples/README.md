# Run the Svelte examples

These are mountable Svelte components, not full apps or server integrations. Demo styling illustrates the task; it is not the default appearance of Svelte or its component libraries.

| Purpose | Example | Dependencies beyond Svelte |
| --- | --- | --- |
| Learn a primitive's interaction and markup | [Bits UI component catalog](../references/components.md), e.g. [ChoiceInputs.svelte](ChoiceInputs.svelte) | Bits UI; `@internationalized/date` for date/time examples. No styling framework. |
| Study a completed responsive page shell | [ResponsiveShell.svelte](ResponsiveShell.svelte), the Fieldnotes project browser | None. Native disclosure, links, and form controls with scoped CSS. |
| Practice native form validation and recovery | [NativeForm.svelte](NativeForm.svelte), a local profile preview | None. Native inputs with local feedback and scoped CSS. |
| Study an optional designed hybrid widget | [ThemedCalendar.svelte](ThemedCalendar.svelte), the Northlight appointment calendar | Tailwind 4, Skeleton core, Bits UI 2.22, and `@internationalized/date`. No Skeleton Svelte. Bits owns grid navigation and selection; the theme and app classes supply the visual treatment. |

## Install and mount

Use an existing Svelte 5 app. The examples target Svelte **5.59.1**; see [setup](../references/setup.md) for the app and dependency baseline. Skip all extra packages for the responsive shell and native form.

- For the Bits examples, including `ThemedCalendar.svelte`, install with `bun add --exact bits-ui@2.22.0` on the Bun **1.4.5** baseline. For `Dates.svelte`, `DateRanges.svelte`, `Times.svelte`, and `ThemedCalendar.svelte`, install their direct import as well: `bun add --exact @internationalized/date@3.12.4`.
- For the themed calendar, follow [Tailwind and Skeleton core setup](../references/setup.md#global-css-and-dependency-scanning), load the global stylesheet, and activate `data-theme="cerberus"` on `<html>`. The day grid uses the current light or dark color scheme. Do not add the Skeleton Svelte package or its CSS for this example.

Copy the component into your app. Mount it from `src/App.svelte` in a standalone app, or from `src/routes/+page.svelte` in SvelteKit. This snippet assumes the example is beside the mounting file; change the component name and import path to match. The responsive shell supplies its own `main` landmark, so mount it outside any existing `main`.

```svelte
<script lang="ts">
  import ChoiceInputs from './ChoiceInputs.svelte';
</script>

<ChoiceInputs />
```

Start the app with its usual development script (typically `bun run dev`).

## What to check

- **Primitives:** use Tab and the relevant arrows, Enter, Space, and Escape keys as well as pointer input. For form examples, submit, change values, reset, and submit again to inspect the payload; local form output does not save anything remotely.
- **Fieldnotes shell:** at a narrow width, open **Page navigation** with the keyboard and follow a section link. Apply the `harbor` filter for one brief, then use a no-match query and check that clearing filters restores four briefs and focuses search. See the [full shell checks](../references/design.md#acceptance-and-smoke-expectations).
- **Native form:** submit empty to check summary focus and error links. Submit valid values for a local preview, then reset and check output and returned focus. See the [native form checks](../references/accessibility.md#standalone-native-form).
- **Themed calendar:** check the initial January 13 selection, try the unavailable January 14, then move to January 15 with the keyboard and select it. Check that the date readout updates only for an available selection. Browse with **Previous month** and **Next month**. Check that focus, selected, and unavailable dates stay distinguishable without relying on hue alone.

Review the actual rendered examples at narrow widths and enlarged text, with reduced motion and forced colors. Check keyboard focus visibility and measure the foreground, controls, and state contrast in the modes you ship. These checks are not a claim that a theme or example guarantees accessibility.

For Skeleton's own styled widgets, use the separate [Skeleton recipes](../references/skeleton-recipes.md). For optional icons, see [Lucide patterns](../references/lucide-patterns.md); none of these examples requires an icon package.

## Troubleshoot

- **Module or prop errors:** check the package versions in the app's lockfile and compare the code with the installed declarations before copying from rolling docs.
- **Unstyled controls:** Bits UI is headless. The examples include only the CSS they need; app-wide resets can change the appearance or erase focus outlines. Restore visible focus and check the [styling reference](../references/styling.md).
- **Hidden or clipped floating content:** interact with the trigger after hydration, then inspect the portal target and the app's overflow and stacking styles. Keep the component's positioning properties intact.
- **Unexpected payload or reset:** inspect `FormData`, including repeated names and omitted values. Keep generated inputs or manual inputs, not both for the same field. See the [form recipe](../references/recipes.md).
