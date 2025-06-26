try
    @eval using IJulia
catch e
    @warn "Error initializing startup packages" exception = (e, catch_backtrace())
end
include("./startup.jl")
