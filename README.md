# PlutoVariableExplorer.jl

Interactively inspect your workspace values and topology in a [Pluto](https://github.com/fonsp/Pluto.jl) session.

# Usage

Create the following cells:
```julia
import PlutoVariableExplorer as PVE
```
```julia
@bind _update PVE.update_notebook()
```
```
_update; PVE.variable_explorer(PlutoRunner)
```
If you dont create the `_update` variable, then the variable explorer will only be updated when you run the cell that defined it. The `update_variable` will change every time that you press Shift+Enter.

Example view of the variable explorer:
![image](https://github.com/JackDevine/PlutoVariableExplorer.jl/assets/8610352/dc1f6cb2-2cef-47ca-b9ea-d9f1e1802fdc)

