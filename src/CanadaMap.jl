module CanadaMap

using CSV, DataFrames, Tables
using CairoMakie, Extents, GADM, GeoJSON, GeoMakie, NaturalEarth
import GeometryOps as GO
import GeoInterface as GI

# Write your package code here.

include("data.jl")
include("maps.jl")

export generate_canada_map

end
