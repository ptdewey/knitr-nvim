# knitr-nvim
Knit R and Rmd files quickly inside of Neovim

## Installation
Use your favorite package manager (I use lazy)

```lua
-- install package from GitHub
"ptdewey/knitr-nvim"
-- Load the custom user commands
require("knitr")
```

## Usage
This plugin provides two different commands for knitting R files:

Knitting to PDF - `:KnitRpdf`

Knitting to HTML - `:KnitRhtml`

Running either command will knit the file in the current buffer to the desired output format.
