local K = {}

local Job = require("plenary.job")

-- define path to knitting scripts
local plugin_path = debug.getinfo(1).source:sub(2):match("(.*/).*/")
local pdf_script_path = plugin_path .. "scripts/knitr-pdf.sh"
local html_script_path = plugin_path .. "scripts/knitr-html.sh"

-- display to message history
local function display_messages(messages)
    vim.schedule(function()
        local concatenated_messages = table.concat(messages, "\n")
        vim.api.nvim_echo({{concatenated_messages, "None"}}, true, {})
    end)
end

-- handle job errors and output
local function handle_job_output(err, return_val)
    local messages = {}
    if return_val == 0 then
        table.insert(messages, "Knitting finished successfully.")
    else
        table.insert(messages, "Knitting failed with exit code: " .. return_val)
        if err and #err > 0 then
            table.insert(messages, "Error Trace:")
            for _, line in ipairs(err) do
                table.insert(messages, line)
            end
        end
    end
    display_messages(messages)
end

function K.knitr_pdf()
    local filename = vim.fn.expand("%:t")
    if not (filename:match("%.R$") or filename:match("%.Rmd$")) then
        print("Current file is not a .R or .Rmd file.")
        return
    end

    print("Knitting " .. filename .. " to pdf...")
    local filepath = vim.fn.expand("%:p")
    local err_output = {}

    Job:new({
        command = pdf_script_path,
        args = {filepath},
        on_stderr = function(_, data)
            table.insert(err_output, data)
        end,
        on_exit = function(_, return_val)
            handle_job_output(err_output, return_val)
        end,
    }):start()
end

function K.knitr_html()
    local filename = vim.fn.expand("%:t")
    if not (filename:match("%.R$") or filename:match("%.Rmd$")) then
        print("Current file is not a .R or .Rmd file.")
        return
    end

    print("Knitting " .. filename .. " to html...")
    local filepath = vim.fn.expand("%:p")
    local err_output = {}

    Job:new({
        command = html_script_path,
        args = {filepath},
        on_stderr = function(_, data)
            table.insert(err_output, data)
        end,
        on_exit = function(_, return_val)
            handle_job_output(err_output, return_val)
        end,
    }):start()
end

-- create user commands upon setup
function K.setup()
    vim.api.nvim_create_user_command("KnitRpdf", K.knitr_pdf, {
        desc = "Knit current R or Rmd file to PDF"
    })
    vim.api.nvim_create_user_command("KnitRhtml", K.knitr_html, {
        desc = "Knit current R or Rmd file to HTML"
    })
end

return K
