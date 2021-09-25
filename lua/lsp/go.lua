local config = {
    settings = {gopls = {staticcheck = true}}
    -- init_options = {
    -- usePlaceholders = true,
    -- completeUnimported = true
    -- }
}

return {
    config = function(_)
        return config
    end
}
