print("NopFault! Keep Coding")
-- for this vuejs shit to work you need new node.
-- with 14 it doesnt work with 21 it works so `npm install -g node`

vim.g.mapleader = " "
vim.g.maplocalleader = ' '

require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }

    }
    use { "fatih/vim-go" }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        use {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
        },
        use({
            "kdheepak/lazygit.nvim",
            requires = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("telescope").load_extension("lazygit")
            end,
        }),
        use { "akinsho/toggleterm.nvim", tag = '*' },
        use { 'akinsho/bufferline.nvim', tag = '*' },
        use "terrortylor/nvim-comment",
        use "lewis6991/gitsigns.nvim",
        use {
            "windwp/nvim-autopairs",
            config = function() require("nvim-autopairs").setup {} end
        },
        use 'feline-nvim/feline.nvim',
        use 'nvim-tree/nvim-web-devicons',
        use 'airblade/vim-gitgutter',
        use "lukas-reineke/indent-blankline.nvim",
        use 'arminveres/md-pdf.nvim',
        use 'rcarriga/nvim-notify',
        use 'jwalton512/vim-blade',
        use 'tpope/vim-dispatch',
        use 'tpope/vim-projectionist',
        use 'noahfrederick/vim-composer',
        use 'noahfrederick/vim-laravel',
    }
end)

-- KEYMAPS
--
vim.keymap.set('n', '<Leader>ff', ':Ex<CR>')

local builtin = require('telescope.builtin')
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)

vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", opts)
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set("n", "<leader>nn",
    ":e /Users/lazymonad/Library/Mobile Documents/iCloud~md~obsidian/Documents/NopFault/<CR>", opts)

vim.keymap.set('n', '<C-h>', ':bprev<CR>', opts)
vim.keymap.set('n', '<C-l>', ':bnext<CR>', opts)
vim.keymap.set('n', '<C-n>', ':enew<CR>', opts)
vim.keymap.set('n', '<C-q>', ':bdelete<CR>', opts)

vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts)

vim.keymap.set("n", "<leader>sf", ":source %<CR>", opts)

vim.keymap.set("n", "<leader>tt", ":ToggleTerm size=90 direction=horizontal <CR>", opts)

vim.keymap.set('n', '<C-t>', ':r! date "+\\%Y-\\%m-\\%d" <CR>', opts)

-- LSP
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
vim.keymap.set('n', "[d", function() vim.diagnostic.goto_next() end, opts)
vim.keymap.set('n', "]d", function() vim.diagnostic.goto_prev() end, opts)
vim.keymap.set('n', "<C-f>", function() code_format() end, opts)

-- MD to PDF
vim.keymap.set("n", "<leader>zz", function()
    require('md-pdf').convert_md_to_pdf()
end)


-- BASIC CONFIG
--
local o = vim.o
o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 2


o.background = "dark"
o.number = true
o.relativenumber = true

o.timeoutlen = 500

o.completeopt = 'menuone,noselect'

o.cursorline = true
o.scrolloff = 30
o.autochdir = true
o.hlsearch = true
o.foldenable = false
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'


vim.cmd [[autocmd BufWritePost *.swift :silent exec "!swiftformat %"]]

--
-- BUFFERS
vim.opt.termguicolors = true
require("bufferline").setup {}

-- THEME
--
require("tokyonight").setup({
    style = "night",
    styles = {
        functions = {}
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    on_colors = function(colors)
        colors.hint = colors.orange
        colors.error = "#ff0000"
    end
})
vim.cmd [[colorscheme tokyonight]]

-- INDENT VISUALISATION
--
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }

-- TREESITTER
--
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "vue", "lua", "vim", "go", "javascript", "typescript", "rust" },
    highlight = {
        enable = false,
    }
}


-- LSP
--
local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.ensure_installed({
    "gopls",
    "volar",
    "tsserver",
    "rust_analyzer",
    "lua_ls",
    "eslint",
    "zls",
})

require("mason").setup()
require("mason-lspconfig").setup()


-- Custom methods
--
function code_format()
    vim.lsp.buf.format()
    if (vim.bo.filetype == "go")
    then
        local clients = vim.lsp.buf_get_clients()
        for _, client in pairs(clients) do
            local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
            params.context = { only = { "source.organizeImports" } }

            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
        end
    end
end

--lsp.on_attach(function(client, bufnr)
local opts = { buffer = bufnr, remap = false }
--end)



lsp.setup({})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        virtual_text = true,
        underline = false,
    }
)


-- COMMENT
--
require("nvim_comment").setup({
    operator_mapping = "<leader>/"
})


-- LAZY GIT
--
require('telescope').load_extension('lazygit')


-- TERMINAL SETUP
--
require("toggleterm").setup()


-- FELINE
--

require('gitsigns').setup()

local one_monokai = {
    fg = "#abb2bf",
    bg = "#1e2024",
    green = "#98c379",
    yellow = "#e5c07b",
    purple = "#c678dd",
    orange = "#d19a66",
    peanut = "#f6d5a4",
    red = "#e06c75",
    aqua = "#61afef",
    darkblue = "#282c34",
    dark_red = "#f75f5f",
}

local vi_mode_colors = {
    NORMAL = "green",
    OP = "green",
    INSERT = "yellow",
    VISUAL = "purple",
    LINES = "orange",
    BLOCK = "dark_red",
    REPLACE = "red",
    COMMAND = "aqua",
}

local c = {
    vim_mode = {
        provider = {
            name = "vi_mode",
            opts = {
                show_mode_name = true,
                -- padding = "center", -- Uncomment for extra padding.
            },
        },
        hl = function()
            return {
                fg = require("feline.providers.vi_mode").get_mode_color(),
                bg = "darkblue",
                style = "bold",
                name = "NeovimModeHLColor",
            }
        end,
        left_sep = "block",
        right_sep = "block",
    },
    gitBranch = {
        provider = "git_branch",
        hl = {
            fg = "peanut",
            bg = "darkblue",
            style = "bold",
        },
        left_sep = "block",
        right_sep = "block",
    },
    gitDiffAdded = {
        provider = "git_diff_added",
        hl = {
            fg = "green",
            bg = "darkblue",
        },
        left_sep = "block",
        right_sep = "block",
    },
    gitDiffRemoved = {
        provider = "git_diff_removed",
        hl = {
            fg = "red",
            bg = "darkblue",
        },
        left_sep = "block",
        right_sep = "block",
    },
    gitDiffChanged = {
        provider = "git_diff_changed",
        hl = {
            fg = "fg",
            bg = "darkblue",
        },
        left_sep = "block",
        right_sep = "right_filled",
    },
    separator = {
        provider = "",
    },
    fileinfo = {
        provider = {
            name = "file_info",
            opts = {
                type = "relative-short",
            },
        },
        hl = {
            style = "bold",
        },
        left_sep = " ",
        right_sep = " ",
    },
    diagnostic_errors = {
        provider = "diagnostic_errors",
        hl = {
            fg = "red",
        },
    },
    diagnostic_warnings = {
        provider = "diagnostic_warnings",
        hl = {
            fg = "yellow",
        },
    },
    diagnostic_hints = {
        provider = "diagnostic_hints",
        hl = {
            fg = "aqua",
        },
    },
    diagnostic_info = {
        provider = "diagnostic_info",
    },
    lsp_client_names = {
        provider = "lsp_client_names",
        hl = {
            fg = "purple",
            bg = "darkblue",
            style = "bold",
        },
        left_sep = "left_filled",
        right_sep = "block",
    },
    file_type = {
        provider = {
            name = "file_type",
            opts = {
                filetype_icon = true,
                case = "titlecase",
            },
        },
        hl = {
            fg = "red",
            bg = "darkblue",
            style = "bold",
        },
        left_sep = "block",
        right_sep = "block",
    },
    file_encoding = {
        provider = "file_encoding",
        hl = {
            fg = "orange",
            bg = "darkblue",
            style = "italic",
        },
        left_sep = "block",
        right_sep = "block",
    },
    position = {
        provider = "position",
        hl = {
            fg = "green",
            bg = "darkblue",
            style = "bold",
        },
        left_sep = "block",
        right_sep = "block",
    },
    line_percentage = {
        provider = "line_percentage",
        hl = {
            fg = "aqua",
            bg = "darkblue",
            style = "bold",
        },
        left_sep = "block",
        right_sep = "block",
    },
    scroll_bar = {
        provider = "scroll_bar",
        hl = {
            fg = "yellow",
            style = "bold",
        },
    },
}

local left = {
    c.vim_mode,
    c.gitBranch,
    c.gitDiffAdded,
    c.gitDiffRemoved,
    c.gitDiffChanged,
    c.separator,
}

local middle = {
    c.fileinfo,
    c.diagnostic_errors,
    c.diagnostic_warnings,
    c.diagnostic_info,
    c.diagnostic_hints,
}

local right = {
    c.lsp_client_names,
    c.file_type,
    c.file_encoding,
    c.position,
    c.line_percentage,
    c.scroll_bar,
}

local components = {
    active = {
        left,
        middle,
        right,
    },
}

require('feline').setup({
    components = components,
    theme = one_monokai,
    vi_mode_colors = vi_mode_colors,
})

-- AUTOPAIRS
--
require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt", "vim" },
})

-- *.md to pdf
--
require('md-pdf').setup({
    --- Set margins around document
    margins = "1.5cm",
    --- tango, pygments are quite nice for white on white
    highlight = "tango",
})

require("notify").setup({})
