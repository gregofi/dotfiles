-- Colors the comment threads of PLAN.md by author.
-- Depth marks who spoke: `>` the user, `>> Claude:` Claude, `>>>` the user again.

local _M = {}

local ns = vim.api.nvim_create_namespace("local.plan")

local BG = {
    user = "PlanThreadBgUser",
    claude = "PlanThreadBgClaude",
}

-- The `>` markers and the `Claude:` that opens a message.
local BOLD = "PlanThreadBold"

-- The color each author's line background is tinted toward.
local COLOR = {
    user = 0x3b82f6,
    claude = 0xff8800,
}

-- How much of the author's color the line background carries.
local TINT = 0.3

local function blend(base, over, alpha)
    local function channel(shift)
        local b = math.floor(base / shift) % 256
        local o = math.floor(over / shift) % 256
        return math.floor(b + (o - b) * alpha + 0.5)
    end
    return channel(65536) * 65536 + channel(256) * 256 + channel(1)
end

local function setup_highlights()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    for author, group in pairs(BG) do
        local bg = normal ~= nil and blend(normal, COLOR[author], TINT) or nil
        vim.api.nvim_set_hl(0, group, { bg = bg, default = true })
    end
    vim.api.nvim_set_hl(0, BOLD, { bold = true, default = true })
end

local function claude_token(body)
    return body:match("^Claude:") or body:match("^C:")
end

--- Scan a buffer into threads.
--- A thread is a run of consecutive quoted lines, and every change of depth
--- inside it starts a new message.
--- Returns a list of threads, each a list of { depth, author, start_line, end_line }
--- with 1-based, inclusive line numbers.
function _M.parse(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local threads = {}
    local thread = nil

    for i, line in ipairs(lines) do
        local markers, body = line:match("^(>+)%s?(.*)$")
        if markers == nil then
            thread = nil
        else
            if thread == nil then
                thread = {}
                table.insert(threads, thread)
            end
            local message = thread[#thread]
            if message == nil or message.depth ~= #markers then
                message = { depth = #markers, start_line = i }
                table.insert(thread, message)
            end
            message.end_line = i
            if message.explicit == nil and body:match("%S") then
                message.explicit = claude_token(body) ~= nil
            end
        end
    end

    -- Messages without a `Claude:` line alternate from whoever opened the thread.
    for _, messages in ipairs(threads) do
        local first = messages[1]
        local opener = first.explicit and "claude" or "user"
        local other = opener == "user" and "claude" or "user"
        for _, message in ipairs(messages) do
            if message.explicit then
                message.author = "claude"
            else
                message.author = (message.depth - first.depth) % 2 == 0 and opener or other
            end
        end
    end

    return threads
end

function _M.render(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for _, thread in ipairs(_M.parse(buf)) do
        for _, message in ipairs(thread) do
            for lnum = message.start_line, message.end_line do
                local markers, space, body = lines[lnum]:match("^(>+)(%s?)(.*)$")
                local token = claude_token(body)
                vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
                    line_hl_group = BG[message.author],
                    end_col = token and #markers + #space + #token or #markers,
                    hl_group = BOLD,
                })
            end
        end
    end
end

setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("local.plan.highlights", { clear = true }),
    callback = setup_highlights,
})

-- By filename, not filetype, so ordinary markdown is left alone.
vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    group = vim.api.nvim_create_augroup("local.plan", { clear = true }),
    pattern = "PLAN.md",
    callback = function(args)
        _M.render(args.buf)
    end,
})

return _M
