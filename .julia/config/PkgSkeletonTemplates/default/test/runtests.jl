using {PKGNAME}
using Test

using JET
@testset "static analysis with JET.jl" begin
    @test isempty(JET.get_reports(report_package({PKGNAME}, target_modules=({PKGNAME},))))
end

@testset "QA with Aqua" begin
    import Aqua
    Aqua.test_all({PKGNAME})
end

# write tests here


