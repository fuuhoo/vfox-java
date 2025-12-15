local distribution_version_parser = require("distribution_version")
local util = require("util")

function PLUGIN:PreUse(ctx)
    local distribution_version = distribution_version_parser.parse_version(ctx.version)

    if distribution_version and distribution_version.distribution.short_name ~= "open" then
        version = distribution_version.version .. "-" .. distribution_version.distribution.short_name    
    else
        version = ctx.version
    end
    local shorthands = util.calculate_shorthand(ctx.installedSdks)
    version=shorthands[version]
    return {
        version = version,
    }
end

