# CanadaMap

[![Build Status](https://github.com/JuliaExtremes/CanadaMap.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaExtremes/CanadaMap.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Example - Map of Canada showing the location of Montréal

```julia
using CanadaMap, GeoMakie

# Generate an empty map of Canada
fig, ga = generate_canada_map()

# Show Montréal
scatter!(
    ga,
    -73.561668,
    45.508888;
    color = :red
)

fig
```

## Example - Map of Québec showing the location of Montréal

```julia
using CanadaMap, GeoMakie

# Generate an empty map of Québec
fig, ga = generate_quebec_map()

# Show Montréal
scatter!(
    ga,
    -73.561668,
    45.508888;
    color = :red
)

fig
```
