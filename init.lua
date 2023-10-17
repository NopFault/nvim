print("NopFault! Keep Coding")

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
        use "windwp/windline.nvim",
        use { "akinsho/toggleterm.nvim", tag = '*' },
        use { 'akinsho/bufferline.nvim', tag = '*' },
        use "terrortylor/nvim-comment",
        use "lewis6991/gitsigns.nvim",
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

vim.keymap.set("n", "<leader>nn", ":e /Users/nopfault/Library/Mobile Documents/iCloud~md~obsidian/Documents/<CR>", opts)

vim.keymap.set('n', '<C-h>', ':bprev<CR>', opts)
vim.keymap.set('n', '<C-l>', ':bnext<CR>', opts)
vim.keymap.set('n', '<C-n>', ':enew<CR>', opts)
vim.keymap.set('n', '<C-q>', ':bdelete<CR>', opts)

vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts)

vim.keymap.set("n", "<leader>sf", ":source %<CR>", opts)

vim.keymap.set("n", "<leader>tt", ":ToggleTerm size=90 direction=horizontal <CR>", opts)

vim.keymap.set('n', '<C-t>', ':r! date "+\\%Y-\\%m-\\%d" <CR>', opts)


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


-- BUFFERS
--
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


-- TREESITTER
--
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "go", "javascript", "typescript", "rust" },
    highlight = {
        enable = false,
    }
}


-- LSP
--
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "tsserver",
    "gopls",
    "eslint",
    "rust_analyzer",
})

lsp.set_preferences({
    sign_icons = {}
})

-- Custom method for imports
function org_imports()
    vim.lsp.buf.format()
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

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', "<C-f>", function() org_imports() end, opts)
end)

lsp.setup()

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


-- WIND LINE
--
require('wlsample.bubble')
require('gitsigns').setup()
