# Choose a Bits UI component

Start with native HTML. Choose Bits UI when the interaction calls for more than native controls provide. Each component below links to its official Markdown documentation and a runnable Svelte 5 example. Check the installed declarations before applying rolling docs to a pinned version. See [Bits UI usage](bits-ui.md), the [examples guide](../examples/README.md), and the [official docs index](https://www.bits-ui.com/llms.txt).

## Navigation and disclosure

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Accordion](https://www.bits-ui.com/docs/components/accordion/llms.txt) | Group related expandable sections under headings; use Collapsible for one independent section. | [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte) |
| [Collapsible](https://www.bits-ui.com/docs/components/collapsible/llms.txt) | Control one disclosure from app state; prefer `<details>` for a simple self-contained disclosure. | [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte) |
| [Navigation Menu](https://www.bits-ui.com/docs/components/navigation-menu/llms.txt) | Reveal groups of destination links; prefer `<nav>` and anchors for flat site navigation, not Menubar. | [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte) |
| [Pagination](https://www.bits-ui.com/docs/components/pagination/llms.txt) | Move through numbered pages; the app fetches or slices results. Use real links for shareable page URLs. | [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte) |
| [Tabs](https://www.bits-ui.com/docs/components/tabs/llms.txt) | Switch between local panels; use links for routes and Accordion for sections users may read together. | [DisclosureNavigation.svelte](../examples/DisclosureNavigation.svelte) |

## Commands and menus

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Command](https://www.bits-ui.com/docs/components/command/llms.txt) | Search and run commands or jump to destinations; use Combobox to edit a field's selection. | [Menus.svelte](../examples/Menus.svelte) |
| [Context Menu](https://www.bits-ui.com/docs/components/context-menu/llms.txt) | Offer actions for a particular target; provide a visible keyboard- and touch-accessible way to reach the same actions. | [Menus.svelte](../examples/Menus.svelte) |
| [Dropdown Menu](https://www.bits-ui.com/docs/components/dropdown-menu/llms.txt) | Open actions from a visible trigger; use Select for a field whose value stays selected. | [Menus.svelte](../examples/Menus.svelte) |
| [Menubar](https://www.bits-ui.com/docs/components/menubar/llms.txt) | Provide persistent application menus such as File and Edit; do not use it for site navigation. | [Menus.svelte](../examples/Menus.svelte) |
| [Toolbar](https://www.bits-ui.com/docs/components/toolbar/llms.txt) | Group related controls such as editor tools with arrow-key navigation; keep a few unrelated buttons in normal tab order. | [Menus.svelte](../examples/Menus.svelte) |

## Overlays

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Alert Dialog](https://www.bits-ui.com/docs/components/alert-dialog/llms.txt) | Interrupt for a consequential decision; use inline feedback for ordinary success or errors. | [Overlays.svelte](../examples/Overlays.svelte) |
| [Dialog](https://www.bits-ui.com/docs/components/dialog/llms.txt) | Present a named modal task; use native `<dialog>` when its behavior is sufficient or Popover when the surrounding UI should remain usable. | [Overlays.svelte](../examples/Overlays.svelte) |
| [Link Preview](https://www.bits-ui.com/docs/components/link-preview/llms.txt) | Preview a real link's destination; make it supplementary, never the only source of information. | [Overlays.svelte](../examples/Overlays.svelte) |
| [Popover](https://www.bits-ui.com/docs/components/popover/llms.txt) | Open a contextual surface with controls; use Tooltip for short, noninteractive hints. | [Overlays.svelte](../examples/Overlays.svelte) |
| [Tooltip](https://www.bits-ui.com/docs/components/tooltip/llms.txt) | Supplement a named trigger with short hover/focus help; keep essential instructions visible and interactive content out. | [Overlays.svelte](../examples/Overlays.svelte) |

## Form controls and selection

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Checkbox](https://www.bits-ui.com/docs/components/checkbox/llms.txt) | Select independent options or indicate a mixed selection; prefer native checkboxes for straightforward forms. | [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) |
| [Label](https://www.bits-ui.com/docs/components/label/llms.txt) | Associate visible text with a composed control's labelable element; use native `<label>` for ordinary inputs. | [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) |
| [Radio Group](https://www.bits-ui.com/docs/components/radio-group/llms.txt) | Expose mutually exclusive options together; use Select when a long list would take too much space. | [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) |
| [Select](https://www.bits-ui.com/docs/components/select/llms.txt) | Choose from a closed list without editing a query; prefer native `<select>` where it meets the requirements. | [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) |
| [Switch](https://www.bits-ui.com/docs/components/switch/llms.txt) | Toggle an on/off setting; use Checkbox for checklist membership or consent. | [ChoiceInputs.svelte](../examples/ChoiceInputs.svelte) |
| [Combobox](https://www.bits-ui.com/docs/components/combobox/llms.txt) | Filter options by typing while retaining a distinct selected value; use Select when there is no editable query. | [Combobox.svelte](../examples/Combobox.svelte) |
| [Pin Input](https://www.bits-ui.com/docs/components/pin-input/llms.txt) | Accept a short fixed-length code with segmented entry; use one text field for arbitrary text and preserve leading zeros. | [ValueInputs.svelte](../examples/ValueInputs.svelte) |
| [Rating Group](https://www.bits-ui.com/docs/components/rating-group/llms.txt) | Capture a discrete ordered score; present an existing score as readable text when no input is needed. | [ValueInputs.svelte](../examples/ValueInputs.svelte) |
| [Slider](https://www.bits-ui.com/docs/components/slider/llms.txt) | Adjust a bounded number or interval; use numeric input for exact entry or native range for a simple single thumb. | [ValueInputs.svelte](../examples/ValueInputs.svelte) |
| [Toggle](https://www.bits-ui.com/docs/components/toggle/llms.txt) | Represent one pressed tool or mode such as Bold; use a normal button for a one-shot command. | [ValueInputs.svelte](../examples/ValueInputs.svelte) |
| [Toggle Group](https://www.bits-ui.com/docs/components/toggle-group/llms.txt) | Group related pressed tools or modes; use Radio Group for mutually exclusive form choices. | [ValueInputs.svelte](../examples/ValueInputs.svelte) |

## Date and time

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Calendar](https://www.bits-ui.com/docs/components/calendar/llms.txt) | Keep a date selection grid visible; use Date Picker to open the grid on demand. | [Dates.svelte](../examples/Dates.svelte) |
| [Date Field](https://www.bits-ui.com/docs/components/date-field/llms.txt) | Edit date segments without a popup; prefer native date input if platform presentation is sufficient. | [Dates.svelte](../examples/Dates.svelte) |
| [Date Picker](https://www.bits-ui.com/docs/components/date-picker/llms.txt) | Combine single-date entry with an on-demand calendar; use Date Range Picker for two related dates. | [Dates.svelte](../examples/Dates.svelte) |
| [Date Range Field](https://www.bits-ui.com/docs/components/date-range-field/llms.txt) | Edit paired date segments without a calendar; use separate Date Fields for unrelated dates. | [DateRanges.svelte](../examples/DateRanges.svelte) |
| [Date Range Picker](https://www.bits-ui.com/docs/components/date-range-picker/llms.txt) | Combine start/end entry with an on-demand range calendar; use Date Range Field when users only need text entry. | [DateRanges.svelte](../examples/DateRanges.svelte) |
| [Range Calendar](https://www.bits-ui.com/docs/components/range-calendar/llms.txt) | Let users see and select an interval in an always-visible calendar; use Calendar if there is no second endpoint. | [DateRanges.svelte](../examples/DateRanges.svelte) |
| [Time Field](https://www.bits-ui.com/docs/components/time-field/llms.txt) | Edit one time of day as segments; use native time input when its platform behavior is sufficient. | [Times.svelte](../examples/Times.svelte) |
| [Time Range Field](https://www.bits-ui.com/docs/components/time-range-field/llms.txt) | Edit connected start/end times; define overnight policy separately and use independent fields for unrelated times. | [Times.svelte](../examples/Times.svelte) |

## Display and layout

| Component docs | Choose it when / use something else when | Example |
| --- | --- | --- |
| [Aspect Ratio](https://www.bits-ui.com/docs/components/aspect-ratio/llms.txt) | Compose fixed-proportion media with component anatomy; use CSS `aspect-ratio` for a plain wrapper. | [Display.svelte](../examples/Display.svelte) |
| [Avatar](https://www.bits-ui.com/docs/components/avatar/llms.txt) | Render a profile image with a loading/error fallback; use an ordinary `<img>` when no fallback is needed. | [Display.svelte](../examples/Display.svelte) |
| [Button](https://www.bits-ui.com/docs/components/button/llms.txt) | Compose a common action control with a Bits child snippet; use a native button for simple actions and an anchor for navigation. | [Display.svelte](../examples/Display.svelte) |
| [Meter](https://www.bits-ui.com/docs/components/meter/llms.txt) | Show a measurement such as disk usage within a known range; use Progress for completion of a task. | [Display.svelte](../examples/Display.svelte) |
| [Progress](https://www.bits-ui.com/docs/components/progress/llms.txt) | Show task completion or an indeterminate operation; use native `<progress>` if it meets presentation needs. | [Display.svelte](../examples/Display.svelte) |
| [Scroll Area](https://www.bits-ui.com/docs/components/scroll-area/llms.txt) | Customize scrollbars while preserving scroll behavior; start with native `overflow: auto`. | [Display.svelte](../examples/Display.svelte) |
| [Separator](https://www.bits-ui.com/docs/components/separator/llms.txt) | Divide items within a composite or indicate a semantic boundary; use CSS for decoration or `<hr>` for a thematic break. | [Display.svelte](../examples/Display.svelte) |

## Composition and missing primitives

- [Composition.svelte](../examples/Composition.svelte) covers cross-cutting patterns. Consult the official [child snippet](https://www.bits-ui.com/docs/child-snippet/llms.txt), [state management](https://www.bits-ui.com/docs/state-management/llms.txt), and [Portal](https://www.bits-ui.com/docs/utilities/portal/llms.txt) pages before customizing anatomy.
- **Notification or status:** use persistent inline feedback when it fits. Use an existing `role="status"` region for polite updates and `role="alert"` only for urgent updates. If transient notifications are required, [Skeleton Toast](skeleton.md) is an option; keep important feedback available after dismissal.
- **Drawer:** style Dialog as a side sheet for a modal task. For persistent navigation, use a landmarks-and-links layout instead of modal focus trapping.
- **Stepper, carousel, file upload, or tags:** use a simple native pattern when sufficient. When managed interaction is required, see the [Skeleton components](skeleton.md) that cover these gaps. A file picker is not a server upload, and a step indicator is not a routing or validation engine.
- **Tables:** use semantic `<table>` for data. Do not infer interactive grid behavior from styling.
