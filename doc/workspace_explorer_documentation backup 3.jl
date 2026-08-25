### A Pluto.jl notebook ###
# v1.0.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 83633d03-c6a1-408b-86a4-4ae0bf692eb3
begin
    import PlutoWorkspaceExplorer as PWE
	using HypertextLiteral, Primes#, Symbolics
end

# ╔═╡ 44a6a78e-e6a3-4957-9549-84d192a11d83
md"""
Using the workspace explorer is a **one step** process: just call `@workspace_explorer` in a single cell. It updates automatically every time you run a cell (press `Shift+Enter`).

For keyword arguments (`show_type`, `exclude_dependencies`, `show_pluto_modules`), use the two-cell setup shown below, calling `workspace_explorer(PlutoRunner; ...)` directly.
"""

# ╔═╡ 236ffc2b-6a2e-4023-b9dd-6d34ea2c5d4d
PWE.@workspace_explorer PlutoRunner

# ╔═╡ 5ccaeff5-96f2-4f3a-a4b8-a58d8192bbda
# Optional: the explicit two-cell setup, useful for passing keyword arguments.
# @bind _update PWE.update_notebook()
# _update; PWE.workspace_explorer(PlutoRunner)

# ╔═╡ 9c13c584-a912-4f41-91d4-682398219895
x = 4

# ╔═╡ d9b387fa-e8c0-4165-a194-06f78b043179
y = x*22

# ╔═╡ 0bdfc314-20aa-41ac-aaf2-da1187a76a67
arr = randn(30, 30)*y

# ╔═╡ 77d3c0a6-e76e-4d2e-8eb0-bd36c88a6f1e
nested_dict = Dict(:x => x, :k => Dict(:y => y))

# ╔═╡ 890a0072-a4f1-45e6-9d7e-8d43bcffcda6
text = "Hello!"

# ╔═╡ 27a67c8c-fe4c-46f0-be7e-5dbb658898fa
h = @htl("""<h1 style="color: green">$(text)</h1>""")

# ╔═╡ b78b421f-3daa-40d6-9732-bedb0595acec
@syms α::Real β::Real

# ╔═╡ 56e65b46-c7a6-4cad-b73a-b0810b887db6
😀 = "Emojis are fine too 😀"

# ╔═╡ fe6a966e-235f-463f-98c4-327072ecaf3d
n = 1000

# ╔═╡ 1249e460-9ca4-4a6e-b302-3380e7c1e989
prime_product_error(n) = prod(p^2/(p^2-1) for p in primes(n)) - π^2/6

# ╔═╡ 1fc0f0d8-4217-4d8c-b55b-3be30ae88f0b
product_error = prime_product_error(n)

# ╔═╡ a476b103-a9df-4256-a0c5-78abbae10ffa
struct MyNewDataType end

# ╔═╡ Cell order:
# ╠═83633d03-c6a1-408b-86a4-4ae0bf692eb3
# ╟─44a6a78e-e6a3-4957-9549-84d192a11d83
# ╠═236ffc2b-6a2e-4023-b9dd-6d34ea2c5d4d
# ╠═5ccaeff5-96f2-4f3a-a4b8-a58d8192bbda
# ╠═0bdfc314-20aa-41ac-aaf2-da1187a76a67
# ╠═77d3c0a6-e76e-4d2e-8eb0-bd36c88a6f1e
# ╠═9c13c584-a912-4f41-91d4-682398219895
# ╠═d9b387fa-e8c0-4165-a194-06f78b043179
# ╠═890a0072-a4f1-45e6-9d7e-8d43bcffcda6
# ╠═27a67c8c-fe4c-46f0-be7e-5dbb658898fa
# ╠═b78b421f-3daa-40d6-9732-bedb0595acec
# ╠═56e65b46-c7a6-4cad-b73a-b0810b887db6
# ╠═fe6a966e-235f-463f-98c4-327072ecaf3d
# ╠═1249e460-9ca4-4a6e-b302-3380e7c1e989
# ╠═1fc0f0d8-4217-4d8c-b55b-3be30ae88f0b
# ╠═a476b103-a9df-4256-a0c5-78abbae10ffa
