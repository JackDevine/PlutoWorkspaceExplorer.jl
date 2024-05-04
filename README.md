# PlutoWorkspaceExplorer.jl

Interactively inspect your workspace values and topology in a [Pluto](https://github.com/fonsp/Pluto.jl) session.

# Usage

Create the following cells:
```julia
import PlutoWorkspaceExplorer as PWE
```
```julia
@bind _update PWE.update_notebook()
```
```
_update; PWE.workspace_explorer(PlutoRunner)
```
If you dont create the `_update` variable, then the workspace explorer will only be updated when you run the cell that defined it. The `_update` variable will change every time that you press Shift+Enter.

Example view of the workspace explorer:
![image](https://github.com/JackDevine/PlutoVariableExplorer.jl/assets/8610352/dc1f6cb2-2cef-47ca-b9ea-d9f1e1802fdc)

https://github.com/JackDevine/PlutoVariableExplorer.jl/assets/8610352/e5a8c622-6086-44c1-a01e-e5965fccbd22

