local strings = require("vfox.strings")

local UTIL = {}



function UTIL.compare_versions(v1o, v2o)
    local v1 = v1o.version
    local v2 = v2o.version
    local v1_parts = {}
    for part in string.gmatch(v1, "[^.]+") do
        table.insert(v1_parts, tonumber(part))
    end

    local v2_parts = {}
    for part in string.gmatch(v2, "[^.]+") do
        table.insert(v2_parts, tonumber(part))
    end

    for i = 1, math.max(#v1_parts, #v2_parts) do
        local v1_part = v1_parts[i] or 0
        local v2_part = v2_parts[i] or 0
        if v1_part > v2_part then
            return true
        elseif v1_part < v2_part then
            return false
        end
    end

    return false
end




function UTIL.extract_semver(semver)
    -- local pattern = "^(%d+)%.(%d+)%.[%s.]+$"
    local pattern="^(%d+)%.(%d+)%.(%d+)(.*)$"
    local major, minor,patch = semver:match(pattern)
    return major, minor,patch
end

function UTIL.calculate_shorthand(list)
    local versions_shorthand = {}
    for _, v in pairs(list) do
        local version = v.version
        local version_parts = strings.split(version, "-")
        -- version=version_parts[1]
        local distribution=version_parts[2]
        local major, minor,patch = UTIL.extract_semver(version)
        local major_temp=major
        if major then
            if distribution then
                major=major.."-"..distribution
            end
            if not versions_shorthand[major] then
                versions_shorthand[major] = version
            else
                if UTIL.compare_versions({ version = version }, { version = versions_shorthand[major] }) then
                    versions_shorthand[major] = version
                end
            end

            if minor then
                local major_minor = major_temp .. "." .. minor
                if distribution then
                        major_minor=major_minor.."-"..distribution
                end
                -- print("major_minor",major_minor)
                if not versions_shorthand[major_minor] then
                    versions_shorthand[major_minor] = version
                else
                    if UTIL.compare_versions({ version = version }, { version = versions_shorthand[major_minor] }) then
                        versions_shorthand[major_minor] = version
                    end
                end
            end
        end
    end
    return versions_shorthand
end

return UTIL
