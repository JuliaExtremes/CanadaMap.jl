using Pkg
pkg"activate ."

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