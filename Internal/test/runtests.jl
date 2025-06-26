using Internal
using Test
using Aqua
using JET

@testset "Internal.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Internal)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(Internal; target_defined_modules = true)
    end
    # Write your tests here.
end
