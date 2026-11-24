# Bits UI in SvelteKit 3.1+

This reference covers Kit routing, SSR and actions. Standalone Svelte 5 does not need Kit. Kit `3.1.0` is the floor for this guidance; `3.4.0` is the exact baseline. Kit 2 conventions below are migration context. Check the installed release's declarations and source before applying a version-sensitive contract.

- [Verify the project before changing it](#verify-the-project-before-changing-it)
- [Runes, props, snippets and events](#runes-props-snippets-and-events)
- [Page state and request isolation](#page-state-and-request-isolation)
- [Bits state across routes](#bits-state-across-routes)
- [Browser-only work and cleanup](#browser-only-work-and-cleanup)
- [Purposeful motion](#purposeful-motion)
- [Load, secrets and serialization](#load-secrets-and-serialization)
- [Global CSS, layout children and hydration](#global-css-layout-children-and-hydration)
- [Native form actions with progressive enhancement](#native-form-actions-with-progressive-enhancement)

## Verify the project before changing it

Inspect the manifest, lockfile, installed versions, route and layout structure, Vite configuration, and existing form and state conventions. Follow [setup](setup.md) for the Bun toolchain and exact dependency pins; CSS and icons are optional. Retain compatible configuration and deployment adapters. Do not treat an adapter update or `vite preview` as proof of production hosting compatibility.

For the Kit 3.1+ target, migrate these historical Kit 2 conventions:

- Move supported settings to `sveltekit({ ... })` from `@sveltejs/kit/vite` in `vite.config.*`. Preserve the adapter, required preprocessors and compiler options, then remove obsolete `svelte.config.*`. If using Tailwind, put its Vite plugin before `sveltekit()`.
- Kit 3 no longer generates `.svelte-kit/tsconfig.json`. Change the root `tsconfig.json`/`jsconfig.json` to extend `$app/tsconfig`, explicitly set `include: ["src", "test", "*"]` and `exclude: ["src/service-worker"]`, and merge custom source/test paths and compiler options. Do not disable `isolatedModules` or `verbatimModuleSyntax`. A TypeScript service worker uses its own config extending `$app/tsconfig/service-worker`. See [setup](setup.md) for complete configuration and the [Kit 3 `$app/tsconfig` migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig).
- Kit no longer generates `$lib`. Declare `"#lib/*": "./src/lib/*"` in `package.json` `imports`, then migrate every `$lib` import/re-export to `#lib` with explicit file extensions. Add a bare `#lib` mapping only if a real barrel exists and callers need it. Relative imports remain valid. [Vite 8.3.6](https://github.com/vitejs/vite/releases/tag/v8.3.6) fixed resolution of `#` subpath imports in the dependency optimizer; the 8.3.8 baseline includes that fix. Keep the explicit mapping, not an alias workaround.
- Use `$app/env`, including `import { browser } from '$app/env'` for runtime guards. Exact Kit 3.4.0 still ships [`$app/environment`](https://unpkg.com/@sveltejs/kit@3.4.0/src/runtime/app/environment/index.js) as a deprecated compatibility re-export; do not use it in new code.
- `$app/stores` was **removed**, not merely deprecated. `$env/...` modules are **deprecated** in favor of `$app/env/private` and `$app/env/public`.
- Ordinary Bits interactions and page actions do not require experimental remote functions or Svelte's experimental async compiler option.

Sources: [Kit 3 migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3), [Kit 3.4.0 metadata](https://registry.npmjs.org/@sveltejs%2Fkit/3.4.0) and [exact declarations](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts).

## Runes, props, snippets and events

Runes are compiler syntax, not functions to import. Use them in `.svelte` files or reusable `.svelte.ts`/`.svelte.js` modules, not arbitrary `.ts` files.

| Rune | Use | Avoid |
| --- | --- | --- |
| `$state(initial)` | Local editable state; plain objects/arrays are deeply reactive proxies | Assuming a destructured object property stays reactive; module-level user state during SSR |
| `$derived(expression)` / `$derived.by(() => ...)` | Pure calculations from reactive inputs | Side effects; using `$effect` to copy inputs into another state variable |
| `$effect(() => { ...; return cleanup; })` | Browser-only synchronization with external systems after DOM updates | SSR-required calculations; dependencies only read after `await`; loops caused by reading and writing the same state |
| `$props()` | Typed incoming values, callbacks and snippets | Mutating a parent's non-bindable object; copying a prop once and expecting navigation updates |
| `$props.id()` | Component-instance IDs consistent across SSR and hydration | Hardcoded reusable IDs; random values or shared counters |
| `$bindable(fallback)` | Explicit opt-in for a wrapper's two-way prop | Assuming every library prop supports `bind:`; binding `undefined` when a fallback is declared |

`let draft = $state(data.value)` takes an initial value; it does not track future `data` changes. For a live display, use `$derived(data.value)`. For an editable draft, choose an explicit reset or reinitialization policy instead of silently overwriting the user's edits in an effect.

Use DOM event properties such as `onclick` and callbacks declared by the component. Read `event.currentTarget` from the event argument. Event modifiers are not attached to event properties: call `event.preventDefault()` only when the behavior requires it. For Bits bindings and callbacks, use the installed primitive's prop types rather than assuming every prop is bindable.

New components receive snippets as props and render them with `{@render children()}`. Type them as `Snippet` or `Snippet<[ArgumentType]>` from `svelte`. When delegating a Bits part with `child`, forward the supplied props to the actual element, including the handlers and attributes that implement the interaction. See [Bits fundamentals](bits-ui.md) for composition.

A standalone native wrapper demonstrates typed props, `$bindable`, a snippet, derived state and a hydration-safe ID. A parent can use `<NameField bind:value={name}>Help text</NameField>` with `let name = $state('')`.

`src/lib/NameField.svelte`:
```svelte
<script lang="ts">
	import type { Snippet } from 'svelte';

	interface Props {
		value?: string;
		children?: Snippet;
	}

	let { value = $bindable(''), children }: Props = $props();
	const uid = $props.id();
	const length = $derived(value.length);
</script>

<label for={`${uid}-name`}>Name</label>
<input id={`${uid}-name`} name="name" bind:value maxlength="80" aria-describedby={`${uid}-length`} />
<p id={`${uid}-length`}>{length}/80 characters</p>
{#if children}
	{@render children()}
{/if}
```

Keep a native control's `name`, label and form participation. A Bits value in `$state` does not automatically appear in `FormData`; use the primitive's documented form props where available, or one named input that represents the value. Inspect actual submissions for selected, empty, disabled, and reset cases. Use native controls when the form must be editable without JavaScript.

Sources: [runes and snippets migration](https://svelte.dev/docs/svelte/v5-migration-guide), [props and IDs](https://svelte.dev/docs/svelte/$props), [Bits state management](https://www.bits-ui.com/docs/state-management/llms.txt), [Bits child snippets](https://www.bits-ui.com/docs/child-snippet/llms.txt).

## Page state and request isolation

Import `page`, `navigating`, or `updated` from `$app/state` as needed. These are read-only reactive objects, not stores: read `page`, not `$page`, and do not call `.subscribe()` or `.set()`. Derive reactive values with runes, not legacy `$:` or a one-time destructuring assignment. `page.url` is read-only in Kit 3; use a new `URL`/`URLSearchParams` and supported navigation APIs to change the location.

Reactive route-state display:

`src/lib/RouteLocation.svelte`:
```svelte
<script lang="ts">
	import { page } from '$app/state';
	const pathname = $derived(page.url.pathname);
</script>

<p>Current route: {pathname}</p>
```

Kit 3.1+ navigation contracts (partial TypeScript fragment; call in browser event handlers):

```ts
import { goto } from '$app/navigation';
import { page } from '$app/state';

const target = new URL(page.shallow?.url.href ?? page.url.href);
target.searchParams.set('panel', 'details');
await goto(target, {
	shallow: true,
	replace: true,
	reset: false,
	state: { ...page.state },
	persistState: true
});
```

`goto(url, options)` performs shallow navigation only with `shallow: true`; `state` or `persistState` alone does not. `replace: true` replaces the history entry. `reset` defaults to true for normal navigation and false for shallow navigation; false preserves focus and scroll. `state` must satisfy the application's `App.PageState`; `persistState: true` restores it after a full reload. `goto` also accepts `refreshAll: boolean` and `invalidate: Array<string | URL | ((url: URL) => boolean)>`. The separate `refreshAll()` function takes **no arguments** and refreshes active remote functions and current-page loads while preserving `page.state`.

`invalidateAll`, the old `replaceState` option, and navigation functions `pushState`/`replaceState` are deprecated, not all removed. Use current names in new code. Normal `goto` rejects unresolved app routes; use full-page browser navigation for external destinations and respect the application's base path. Copy a URL before mutation: Kit's URLs and search parameters are read-only.

During shallow routing, `page.url`, `page.params`, and `page.route` still describe the rendered page. `page.shallow` describes the address-bar target. Read `page.shallow?.url ?? page.url` for the user-visible URL; do not expect shallow query changes in `page.url.searchParams`. A full reload renders the target, and persisted `page.state` becomes available after hydration.

Register `afterNavigate` during component initialization. Starting in [Kit 3.2.0](https://github.com/sveltejs/kit/releases/tag/@sveltejs%2Fkit@3.2.0), the initial `type: 'enter'` callback during hydration receives the loaded route and params in `navigation.to.route` and `navigation.to.params`. On initial client-only navigation with SSR disabled, `navigation.from` is `null`. Do not rely on these startup metadata fixes on Kit 3.1.x.

Never put the current user's account, authentication, theme preference, form draft, toast queue or open-dialog state in a mutable module singleton that runs on the server. This applies equally to stores, `.svelte.ts` rune modules and `<script module>`. A long-lived server process can serve many users concurrently. Module-level immutable configuration or a deliberately shared database connection is different from per-user state.

If the application requires authentication, authenticate from the request's cookies/session and attach request-scoped values to `event.locals` in server hooks; do not invent an auth API for a presentational recipe. Return only browser-safe data from `load`. Keep UI state in component instances; for tree-wide state, create it per layout instance and pass it through context. Do not write to global stores from `load`. Durable user data belongs in the application's authenticated persistence layer, not server RAM. Layouts and pages may survive navigation, so derive changing data from props rather than expecting them to remount. Check isolation with two independent sessions and concurrent requests, including different theme cookies and failed form drafts.

During SSR, read `$app/state` in component rendering, not a server utility or `load`; those have their own request event. Avoid child-to-parent context writes during SSR that change already-rendered markup.

Sources: [request isolation and context](https://svelte.dev/docs/kit/state-management), [application state](https://svelte.dev/docs/kit/$app-state), [navigation](https://svelte.dev/docs/kit/$app-navigation), [shallow routing](https://svelte.dev/docs/kit/shallow-routing), [exact Kit 3.4.0 declarations](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts), [removed stores](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-stores-(removed)).

## Bits state across routes

- **Local interaction:** keep hover, floating-menu state and transient dialog state in the owning component. For a dialog that must be available on every route, keep its Bits root and parts inside one persistent layout instance. A portal moves DOM; it does not move ownership or let triggers outside the root share its context. If several features need to open it, expose an instance-owned command through layout context and deliberately choose a valid focus-return target.
- **Navigation:** use ordinary links for route changes, including in a shell or a delegated menu link. Keep link semantics and Bits props when composing a part that supports `child`; do not nest an anchor inside a button. Derive `aria-current` from the active route. Use Tabs for in-page panels, not as a substitute for route links.
- **Shareable state:** keep filters or a selected panel in URL search parameters when they must survive reload or be shareable. Derive the model from the current URL; write a copy on user actions rather than synchronizing two independent models in effects. Use normal navigation or a native GET form when server loads need the parameters. Use shallow navigation only for a client-side view of the already-rendered route.
- **History-only state:** use typed `page.state` for state scoped to the browser history entry. It is not an SSR source. Avoid reopening a modal during hydration from persisted client-only state unless the UX explicitly calls for that behavior.
- **Route lifecycle:** persistent layouts do not remount on each navigation. Decide whether an overlay stays open or closes on route replacement. If using `afterNavigate` registered during initialization, account for initial entry and shallow updates; don't focus an opener that the old route removed. Test that destination focus and announcements still work. Keep an ordinary same-route close restoring focus to its trigger.

Sources: [Kit state management](https://svelte.dev/docs/kit/state-management), [Kit navigation](https://svelte.dev/docs/kit/$app-navigation), [Bits child snippets](https://www.bits-ui.com/docs/child-snippet/llms.txt).

## Browser-only work and cleanup

Component initialization and universal `load` can execute on the server. Do not access `window`, `document`, `localStorage`, `matchMedia`, or browser-only library code at module evaluation or unguarded initialization. `onMount` and `$effect` run only in the browser. A `browser` guard does not fix a static import whose package accesses `window` while evaluating: dynamically import that package inside browser-only code instead.

Use a synchronous `onMount` callback so its returned cleanup is registered. If it starts async initialization, launch the async work inside it, handle rejection, and guard against completion after destruction. Unsubscribe observers and listeners and release library instances on unmount; effect cleanup also runs before each rerun. `onDestroy` can run on the server, so it is not itself a browser guard.

Standalone browser-state example, with stable SSR markup until mounting:

`src/lib/ReducedMotion.svelte`:
```svelte
<script lang="ts">
	import { onMount } from 'svelte';
	let reducedMotion = $state(false);

	onMount(() => {
		const query = window.matchMedia('(prefers-reduced-motion: reduce)');
		const update = () => { reducedMotion = query.matches; };
		update();
		query.addEventListener('change', update);
		return () => query.removeEventListener('change', update);
	});
</script>

<p>Reduced motion: {reducedMotion ? 'enabled' : 'disabled'}</p>
```

Use CSS `prefers-reduced-motion` for animation defaults that must apply before JavaScript starts; this component only illustrates browser state and cleanup. Do not disable SSR for an entire application to accommodate one browser-only widget.

Sources: [lifecycle](https://svelte.dev/docs/svelte/lifecycle-hooks), [effects](https://svelte.dev/docs/svelte/$effect), [Kit environment migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-environment-(renamed)), [load execution](https://svelte.dev/docs/kit/load#Universal-vs-server).

## Purposeful motion

Keep business state authoritative. Update selection, progress, text and ARIA values from the real state, not an interpolated value or an animation-completion callback. Motion is optional presentation; it must not delay submitting a form, reporting success or navigating.

| Need | Smallest suitable mechanism |
| --- | --- |
| Hover, focus or pressed styling | CSS/Tailwind state variants |
| Content entering or leaving the DOM | `transition:` with a function from `svelte/transition` |
| Reordering existing list items | `animate:flip` from `svelte/animate`, on an immediate child of a keyed `{#each}` |
| Spring-like or fixed-duration interpolation | `Spring` or `Tween` from `svelte/motion` |
| Optional continuity between routes | `onNavigate` and the browser View Transitions API |
| Element-bound browser integration | `{@attach ...}` with synchronous cleanup |

Transitions can retain outgoing elements until the outro completes; do not assume state changes immediately remove them from the DOM. `animate:` handles reordering, not insertion/removal. Avoid two systems changing the same transform: animate a separate wrapper rather than overwriting floating placement. Prefer native `<details>` where its behavior meets the need.

Use the current `Spring`/`Tween` classes, not the deprecated `spring`/`tweened` stores. Set `.target` and read `.current`; use `.set(value, options)` when options are needed. `Spring.set` accepts `{ instant: true }`; `Tween.set` accepts `{ duration: 0 }` for an immediate update. Read `prefersReducedMotion.current`, not the media-query object as a boolean. Pass zero duration to Svelte transitions and list animations when motion is reduced: global CSS duration overrides do not disable their Web Animations API effects.

Do not use a motion promise as an operation's completion signal. In Svelte 5.59.1, a superseded pending `Spring.set` promise rejects; an interrupted tween's promise need not resolve. Handle rejected spring promises when chaining them. Keep motion state per component and stop owned animation work on destruction.

Standalone optional feedback for a local JavaScript-only selection, not a persisted operation:

`src/lib/MotionSelection.svelte`:
```svelte
<script lang="ts">
	import { onDestroy, onMount } from 'svelte';
	import { Spring, prefersReducedMotion } from 'svelte/motion';

	let ready = $state(false);
	let selected = $state(false);
	const scale = new Spring(1, { stiffness: 0.2, damping: 0.7 });

	onMount(() => { ready = true; });

	$effect(() => {
		const reduced = prefersReducedMotion.current;
		void scale.set(selected && !reduced ? 1.03 : 1, { instant: reduced })
			.catch(() => { /* A newer target superseded this decorative movement. */ });
	});

	onDestroy(() => { void scale.set(1, { instant: true }); });
</script>

<div class="inline-block" style:transform={`scale(${prefersReducedMotion.current ? 1 : scale.current})`}>
	<button
		type="button"
		disabled={!ready}
		aria-pressed={selected}
		onclick={() => { selected = !selected; }}
	>
		{selected ? 'Selected' : 'Select'}
	</button>
</div>
```

The server and first client render both start at scale 1 with the same text and semantics. The button remains disabled until mounting and stays disabled without JavaScript; it does not imply that a selection was saved. Changing the motion preference does not change selection. CSS media queries remain preferable for effects that must respect the preference before hydration; do not branch the server-rendered content tree on a browser media query.

Attachments run in browser effects and may rerun when their synchronous reactive dependencies change. Return cleanup synchronously to remove listeners, disconnect observers, cancel animation frames or destroy a library instance before rerun/unmount. Attach to a DOM element; a component receives an attachment only if its implementation forwards the attachment-bearing props to an element. Existing library actions remain valid; do not mechanically replace them. Neither attachments nor these motion APIs require experimental async compilation.

Sources: [motion APIs](https://svelte.dev/docs/svelte/svelte-motion), [exact spring implementation](https://unpkg.com/svelte@5.59.1/src/motion/spring.js), [exact tween implementation](https://unpkg.com/svelte@5.59.1/src/motion/tweened.js), [transitions and reduced motion](https://svelte.dev/docs/svelte/transition), [keyed-list animation](https://svelte.dev/docs/svelte/animate), [attachments](https://svelte.dev/docs/svelte/@attach), [experimental async scope](https://svelte.dev/docs/svelte/await-expressions).

### Route view transitions

Register `onNavigate` during persistent-layout initialization, not inside `onMount`. It runs for client navigation, not initial SSR or full-document navigation. Kit waits for the returned promise: release that promise when the view-transition update callback starts, then return `navigation.complete` from the update callback. Awaiting completion before releasing Kit creates a deadlock. Never make Kit wait for the visual animation to finish.

Complete Kit 3.1+ root layout with optional route transitions; merge into the existing layout, retaining its CSS, providers and shell. Keep the `navigation.shallow` filter: shallow navigation must not trigger route-replacement decoration. Check the router source and navigation declarations for the installed Kit release if adapting the example.

`src/routes/+layout.svelte` (route-motion alternative):
```svelte
<script lang="ts">
	import '../app.css';
	import { onDestroy } from 'svelte';
	import { onNavigate } from '$app/navigation';
	import { prefersReducedMotion } from 'svelte/motion';
	import type { LayoutProps } from './$types';

	let { children }: LayoutProps = $props();
	let active: { transition: ViewTransition; release: () => void } | undefined;

	function skipActive() {
		active?.release();
		active?.transition.skipTransition();
		active = undefined;
	}

	onDestroy(skipActive);

	onNavigate((navigation) => {
		skipActive();
		if (navigation.shallow || prefersReducedMotion.current || !document.startViewTransition) return;

		const complete = navigation.complete;
		void complete.catch(() => {}); // An interrupted navigation may reject before the update callback runs.

		return new Promise<void>((resolve) => {
			const release = () => resolve();
			try {
				const transition = document.startViewTransition(() => {
					release();
					return complete;
				});
				const current = { transition, release };
				active = current;

				const finish = () => {
					release();
					if (active === current) active = undefined;
				};
				void transition.ready.catch(release);
				void transition.updateCallbackDone.catch(release);
				void transition.finished.then(finish, finish);
			} catch {
				release(); // A decorative API failure must not block navigation.
			}
		});
	});
</script>

{@render children()}
```

Merge into the existing global stylesheet:

`src/app.css` (route-motion addition):
```css
::view-transition-group(root),
::view-transition-old(root),
::view-transition-new(root) {
	animation-duration: 160ms;
}

@media (prefers-reduced-motion: reduce) {
	::view-transition-group(*),
	::view-transition-old(*),
	::view-transition-new(*) {
		animation: none;
	}
}
```

Kit 3 shallow `goto` calls also invoke navigation hooks; skip them when the effect is for route replacement only. Unsupported browsers and reduced-motion users navigate normally. A new navigation releases and skips the previous decoration; destruction does the same. Observe all three transition promises: duplicate `view-transition-name` values, skipped transitions or a rejected update callback can reject them. Consuming decoration failures does not replace Kit's navigation/error handling. Keep names unique among simultaneously rendered elements, retain route titles, focus and announcements, and test rapid navigation, Back/Forward and interrupted updates.

Sources: [Kit navigation lifecycle](https://svelte.dev/docs/kit/$app-navigation#onNavigate), [Kit view-transition pattern](https://svelte.dev/docs/kit/faq#How-do-I-use-the-view-transitions-API), [Kit 3 shallow-navigation changes](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-navigation-Changes-to-shallow-routing), [exact Kit 3.4.0 router](https://unpkg.com/@sveltejs/kit@3.4.0/src/runtime/client/client.js), [startViewTransition](https://developer.mozilla.org/en-US/docs/Web/API/Document/startViewTransition), [transition promises](https://developer.mozilla.org/en-US/docs/Web/API/ViewTransition), [skipping transitions](https://developer.mozilla.org/en-US/docs/Web/API/ViewTransition/skipTransition).

## Load, secrets and serialization

`+page.ts`/`+layout.ts` export universal `load`: they normally run on the server for initial SSR, during browser hydration, and in the browser for later navigation. `+page.server.ts`/`+layout.server.ts` run only on the server. Use the provided `fetch` in `load` for request-aware fetching and hydration reuse; don't duplicate that request in `onMount` without a separate requirement.

Keep credentials, database queries and private environment access in server modules. In Kit 3, define a `variables` export in `src/env.ts` or `src/env.js` using `defineEnvVars` from `@sveltejs/kit/env`, then import named private values from `$app/env/private`. Variables default to `public: false` and `static: false`: runtime values are read at application startup, not separately for each request. `public: true` deliberately exposes values through `$app/env/public`; `static: true` validates/inlines the build-time value. With no `schema`, a variable must be set but may be empty; supply a synchronous validator to enforce nonempty/typed values or permit `undefined`. Never read tenant/session state from these process-wide values.

Do not import private code into a component or universal loader, even indirectly. Within the project root and outside `node_modules`, `*.server.*` (including `server.ts`) is protected; a `server` directory is also protected except under the configured routes/assets directories (normally `src/routes` and `static`). External packages do not automatically gain this boundary from their filenames. Keep private module imports out of client/universal hooks and service workers too. **Anything returned from server `load` or an action is sent to the browser**. Never return tokens, password hashes or internal exception details.

Server `load` results must be serializable by Kit's `devalue` transport. Conservative results use plain objects, arrays, strings, numbers, booleans and null; Kit also supports types such as `Date`, `Map`, `Set` and `BigInt`. Do not return database clients, functions, DOM nodes or arbitrary class instances without a deliberately implemented transport. Use generated `PageServerLoad`, `PageLoad`, `PageProps` and `Actions` types from `./$types` rather than duplicating their shapes.

Sources: [load](https://svelte.dev/docs/kit/load), [server-only modules](https://svelte.dev/docs/kit/server-only-modules), [exact Kit 3.4.0 import guard](https://unpkg.com/@sveltejs/kit@3.4.0/src/exports/vite/plugins/guard.js), [environment variables](https://svelte.dev/docs/kit/environment-variables), [exact environment implementation](https://unpkg.com/@sveltejs/kit@3.4.0/src/core/env.js), [exact Kit 3.4.0 types](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts).

## Global CSS, layout children and hydration

Bits UI needs no global stylesheet. Import an existing application stylesheet once in the root layout. If adopting Tailwind or optional Skeleton CSS, use the imports and shared-source paths in [setup](setup.md); keep route hydration independent of styling.

Minimal root layout; merge into the existing layout, retaining its providers and shell:

`src/routes/+layout.svelte`:
```svelte
<script lang="ts">
	import '../app.css';
	import type { LayoutProps } from './$types';
	let { children }: LayoutProps = $props();
</script>

{@render children()}
```

If theming, use a deterministic initial theme that matches an imported stylesheet. Keep the initial component tree, including selected values and open states, identical between server render and hydration:

- Use `$props.id()` for component-instance IDs, with suffixes for related elements; never `Math.random()`, timestamps or a server-global incrementing counter for label/dialog IDs.
- Start preferences with the same SSR-safe default on both sides, then read browser storage or media queries after mount. Browser storage may be unavailable; treat it as optional, not an authentication or persistence authority.
- If the initial theme must match a user's saved preference without a flash, let the server read a validated cookie and emit the correct initial HTML attribute through the existing server/template integration. Return the same preference to the component tree. Cookie-specific rendering must not be shared across users in a public cache.
- A pre-hydration theme bootstrap must respect CSP and must not alter Svelte-owned markup into a different tree. Do not add an unreviewed inline script or generic client theme singleton just to hide a flash.
- CSS media queries can apply system preferences before hydration without reading browser globals in component initialization.

Kit handles hydration for its routes; do not call `mount` or `hydrate` manually in a Kit layout. If the server rendered a Bits trigger but none of its interactions work, inspect client startup and hydration errors before changing CSS. If it responds without decoration, inspect the [styling](styling.md).

Sources: [layout routing](https://svelte.dev/docs/kit/routing#layout), [props IDs](https://svelte.dev/docs/svelte/$props#props-id), [server hooks and HTML transforms](https://svelte.dev/docs/kit/hooks#Server-hooks-handle).

## Native form actions with progressive enhancement

Use a real `<form method="POST">`, named inputs and a submit button. Actions live in `+page.server.ts`, not `+server.ts`. `use:enhance` from `$app/forms` enhances POST forms targeting page actions, not arbitrary JSON endpoints or GET search forms. Browser validation helps users but never replaces server validation. Preserve Enter-to-submit, labels, submitter behavior and native navigation. To omit client enhancement, remove `use:enhance`, its `$app/forms` imports and the example's `submit` callback; keep the same server action rather than replacing it with an `onclick` fetch.

The following pair implements a complete text-formatting page with no database or invented authentication API. Its policy rejects nontext, whitespace-only, and raw values longer than 80 UTF-16 code units (matching native `maxlength`); it trims only the greeting's display name. Failure data retains the exact submitted text, including leading/trailing spaces and overlength values, without slicing. Missing/file input has no text value to redisplay. Native `required` does not reject whitespace-only text, so this case reaches the server. The action does not claim to save anything.

`src/routes/greeting/+page.server.ts`:

```ts
import { fail } from '@sveltejs/kit';
import type { Actions } from './$types';

export const actions = {
	default: async ({ request }) => {
		const fields = await request.formData();
		const entry = fields.get('name');
		const name = typeof entry === 'string' ? entry : '';
		const normalizedName = name.trim();

		if (typeof entry !== 'string' || normalizedName.length < 1 || name.length > 80) {
			return fail(400, {
				name,
				error: 'Enter a nonblank name of at most 80 characters, including spaces.',
				greeting: null
			});
		}

		return { name, error: null, greeting: `Hello, ${normalizedName}!` };
	}
} satisfies Actions;
```

`src/routes/greeting/+page.svelte`:
```svelte
<script lang="ts">
	import { onMount } from 'svelte';
	import { enhance, type SubmitFunction } from '$app/forms';
	import type { PageProps } from './$types';
	let { form }: PageProps = $props();
	const uid = $props.id();
	let nameInput = $state<HTMLInputElement>();

	onMount(() => {
		if (form?.error) nameInput?.focus();
	});

	const submit: SubmitFunction = () => async ({ result, update, formElement }) => {
		await update();
		if (result.type === 'failure') {
			formElement.querySelector<HTMLInputElement>('[aria-invalid="true"]')?.focus();
		}
	};
</script>

<h1>Create a greeting</h1>
<form method="POST" use:enhance={submit}>
	<label for={`${uid}-name`}>Name</label>
	<input
		id={`${uid}-name`}
		name="name"
		type="text"
		required
		bind:this={nameInput}
		maxlength="80"
		value={form?.name ?? ''}
		aria-invalid={form?.error ? 'true' : undefined}
		aria-describedby={form?.error ? `${uid}-help ${uid}-error` : `${uid}-help`}
	/>
	<p id={`${uid}-help`}>Use a nonblank name of up to 80 characters, including spaces. Nothing is saved.</p>
	<button type="submit">Create greeting</button>
	{#if form?.error}
		<p id={`${uid}-error`}>Name: {form.error} <a href={`#${uid}-name`}>Edit name</a></p>
	{/if}
</form>
<p role="status" aria-atomic="true">{form?.greeting ?? ''}</p>
```

Kit exposes returned action data through the page's `form` prop. `return fail(400, data)` creates an action failure; it does **not** throw. `redirect(303, location)` and `error(404, 'Message')` from `@sveltejs/kit` throw internally and return `never`: call them directly, without `throw` or returning a fabricated result. Do not swallow them in a broad `catch`. Use `fail` for expected field validation; use `error` for an HTTP error page. For extra declared `App.Error` fields, use `error(status, message, properties)`; the old object-second-argument overload `error(status, body)` is **deprecated**, not absent. After a real persisted mutation, a local `redirect(303, location)` gives POST/Redirect/GET. Kit 3 requires explicit external permission (`external: true` or an origin allowlist) for external redirect targets; validate destinations instead of trusting a submitted URL.

Default `use:enhance` resets successful forms, refreshes data on success (not failure), updates action state, follows redirects and renders errors. Kit 3 navigates on **both success and failure** when an action targets another page, matching native submission. A custom returned result callback replaces this behavior: invoke `await update()` to retain it, or implement every required result path deliberately. The example does so before focusing the invalid field; native browser constraint failures occur before enhancement and retain browser-managed focus. Hydrated failed HTML responses focus the field on mount; without JavaScript the visible error and “Edit name” link remain available. Do not expect Kit's general focus reset to choose the invalid input.

In Kit 3, `update({ refreshAll: false })` replaces the deprecated `invalidateAll` update option; `update({ reset: false })` prevents a successful form reset when intended. `update({ navigate: false })` applies non-redirect cross-page results locally; redirects are still followed. `refreshAll: false` does not prevent destination loads during cross-page navigation. These are `update` options, not arguments to `$app/navigation`'s no-argument `refreshAll()`. Failed forms are not reset by default, but unenhanced failed POSTs need explicit returned values as above. Do not suppress errors or bypass forms with click-only handlers. Check the pair with JavaScript enabled and disabled: empty native rejection, whitespace-only server failure, raw overlength POST failure and success. Confirm exact failed text, field association/focus and no hydration warnings; see [accessibility.md](accessibility.md#concrete-verification-checklist) for the shared keyboard/motion/contrast criteria.

Named actions use `action="?/save"`; do not combine named and default actions on the same page. Keep private fields (passwords, tokens) out of failure data. File forms need `enctype="multipart/form-data"` for native submissions, plus server file validation. Authentication, authorization and persistence are application responsibilities, not styling or enhancement features.

For a native file input using `bind:files`, [Svelte 5.58.1](https://github.com/sveltejs/svelte/releases/tag/svelte@5.58.1) fixed the binding so it also updates when the form resets. This includes the default enhanced reset after a successful action; failure still does not reset the form.

Remote forms are a separate API, not a prerequisite for Bits or ordinary server actions. If explicitly requested, verify the installed remote `form` API, schema, native fallback and its own `.enhance(...)` contract. Do not confuse it with `use:enhance` from `$app/forms`.

Sources: [form actions](https://svelte.dev/docs/kit/form-actions), [exact Kit 3.4.0 forms/fail/redirect/error and remote-form types](https://unpkg.com/@sveltejs/kit@3.4.0/types/index.d.ts), [exact enhancement implementation](https://unpkg.com/@sveltejs/kit@3.4.0/src/runtime/app/forms/client.js), [Kit 3 enhancement changes](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-forms), [optional remote forms](https://svelte.dev/docs/kit/remote-functions#form).
