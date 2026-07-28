"""
    select_features(data, region)
    select_features(data, extent)
    select_features(data; lonlim, latlim)

Return the features in `data` whose bounding boxes overlap the selected region.

The region may be supplied as a `GADM.Table`, an `Extents.Extent`, or longitude
and latitude limits. The selection is approximate: retained features are
returned in their entirety and do not necessarily intersect the region itself.
"""
function select_features end

function select_features(
    data::GeoJSON.FeatureCollection,
    extent::Extents.Extent
)
    keep = map(data.geometry) do geometry
        _extent_intersects(geometry, extent)
    end

    return data[keep]
end

function select_features(
    data::GeoJSON.FeatureCollection;
    lonlim::Tuple{<:Real, <:Real},
    latlim::Tuple{<:Real, <:Real}
)
    lonlim[1] ≤ lonlim[2] ||
        throw(ArgumentError("`lonlim` must be ordered from west to east."))

    latlim[1] ≤ latlim[2] ||
        throw(ArgumentError("`latlim` must be ordered from south to north."))

    extent = Extents.Extent(
        X = lonlim,
        Y = latlim
    )

    return select_features(data, extent)
end

function select_features(
    data::GeoJSON.FeatureCollection,
    region::GADM.Table
)
    return select_features(data, GI.extent(region))
end

"""
    _extent_intersects(geometry, extent)

Return whether the bounding box of `geometry` overlaps `extent`.

For a `MultiLineString`, the component line strings are tested individually.
"""
_extent_intersects(geometry, extent) =
    _extent_intersects(
        GI.geomtrait(geometry),
        geometry,
        extent
    )

_extent_intersects(
    ::GI.AbstractMultiLineStringTrait,
    geometry,
    extent
) = any(GI.getlinestring(geometry)) do line
    Extents.intersects(GI.extent(line), extent)
end

_extent_intersects(
    ::GI.AbstractGeometryTrait,
    geometry,
    extent
) = Extents.intersects(
    GI.extent(geometry),
    extent
)