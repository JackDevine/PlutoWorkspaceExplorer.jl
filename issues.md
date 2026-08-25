# PlutoWorkspaceExplorer.jl — Known Issues

Below is a consolidated list of issues identified from reading the source code and documentation. Each issue is numbered for easy reference.

---

## Issue 1: `@workspace_explorer` macro cannot pass keyword arguments

**File**: `src/workspace_explorer.jl`, lines 192–207

The macro expands to a `@bind` block that calls `_workspace_explorer_with_trigger(mod)`, which in turn calls `workspace_explorer(mod; args...)`. But the macro itself does not accept any keyword arguments, so the only way to pass options like `show_type`, `exclude_dependencies`, or `show_pluto_modules` is the two-cell pattern described in the README.

**Impact**: Users lose the convenience of the single-cell macro when they need to customize any option.

**Possible fix**: Accept keyword arguments in the macro signature and forward them to the internal call.

---

## Issue 2: One-argument `workspace_explorer` starts from empty state every time

**File**: `src/workspace_explorer.jl`, lines 104–111

```julia
function workspace_explorer(mod; args...)
    cell_exprs = Expr[]
    notebook_cells = SimpleCell[SimpleCell(code) for code in cell_exprs]
    topology = PDE.NotebookTopology{SimpleCell}()
    workspace_explorer(topology, notebook_cells, cell_exprs, mod; args...)[1]
end
```

This convenience method always starts with **empty** topology, empty notebook cells, and empty cell expressions. It never picks up from a previous state, so every call recomputes the dependency graph from scratch.

**Impact**: Likely inefficient on large notebooks with many cells/variables, since there is no incremental update path.

**Possible fix**: Keep per-module state (e.g., a `Dict{Module,...}` of previous topology/cells) so that subsequent calls can do incremental updates via `notebook_topology`.

---

## Issue 3: `notebook_topology` accesses Pluto-internal fields that may change between versions

**File**: `src/workspace_explorer.jl`, lines 282–283

```julia
cell_exprs = [expr.expanded_expr
              for expr in values(mod.cell_expanded_exprs)]
```

This directly accesses `mod.cell_expanded_exprs` and the `.expanded_expr` field of each entry. This is a Pluto internal data structure — the `PlutoRunner` module or a workspace module may not have a consistent API across Pluto versions.

Also, the code relies on `mod.moduleworkspace_count.x` (line 316) to construct the workspace name:

```julia
workspace_name = Symbol("workspace#$(mod.moduleworkspace_count.x)")
```

**Impact**: The package may break silently when Pluto changes its internal module structure, particularly with the Pluto 1.x series.

**Possible fix**: Provide thin wrapper/fallback functions that probe for known Pluto internal structures, or document which Pluto versions are supported and gate on `Pluto.version`.

---

## Issue 4: Heuristic string-based checks are fragile

**File**: `src/workspace_explorer.jl`

Several functions use string matching to determine module membership:

- **`defined_in_notebook`** (line 233–235): checks `contains(string(symbol_module(sym, ws)), "Main.var")` — matches Pluto's internal naming convention for notebook workspace modules.
- **`show_symbol`** (line 269–273): checks `contains(string(sym), "workspace#")` to filter Pluto workspace modules.
- **`symbol_module`** (line 224–230): uses `which(ws, s)` in a try/catch, falling back to `Main` on error — but `which` may not behave as expected for all symbol types (e.g. DataType, Module).

**Impact**: These heuristics could produce false positives or false negatives if Pluto's naming conventions ever change, or for edge cases like user symbols containing `"workspace#"` in their name.

**Possible fix**: Explore Pluto's own exported API or documented introspection methods instead of string matching, and add a more robust is-pluto-module predicate.

---

## Issue 5: Variable type classification is based on `isa` checks, missing edge cases

**File**: `src/workspace_explorer.jl`, lines 346–360

```julia
is_variable = fill(false, size(definitions))
is_function = copy(is_variable)
is_datatype = copy(is_variable)
is_module = copy(is_variable)
for (i, variable) in enumerate(variables)
    if variable isa Function
        is_function[i] = true
    elseif variable isa Module
        is_module[i] = true
    elseif variable isa DataType
        is_datatype[i] = true
    else
        is_variable[i] = true
    end
end
```

- A variable that is `nothing` or was not resolved (line 318 catches errors and sets to `nothing`) gets classified as "variable" rather than being flagged as unresolved.
- A `DataType` that is also callable (like a constructor) is still shown only in the "Data types" section — no cross-reference.
- There is no category for constants or other kinds of bindings.
- The TODO on line 362 notes that `pluto_link` updates should be incremental, but they aren't.

**Impact**: Misclassification or missing entries can be mildly confusing; `nothing` variables clutter the "Variables" table.

**Possible fix**: Handle `nothing`/missing entries explicitly (show as "unresolved" or skip them). Consider adding annotations or filtering.

---

## Issue 6: `_embed_display` triple-branched fallback may miss some Pluto versions

**File**: `src/workspace_explorer.jl`, lines 51–59

```julia
function _embed_display(mod, x)
    if isdefined(mod, :embed_display)
        mod.embed_display(x)
    elseif isdefined(mod, :EmbeddableDisplay)
        mod.EmbeddableDisplay(x, join(rand('a':'z', 16)))
    else
        x
    end
end
```

This tries three strategies for embedding values in HTML output. The first branch (`embed_display`) was removed in Pluto 1.x; the second branch (`EmbeddableDisplay`) may have changed its constructor signature in newer Pluto releases. The fallback (raw `x`) loses Pluto's rich display for images, tables, etc.

**Impact**: Some values may not render with their rich Pluto multimedia display in newer Pluto versions.

**Possible fix**: Use `AbstractPlutoDingetjes`'s `Bonds.initial_value` or `PlutoRunner.embed_display` detection more robustly. Could also leverage `show(IOContext(...), MIME"text/html"(), x)` as a fallback.

---

## Issue 7: Tables.jl compatibility and the `variable_table` helper

**File**: `src/workspace_explorer.jl`, lines 215–221

```julia
function variable_table(cols...)
    col_names = collect(first.(cols))
    Tables.MatrixTable(col_names,
        Dict(c => i for (i, c) in enumerate(col_names)),
        hcat([c[2] for c in cols]...)
    )
end
```

This function is never actually used in the current code — the `render_variable_table` function builds HTML directly via `HypertextLiteral` rather than using the `Tables.jl` interface.

**Impact**: Dead code that could confuse maintainers. It also suggests the architecture might have shifted from a tables-based approach to direct HTML generation at some point, and this function wasn't cleaned up.

**Possible fix**: Remove the unused `variable_table` function (and its `Tables` dependency if nothing else uses it).

---

## Issue 8: Collapse/expand toggle width comparison uses string equality

**File**: `src/workspace_explorer.jl`, lines 457–468

```javascript
const collapsed_width = "32vw"
const expanded_width = "90vw"
span.style.width = collapsed_width
button.addEventListener("click", (e) => {
    if (span.style.width == collapsed_width) {
        span.style.width = expanded_width
        button.innerHTML = right_arrow
    } else {
        span.style.width = collapsed_width
        button.innerHTML = left_arrow
    }
})
```

The click handler compares `span.style.width` as a string. If any other code or style sheet sets the width in a different format (e.g., `"32vw"` → `"32vw "` with trailing whitespace, or resolved as a pixel value), the toggle breaks — both branches become collapsed.

**Impact**: Under some browser/environment conditions the expand/collapse button may stop working.

**Possible fix**: Use a boolean flag (e.g., `data-collapsed` attribute or a JavaScript boolean) instead of comparing CSS values as strings.

---

## Issue 9: Dependency/prependency graph may double-count or miss symbols

**File**: `src/workspace_explorer.jl`, lines 320–333

```julia
for var in keys(dependencies)
    dependencies[var] = union(
        dependencies[var],
        Set(Symbol(symbol_module(d, ws)) for d in dependencies[var])
    )
end
```

This adds the module name of each dependency as an extra symbol, which conflates "this variable references symbol `Foo`" with "this variable references module `Foo`". The resulting dependency/prependency tables mix symbols and module names, making the graph relationship unclear.

Also, multiple variables that depend on the same module name will all show the same module symbol in their dependency lists, which is noisy.

**Impact**: The dependency/prependency tables are harder to read than necessary, with a mix of actual symbol names and module names.

**Possible fix**: Separate the module-level dependencies into a distinct column, or keep them as tooltip annotations rather than first-class entries in the list.

---

## Summary

| # | Area | Severity | Description |
|---|------|----------|-------------|
| 1 | Macro | **Medium** | `@workspace_explorer` can't pass keyword arguments |
| 2 | Performance | **Medium** | No incremental state — recomputes everything every call |
| 3 | Compatibility | **High** | Relies on Pluto internal fields that may change |
| 4 | Robustness | **Medium** | String-based heuristics for module membership are fragile |
| 5 | UX | **Low** | Variable classification has edge cases with `nothing` values |
| 6 | Compatibility | **Medium** | `_embed_display` fallback may fail on some Pluto versions |
| 7 | Cleanup | **Low** | Unused `variable_table` function and `Tables` dep |
| 8 | Stability | **Low** | Expand/collapse toggle compares CSS values as strings |
| 9 | UX | **Low** | Dependency lists mix symbol names and module names |