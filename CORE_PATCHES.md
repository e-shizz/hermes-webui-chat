# Required Hermes Core Patches

This plugin includes **upstream dashboard patches** that fix plugin route layout and styling in the Hermes Agent core dashboard frontend. These patches benefit **all dashboard plugins** — not just WebUI — and are maintained here for convenience.

They live in `patches/` as standalone `.patch` files and are applied after each `hermes upgrade`.

## Patch Files

| Patch | File | Purpose |
|-------|------|---------|
| `0001-dashboard-plugin-route-flex-layout.patch` | `web/src/App.tsx` | Plugin routes get `min-h-0 flex flex-1 flex-col` so plugins can use `h-full` for viewport-filling layouts. Previously only `/chat` and `/docs` got flex treatment; plugin routes got plain `w-full min-w-0` which broke height calculations. |
| `0002-dashboard-sessions-page-resume-button.patch` | `web/src/pages/SessionsPage.tsx` | Adds "Resume in Web Chat" button (MessageSquare icon) that deep-links to `/webui?resume=<id>`. Makes it easy to jump from the sessions list into a chat. |
| `0003-dashboard-code-background-fix.patch` | `web/src/index.css` | Fixes a dashboard-wide bug where `@nous-research/ui`'s `SelectionSwitcher` cycles `--selection-bg` through rainbow colors on every text selection / Ctrl+A, causing all inline `<code>` elements to flash. The fix gives inline code a static readable background while keeping code blocks (`pre.hljs`) transparent so `hljs` syntax highlighting and the container's glass effect work correctly. |

> **Upstream PR:** https://github.com/NousResearch/hermes-agent/pull/15819 
> If/when these patches merge upstream, they can be deleted from `patches/`.

## How to Apply (after `hermes upgrade`)

```bash
cd ~/.hermes/plugins/webui
./scripts/apply-core-patches.sh
```

This will:
1. Detect which patches are missing
2. Apply them cleanly via `git apply`
3. Rebuild the web frontend (`npm run build`)

Patches are **idempotent** — already-applied patches are safely skipped.

## Why Patches Instead of Fork Commits?

Previously these changes were maintained as commits on a `feature/webui-chat`
branch in a forked `hermes-agent` repo. This broke every upgrade because:
- `hermes upgrade` resets `main` to `origin/main`
- Fork branch commits become dangling
- Cherry-picking was error-prone and messy

The patch-based workflow keeps **all plugin-related changes in the plugin repo**,
where they belong. After any upgrade, run one script and you're back in business.

## Adding a New Patch

1. Make the change in `~/.hermes/hermes-agent/web/src/...`
2. `cd ~/.hermes/hermes-agent && git diff web/src/SomeFile.tsx > ~/.hermes/plugins/webui/patches/000X-description.patch`
3. Test: `./scripts/apply-core-patches.sh`
4. Commit the new patch file to the plugin repo

## Removing a Patch

If upstream Hermes merges the fix natively, the applier will skip it
(`Already applied`). Delete the patch file from `patches/` once you confirm
it's no longer needed.
