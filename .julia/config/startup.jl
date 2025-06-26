using Pkg

required_dependencies = String[
    "Revise",
    "VimBindings",
    "PkgSkeleton",
]

optional_dependencies = String[
    "Aqua",
    "JET",
    "Cthulhu",
    "Debugger",
    "BenchmarkTools",
    "ProfileView",
]

in_global_env = contains(Pkg.project().path, r"\.julia/environments/v.*/Project.toml")

if !in_global_env
    @info "Checking Global Env contains required and optional dependencies"
    Pkg.activate()
end

installed_deps = keys(Pkg.project().dependencies)

for dep in required_dependencies
    !(dep in installed_deps) && @error "$dep should be installed in the global project, but it is not"
end

for dep in optional_dependencies
    !(dep in installed_deps) && @warn "$dep should be installed in the global project, but it is not"
end

if !in_global_env
    Pkg.activate(".")
end


# using Aqua
# using JET
# using Cthulhu
# using Debugger
# using BenchmarkTools
# using PkgTemplates
# using PkgSkeleton
# using ProfileView

@eval begin
    using Revise
    if isinteractive()
        @eval using VimBindings
    end

    using PkgSkeleton
    const default_user = "arnold-c"
    const default_dir = "/Users/cfa5228/Documents/Repos/"
    # const default_plugins = [Tests(; project = true, aqua = true, jet = true), Git(; ssh = true)]
    # const internal_plugins = [Tests(; project = true, aqua = true, jet = true), !Git, !GitHubActions, !CompatHelper, !TagBot, !Dependabot]
    const internal_template_dir = "/Users/cfa5228/.julia/config/PkgSkeletonTemplates/"
    const personal_templates = [:default, :runic]
    const default_templates = [:github]
    #
    # """
    #     internal_template(
    #         name::AbstractString;
    #         user=default_user,
    #         dir=".",
    #         plugins=internal_plugins,
    #         kwargs...
    #     )
    #
    # Create a new template and package, by default using my GitHub username, within the current directory, with JET and Aqua in the Test environment. Git is not set up as this is an internal package to a Git-tracked project.
    #
    # Forwards the provided name to the created template.
    # """
    # function internal_template(
    #         name::AbstractString;
    #         user = default_user,
    #         dir = ".",
    #         plugins = internal_plugins,
    #         kwargs...
    #     )
    #     return template(
    #         ; user = user,
    #         dir = dir,
    #         plugins = plugins,
    #         kwargs...
    #     )(name)
    # end

    """
    	inplace_template(
    		; user_replacements = Dict(
    			# - `UUID`: the package UUID; default: random
    			# - `PKGNAME`: the package name; default: taken from the destination directory
    			# - `GHUSER`: the github user; default: taken from Git options
    			# - `USERNAME`: the user name; default: taken from Git options
    			# - `USEREMAIL`: the user e-mail; default: taken from Git options
    			# - `YEAR`: the calendar year; default: from system time
    			"USERNAME" => default_user,
                "PKGNAME" => PkgSkeleton.pkg_name_from_path(pwd()),
    		),
    		skeleton_templates = default_templates,
    		personal_templates = personal_templates,
    		kwargs...
    	)

    Create a new package in the current directory using it's name. By default the username is set to my default user, but this can be set within the `user_replacements` Dict with the `"USERNAME"` key, or set to pull information from the Git options by passing an empty Dict.

    `personal_templates` are created in the directory specified in `internal_template_dir` and are passed to `inplace_template()` with a vector of symbols, matching the format of `PkgSkeleton.jl` template specification.
    """
    function inplace_template(
            ; user_replacements = Dict(
                "USERNAME" => default_user,
                "PKGNAME" => PkgSkeleton.pkg_name_from_path(pwd()),
            ),
            skeleton_templates = default_templates,
            personal_templates = personal_templates,
            kwargs...
        )
        if !isempty(personal_templates)
            templates = vcat(
                skeleton_templates,
                joinpath.(internal_template_dir, String.(personal_templates))
            )
        else
            templates = skeleton_templates
        end

        PkgSkeleton.generate(
            ".";
            user_replacements = user_replacements,
            templates = templates
        )
        if in(:default, personal_templates)
            Pkg.activate("test")
            println("Adding `Aqua.jl` and `JET.jl` packages to the `Test` environment")
            Pkg.add(["Aqua", "JET"])
        end

        if in(:runic, personal_templates)
            io = open("README.md", "a")
            write(io, "[![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl)")
            close(io)
        end
        Pkg.activate(".")
        return nothing
    end

    # """
    #     template(
    #         name::AbstractString;
    #         user=default_user,
    #         dir=default_dir,
    #         plugins=default_plugins,
    #         kwargs...
    #     )
    #
    # Create a new template and package, by default using my GitHub username, in my Repos directory, with JET and Aqua in the Test environment, and GitHub action to run the tests.
    #
    # Forwards the provided name to the created template.
    # """
    # function template(
    #         name::AbstractString;
    #         user = default_user,
    #         dir = default_dir,
    #         plugins = default_plugins,
    #         kwargs...
    #     )
    #     return template(
    #         ; user = user,
    #         dir = dir,
    #         plugins = plugins,
    #         kwargs...
    #     )(name)
    # end
    #
    # """
    #     template(;
    #         user=default_user,
    #         dir=default_dir,
    #         plugins=default_plugins,
    #         kwargs...
    #     )
    #
    # Create a new template, by default using my GitHub username, in my Repos directory, with JET and Aqua in the Test environment, and GitHub action to run the tests.
    #
    # Needs to be applied to a package name to instantiate the package.
    # """
    # function template(;
    #         user = default_user,
    #         dir = default_dir,
    #         plugins = default_plugins,
    #         kwargs...
    #     )
    #     return Template(;
    #         user = user,
    #         dir = dir,
    #         plugins = plugins,
    #         kwargs...
    #     )
    # end
end
