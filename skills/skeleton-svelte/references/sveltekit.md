# Svelte 5.57.2 and SvelteKit 3.1.0 integration

Use this reference for application behavior around Skeleton 5.0.1, not to justify migrating an unrelated application. Skeleton's current installation minimum remains Kit 2; preserve compatible existing Kit 2 applications unless framework migration is requested. Apply the Kit 3-specific configuration, imports, navigation and action options below only to a Kit 3 project or an explicitly requested migration. Prefer exact installed declarations over version-mixed examples.

- [Verify the project before changing it](#verify-the-project-before-changing-it)
- [Runes, props, snippets and events](#runes-props-snippets-and-events)
- [Page state and request isolation](#page-state-and-request-isolation)
- [Browser-only work and cleanup](#browser-only-work-and-cleanup)
- [Load, secrets and serialization](#load-secrets-and-serialization)
- [Global CSS, layout children and hydration](#global-css-layout-children-and-hydration)
- [Native form actions with progressive enhancement](#native-form-actions-with-progressive-enhancement)

## Verify the project before changing it

Inspect the package manifest, lockfile, installed package versions, route and layout structure, Vite configuration, global CSS, theme ownership, and existing form and state conventions. Use the project's package manager; do not regenerate configuration or replace working conventions merely to match an example. New runes components can coexist with existing legacy Svelte components, but do not mix `export let` or `$:` declarations into a runes component.

The reproducible baseline is `@skeletonlabs/skeleton@5.0.1`, `@skeletonlabs/skeleton-svelte@5.0.1`, `svelte@5.57.2`, `@sveltejs/kit@3.1.0`, `tailwindcss@4.3.3`, `@tailwindcss/vite@4.3.3`, `vite@8.3.4`, and `@sveltejs/vite-plugin-svelte@7.3.1`. Skeleton core requires Tailwind `^4.0.0`; its Svelte package requires Svelte `^5.40.0`. Kit 3.1.0 separately requires Node `>=22.17`, Svelte `^5.57.1`, Vite `^8.0.12`, and the Svelte Vite plugin `^7.0.0`. Its TypeScript peer is optional: the baseline uses TypeScript `6.0.3` and `svelte-check@4.7.7` when TypeScript tooling is present; do not install TypeScript 7. JavaScript-only projects may omit that tooling. Preserve the production adapter and check its compatibility; `adapter-auto@8.0.0` is the baseline auto-adapter, not a replacement for deployment-specific configuration. Pin direct dependencies and retain the lockfile; satisfying peers alone is not proof of a working application.

These requirements describe the chosen Kit 3 target, not every existing Skeleton app. See [setup](setup.md#existing-project) for the inspection-only path and the combined Node/Vite-plugin engine ranges.

For an npm project, these are inspection commands, not upgrade commands:

```sh
npm ls svelte @sveltejs/kit @skeletonlabs/skeleton @skeletonlabs/skeleton-svelte
npm view @sveltejs/kit@3.1.0 engines peerDependencies peerDependenciesMeta
npm view @skeletonlabs/skeleton@5.0.1 peerDependencies exports
npm view @skeletonlabs/skeleton-svelte@5.0.1 peerDependencies exports
```

For an actual Kit 3 project, account for these differences from Kit 2 examples:

- Configuration belongs in `sveltekit({ ... })` from `@sveltejs/kit/vite`, inside `vite.config.*`; `svelte.config.js` is no longer supported. Move supported options into this plugin, preserving the adapter, required preprocessors and compiler options. Keep the Tailwind Vite plugin before `sveltekit()` and retain unrelated PostCSS transforms.
- Kit 3 no longer generates `.svelte-kit/tsconfig.json`. Change the root `tsconfig.json`/`jsconfig.json` to extend `$app/tsconfig`, explicitly set `include: ["src", "test", "*"]` and `exclude: ["src/service-worker"]`, and merge custom source/test paths and compiler options. Do not disable `isolatedModules` or `verbatimModuleSyntax`. A TypeScript service worker uses its own config extending `$app/tsconfig/service-worker`. See [setup](setup.md) for complete configuration and the [Kit 3 `$app/tsconfig` migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-tsconfig).
- Kit no longer generates `$lib`. Declare `"#lib/*": "./src/lib/*"` in `package.json` `imports`, then migrate every `$lib` import/re-export to `#lib` with explicit file extensions. Add a bare `#lib` mapping only if a real barrel exists and callers need it. Relative imports remain valid; do not add compatibility aliases.
- Use `$app/env`, including `import { browser } from '$app/env'` for runtime guards. `$app/environment` remains a **deprecated compatibility module** in exact Kit 3.1.0, not a removed module.
- `$app/stores` was **removed**, not merely deprecated. `$env/...` modules are **deprecated** in favor of `$app/env/private` and `$app/env/public`.
- Do not enable experimental remote functions or async compiler features to implement ordinary Skeleton interactions or form actions.

Sources: [Kit 3 migration](https://svelte.dev/docs/kit/migrating-to-sveltekit-3), [Kit 3.1.0 metadata](https://registry.npmjs.org/@sveltejs%2Fkit/3.1.0), [Svelte 5.57.2 metadata](https://registry.npmjs.org/svelte/5.57.2), [Skeleton core 5.0.1 metadata](https://registry.npmjs.org/@skeletonlabs%2Fskeleton/5.0.1), [Skeleton Svelte 5.0.1 metadata](https://registry.npmjs.org/@skeletonlabs%2Fskeleton-svelte/5.0.1), [current installation](https://www.skeleton.dev/docs/svelte/get-started/installation/sveltekit).

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

DOM events use properties such as `onclick`, `oninput`, and `onsubmit`. Use the event argument (`event.currentTarget`) rather than a global `event`. Event modifiers are not attached to these properties: call `event.preventDefault()` only when the behavior actually requires it. Skeleton 5 compound roots use prop-in/callback-out state: Tabs uses `value`/`onValueChange` with `event.value`, Accordion uses `value: string[]`/`onValueChange` with `event.value`, and Switch uses `checked`/`onCheckedChange` with `event.checked`. Keep the owning value in component-instance `$state`; do not assume these state props support `bind:`.

New components receive snippets through props and render them with `{@render children()}`; named `{#snippet ...}` blocks can be passed as named props. Type them as `Snippet` or `Snippet<[ArgumentType]>` from `svelte`. Skeleton 5 uses callable roots such as `<Tabs>` with `<Tabs.List>`, `<Tabs.Trigger>` and `<Tabs.Content>`, not `<Tabs.Root>` or the old control/panel anatomy. An `element(attributes)` snippet replaces internal markup: spread all supplied attributes onto the custom element to preserve behavior, IDs, roles and hidden state. Slots and `let:` belong to legacy APIs; do not mechanically convert them without checking the destination contract.

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

Native input bindings remain valid, as the wrapper demonstrates. For Skeleton components, inspect installed `.svelte.d.ts` props and bindings before choosing an API; a prop named `value` is not proof that it is bindable. Keep native input `name`, label association, keyboard behavior and form participation; a visual component value is not automatically present in `FormData`. Use the component's documented hidden input where applicable, such as `Switch.HiddenInput`. See [components](components.md) and [recipes](recipes.md) for complete v5 anatomy.

Sources: [state](https://svelte.dev/docs/svelte/$state), [derived](https://svelte.dev/docs/svelte/$derived), [effect](https://svelte.dev/docs/svelte/$effect), [props and IDs](https://svelte.dev/docs/svelte/$props), [bindable](https://svelte.dev/docs/svelte/$bindable), [snippets](https://svelte.dev/docs/svelte/snippet), [Svelte 5 migration](https://svelte.dev/docs/svelte/v5-migration-guide), [exact Svelte 5.57.2 types](https://unpkg.com/svelte@5.57.2/types/index.d.ts), [Skeleton fundamentals](https://www.skeleton.dev/docs/svelte/get-started/fundamentals), [exact Skeleton Svelte 5.0.1 declarations](https://unpkg.com/@skeletonlabs/skeleton-svelte@5.0.1/dist/index.d.ts).

## Page state and request isolation

Import `page`, `navigating`, or `updated` from `$app/state` as needed. These are read-only reactive objects, not stores: read `page`, not `$page`, and do not call `.subscribe()` or `.set()`. Derive reactive values with runes, not legacy `$:` or a one-time destructuring assignment. `page.url` is read-only in Kit 3; use a new `URL`/`URLSearchParams` and supported navigation APIs to change the location.

Standalone route-state display:

`src/lib/RouteLocation.svelte`:
```svelte
<script lang="ts">
	import { page } from '$app/state';
	const pathname = $derived(page.url.pathname);
</script>

<p>Current route: {pathname}</p>
```

Kit 3.1.0 navigation contracts (partial TypeScript fragment; call in browser event handlers):

```ts
import { goto, refreshAll } from '$app/navigation';
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
await refreshAll();
```

`goto(url, options)` performs shallow navigation only with `shallow: true`; `state` or `persistState` alone does not. `replace: true` replaces the history entry. `reset` defaults to true for normal navigation and false for shallow navigation; false preserves focus and scroll. `state` must satisfy the application's `App.PageState`; `persistState: true` restores it after a full reload. `goto` also accepts `refreshAll: boolean` and `invalidate: Array<string | URL | ((url: URL) => boolean)>`. The separate `refreshAll()` function takes **no arguments** and refreshes active remote functions and current-page loads while preserving `page.state`.

`invalidateAll`, the old `replaceState` option, and navigation functions `pushState`/`replaceState` are deprecated, not all removed. Use current names in new code. Normal `goto` rejects unresolved app routes; use full-page browser navigation for external destinations and respect the application's base path. Copy a URL before mutation: Kit's URLs and search parameters are read-only.

During shallow routing, `page.url`, `page.params`, and `page.route` still describe the rendered page. `page.shallow` describes the address-bar target. Read `page.shallow?.url ?? page.url` for the user-visible URL; do not expect shallow query changes in `page.url.searchParams`. A full reload renders the target, and persisted `page.state` becomes available after hydration.

Never put the current user's account, authentication, theme preference, form draft, toast queue or open-dialog state in a mutable module singleton that runs on the server. This applies equally to stores, `.svelte.ts` rune modules and `<script module>`. A long-lived server process can serve many users concurrently. Module-level immutable configuration or a deliberately shared database connection is different from per-user state.

If the application requires authentication, authenticate from the request's cookies/session and attach request-scoped values to `event.locals` in server hooks; do not invent an auth API for a presentational recipe. Return only browser-safe data from `load`. Keep UI state in component instances; for tree-wide state, create it per layout instance and pass it through context. Do not write to global stores from `load`. Durable user data belongs in the application's authenticated persistence layer, not server RAM. Layouts and pages may survive navigation, so derive changing data from props rather than expecting them to remount. Check isolation with two independent sessions and concurrent requests, including different theme cookies and failed form drafts.

During SSR, read `$app/state` in component rendering, not a server utility or `load`; those have their own request event. Avoid child-to-parent context writes during SSR that change already-rendered markup.

Sources: [request isolation and context](https://svelte.dev/docs/kit/state-management), [application state](https://svelte.dev/docs/kit/$app-state), [navigation](https://svelte.dev/docs/kit/$app-navigation), [shallow routing](https://svelte.dev/docs/kit/shallow-routing), [exact Kit 3.1.0 declarations](https://unpkg.com/@sveltejs/kit@3.1.0/types/index.d.ts), [removed stores](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-stores-(removed)).

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

## Load, secrets and serialization

`+page.ts`/`+layout.ts` export universal `load`: they normally run on the server for initial SSR, during browser hydration, and in the browser for later navigation. `+page.server.ts`/`+layout.server.ts` run only on the server. Use the provided `fetch` in `load` for request-aware fetching and hydration reuse; don't duplicate that request in `onMount` without a separate requirement.

Keep credentials, database queries and private environment access in server modules. In Kit 3, define a `variables` export in `src/env.ts` or `src/env.js` using `defineEnvVars` from `@sveltejs/kit/env`, then import named private values from `$app/env/private`. Variables default to `public: false` and `static: false`: runtime values are read at application startup, not separately for each request. `public: true` deliberately exposes values through `$app/env/public`; `static: true` validates/inlines the build-time value. With no `schema`, a variable must be set but may be empty; supply a synchronous validator to enforce nonempty/typed values or permit `undefined`. Never read tenant/session state from these process-wide values. Existing Kit 2 projects retain their supported environment convention unless migration is requested.

Do not import private code into a component or universal loader, even indirectly. Within the project root and outside `node_modules`, `*.server.*` (including `server.ts`) is protected; a `server` directory is also protected except under the configured routes/assets directories (normally `src/routes` and `static`). External packages do not automatically gain this boundary from their filenames. Keep private module imports out of client/universal hooks and service workers too. **Anything returned from server `load` or an action is sent to the browser**. Never return tokens, password hashes or internal exception details.

Server `load` results must be serializable by Kit's `devalue` transport. Conservative results use plain objects, arrays, strings, numbers, booleans and null; Kit also supports types such as `Date`, `Map`, `Set` and `BigInt`. Do not return database clients, functions, DOM nodes or arbitrary class instances without a deliberately implemented transport. Use generated `PageServerLoad`, `PageLoad`, `PageProps` and `Actions` types from `./$types` rather than duplicating their shapes.

Sources: [load](https://svelte.dev/docs/kit/load), [server-only modules](https://svelte.dev/docs/kit/server-only-modules), [exact Kit 3.1.0 import guard](https://unpkg.com/@sveltejs/kit@3.1.0/src/exports/vite/plugins/guard.js), [environment variables](https://svelte.dev/docs/kit/environment-variables), [exact environment implementation](https://unpkg.com/@sveltejs/kit@3.1.0/src/core/env.js), [exact Kit 3 types](https://unpkg.com/@sveltejs/kit@3.1.0/types/index.d.ts).

## Global CSS, layout children and hydration

Import existing global CSS once in the root layout; do not scatter imports across route components. Skeleton 5 uses the framework CSS import, not the old optional-presets subpath or a Skeleton `node_modules` source scan.

`src/app.css`:
```css
@import 'tailwindcss';
@import '@skeletonlabs/skeleton';
@import '@skeletonlabs/skeleton-svelte';
@import '@skeletonlabs/skeleton/themes/cerberus';

/* Required when using Skeleton's styled native form utilities. */
@plugin '@tailwindcss/forms';
```

Install `@tailwindcss/forms@0.5.11` for those form utilities; it is not required for otherwise unstyled native forms. Presets are included in core; `@skeletonlabs/skeleton/optional/presets` is not exported. Remove only the obsolete Skeleton framework `@source` scan. Tailwind `@source` remains valid for shared application packages outside automatic detection; its paths are stylesheet-relative. Preserve existing custom themes and unrelated CSS.

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

Set a deterministic initial `data-theme` on `<html>` in `src/app.html`, matching an imported Skeleton theme. Keep the initial component tree and values identical between server render and hydration:

- Use `$props.id()` for component-instance IDs, with suffixes for related elements; never `Math.random()`, timestamps or a server-global incrementing counter for label/dialog IDs.
- Start preferences with the same SSR-safe default on both sides, then read browser storage or media queries after mount. Browser storage may be unavailable; treat it as optional, not an authentication or persistence authority.
- If the initial theme must match a user's saved preference without a flash, let the server read a validated cookie and emit the correct initial HTML attribute through the existing server/template integration. Return the same preference to the component tree. Cookie-specific rendering must not be shared across users in a public cache.
- A pre-hydration theme bootstrap must respect CSP and must not alter Svelte-owned markup into a different tree. Do not add an unreviewed inline script or generic client theme singleton just to hide a flash.
- CSS media queries can apply system preferences before hydration without reading browser globals in component initialization.

Sources: [Skeleton 5 installation](https://www.skeleton.dev/docs/svelte/get-started/installation/sveltekit), [Skeleton native forms](https://www.skeleton.dev/docs/svelte/tailwind-components/forms), [layout routing](https://svelte.dev/docs/kit/routing#layout), [props IDs](https://svelte.dev/docs/svelte/$props#props-id), [state management](https://svelte.dev/docs/kit/state-management), [server hooks and HTML transforms](https://svelte.dev/docs/kit/hooks#Server-hooks-handle).

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

In Kit 3, `update({ refreshAll: false })` replaces the deprecated `invalidateAll` update option; `update({ reset: false })` prevents a successful form reset when intended. `update({ navigate: false })` applies non-redirect cross-page results locally; redirects are still followed. `refreshAll: false` does not prevent destination loads during cross-page navigation. These are `update` options, not arguments to `$app/navigation`'s no-argument `refreshAll()`. Failed forms are not reset by default, but unenhanced failed POSTs need explicit returned values as above. Retained Kit 2 projects use their installed enhancement contract. Do not suppress errors or bypass forms with click-only handlers. Check the pair with JavaScript enabled and disabled: empty native rejection, whitespace-only server failure, raw overlength POST failure and success. Confirm exact failed text, field association/focus and no hydration warnings; see [accessibility.md](accessibility.md#concrete-verification-checklist) for the shared keyboard/motion/contrast criteria.

Named actions use `action="?/save"`; do not combine named and default actions on the same page. Keep private fields (passwords, tokens) out of failure data. File forms need `enctype="multipart/form-data"` for native submissions, plus server file validation. Authentication, authorization and persistence are application responsibilities, not styling or enhancement features.

Remote forms are an optional, separately verified API, not a reason to replace ordinary server actions or enable experimental switches for Skeleton. Exact Kit 3.1.0 declarations expose remote `form` from `$app/server`, typed `fields`/`fields.name.as(...)`, validation issues, schema preflight and a form-specific `.enhance(...)` method. If explicitly requested, verify their configuration, schema, native fallback and enhancement contract against the installed release; do not confuse that method with `use:enhance` from `$app/forms`.

Sources: [form actions](https://svelte.dev/docs/kit/form-actions), [exact Kit 3.1.0 forms/fail/redirect/error and remote-form types](https://unpkg.com/@sveltejs/kit@3.1.0/types/index.d.ts), [exact enhancement implementation](https://unpkg.com/@sveltejs/kit@3.1.0/src/runtime/app/forms/client.js), [Kit 3 enhancement changes](https://svelte.dev/docs/kit/migrating-to-sveltekit-3#$app-forms), [optional remote forms](https://svelte.dev/docs/kit/remote-functions#form).
