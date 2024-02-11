local K = {}

local Job = require("plenary.job")

-- get plugin directory path
local plugin_path = debug.getinfo(1).source:sub(2):match("(.*/).*/")
local pdf_script_path = plugin_path .. "scripts/knitr-pdf.sh"
local html_script_path = plugin_path .. "scripts/knitr-html.sh"

-- knit file to pdf
K.knitr_pdf = function()
    local filename = vim.fn.expand("%:t")

    -- check if current file is an R file
    if filename:match("%.R$") or filename:match("%.Rmd$") then
        print("Knitting " .. filename .. " to pdf...")

        -- get path to file open in current buffer
        local filepath = vim.fn.expand("%:p")

        -- run script in background shell process
        Job:new({
            command = pdf_script_path,
            args = { filepath },
            on_exit = function(output, return_val)
                if (return_val == 0) then
                    print("Knitting finished sucessfully.")
                else
                    print("Knitting failed with exit code: " .. return_val)
                    print("Error Trace:")
                    print(vim.inspect(output))
                end
            end,
        }):start()

    else
        print("Current file is not a .R or .Rmd file.")
    end

end

-- knit file to html
K.knitr_html = function()
    local filename = vim.fn.expand("%:t")

    -- check if current file is an R file
    if filename:match("%.R$") or filename:match("%.Rmd$") then

        -- get path to file open in current buffer
        local filepath = vim.fn.expand('%:p')
        print("Knitting " .. filepath .. " to html...")

        -- run script in background shell process
        Job:new({
            command = html_script_path,
            args = { filepath },
            on_exit = function(_, return_val)
                if (return_val == 0) then
                    print("Knitting finished sucessfully.")
                else
                    print("Knitting failed with exit code: " .. return_val)
                end
            end,
        }):start()

    else
        print("Current file is not a .R or .Rmd file.")
    end
end

-- Create user commands upon setup
K.setup = function(_)
    vim.api.nvim_create_user_command("KnitRpdf", K.knitr_pdf, {})
    vim.api.nvim_create_user_command("KnitRhtml", K.knitr_html, {})
end

return K
