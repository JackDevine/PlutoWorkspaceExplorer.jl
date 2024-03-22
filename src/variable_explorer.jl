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

# ╔═╡ ba2e5540-daf7-11ee-2331-8dd584384545
begin
	using HypertextLiteral
	import PlutoDependencyExplorer as PDE
	import ExpressionExplorer as EE
	import Tables
	using PlutoUI
end

# ╔═╡ a9e313a8-3d7e-4aed-9155-e7edfbae7136
using Symbolics

# ╔═╡ 1d0c82c6-460a-4e2b-910f-d85023b11c6c
using Primes

# ╔═╡ ad8d2302-d50b-46fb-b46d-e5704e8e847b
function update_notebook()
	@htl(
	"""
	<span>
	<script>
	let span = currentScript.parentElement
	document.addEventListener("keydown", (e) => {
	    if (e.key == "Enter" && e.shiftKey) {
	        span.value = editor_state.notebook.cell_inputs
			span.dispatchEvent(new CustomEvent("input"))
			e.preventDefault()
	    }
	})
	span.value = {}
	</script>
	</span>
	""")
end

# ╔═╡ 38e73f37-447f-46d6-a4aa-948849e5cd08
@bind r update_notebook()

# ╔═╡ b3047049-a79f-4bf5-b973-cf4daca8d8dd
r

# ╔═╡ 20b7d347-8059-429a-b065-5fd2e8b4240a
begin
	# cell_exprs = [expr.expanded_expr
	#               for expr in values(PlutoRunner.cell_expanded_exprs)]
	
	# notebook_cells = [SimpleCell(code) for code in cell_exprs]
 #    topology = PDE.NotebookTopology{SimpleCell}()
end

# ╔═╡ dfd496ce-f776-446d-9be6-f1613ffeef56
th(n) = @htl("""<th>$n</th>""")

# ╔═╡ 4d13e91d-8bc0-49e0-9aa2-a933079697c0
begin
    td(n) = @htl("""<td><div><pre class="no-block">$n</pre></div></td>""")
	# td(n) = @htl("""
	# <td>
	#   <div>
	#     <div class="raw-html-output">
	#       $n
	#     </div>
	#   </div>
	# </td>""")
end

# ╔═╡ 90298b52-5ce2-4d9b-af79-427dc4f9c401
function render_variable_table_row(ind, data...)
	@htl("""
	<tr>$((td(embed_display(data[j][ind])) for j in eachindex(data)))</tr>
	""")
end

# ╔═╡ f4558a2f-c73e-4ecb-8431-5efb39627084
function render_variable_table(t)
	headers = keys(t)
	data = values(t)
	n = length(first(data))
	@htl("""
	<style>
	table.pluto-table .variable-schema-names th {
	    background-color: white;
	    position: sticky;
	    top: calc(0.5rem - var(--pluto-cell-spacing));
	    height: 2rem;
	    z-index: 1;
	}
	
	</style>
	<table class="pluto-table">
	<thead><tr class="variable-schema-names">$((th(x) for x in headers))</tr></thead>
	<tbody>
	$((render_variable_table_row(i, data...) for i in 1:n))
	</tbody>
	</table>
	""")
end

# ╔═╡ 092f419c-1b79-4bc1-b499-3dfce9d7edc7
# @htl(
# """
# $(@bind r update_notebook())
# $(variable_explorer())
# """
# )

# ╔═╡ cdb0a858-1dd0-403a-8007-ea77e0df3289
# @bind n update_notebook()

# ╔═╡ df16c77e-efff-4028-a07a-6fc692e7b62e
let
	# n
	# display(@bind _ update_notebook())
    # variable_explorer()
end

# ╔═╡ b8029441-1e4c-438b-a76e-d29351270545
# function variable_explorer()
# 	@htl("""
# 	<style>
# 	.aside {
# 	    position: fixed;
# 	    top: 5rem;
# 	    right: 1rem;
# 	}
# 	</style>
	
# 	<div class="aside">
# 	<script>
# 	const cell_inputs = editor_state.notebook.cell_inputs
# 	const julia_variables = $(AbstractPlutoDingetjes.Display.with_js_link(notebook_topology))
		
# 	// I can now call sqrt_from_julia like a JavaScript function. It returns a Promise:
# 	//const result = await sqrt_from_julia(9.0)
# 	//console.log(result)
# 	const variables = await julia_variables()
# 	function variable_explorer_table(vars) {
# 	    //const variables = await julia_variables()
# 	    return `
# 	    <table>
# 			<tr><th>Name</th><th>Value</th></tr>
# 			<tr><td>x</td><td>3</td></tr>
# 		</table>`
# 	}
#     const div = currentScript.parentElement
# 	div.innerHTML = variable_explorer_table(3)
	
# 	</script>
# 	Hallo
# 	</div>
# 	""")
# end
	

# ╔═╡ 871ff609-47a1-45dd-94d7-baf0829f297b
# variable_explorer()

# ╔═╡ b9bc658e-50a7-4860-b848-e8cda7f93e11
begin
	struct SimpleCell <: PDE.AbstractCell
		code
		expanded_expr
	end
	SimpleCell(code::Expr) = SimpleCell(string(code), code)
end

# ╔═╡ 8cf59e08-91c1-4ddf-8176-52db345b5f97
begin
    r
	cell_exprs = Expr[]
	
	notebook_cells = SimpleCell[SimpleCell(code) for code in cell_exprs]
    topology = PDE.NotebookTopology{SimpleCell}()
	# explorer, topology, notebook_cells, cell_exprs = variable_explorer(topology, notebook_cells, cell_exprs; show_type=true)
	# explorer
end

# ╔═╡ 7e63e520-7d60-4b6e-8668-b4efa4577948
function get_function_definitions(cell)
	cell.funcdefs_without_signatures
end

# ╔═╡ aa0457b7-eb46-416e-8619-5e98babb4c91
begin
	get_pluto_link_str(s) = """<a href="#$s"><span class="ͼo ͼ12">$s</span></a>"""
	
	function pluto_link(sym)
		s = string(sym)
		pluto_link_str = get_pluto_link_str(s)
		HTML(pluto_link_str)
	end
	
	function pluto_link(sym, t)
		s = string(sym)
		# @htl("""
		# <a title="Ctrl-Click to jump to the definition of $s." data-pluto-variable="$s" href="#$s"><span class="ͼo ͼ12">$s</span></a>
		# """)

		pluto_link_str = get_pluto_link_str(s)
		HTML(pluto_link_str*"""<span class="ͼo ͼ14">::</span><span class="ͼo ͼ13">$(t)</span>""")
	end
end

# ╔═╡ 4b595e45-2b87-4a9c-bb79-fe558ccbea8a
function variable_table(cols...)
	col_names = collect(first.(cols))
	Tables.MatrixTable(col_names,
		Dict(c => i for (i, c) in enumerate(col_names)),
		hcat([c[2] for c in cols]...)
	)
end

# ╔═╡ 53a03bbe-eb49-46bd-8a36-6a972e221ba9
function symbol_module(s, ws)
	try
		which(ws, s)
	catch
		Main
	end
end

# ╔═╡ 4cc19a3e-9619-4eec-b24a-6a362eb31fce
function notebook_topology(old_topology, old_notebook, old_cells; show_type=true)
	cell_exprs = [expr.expanded_expr
	              for expr in values(PlutoRunner.cell_expanded_exprs)]
	updated_cell_exprs = setdiff(cell_exprs, old_cells)
	deleted_cells = setdiff(old_cells, cell_exprs)
	
	updated_notebook_cells = SimpleCell[SimpleCell(code) for code in updated_cell_exprs]
	
	
	# @time topology = PDE.updated_topology(
	# 	old_topology,
	# 	old_notebook,
	# 	updated_notebook_cells;
	
	# 	get_code_str = c -> c.code,
	# 	get_code_expr = c -> c.expanded_expr,
	# )
	# topology = PDE.updated_topology(
	# 	old_topology,
	# 	SimpleCell.(cell_exprs),
	# 	SimpleCell.(cell_exprs);
	
	# 	get_code_str = c -> c.code,
	# 	get_code_expr = c -> c.expanded_expr,
	# )
	topology = PDE.updated_topology(
		old_topology,
		[old_notebook; updated_notebook_cells],
		updated_notebook_cells;
	
		get_code_str = c -> c.code,
		get_code_expr = c -> c.expanded_expr,
	)
	

	ordered_cells = PDE.topological_order(topology).runnable
	cell_nodes = [EE.compute_reactive_node(c.expanded_expr) for c in ordered_cells]
	
	definitions = Symbol[]
	prependencies = Dict{Symbol,Set{Symbol}}()
	dependencies = Dict{Symbol,Set{Symbol}}()
	for c in cell_nodes
		cell_definitions = c.definitions
		cell_references = c.references
		cell_funcdefs = get_function_definitions(c)
		all_definitions = union(cell_definitions, cell_funcdefs)
		append!(definitions, all_definitions)
		
		for def in all_definitions
			dependencies[def] = cell_references
		end
	end
	
	workspace_name = Symbol("workspace#$(PlutoRunner.moduleworkspace_count.x)")
	ws = getfield(Main, workspace_name)
	variables = [try getfield(ws, var) catch nothing end for var in definitions]

	for var in keys(dependencies)
		dependencies[var] = union(
			dependencies[var],
			Set(Symbol(symbol_module(d, ws)) for d in dependencies[var])
		)
	end
	for (var, deps) in dependencies
		for d in deps
			prependencies[d] = union(
				get(prependencies, d, Set{Symbol}()),
				Set([var])
			)
		end
	end
	
	dependency_list = [pluto_link.(get(dependencies, def, Set(Symbol[]))) for def in definitions]
	prependency_list = [pluto_link.(get(prependencies, def, Set(Symbol[]))) for def in definitions]

	is_variable = fill(false, size(definitions))
	is_function = copy(is_variable)
	is_module = copy(is_variable)
    for (i, variable) in enumerate(variables)
		if variable isa Function
			is_function[i] = true
		elseif variable isa Module
			is_module[i] = true
		else
			is_variable[i] = true
		end
	end

	# TODO only update pluto links that have changed
	variable_definition_html = if show_type
		pluto_link.(definitions[is_variable], typeof.(variables[is_variable]))
	else
		pluto_link.(definitions[is_variable])
	end

	# v = variable_table(:Name => variable_definition_html,
	# 	:Value => variables[is_variable],
	# 	:Dependencies => dependency_list[is_variable],
	# 	:Prependencies => prependency_list[is_variable]
	# ) |> embed_display
	v = render_variable_table(
		(;Name = variable_definition_html,
		Value = variables[is_variable],
		Dependencies = dependency_list[is_variable],
		Prependencies = prependency_list[is_variable])
	)
 #    f = variable_table(:Name => pluto_link.(definitions[is_function]),
	# 	:Dependencies => dependency_list[is_function],
	# 	:Prependencies => prependency_list[is_function]
	# )
	f = render_variable_table(
		(;Name = pluto_link.(definitions[is_function]),
		Dependencies = dependency_list[is_function],
		Prependencies = prependency_list[is_function])
	)
	# m = embed_display(pluto_link.(definitions[is_module]))
	m = render_variable_table(
		(;Name = pluto_link.(definitions[is_module]),
		Prependencies = prependency_list[is_module])
	)
	
	v, f, m, topology, updated_notebook_cells, cell_exprs
end

# ╔═╡ 6d97aaae-f1e4-47e5-a376-19b87f48df7f
function variable_explorer(old_topology, old_notebook, old_cells; show_type=true)
	variables, functions, modules, new_topology, new_notebook, new_cells = notebook_topology(
		old_topology, old_notebook, old_cells;
		show_type
	)
	variable_explorer_html = @htl(
	"""
	<span class="aside">
		<style>
		.aside {
			position: fixed;
			top: 4rem;
			right: 1rem;
		    overflow: scroll;
			width: 32vw;
			padding: 0.5rem;
			padding-top: 0em;
			border-radius: 10px;
			max-height: calc(100vh - 5rem - 90px);
			overflow: auto;
			z-index: 40;
		    background-color: var(--main-bg-color);
		}
		.expand-collapse {
		    position: sticky;
		    top: 0;
		    z-index: 41;
		    background-color: var(--main-bg-color);
		    border-color: black;
		    border-width: 0px;
		    border-radius: 8px;
		    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Cantarell, "Apple Color Emoji",
			"Segoe UI Emoji", "Segoe UI Symbol", system-ui, sans-serif;
		}
		</style>
	
		<button class="expand-collapse">
		</button>
		<h4>Variables</h4>$(variables)
		<h4>Functions</h4>$(functions)
		<h4>Modules</h4>$(modules)
	
		<script>
		    const left_arrow = `<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-back-outline.svg" style="height: 1.5em; width: 1.5em;">`
			const right_arrow = `<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-forward-outline.svg" style="height: 1.5em; width: 1.5em">`
			const span = currentScript.parentElement
			const button = span.querySelector("button")
			button.innerHTML = left_arrow
		
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
		</script>
	</span>
	""")
	variable_explorer_html, new_topology, new_notebook, new_cells
end

# ╔═╡ e89b9049-b557-4cae-b520-faa8c2ede58d
let
    d = notebook_topology(topology, notebook_cells, cell_exprs; show_type=true)
	# [parentmodule.(v) for v in values(d)]
	# parentmodule.(d)
	workspace_name = Symbol("workspace#$(PlutoRunner.moduleworkspace_count.x)")
	ws = getfield(Main, workspace_name)
	ws_definitions = Set(names(getfield(PlutoRunner.Main, workspace_name), imported = true))
	# which(ws, Symbol("@htl"))
	# function symbol_module(s, ws, ws_defintions)
	# 	(s in ws_definitions) && return Main
	# 	try
	# 	    which(ws, s)
	# 	catch
	# 		Main
	# 	end
	# end
	# Dict(k => [symbol_module(s, ws, ws_definitions) for s in v] for (k, v) in d)
end

# ╔═╡ d56bc150-a70a-423d-abb1-014dd7b60e30
names(PlutoRunner, all = true)

# ╔═╡ 96a7123e-fb97-49db-89b8-079ad89203f4
names(PlutoRunner.Main)

# ╔═╡ f0409d12-cdd9-4f0c-b5ec-c737c06e9407
@bind x Slider(LinRange(-1, 1, 100))

# ╔═╡ 2ab2ba22-002b-4787-819a-13303ef10696
y = 400*x

# ╔═╡ efed74f4-d689-46d8-9138-41634fb47d0b
foobar = 4

# ╔═╡ 808bf0ea-088f-4a26-8940-a9fe7939d259
baz = 55*x*y*foobar

# ╔═╡ 9f492370-f6c3-47d7-9180-6edadbc4b0bd
z = x*y*randn(50, 50)

# ╔═╡ e203d1c5-3e03-4711-9fc9-8996bb54c82c
# GC.gc()

# ╔═╡ 0f4b2e48-df18-44b0-83ee-08eacbdbc310
text = repeat("hallo!! ", 2)

# ╔═╡ 9f98c90a-1e19-4789-89db-b6ad2275f296
h = @htl("""<h1 style="color: green">$(text)</h1>""")

# ╔═╡ 5ab8cf23-cf08-4c99-ae93-25d3d164108a
bar = Dict(:k => x, :d => Dict(:k2 => y, :k3 => Dict(:k => 3)))

# ╔═╡ 37836c9a-be21-4c70-8527-6500aae1a2fe
@bind b Slider(LinRange(-2, 2, 100))

# ╔═╡ b7c4ea8d-1b69-42e0-a3e2-f0905f8117f2
bb = b*35

# ╔═╡ f69bbd3d-4117-4ce3-bb26-739f676cefda
😀 = "Emojis are fine too 😀"

# ╔═╡ 589afc9c-4f08-4424-8331-370aa3925b5a
@syms α::Real β::Real

# ╔═╡ 9f3fe317-e78c-43ce-bd0a-2d44441b51fa
δ = α*β^2

# ╔═╡ cccd3947-db5f-43de-b4c0-bcb441b894c5
δ/α

# ╔═╡ cf37c69f-827b-4418-929b-60298a86aec2
@syms temperature

# ╔═╡ c461b2cd-6dfc-447d-8417-0ef4e272d399
let
    workspace_name = Symbol("workspace#$(PlutoRunner.moduleworkspace_count.x)")
	ws = getfield(Main, workspace_name)
	PlutoRunner.binding_from(:x, ws)
	# PlutoRunner.registered_bond_elements[:b]
end

# ╔═╡ 89f0b442-e066-4612-9903-a4b953784cc5
foldable = @htl("""
<details style="border: 0px">
	<summary>
	Hi
	</summary>
Hallo
</details>
""")

# ╔═╡ dce84d13-b036-47f0-b07a-50f25c50d495
n = 1000

# ╔═╡ 8ab324e8-5bc3-4957-8d1f-2cf770ef6ca9
prod_error = prod(p^2/(p^2-1) for p in primes(n)) - π^2/6

# ╔═╡ 9f3fddee-0e42-423f-b5db-b4522c6ff3e1
# counter = begin
# 	state, set_state = @use_state(0)

# 	@use_effect([]) do
# 		schedule(Task() do
# 			while true
# 				sleep(1)
# 				set_state(function(previous_state)
# 					previous_state + 1
# 				end)
# 			end
# 		end)

# 		# In the real world this should also return a cleanup function,
# 		# More on that in the docs for @use_effect
# 	end

# 	state
# end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ExpressionExplorer = "21656369-7473-754a-2065-74616d696c43"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoDependencyExplorer = "72656b73-756c-7461-726b-72656b6b696b"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[compat]
ExpressionExplorer = "~1.0.0"
HypertextLiteral = "~0.9.5"
PlutoDependencyExplorer = "~1.0.3"
PlutoUI = "~0.7.58"
Primes = "~0.5.6"
Symbolics = "~5.22.1"
Tables = "~1.11.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "4ddbcc0c9a22ef2268b00ffa8328a83715ee4414"

[[deps.ADTypes]]
git-tree-sha1 = "41c37aa88889c171f1300ceac1313c06e891d245"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.2.6"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "e2a9873379849ce2ac9f9fa34b0e37bde5d5fe0a"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "881e43f1aa014a6f75c8fc0847860e00a1500846"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.8.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bijections]]
git-tree-sha1 = "c9b163bd832e023571e86d0b90d9de92a9879088"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.6"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.CompositeTypes]]
git-tree-sha1 = "02d2316b7ffceff992f3096ae48c7829a8aa0638"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.3"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "0f4b5d62a88d8f59003e43c25a8a90de9eb76317"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.18"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "15b469c178ecfbdc1ca5608d8bb5b4ae6cb1352d"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.7.8"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.DynamicPolynomials]]
deps = ["Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "0bb0a6f812213ecc8fbbcf472f4a993036858971"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.5.5"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "bce17cd0180a75eec637d6e3f8153011b8bdb25a"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.0.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Format]]
git-tree-sha1 = "f3cf88025f6d03c194d73f5d13fee9004a108329"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.6"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "d1f981fba6eb3ec393eede4821bca3f2b7592cd4"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.15.1"

[[deps.LambertW]]
git-tree-sha1 = "c5ffc834de5d61d00d2b0e18c96267cffc21f648"
uuid = "984bce1d-4616-540c-a9ee-88d1112d94c9"
version = "0.4.6"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cad560042a7cc108f5a4c24ea1431a9221f22c1b"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.2"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "769c9175942d91ed9b83fa929eee4fe6a1d128ad"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.5.4"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "302fd161eb1c439e4115b51ae456da4e9984f130"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.4.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "dd77d591d2f72c49541dfd245630b3535b4ff7c4"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.0.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "71a22244e352aa8c5f0f2adde4150f62368a3f2e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.58"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff"]
git-tree-sha1 = "b6665214f2d0739f2d09a17474dd443b9139784a"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.20"

    [deps.PreallocationTools.extensions]
    PreallocationToolsReverseDiffExt = "ReverseDiff"

    [deps.PreallocationTools.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "SparseArrays", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "dc428bb59c20dafd1ec500c3432b9e3d7e78e7f3"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.10.1"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "6aacc5eefe8415f47b3e34214c1d79d2674a0ba2"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.12"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "3a281a9fce9cd62b849d7f16e412933a5fe755cb"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.29.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseMakieExt = "Makie"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools", "Setfield", "SparseArrays", "StaticArraysCore"]
git-tree-sha1 = "10499f619ef6e890f3f4a38914481cc868689cd5"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.8"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.SymbolicIndexingInterface]]
git-tree-sha1 = "251bb311585143931a306175c3b7ced220300578"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.8"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "TimerOutputs", "Unityper"]
git-tree-sha1 = "849b1dfb1680a9e9f2c6023f79a49b694fb6d0da"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "1.5.0"

[[deps.Symbolics]]
deps = ["ArrayInterface", "Bijections", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "DynamicPolynomials", "ForwardDiff", "IfElse", "LaTeXStrings", "LambertW", "Latexify", "Libdl", "LinearAlgebra", "LogExpFunctions", "MacroTools", "Markdown", "NaNMath", "PrecompileTools", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "SymbolicUtils"]
git-tree-sha1 = "febe1df0dc665c874cbf6fd88283603201749509"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "5.22.1"

    [deps.Symbolics.extensions]
    SymbolicsGroebnerExt = "Groebner"
    SymbolicsPreallocationToolsExt = "PreallocationTools"
    SymbolicsSymPyExt = "SymPy"

    [deps.Symbolics.weakdeps]
    Groebner = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
    PreallocationTools = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f548a9e9c490030e545f72074a41edfd0e5bcdd7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.23"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unityper]]
deps = ["ConstructionBase"]
git-tree-sha1 = "25008b734a03736c41e2a7dc314ecb95bd6bbdb0"
uuid = "a7c27f48-0311-42f6-a7f8-2c11e75eb415"
version = "0.1.6"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═ba2e5540-daf7-11ee-2331-8dd584384545
# ╠═a9e313a8-3d7e-4aed-9155-e7edfbae7136
# ╠═6d97aaae-f1e4-47e5-a376-19b87f48df7f
# ╠═ad8d2302-d50b-46fb-b46d-e5704e8e847b
# ╠═b3047049-a79f-4bf5-b973-cf4daca8d8dd
# ╠═38e73f37-447f-46d6-a4aa-948849e5cd08
# ╠═20b7d347-8059-429a-b065-5fd2e8b4240a
# ╠═8cf59e08-91c1-4ddf-8176-52db345b5f97
# ╠═dfd496ce-f776-446d-9be6-f1613ffeef56
# ╠═4d13e91d-8bc0-49e0-9aa2-a933079697c0
# ╠═90298b52-5ce2-4d9b-af79-427dc4f9c401
# ╠═f4558a2f-c73e-4ecb-8431-5efb39627084
# ╠═092f419c-1b79-4bc1-b499-3dfce9d7edc7
# ╠═cdb0a858-1dd0-403a-8007-ea77e0df3289
# ╠═df16c77e-efff-4028-a07a-6fc692e7b62e
# ╠═b8029441-1e4c-438b-a76e-d29351270545
# ╠═871ff609-47a1-45dd-94d7-baf0829f297b
# ╠═b9bc658e-50a7-4860-b848-e8cda7f93e11
# ╠═7e63e520-7d60-4b6e-8668-b4efa4577948
# ╠═aa0457b7-eb46-416e-8619-5e98babb4c91
# ╠═4b595e45-2b87-4a9c-bb79-fe558ccbea8a
# ╠═53a03bbe-eb49-46bd-8a36-6a972e221ba9
# ╠═4cc19a3e-9619-4eec-b24a-6a362eb31fce
# ╠═e89b9049-b557-4cae-b520-faa8c2ede58d
# ╠═d56bc150-a70a-423d-abb1-014dd7b60e30
# ╠═96a7123e-fb97-49db-89b8-079ad89203f4
# ╠═f0409d12-cdd9-4f0c-b5ec-c737c06e9407
# ╠═2ab2ba22-002b-4787-819a-13303ef10696
# ╠═efed74f4-d689-46d8-9138-41634fb47d0b
# ╠═808bf0ea-088f-4a26-8940-a9fe7939d259
# ╠═9f492370-f6c3-47d7-9180-6edadbc4b0bd
# ╠═e203d1c5-3e03-4711-9fc9-8996bb54c82c
# ╠═0f4b2e48-df18-44b0-83ee-08eacbdbc310
# ╠═9f98c90a-1e19-4789-89db-b6ad2275f296
# ╠═5ab8cf23-cf08-4c99-ae93-25d3d164108a
# ╠═37836c9a-be21-4c70-8527-6500aae1a2fe
# ╠═b7c4ea8d-1b69-42e0-a3e2-f0905f8117f2
# ╠═f69bbd3d-4117-4ce3-bb26-739f676cefda
# ╠═589afc9c-4f08-4424-8331-370aa3925b5a
# ╠═9f3fe317-e78c-43ce-bd0a-2d44441b51fa
# ╠═cccd3947-db5f-43de-b4c0-bcb441b894c5
# ╠═cf37c69f-827b-4418-929b-60298a86aec2
# ╠═c461b2cd-6dfc-447d-8417-0ef4e272d399
# ╠═89f0b442-e066-4612-9903-a4b953784cc5
# ╠═1d0c82c6-460a-4e2b-910f-d85023b11c6c
# ╠═dce84d13-b036-47f0-b07a-50f25c50d495
# ╠═8ab324e8-5bc3-4957-8d1f-2cf770ef6ca9
# ╠═9f3fddee-0e42-423f-b5db-b4522c6ff3e1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
