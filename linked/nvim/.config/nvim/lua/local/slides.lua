local _M = {}
local slide_files = {}
local current_slide = 1

function _M.read_index()
    local index = {}
    local f = io.open("index.txt", "r")

    if f == nil then
        print("No index file found")
        return nil
    end

    for line in f:lines() do
        table.insert(index, line)
    end
    f:close()

    print("Read " .. #index .. " slides")
    return index
end

function _M.init()
    local index = _M.read_index()
    if index == nil then
        return
    end

    for i, file in ipairs(index) do
        table.insert(slide_files, file)
    end
end

vim.api.nvim_create_user_command("SlidesInit",
    function()
        _M.init()
    end,
    {
        nargs = 0,
    }
)

vim.api.nvim_create_user_command("SlidesNext",
    function()
        if current_slide > #slide_files then
            print("End of presentation")
            return
        end

        vim.cmd("e " .. slide_files[current_slide])
        current_slide = current_slide + 1
    end,
    {
        nargs = 0,
    }
)

vim.api.nvim_create_user_command("SlidesPrev",
    function()
        if current_slide == 1 then
            print("At the start of presentation")
            return
        end

        current_slide = current_slide - 1
        vim.cmd("e " .. slide_files[current_slide])
    end,
    {
        nargs = 0,
    }
)

return _M
