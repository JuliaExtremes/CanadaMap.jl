"""
    generate_canada_map()

Create a base map of Canada with provincial boundaries, surrounding land,
major lakes, rivers, and oceans. Return the figure and geographic axis.
"""
function generate_canada_map()

    region = GADM.get("CAN"; depth = 0)

    lakes = naturalearth("lakes", 50)
    rivers = naturalearth("rivers_lake_centerlines", 50)
    oceans = naturalearth("ocean_scale_rank", 10)

    can_lakes = select_features(lakes, region)
    can_rivers = select_features(rivers, region)
    can_oceans = select_features(oceans, region)

    can_centroid = GO.centroid(region)

    df_can = DataFrame(GADM.get("CAN"; depth = 1))
    df_usa = DataFrame(GADM.get("USA"; depth = 0))
    df_grl = DataFrame(GADM.get("GRL"; depth = 0))

    fig_can = Figure()

    ga = GeoAxis(
        fig_can[1, 1];
        source = "+proj=longlat +datum=WGS84",
        dest = "+proj=ortho +lon_0=$(can_centroid[1]) +lat_0=$(can_centroid[2])",
        limits = ((-130, -57), (42, 78)),
        xticks = -160:10:-30,
        yticks = [35, 40, 45, 49, 55, 60, 65, 70, 75, 80, 85]
    )

    # Ocean background
    for i in eachindex(can_oceans) 
        poly!(ga, can_oceans[i].geometry, color=:lightblue)
     end

    # Surrounding land
    poly!(
        ga,
        df_usa.geom;
        color = :ivory,
        strokecolor = :gray47,
        strokewidth = 0.7,
        shading = NoShading
    )

    poly!(
        ga,
        df_grl.geom;
        color = :ivory,
        strokecolor = :gray47,
        strokewidth = 0.7,
        shading = NoShading
    )

    # Canada
    poly!(
        ga,
        df_can.geom;
        color = :mintcream,
        strokecolor = :gray47,
        strokewidth = 0.7,
        shading = NoShading
    )

    # Rivers and lakes are drawn over the land
    for i in eachindex(can_rivers)
        lines!( ga, can_rivers[i].geometry, color=:steelblue, linewidth=0.8 )
    end
    
    for i in eachindex(can_lakes)
        poly!(ga, can_lakes[i].geometry, color=:lightblue)
    end

    return fig_can, ga
end

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

    df_quebec = df_can[quebec_index,:]

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
        limits=((-82, -55), (44, 63.5)),
        xticks = -90:5:-45,
        yticks = 40:5:65
    )

    # Ocean background
    for i in eachindex(quebec_oceans)
        poly!(ga, quebec_oceans[i].geometry, color=:lightblue)
    end

    # Surrounding land
    poly!(
        ga,
        df_usa.geom;
        color=:ivory,
        strokecolor=:gray47,
        strokewidth=0.7,
        shading=NoShading
    )

    poly!(
        ga,
        df_can.geom;
        color=:ivory,
        strokecolor=:gray47,
        strokewidth=0.7,
        shading=NoShading
    )

    poly!(
        ga,
        df_quebec.geom;
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