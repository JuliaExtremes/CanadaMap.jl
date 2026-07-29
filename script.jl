using Pkg
pkg"activate ."

using CanadaMap, GeoMakie

using CSV, DataFrames, Tables
using CairoMakie, Extents, GADM, GeoJSON, GeoMakie, NaturalEarth
import GeometryOps as GO
import GeoInterface as GI


import CanadaMap: select_features


# Canadian provinces and territories
df_can = DataFrame(GADM.get("CAN"; depth=1))

# Extract Québec
quebec_index = findfirst(==("Québec"), string.(df_can.NAME_1))

isnothing(quebec_index) &&
    error("Québec was not found in the GADM data.")

quebec_geom = df_can.geom[quebec_index]
quebec_extent = GI.extent(quebec_geom)
quebec_centroid = GO.centroid(quebec_geom)

# Natural Earth features
lakes = naturalearth("lakes", 10)
rivers = naturalearth("rivers_lake_centerlines", 10)
oceans = naturalearth("ocean_scale_rank", 10)

quebec_lakes = select_features(lakes, quebec_extent)
quebec_rivers = select_features(rivers, quebec_extent)
quebec_oceans = select_features(oceans, quebec_extent)

# Surrounding countries
df_usa = DataFrame(GADM.get("USA"; depth=0))

fig = Figure()

ga = GeoAxis(
    fig[1, 1];
    source="+proj=longlat +datum=WGS84",
    dest="+proj=ortho +lon_0=$(quebec_centroid[1]) +lat_0=$(quebec_centroid[2])",
    limits=((-82, -55), (44, 63.5))
)

# Ocean background
for i in eachindex(quebec_oceans)
    poly!(ga, quebec_oceans[i].geometry, color=:lightblue)
end

# Surrounding land
poly!(
    ga,
    df_usa.geom;
    color=:mintcream,
    strokecolor=:gray47,
    strokewidth=0.7,
    shading=NoShading
)

poly!(
    ga,
    df_can.geom;
    color=:mintcream,
    strokecolor=:gray47,
    strokewidth=0.7,
    shading=NoShading
)


# Rivers and lakes are drawn over the land
for i in eachindex(quebec_rivers)
    lines!(ga, quebec_rivers[i].geometry, color=:steelblue, linewidth=0.8)
end

for i in eachindex(quebec_lakes)
    poly!(ga, quebec_lakes[i].geometry, color=:lightblue)
end

fig

"""
    generate_quebec_map()

Create a base map of Québec with surrounding land, major lakes, rivers,
and oceans. Return the figure and geographic axis.
"""
function generate_quebec_map()

    # Canadian provinces and territories
    df_can = DataFrame(GADM.get("CAN"; depth=1))

    # Extract Québec
    quebec_index = findfirst(==("Québec"), string.(df_can.NAME_1))

    isnothing(quebec_index) &&
        error("Québec was not found in the GADM data.")

    quebec_geom = df_can.geom[quebec_index]
    quebec_extent = GI.extent(quebec_geom)
    quebec_centroid = GO.centroid(quebec_geom)

    # Natural Earth features
    lakes = naturalearth("lakes", 10)
    rivers = naturalearth("rivers_lake_centerlines", 10)
    oceans = naturalearth("ocean_scale_rank", 10)

    quebec_lakes = select_features(lakes, quebec_extent)
    quebec_rivers = select_features(rivers, quebec_extent)
    quebec_oceans = select_features(oceans, quebec_extent)

    # Surrounding countries
    df_usa = DataFrame(GADM.get("USA"; depth=0))

    fig = Figure()

    ga = GeoAxis(
        fig[1, 1];
        source="+proj=longlat +datum=WGS84",
        dest="+proj=ortho +lon_0=$(quebec_centroid[1]) +lat_0=$(quebec_centroid[2])",
        limits=((-82, -55), (44, 63.5))
    )

    # Ocean background
    for i in eachindex(quebec_oceans)
        poly!(ga, quebec_oceans[i].geometry, color=:lightblue)
    end

    # Surrounding land
    poly!(
        ga,
        df_usa.geom;
        color=:mintcream,
        strokecolor=:gray47,
        strokewidth=0.7,
        shading=NoShading
    )

    poly!(
        ga,
        df_can.geom;
        color=:mintcream,
        strokecolor=:gray47,
        strokewidth=0.7,
        shading=NoShading
    )

    # Rivers and lakes are drawn over the land
    for i in eachindex(quebec_rivers)
        lines!(ga, quebec_rivers[i].geometry, color=:steelblue, linewidth=0.8)
    end

    for i in eachindex(quebec_lakes)
        poly!(ga, quebec_lakes[i].geometry, color=:lightblue)
    end

    return fig, ga
end

fig, ga = generate_quebec_map()

fig
