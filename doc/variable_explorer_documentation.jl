### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 32e9249c-e83e-11ee-0c7d-f3dd42ccea41
begin
	import Pkg; Pkg.offline(true)
	Pkg.add(url="https://github.com/JackDevine/PlutoVariableExplorer.jl")
	using PlutoVariableExplorer
end

# ╔═╡ 236ffc2b-6a2e-4023-b9dd-6d34ea2c5d4d
@bind r update_notebook()

# ╔═╡ de96465d-05a6-4946-b28a-0b73c42b7cf4
begin
    r
	cell_exprs = Expr[]
	
	notebook_cells = PlutoVariableExplorer.SimpleCell[PlutoVariableExplorer.SimpleCell(code) for code in cell_exprs]
    topology = PlutoVariableExplorer.PDE.NotebookTopology{PlutoVariableExplorer.SimpleCell}()
	
	explorer, topology, notebook_cells, cell_exprs = variable_explorer(topology, notebook_cells, cell_exprs, PlutoRunner; show_type=true)
	explorer
end

# ╔═╡ Cell order:
# ╠═32e9249c-e83e-11ee-0c7d-f3dd42ccea41
# ╠═236ffc2b-6a2e-4023-b9dd-6d34ea2c5d4d
# ╠═de96465d-05a6-4946-b28a-0b73c42b7cf4
