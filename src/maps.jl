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
        dest = "+proj=ortho " *
               "+lon_0=$(can_centroid[1]) " *
               "+lat_0=$(can_centroid[2])",
        limits = ((-130, -57), (42, 78))
    )

    # Ocean background
    for i in eachindex(can_oceans) 
        poly!(ga, can_oceans[i].geometry, color=:lightblue)
     end

    # Surrounding land
    poly!(
        ga,
        df_usa.geom;
        color = :mintcream,
        strokecolor = :gray47,
        strokewidth = 0.7,
        shading = NoShading
    )

    poly!(
        ga,
        df_grl.geom;
        color = :mintcream,
        strokecolor = :gray47,
        strokewidth = 0.7,
        shading = NoShading
    )

    # Canada
    poly!(
        ga,
        df_can.geom;
        color = :ivory,
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