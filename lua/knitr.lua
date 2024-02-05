local K = {}

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
        vim.fn.system { pdf_script_path, filepath}
        print("Finished knitting.")
    else
        print("Current file is not a .R or .Rmd file.")
    end

end

-- knit file to html
K.knitr_html= function()
    local filename = vim.fn.expand("%:t")
    -- check if current file is an R file
    if filename:match("%.R$") or filename:match("%.Rmd$") then
        -- get path to file open in current buffer
        local filepath = vim.fn.expand('%:p')
        print("Knitting " .. filepath .. " to html...")
        -- run script in background shell process
        vim.fn.system { html_script_path, filepath}
        print("Finished knitting.")
    else
        print("Current file is not a .R or .Rmd file.")
    end
end

-- Create user commands
vim.api.nvim_create_user_command("KnitRpdf", K.knitr_pdf, {})
vim.api.nvim_create_user_command("KnitRhtml", K.knitr_html, {})

return K
