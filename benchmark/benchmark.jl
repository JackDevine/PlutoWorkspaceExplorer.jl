#!/usr/bin/env julia
#=##############################################################################
# benchmark.jl — Performance benchmarks for PlutoWorkspaceExplorer.jl caching
#
# Usage in a Pluto notebook or REPL:
#   julia --project=. benchmark/benchmark.jl
#
# This benchmark measures the performance improvement from the _TOPOLOGY_CACHE
# introduced in Fix #2 (GitHub issue #2). It directly benchmarks the core
# topology update logic that the cache enables.
#
# To run within the PlutoWorkspaceExplorer package context:
#   1. cd to the package root
#   2. julia --project=. -e 'include("benchmark/benchmark.jl")'
#
# The benchmark simulates incremental notebook updates by generating synthetic
# cell expressions and measuring PlutoDependencyExplorer's updated_topology.
#=##############################################################################

using Printf
using Random
using PlutoDependencyExplorer
using ExpressionExplorer

# -----------------------------------------------------------------------------
# Synthetic data generation
# -----------------------------------------------------------------------------

"""Generate a synthetic cell expression defining `n` unique variables."""
function gen_cell_expr(n::Int, seed_vars::Vector{Symbol}=Symbol[])
    vars = [Symbol("x_$(rand(0x0000:0xffff), hex)") for _ in 1:n]
    exprs = [Expr(:(=), v, rand()) for v in vars]
    length(exprs) == 1 && return exprs[1]
    return Expr(:block, exprs...)
end

"""Build a specification of a notebook with `n_cells` cells, each defining `vars_per_cell` variables."""
function gen_notebook_spec(n_cells::Int, vars_per_cell::Int)
    [gen_cell_expr(vars_per_cell) for _ in 1:n_cells]
end

"""A struct mimicking SimpleCell for benchmarking the topology pipeline."""
struct BenchCell
    code::String
    expanded_expr::Expr
end
BenchCell(code::Expr) = BenchCell(string(code), code)

"""Compute topology from a list of cell expressions."""
function compute_topology(cell_exprs::Vector{Expr})
    cells = [BenchCell(ce) for ce in cell_exprs]
    topo = NotebookTopology{BenchCell}()
    topo = updated_topology(topo, cells, cells;
        get_code_str = c -> c.code,
        get_code_expr = c -> c.expanded_expr,
    )
    return topo, cells
end

"""Incrementally update topology with new cells."""
function incremental_update(old_cells::Vector{BenchCell}, old_topo::NotebookTopology, new_cell_exprs::Vector{Expr})
    new_cells = [BenchCell(ce) for ce in new_cell_exprs]
    all_cells = [old_cells; new_cells]
    topo = updated_topology(old_topo, all_cells, new_cells;
        get_code_str = c -> c.code,
        get_code_expr = c -> c.expanded_expr,
    )
    return topo, all_cells
end

# -----------------------------------------------------------------------------
# Benchmarking
# -----------------------------------------------------------------------------

"""Time a function in seconds (best of 3, GC before each)."""
function bench_time(f, trials=3)
    times = Float64[]
    for _ in 1:trials
        GC.gc()
        start = time_ns()
        f()
        push!(times, (time_ns() - start) / 1e9)
    end
    return minimum(times), mean(times)
end

"""Run a full benchmark scenario."""
function run_scenario(name::String, init_exprs::Vector{Expr}, update_exprs::Vector{Expr})
    println("\n" ^ 1)
    println("─"^ 72)
    println("Scenario: $name")
    println("  Initial cells:  $(length(init_exprs))")
    println("  Update cells:   $(length(update_exprs))")
    println("─"^ 72)

    # --- Cold: compute everything from scratch ---
    cold_min, cold_avg = bench_time() do
        compute_topology(init_exprs)
    end
    @printf("  Cold (full build):     min=%.4fs  avg=%.4fs\n", cold_min, cold_avg)

    # --- First actual run to populate caches (not measured) ---
    topo_state, cell_state = compute_topology(init_exprs)

    # --- Warm: no changes (empty diff) ---
    warm_nc_min, warm_nc_avg = bench_time() do
        incremental_update(cell_state, topo_state, Expr[])
    end
    @printf("  Warm (no change):      min=%.4fs  avg=%.4fs\n", warm_nc_min, warm_nc_avg)

    # --- Warm: with updates ---
    warm_up_min, warm_up_avg = bench_time() do
        incremental_update(cell_state, topo_state, update_exprs)
    end
    @printf("  Warm (+update cells):  min=%.4fs  avg=%.4fs\n", warm_up_min, warm_up_avg)

    speedup_hit = cold_avg > 0 ? cold_avg / max(warm_nc_avg, 1e-12) : 0.0
    speedup_inc = cold_avg > 0 ? cold_avg / max(warm_up_avg, 1e-12) : 0.0
    @printf("  Speedup (warm-hit / cold): %.1fx\n", speedup_hit)
    @printf("  Speedup (warm-inc / cold): %.1fx\n", speedup_inc)

    return cold_avg, warm_nc_avg, warm_up_avg
end

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

function main()
    println("=" ^ 72)
    println("PlutoWorkspaceExplorer.jl — Topology Cache Benchmark")
    println("Date: $(now())")
    println("Julia: $(VERSION)")
    println("PDE: $(pkgversion(PlutoDependencyExplorer))")
    println(" EE: $(pkgversion(ExpressionExplorer))")
    println("=" ^ 72)

    all_cold = Float64[]
    all_warm_nc = Float64[]
    all_warm_up = Float64[]

    # Scenario 1: Small notebook
    init = gen_notebook_spec(5, 20)
    upd = gen_notebook_spec(2, 20)
    c1, w1, u1 = run_scenario("Small (5 cells × 20 vars → +2 cells)", init, upd)
    push!(all_cold, c1); push!(all_warm_nc, w1); push!(all_warm_up, u1)

    # Scenario 2: Medium notebook
    init = gen_notebook_spec(20, 10)
    upd = gen_notebook_spec(5, 10)
    c2, w2, u2 = run_scenario("Medium (20 cells × 10 vars → +5 cells)", init, upd)
    push!(all_cold, c2); push!(all_warm_nc, w2); push!(all_warm_up, u2)

    # Scenario 3: Large notebook
    init = gen_notebook_spec(50, 5)
    upd = gen_notebook_spec(10, 5)
    c3, w3, u3 = run_scenario("Large (50 cells × 5 vars → +10 cells)", init, upd)
    push!(all_cold, c3); push!(all_warm_nc, w3); push!(all_warm_up, u3)

    # Summary
    println("\n" ^ 2)
    println("=" ^ 72)
    println("SUMMARY")
    println("=" ^ 72)
    @printf("  Average cold (full build):         %.4f s\n", mean(all_cold))
    @printf("  Average warm (no change, cache hit): %.4f s\n", mean(all_warm_nc))
    @printf("  Average warm (incremental update):   %.4f s\n", mean(all_warm_up))
    overall_hit  = mean(all_cold) / max(mean(all_warm_nc), 1e-12)
    overall_inc  = mean(all_cold) / max(mean(all_warm_up), 1e-12)
    @printf("\n  Overall speedup (cache hit / cold):        %.1fx\n", overall_hit)
    @printf("  Overall speedup (incremental update / cold): %.1fx\n", overall_inc)
    println()
    if overall_hit > 2.0
        println("  ✓ Caching provides significant performance improvement on re-renders.")
    elseif overall_hit > 1.2
        println("  ✓ Caching provides measurable performance improvement.")
    else
        println("  △ Caching improvement is modest.")
    end
end

mean(xs) = length(xs) > 0 ? sum(xs) / length(xs) : 0.0

main()