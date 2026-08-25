# PlutoWorkspaceExplorer.jl — AI Benchmark Plan

## Goal

Fix 3 GitHub issues for PlutoWorkspaceExplorer.jl. Each fix gets its own git worktree/branch (for separate PRs), then an integration branch merges all three for local testing.

## Issues to fix

| # | GitHub Issue | Short description |
|---|-------------|-------------------|
| 1 | [#1 — Handle bound variables](https://github.com/JackDevine/PlutoWorkspaceExplorer.jl/issues/1) | Explorer only updates on Shift+Enter, not on interactive @bind changes |
| 2 | [#2 — Make updates more efficient](https://github.com/JackDevine/PlutoWorkspaceExplorer.jl/issues/2) | No caching — recomputes dependency graph from scratch every call |
| 4 | [#4 — Links work like the main notebook](https://github.com/JackDevine/PlutoWorkspaceExplorer.jl/issues/4) | Variable links jump to top of page; no Ctrl+Click, no selection/highlighting |

## Branch/Worktree layout

```
/fix-issue-1          worktree → fix #1 (bound variables)
/fix-issue-2          worktree → fix #2 (caching + benchmark)
/fix-issue-4          worktree → fix #4 (link behavior)
/integrate-issue-1-2-4  local branch merging all three (test only, not pushed)
```

All branches fork from `issue-3-single-cell-explorer` (current HEAD: `2f1139d`).

## Fix details

### Fix #1 — Handle bound variables

**File**: `src/workspace_explorer.jl`, function `_workspace_explorer_with_trigger`

**Approach**: Add a `MutationObserver` inside the existing `<script>` block that watches the Pluto notebook container (`document.querySelector("pluto-notebook")` or similar) for DOM mutations reflecting cell re-execution. When a mutation is detected, bump `span.value = null; span.dispatchEvent(new CustomEvent("input"))` to trigger re-evaluation. Clean up the observer via `invalidation.then(...)`.

### Fix #2 — Efficient updates

**File**: `src/workspace_explorer.jl`

**Approach**:
1. Add a mutable `Dict{Module, Tuple{topology, notebook_cells, cell_exprs}}` at module level
2. The 1-arg `workspace_explorer(mod; args...)` looks up previous state from this dict, passes to `notebook_topology` for incremental update, stores new state back
3. **Benchmark**: Write a Julia script (in `benchmark/` directory) that:
   - Creates N cells with varied variables
   - Measures cold-cache first render time
   - Measures warm-cache subsequent render times
   - Prints comparison

### Fix #4 — Links work like the main notebook

**File**: `src/workspace_explorer.jl`, functions `get_pluto_link_str` and `pluto_link`

**Approach**:
1. In `onclick`, check for `event.metaKey || event.ctrlKey` before following
2. After scrolling, find the target variable's cell with `document.querySelector("[id='<var>']").closest("pluto-cell").id`
3. Dispatch `window.dispatchEvent(new CustomEvent("cell_focus", {detail: {cell_id: ..., line: 0, definition_of: "<var>"}}))`
4. Update the anchor CSS/href attributes to match Pluto's native approach

## Integration branch

```bash
git checkout -b integrate-issue-1-2-4
git merge fix-issue-1
git merge fix-issue-2
git merge fix-issue-4
```

Test locally, do NOT push to origin.

---

*Snapshot created on 25 Aug 2025 for AI model benchmark comparison.*