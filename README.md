# CanadaMap

[![Build Status](https://github.com/jojal5/CanadaMap.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jojal5/CanadaMap.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Example

```julia
using CanadaMap, GeoMakie

# Generate an empty map of Canada
fig_can, ga = generate_canada_map()

# Show Montréal
scatter!(
    ga,
    -73.561668,
    45.508888;
    color = :red
)

xlims!(ga, -130, -57)
ylims!(ga, 42, 78)

fig_can
```
