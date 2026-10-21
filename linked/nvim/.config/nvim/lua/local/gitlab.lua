local function gitlab_url()
    local handle = io.popen('git config --get remote.origin.url')
    local result = handle:read("*a")
    handle:close()

    local url, group, repo = result:match('git@(.+):(.+)/(.+)\n')
    if url == nil then
        print("Not a git repository")
        return
    end

    if repo:find(".git") then
        repo = repo:sub(1, -5)
    end

    local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD')
    branch = branch:gsub("\n", "")

    local git_prefix = vim.fn.system('git rev-parse --show-toplevel')
    git_prefix = git_prefix:gsub("\n", "")

    local path = vim.fn.expand('%:p')
    path = path:gsub(git_prefix, "")

    local line = vim.fn.line('.')

    local url = "https://" .. url .. "/" .. group .. "/" .. repo .. "/-/blob/" .. branch .. path .. "#L" .. line
    print("Copied to clipboard: " .. url)
    vim.fn.setreg('+', url)
end

--- Looks at currently open buffer and creates an url to
--- gitlab file.
vim.api.nvim_create_user_command(
    'GitlabUrl',
    gitlab_url,
    {
        nargs = 0,
    }
)
