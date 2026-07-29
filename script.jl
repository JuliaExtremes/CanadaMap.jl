using Pkg
pkg"activate ."

using CanadaMap, GeoMakie

# using CSV, DataFrames, Tables
# using CairoMakie, Extents, GADM, GeoJSON, GeoMakie, NaturalEarth
# import GeometryOps as GO
# import GeoInterface as GI

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



fig, ga = generate_canada_map()

# Show Montréal
scatter!(
    ga,
    -73.561668,
    45.508888;
    color = :red
)

fig



