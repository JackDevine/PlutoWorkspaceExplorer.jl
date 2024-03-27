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

# ╔═╡ 384fbd82-8400-4d58-870a-282f7f4f6730
using PlutoLinks: @revise

# ╔═╡ 3b66f142-647a-4c3e-a650-0a45cbd85701
begin
	dir = "/root/Projects/PlutoVariableExplorer.jl"  # Change to location where your clone is
    using Pkg
    Pkg.activate(dir)
	Pkg.add(["HypertextLiteral", "Primes", "Symbolics"])
	
	@revise using PlutoVariableExplorer
	const PVE = PlutoVariableExplorer
	using HypertextLiteral, Primes, Symbolics
end

# ╔═╡ 236ffc2b-6a2e-4023-b9dd-6d34ea2c5d4d
@bind _update PVE.update_notebook()

# ╔═╡ 5ccaeff5-96f2-4f3a-a4b8-a58d8192bbda
_update; PVE.variable_explorer(PlutoRunner)

# ╔═╡ 9c13c584-a912-4f41-91d4-682398219895
x = 4

# ╔═╡ d9b387fa-e8c0-4165-a194-06f78b043179
y = x*22

# ╔═╡ 0bdfc314-20aa-41ac-aaf2-da1187a76a67
arr = randn(30, 30)*y

# ╔═╡ 77d3c0a6-e76e-4d2e-8eb0-bd36c88a6f1e
nested_dict = Dict(:x => x, :k => Dict(:y => y))

# ╔═╡ 890a0072-a4f1-45e6-9d7e-8d43bcffcda6
text = repeat(" hallo!", 3)

# ╔═╡ 27a67c8c-fe4c-46f0-be7e-5dbb658898fa
h = @htl("""<h1 style="color: green">$(text)</h1>""")

# ╔═╡ b78b421f-3daa-40d6-9732-bedb0595acec
@syms α::Real β::Real

# ╔═╡ 56e65b46-c7a6-4cad-b73a-b0810b887db6
😀 = "Emojis are fine too 😀"

# ╔═╡ fe6a966e-235f-463f-98c4-327072ecaf3d
n = 1000

# ╔═╡ 1249e460-9ca4-4a6e-b302-3380e7c1e989
prod_error = prod(p^2/(p^2-1) for p in primes(n)) - π^2/6

# ╔═╡ Cell order:
# ╠═384fbd82-8400-4d58-870a-282f7f4f6730
# ╠═3b66f142-647a-4c3e-a650-0a45cbd85701
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
