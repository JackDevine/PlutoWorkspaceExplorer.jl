# PlutoWorkspaceExplorer.jl

Interactively inspect your workspace values and topology in a [Pluto](https://github.com/fonsp/Pluto.jl) session.

# Usage

Create the following cells:
```julia
import PlutoWorkspaceExplorer as PWE
```
```julia
PWE.@workspace_explorer PlutoRunner
```

That's it — a single cell shows the workspace explorer and updates it
automatically every time you run a cell (press `Shift+Enter`).

![image](https://github.com/JackDevine/PlutoVariableExplorer.jl/assets/8610352/dc1f6cb2-2cef-47ca-b9ea-d9f1e1802fdc)

https://github.com/JackDevine/PlutoVariableExplorer.jl/assets/8610352/e5a8c622-6086-44c1-a01e-e5965fccbd22

## Passing options

For the keyword arguments accepted by the explorer
(`show_type`, `exclude_dependencies`, `show_pluto_modules`), use the explicit
two-cell setup, where the second cell calls `workspace_explorer` directly:

```julia
import PlutoWorkspaceExplorer as PWE
```
```julia
@bind _update PWE.update_notebook()
```
```julia
_update; PWE.workspace_explorer(PlutoRunner; show_type=false,
    exclude_dependencies=[Base, Core], show_pluto_modules=false)
```

If you dont create the `_update` variable, then the workspace explorer will only
be updated when you run the cell that defined it. The `_update` variable will
change every time that you press Shift+Enter.

## How `@workspace_explorer` works

`@workspace_explorer PlutoRunner` expands (roughly) to:

```julia
@bind _pwe_update begin
    # a conditional self-reference: this makes the cell re-run whenever the
    # bound value changes, while still working on the first run (before
    # `_pwe_update` exists)
    isdefined(@__MODULE__, :_pwe_update) ? _pwe_update : nothing
    PlutoWorkspaceExplorer._workspace_explorer_with_trigger(PlutoRunner)
end
```

The returned widget listens for `Shift+Enter` and sets its own bound value,
which re-triggers the cell — a cell referencing its own bound variable is
allowed by Pluto — re-rendering the explorer with the current workspace state.
This bundles the trigger that previously required a separate `@bind` cell into
the explorer itself (see [issue #3](https://github.com/JackDevine/PlutoWorkspaceExplorer.jl/issues/3)).

## License
MIT license, see [LICENSE](LICENSE)
