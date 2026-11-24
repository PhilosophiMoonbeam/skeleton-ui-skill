# Visual design and responsive composition

Start with the existing visual system. Plain CSS, Tailwind, and optional Skeleton tokens establish appearance; native HTML and [Bits UI](bits-ui.md) establish interaction. Use [accessibility.md](accessibility.md) to verify both.

- [Write a visual brief before markup](#write-a-visual-brief-before-markup)
- [Establish a small visual system](#establish-a-small-visual-system)
- [Compose from narrow to wide](#compose-from-narrow-to-wide)
- [Content, states, and visual assets](#content-states-and-visual-assets)
- [Purposeful feedback and motion](#purposeful-feedback-and-motion)
- [Performance and browser constraints](#performance-and-browser-constraints)
- [Responsive page shell](#responsive-page-shell)
- [Acceptance and smoke expectations](#acceptance-and-smoke-expectations)

## Write a visual brief before markup

Capture the audience, their primary task, content type, and desired tone in two sentences. Choose one distinguishing device: an editorial heading, a disciplined dense list, a useful illustration, or a distinctive navigation rail. Use it consistently, not all at once.

Example brief: “A small community design studio needs to find and review project briefs. Use calm neutral surfaces, one blue accent, editorial headings, and generous space around compact, factual project cards.” This differs from a generic analytics dashboard without inventing metrics, charts, or a decorative hero unrelated to the task.

Adapt the existing app before introducing a new look: retain its active theme, fonts, spacing rhythm, navigation conventions, and component shapes unless the brief requires a change. If using Skeleton CSS in a new app, start with one bundled theme and calibrate it. A visual refresh is not a dependency migration.

## Establish a small visual system

| Decision | Recommended starting point | Avoid |
| --- | --- | --- |
| Palette | Neutral canvas and containers with one accent. Reserve status colors for labeled status. With Skeleton, start with `surface` pairings and an intentional `primary` or brand preset. | Every card in a different brand color; gradients behind body text; translucent surfaces with unmeasured contrast. |
| Type | One loaded or system font family; clear page title, section heading, body, and metadata roles. Use weight and spacing as well as size. Keep prose around 45–75 characters per line. | A wall of equally bold labels; tiny low-contrast metadata; all-uppercase paragraphs; fonts that were named but not loaded. |
| Spacing | Use a repeated vocabulary, for example `gap-2`, `gap-4`, `gap-6`, `p-4`, `p-6`. Section gaps should exceed the gaps within their content. | A different offset for every element; changing global `--spacing` to fix one crowded control. |
| Surfaces | Canvas, content surface, and one highlighted surface. A subtle border and consistent radius can distinguish cards without shadows. | Nested cards around every sentence; many competing shadow strengths; every surface floating equally high. |
| Density | Compact navigation and metadata; comfortable reading and controls. Keep related labels, values, and actions together. | Making a productivity view a giant marketing page; making a reading view an unbroken dense table. |
| Icons | Prefer Lucide when icons improve recognition or scanning; repeat one size, stroke weight, and label gap for each role. | Mixing unrelated icon families; a glyph on every heading or row; shrinking control targets to match small glyphs. |
| Composition | One dominant task area with quieter supporting information. Align card titles, controls, and text edges. | Symmetry for its own sake; arbitrary metric tiles; decorative panels that force the useful content below the fold. |

These are starting points, not fixed ratios or a prescribed brand. Modify theme tokens intentionally rather than hardcoding competing palettes. Match backgrounds with appropriate foregrounds; the existence of a contrast token does not prove the final rendered contrast passes. Skeleton's `card` supplies radius, not padding or paint; `btn` defaults to nonwrapping text, so explicitly permit wrapping for long labels.

Calibrate one representative screen with real-length content before repeating components. Choose a canvas, a content surface, one accent treatment, four type roles, and comfortable or compact density; use the token override pattern in [styling.md](styling.md). If everything competes, remove accents, borders, and bold weights before adding decoration. If hierarchy is weak, increase section spacing and distinguish the title before enlarging every card. If content feels sparse, improve grouping and column widths rather than inventing metrics.

Adapt the recipe to the task: keep the editorial introduction for a collection or reading experience; shorten it to a title and explanation for frequent operational work. Use a list or table when users compare the same fields across many records; retain cards when descriptions and next steps need reading space. Change grid breakpoints when the actual labels and controls stop fitting, not to reach a preferred column count.

Optional effects belong to the brief, not to a mandatory redesign:

- **Glass:** author application CSS using an opaque surface/foreground fallback, then opt into a translucent `color-mix()` background and `backdrop-filter` inside a support query. Keep blur modest and localized. Test the actual backdrop; a named contrast token does not certify text over transparency.
- **Gradient or mesh:** author a linear gradient or a few static radial gradients over a solid fallback. Keep essential reading areas opaque, and remove decorative layers in forced colors if they obscure boundaries. Theme tokens can follow theme changes, but static `*-500` endpoints do not automatically change with dark mode; choose explicit light/dark values or pairing tokens and measure both schemes.
- **Typography:** define a small application-owned display/title/body/caption vocabulary if repeated compositions need it. Use the current `--typo-*--*` tokens where appropriate, load the chosen font, keep semantic heading order, and test long titles, text enlargement, and fallback fonts. An oversized or animated title is optional; it must not displace the primary task.

Names such as `preset-glass-*`, `preset-gradient-*`, `preset-input-success/error`, and `preset-typo-*` in upstream user-generated examples are **user-authored CSS**, not shipped Skeleton utilities. Validation paint still needs real validation and text errors. No custom effect guarantees contrast or dark-mode readability. Prefer static decoration; if movement is requested, provide a meaningful still fallback and reduced-motion handling, including any JavaScript animation. The shell below intentionally needs none of these effects.

## Compose from narrow to wide

- Start with one readable column. Keep the page's primary task and navigation available without a desktop sidebar. A mobile disclosure is often simpler than a modal drawer.
- Add a navigation rail and multiple content columns only when they fit their content. Use `minmax(0, 1fr)` and `min-w-0` where children must shrink; wrap long names rather than clipping meaningful text.
- Use bounded reading widths inside flexible layouts. Do not set fixed heights on cards containing user content, or hide page overflow to conceal a layout defect.
- At narrow widths, stack filter controls and reduce outer padding before reducing text size. Preserve source/reading order; the first card should remain first on every screen.
- Use local horizontal scrolling for genuinely wide tables, not for the entire app. Check an open mobile navigation panel, long labels, and enlarged text, not only the closed initial screenshot.

Use a named `<nav>` with real links for page sections; a desktop rail is still navigation, not an ARIA menu. If it has its own scroll area, verify the last link remains reachable by keyboard and touch at short viewport heights. Use the [navigation example](../examples/DisclosureNavigation.svelte) for disclosure or tabs when the content needs that interaction.

Use logical properties such as `padding-inline`, `border-inline-end`, `inset-inline-start`, and `text-align: start`. Set `dir` at the actual locale boundary and confirm the configured direction reaches Bits UI parts and portalled content where needed. Check traversal and popup placement in both directions; [mirror only directional icons](lucide-patterns.md).

## Content, states, and visual assets

Use plausible domain content with specific titles, descriptions, owners, and actionable labels. Label static sample data as local example content. Derive counts from the displayed dataset; do not invent revenue, completion percentages, live activity, persistence, or successful operations. Every displayed link needs a real route, valid section target, or deliberate external destination; every button needs a working action.

Plan default, focus, hover, selected, disabled, empty, pending, error, and success states **where the flow can actually enter them**. An empty filter result needs an explanation and a working recovery action. Pending should correspond to a real operation; error/success text should report its actual outcome. Static local filtering does not need fake loading or save notifications. Make selection/status legible without color alone; keep layout stable while feedback appears.

Prefer text labels when an icon adds no information. Use optional Lucide consistently when icons improve recognition. Match size, stroke, and gaps to surrounding density, without shrinking the control target to the glyph. Pair status icons with explicit text, hide redundant SVGs, and name the actual button or link. See [Lucide](lucide.md).

Use media only when it supports the content: confirm ownership/licensing, provide meaningful alternative text or `alt=""` for decoration, reserve dimensions, and choose a responsive crop. Do not depend on remote placeholder images or unreadable text baked into an image. Motion is optional; respect reduced-motion preferences rather than animating every card.

## Purposeful feedback and motion

Keep expressive branding around a calm working area. Marketing, onboarding, and
frequent operational tasks need different attention budgets; trend reports do not
establish usability gains. “Dopamine-driven” is not an engineering standard or
evidence of a neurological effect. Evaluate task completion, mistakes, recovery,
comprehension, and user control rather than time spent alone.

For genuine asynchronous work, show pending state promptly, prevent unintended
duplicate requests, retain entered values, and expose an actionable error. Confirm
success only after the operation succeeds, unless an explicit optimistic model
supports rollback. Never add a delay to make an animation visible. Keep important
results readable after any flourish ends; do not move focus to decoration.

Separate actual state from its visual interpolation: progress text and accessible
values report real work, not an eased display value. Use indeterminate feedback
when progress is unknown. Prefer CSS for hover/focus/press feedback; choose the
smallest Svelte motion mechanism only when it
explains a state change or preserves useful spatial continuity. Keep static
feedback and normal navigation complete without animation. Do not let two
mechanisms animate the same property on the same element.

These are design recommendations, not prescribed durations or a mandate to add
motion. See [NN/g's animation guidance](https://www.nngroup.com/articles/animation-purpose-ux/)
and [accessibility requirements](accessibility.md).

## Performance and browser constraints

Establish the application's browser matrix before adopting decorative features;
see [styling prerequisites](styling.md) if using the optional CSS layers.
Keep essential content server-renderable and independent of effects. Do not
lazy-load the LCP image; reserve media and placeholder dimensions. Import only
offered themes and load heavy effects only where used. Clean up listeners,
observers, and animation frames; suspend continuous decorative work when hidden.

Prefer transform/opacity for simple movement, but profile actual layout, paint,
and layer costs. Animated gradients, blur, masks, and CSS variables are not
automatically compositor-only. Add `will-change` only for a demonstrated need,
not to every card. See [animation performance](https://web.dev/articles/animations-guide)
and [LCP optimization](https://web.dev/articles/optimize-lcp).

For production evaluation, [Core Web Vitals](https://web.dev/articles/vitals)
good thresholds are LCP ≤2.5s, INP ≤200ms, and CLS ≤0.1 at the 75th percentile,
segmented by mobile/desktop. These are experience metrics, not animation-duration
limits. Local traces diagnose regressions; they do not establish field results.

## Responsive page shell

Use one `main` landmark and a skip link to the main content. On narrow screens, put a native `details` disclosure labeled **Page navigation** before the main area. On wider screens, show a navigation rail and hide the narrow disclosure with `display: none` so its links leave the tab order. Both presentations should point to the same real sections. Tab panels are not a replacement for these links; use Bits UI Tabs only when switching panels in place.

Start with a single-column grid. Add a bounded rail and flexible `minmax(0, 1fr)` content column when long labels and enlarged text fit without clipping. Let content determine the number of card columns; keep card heights flexible. Use logical alignment and spacing so the rail and skip link move with direction. Keep a visible focus indicator on the skip link when revealed.

For content filtering, use a named form, labeled search and status controls, and explicit Apply and Reset actions if filtering on submission. Keep draft fields separate from applied filters, expose a persistent result count with `role="status"`, and show an empty-state message with a working recovery action. When local filtering requires JavaScript, keep unenhanced navigation and initial content usable and explain when filtering is unavailable.

## Acceptance and smoke expectations

These are **checks to perform**, not a claim of tested screenshots or accessible certification:

1. **Wide layout:** Verify the rail and intended content columns fit at wide widths. Wrap titles and next steps; avoid page-level horizontal scrolling.
2. **Narrow layout:** At 375px and 320px, confirm the rail is replaced by an in-flow Page navigation disclosure and filter controls stack.
3. **Keyboard navigation:** Activate the skip link and check focus reaches `main`. Open the disclosure with Space or Enter, then follow a real section link. It has no modal focus trap or Escape contract. Check focus in both schemes and reading directions.
4. **Local interaction:** Apply filters that return one, many, and no results; verify the result count and that Reset restores the full list without losing keyboard access. Editing drafts alone should not announce results in a submit-to-apply flow.
5. **Initial state:** Reload with slow and disabled JavaScript. Confirm the initial content and navigation remain usable; local controls must not imply an available operation or saved data before they can work.
6. **Visual review:** Inspect 320/375/768/1280px widths, 200% zoom, enlarged text, long replacement titles, both color schemes, reduced motion, and forced colors. Measure contrast of body/metadata, buttons, borders needed to identify controls, and focus indicators. Check the actual theme, not only token names. Screen-reader review should identify landmarks, headings, filter labels, status changes, and the empty state.
7. **Design review:** Identify the primary task at a glance. Confirm that one accent and one distinguishing device lead the composition, repeated elements share type/spacing/radius rules, and the narrow layout retains the same hierarchy. Remove decorative panels that displace useful content. Check replacement content and reachable states, not just the polished default dataset.

For real data, use the application's supported route or request flow and implement genuine pending, error, and retry states.

See [native disclosure behavior](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) and the [example mounting guide](../examples/README.md).
