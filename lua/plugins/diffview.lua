return {
  check_git_version = function()
    local git_cmd = "git"
    local target = {
      major = 2,
      minor = 31,
      patch = 0,
    }

    local version_string = vim.fn.system(git_cmd .. " --version")
    version_string = version_string:match "git version (%S+)"

    if not version_string then return false end

    local parts = vim.split(version_string, "%.")
    local v = {}
    v.major = tonumber(parts[1])
    v.minor = tonumber(parts[2])
    v.patch = tonumber(parts[3]) or 0

    if
      ("%08d%08d%08d"):format(v.major, v.minor, v.patch)
      < ("%08d%08d%08d"):format(target.major, target.minor, target.patch)
    then
      return false
    end
    return true
  end,
  config = function()
    require("diffview").setup {
      -- see configuration in
      -- https://github.com/sindrets/diffview.nvim#configuration
    }
  end,
}
