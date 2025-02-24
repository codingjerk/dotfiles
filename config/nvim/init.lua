---@diagnostic disable: lowercase-global

-- TODO:
--
-- Database (SQL + SSH) tool
--
-- Write telegram / reddit post
-- Add config to dotfiles repo
-- Share screenshots

-------------
-- Plugins --
-------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

vim.cmd.colorscheme("nuitbleue")

require("lazy").setup({
    local_spec = false,
    install = { missing = false },

    spec = {
        -- Pydoc
        {
            "fredrikaverpil/pydoc.nvim",
            version = "*",
            cmd = { "PyDoc" },
            opts = {
                window = {
                    type = "vsplit",
                },
                highlighting = {
                    language = "markdown",
                },
                picker = {
                    type = "telescope",
                    telescope_options = {
                        layout_config = {
                            horizontal = {
                                preview_width = 0.7,
                            },
                        },
                    },
                },
            },
        },

        -- Copilot
        {
            "zbirenbaum/copilot.lua",
            event = "VeryLazy",
            config = function()
                require("copilot").setup({
                    panel = {
                        enabled = false,
                    },
                    suggestion = {
                        auto_trigger = true,
                    },
                    filetypes = {
                        markdown = true,
                        yaml = true,
                        gitcommit = true,
                    },
                })
            end,
        },

        -- Copilot chat
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            event = "VeryLazy",
            build = "make tiktoken",
            opts = {
                question_header = "#  User",
                answer_header = "#  AI",
                error_header = "#  ERROR",
                separator = "",
                highlight_headers = false,

                model = "gpt-4o",
                agent = "copilot",

                window = {
                    border = "none",
                },
                show_help = false,
                show_folds = false,

                selection = false,

                chat_autocomplete = false,

                mappings = {
                    submit_prompt = {
                        normal = "<c-cr>",
                        insert = "<c-cr>",
                    },
                },

                system_prompt = ([[
                    You are an advanced expert code-focused AI programming assistant helping with advanced topics.
                    You answer search-like questions, help with refactoring, optimizations and ideas.
                    You answer with succinctness and clarity. You do not include unnecessary explanations, comments and notes until user asks for them.

                    Your user is an expert programmer, using Python, Rust, Bash and Linux.
                ]]):gsub("%s+", " "),

                prompts = {
                    commit = "Write commit message in conventional-commit style with emoji (after ':'). #git",
                    ask =
                    "I ask general question, not related to current project. I want generic answer with details and explanation",
                    explain = "Explain what selected code is doing",
                    opt =
                    "Optimize selected code, if there is no guaranteed straightforward solution, try to give advices on optimization or guide on where to reseach. If there is guaranteed straightforward optimizations, explain them too",
                    write =
                    "Implement a new part of code I'll ask for. Make code complete, correct and clean like I would write myself. Write: "
                },
            },
        },

        -- Better notifications
        {
            "rcarriga/nvim-notify",
            event = "VeryLazy",
            opts = {
                timeout = 2000,
                stages = "static",
                render = "minimal",
            },
        },

        -- Better UI
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            config = function()
                require("noice").setup({
                    routes = {
                        -- Remove search counter
                        {
                            filter = { event = "msg_show", kind = "search_count" },
                            opts = { skip = true },
                        },
                        -- Remove save file message
                        {
                            filter = { find = " written" },
                            opts = { skip = true },
                        },
                        -- Remove undo/redo messages
                        {
                            filter = { find = " before #" },
                            opts = { skip = true },
                        },
                        {
                            filter = { find = " after #" },
                            opts = { skip = true },
                        },
                        -- Remove paste messages
                        {
                            filter = { find = " more lines" },
                            opts = { skip = true },
                        },
                        -- LSP hover messages
                        {
                            filter = { find = "No information available" },
                            opts = { skip = true },
                        },
                    },
                    window = {
                        border = "rounded",
                    },
                    messages = {
                        enabled = true,
                    },
                    lsp = {
                        progress = {
                            enabled = false,
                        },
                    },
                    presets = {
                        bottom_search = true,
                        command_palette = true,
                        long_message_to_split = true,
                        inc_rename = false,
                        lsp_doc_border = true,
                    },
                })
            end,
        },

        -- Color column as a characters
        {
            "lukas-reineke/virt-column.nvim",
            opts = {},
            config = function()
                require("virt-column").setup({
                    char = "¦",
                    virtcolumn = "80,120",
                })
            end,
        },

        -- Move diagnostics to top
        {
            "dgagn/diagflow.nvim",
            version = false,
            event = "VeryLazy",
            opts = {
                padding_right = 2,
                gap_size = 2,
                -- FIXME: wait until author fixes https://github.com/dgagn/diagflow.nvim/issues/54
                show_borders = true,
                border_chars = {
                    top_left = " ",
                    top_right = " ",
                    bottom_left = " ",
                    bottom_right = " ",
                    horizontal = " ",
                    vertical = " "
                },
                scope = "line",
                format = function(diagnostic)
                    -- NOTE: NBSP from pyright breaking the border
                    -- NOTE: quotes from harper too
                    return diagnostic.message:gsub(" ", ".")
                        :gsub("“", "\"")
                        :gsub("”", "\"")
                end,
            }
        },

        -- Indentation guides
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {},
            config = function()
                require("ibl").setup({
                    indent = { char = "¦" },
                    scope = {
                        enabled = true,
                        show_start = false,
                        show_end = false,
                    },
                })
            end,
        },

        -- Completion
        {
            "hrsh7th/nvim-cmp",
            event = "VeryLazy",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
            },
            config = function()
                local cmp = require("cmp")

                local cmp_kinds = {
                    Text = '󰊄 ',
                    Method = '󰊕 ',
                    Function = '󰊕 ',
                    Constructor = '󰊕 ',
                    Field = '󰬟 ',
                    Variable = '󰬟 ',
                    Class = ' ',
                    Interface = '󰬐 ',
                    Module = '󰰐 ',
                    Property = '󰬟  ',
                    Unit = ' ',
                    Value = ' ',
                    Enum = ' ',
                    Keyword = ' ',
                    Snippet = ' ',
                    Color = ' ',
                    File = ' ',
                    Reference = ' ',
                    Folder = ' ',
                    EnumMember = ' ',
                    Constant = ' ',
                    Struct = ' ',
                    Event = ' ',
                    Operator = ' ',
                    TypeParameter = ' ',
                }

                cmp.setup({
                    preselect = false,
                    window = {
                        completion = cmp.config.window.bordered {
                            border = 'single',
                            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                        },
                        documentation = cmp.config.window.bordered {
                            border = 'single',
                            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                        },
                    },
                    mapping = {
                        ["<down>"] = cmp.mapping.select_next_item(),
                        ["<up>"] = cmp.mapping.select_prev_item(),
                        ["<c-e>"] = cmp.mapping.close(),
                        ["<c-cr>"] = cmp.mapping.confirm(),
                        -- NOTE: handled by tab_complete function
                        -- ["<tab>"] = cmp.mapping.select_next_item(),
                        ["<s-tab>"] = cmp.mapping.select_prev_item(),
                    },
                    sources = {
                        { name = "nvim_lsp" },
                        { name = "buffer" },
                        { name = "path" },
                    },
                    formatting = {
                        fields = { 'kind', 'abbr' },
                        format = function(_, vim_item)
                            vim_item.kind = cmp_kinds[vim_item.kind] or ''
                            vim_item.menu = ''
                            return vim_item
                        end,
                    },
                })
            end,
        },

        -- Multiple cursors
        --   Alternatives:
        --   - terryma/vim-multiple-cursors -- kinda works with custom mappings, but deprecated and buggy
        --   - mg979/vim-visual-multi -- doesn't work with custom mappings
        --   - jake-stewart/multicursor.nvim -- works, but is not interactive
        --   - brenton-leighton/multiple-cursors.nvim -- doesn't work with custom mappings
        {
            "jake-stewart/multicursor.nvim",
            event = "VeryLazy",
            branch = "1.0",
            config = function()
                local mc = require("multicursor-nvim")

                mc.setup()

                vim.keymap.set({ "n", "v" }, "C", function() mc.lineAddCursor(1) end)
                vim.keymap.set({ "n", "v" }, "<c-d>", function() mc.matchAddCursor(1) end)
                vim.keymap.set({ "v" }, "l", function() mc.splitCursors("\n") end)

                vim.keymap.set("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    elseif mc.hasCursors() then
                        mc.clearCursors()
                    else
                        vim.cmd("nohlsearch")
                    end
                end)
            end,
        },

        -- LSP
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lsp = require("lspconfig")
                local border = {
                    { "┌", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "┐", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "┘", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "└", "FloatBorder" },
                    { "│", "FloatBorder" },
                }

                local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
                function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                    opts = opts or {}
                    opts.border = opts.border or border
                    return orig_util_open_floating_preview(contents, syntax, opts, ...)
                end

                -- General
                lsp.harper_ls.setup({
                    settings = {
                        ["harper-ls"] = {
                            diagnosticSeverity = "error",
                        }
                    },
                })

                -- LUA
                lsp.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                -- For init.lua
                                globals = {
                                    'vim',
                                    'require'
                                },
                            },
                            telemetry = { enable = false },
                        },
                    },
                })

                -- Python
                -- Autocomplete, Imports, Type checking
                lsp.pyright.setup({
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict",

                                diagnosticSeverityOverrides = {
                                    -- Fix diagnostics level
                                    reportUnknownParameterType = "warning",
                                    reportMissingParameterType = "warning",
                                    reportUnknownArgumentType = "warning",
                                    reportUnknownLambdaType = "warning",
                                    reportUnknownMemberType = "warning",
                                    reportUnusedFunction = "warning",
                                    reportUntypedFunctionDecorator = "warning",
                                    reportDeprecated = "warning",

                                    -- Enable extra diagnostics
                                    reportUnusedCallResult = "warning",
                                    reportUninitializedInstanceVariable = "warning",

                                    -- Gradual typing in new projects
                                    reportMissingImports = false,
                                    reportMissingTypeStubs = false,
                                    reportUnknownVariableType = false,

                                    -- Covered by ruff
                                    reportUnusedImport = false,
                                },
                            },
                        },
                    },
                })

                -- Linting / formatting
                lsp.ruff.setup({})

                -- Rust
                lsp.rust_analyzer.setup({
                    settings = {
                        ["rust-analyzer"] = {
                            cachePriming = {
                                enable = false,
                            },
                            cargo = {
                                -- Use separate target directory for rust-analyzer to remove interferences with cargo
                                targetDir = true,
                            },
                            check = {
                                command = "clippy",
                            },
                            procMacro = {
                                enable = true,
                            },
                            completion = {
                                limit = 1024,
                                callable = {
                                    snippets = "none",
                                },
                                postfix = {
                                    enable = false,
                                },
                                hideDeprecated = true,
                            },
                            imports = {
                                preferNoStd = true,
                            },
                            lens = {
                                enable = false,
                            },
                            diagnostics = {
                                experimental = {
                                    enabled = true,
                                },
                                styleLints = {
                                    enable = true,
                                },
                            },
                            rustfmt = {
                                extraArgs = {
                                    "--config=empty_item_single_line=false",
                                    "--config=wrap_comments=true",
                                    "--config=condense_wildcard_suffixes=true",
                                    "--config=enum_discrim_align_threshold=10",
                                    "--config=format_code_in_doc_comments=true",
                                    "--config=hex_literal_case=Upper",
                                    "--config=max_width=120",
                                    "--config=reorder_impl_items=true",
                                    "--config=group_imports=StdExternalCrate",
                                    "--config=use_field_init_shorthand=true",
                                },
                            },
                        },
                    },
                })

                -- JavaScript
                lsp.ts_ls.setup({})
            end,
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            version = false, -- Last release is way too old
            event = "VeryLazy",
            build = ":TSUpdate",
            config = function()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "lua", "python", "rust" },
                    sync_install = false,
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    indent = { enable = true },
                })
            end,
        },

        -- Treesitter text objects
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            event = "VeryLazy",
            keys = {
                {
                    "mf",
                    function()
                        vim.cmd("normal! v")
                        require("nvim-treesitter.textobjects.select").select_textobject("@function.inner")
                    end,
                    mode = "n",
                },
                {
                    "ma",
                    function()
                        vim.cmd("normal! v")
                        require("nvim-treesitter.textobjects.select").select_textobject("@parameter.inner")
                    end,
                    mode = "n",
                },
                {
                    "mm",
                    function()
                        vim.cmd("normal! v")
                        require("nvim-treesitter.textobjects.select").select_textobject("@call.inner")
                    end,
                    mode = "n",
                },
                {
                    "Mf",
                    function()
                        vim.cmd("normal! v")
                        require("nvim-treesitter.textobjects.select").select_textobject("@function.outer")
                    end,
                    mode = "n",
                },
            },
        },

        -- Git gutter
        {
            "lewis6991/gitsigns.nvim",
            event = "VeryLazy",
            config = function()
                local signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '▁' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '⋯' },
                    untracked    = { text = '┆' },
                }

                require("gitsigns").setup({
                    signs = signs,
                    signs_staged = signs,
                    numhl = false,
                })
            end,
        },

        -- Scrollbar
        {
            "petertriho/nvim-scrollbar",
            event = "VeryLazy",
            opts = {
                handlers = {
                    cursor = false,
                    diagnostic = true,
                    gitsigns = true,
                    handle = true,
                },
            },
        },

        -- File picker / Live grep
        {
            "nvim-telescope/telescope.nvim",
            event = "VeryLazy",
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                local actions = require("telescope.actions");
                local actions_layout = require("telescope.actions.layout")

                require("telescope").setup({
                    defaults = {
                        -- Close pickers on first Escape instead of going to normal mode
                        mappings = {
                            i = {
                                ["<esc>"] = actions.close,
                                ["<c-p>"] = actions_layout.toggle_preview,
                            },
                        },
                        sorting_strategy = "ascending",

                        results_title = "",
                        prompt_title = "",
                        preview_title = "",
                        prompt_prefix = " ",

                        layout_config = {
                            horizontal = {
                                width = 0.9,
                                height = 0.9,
                                prompt_position = "top",
                                preview_cutoff = 80,
                                preview_width = 0.5,
                            },
                            vertical = {
                                width = 0.9,
                                height = 0.9,
                                prompt_position = "top",
                                preview_cutoff = 20,
                                preview_width = 0.5,
                                preview_height = 0.5,
                            },
                        },
                    },
                    pickers = {
                        buffers = {
                            bufnr_width = 0,
                            sort_lastused = true,
                            prompt_title = "",
                            preview_title = "",
                        },
                        diagnostics = {
                            layout_strategy = "vertical",
                            path_display = "hidden",
                            prompt_title = "",
                            preview_title = "",
                        },
                        find_files = {
                            prompt_title = "",
                            preview_title = "",
                        },
                        lsp_document_symbols = {
                            prompt_title = "",
                            preview_title = "",
                        },
                        live_grep = {
                            prompt_title = "",
                            preview_title = "",
                        },
                        lsp_references = {
                            prompt_title = "",
                        },
                    },
                })
            end,
        },

        -- Breadcrumbs
        {
            'Bekaboo/dropbar.nvim',
            event = "VeryLazy",
            config = function()
                require('dropbar').setup({
                    icons = {
                        ui = {
                            bar = {
                                separator = "  ",
                            },
                        },
                        kinds = {
                            symbols = {
                                File = " ",
                                Function = "󰊕 ",
                                Method = "󰊕 ",
                                Class = " ",
                                Enum = " ",
                                Struct = " ",
                                Object = "󰬐 ", -- Rust's impl
                            },
                        },
                    },
                    bar = {
                        enable = function(buf, win, _)
                            if
                                not vim.api.nvim_buf_is_valid(buf)
                                or not vim.api.nvim_win_is_valid(win)
                                or vim.fn.win_gettype(win) ~= ''
                                or vim.wo[win].winbar ~= ''
                                or vim.bo[buf].ft == 'help'
                            then
                                return false
                            end

                            return true
                        end,
                        ---@diagnostic disable-next-line: unused-local
                        sources = function(buf, _)
                            local sources = require('dropbar.sources')
                            local bar = require('dropbar.bar')

                            local state_source = {
                                get_symbols = function(sym_buf, win, _)
                                    local icon_hl = "Title"
                                    local name_hl = "Normal"

                                    if vim.api.nvim_buf_get_option(sym_buf, "modified") then
                                        icon_hl = "WarningMsg"
                                    end

                                    if vim.api.nvim_buf_get_option(sym_buf, "readonly") then
                                        icon_hl = "Error"
                                        name_hl = "Error"
                                    end

                                    local cwd = vim.fn.getcwd()
                                    local project_name = vim.fn.fnamemodify(cwd, ":t")

                                    return {
                                        bar.dropbar_symbol_t:new(setmetatable({
                                            buf = sym_buf,
                                            win = win,
                                            icon = "󰏗 ",
                                            icon_hl = icon_hl,
                                            name = project_name,
                                            name_hl = name_hl,
                                        }, {}))
                                    }
                                end,
                            }

                            local function simplify_impl_name(symbol)
                                local name = symbol.name
                                -- Check if the symbol name matches the "impl ... for ..." pattern
                                if name:match("^impl%s+.+for%s+") then
                                    -- Extract Trait and Type using pattern matching
                                    local trait, type = name:match("^impl%s+(.+)%s+for%s+(.+)$")
                                    if trait and type then
                                        -- Simplify to "<Type>::<Trait>"
                                        symbol.name = string.format("%s::%s", type, trait)
                                    end
                                elseif name:match("^impl%s+.+") then
                                    -- Extract Type using pattern matching
                                    local type = name:match("^impl%s+(.+)$")
                                    if type then
                                        -- Simplify to "<Type>"
                                        symbol.name = type
                                    end
                                end

                                return symbol
                            end

                            local lsp_source = {
                                get_symbols = function(sym_buf, win, cursor)
                                    local symbols = sources.lsp.get_symbols(sym_buf, win, cursor)
                                    -- Apply the simplification to each symbol
                                    for i, symbol in ipairs(symbols) do
                                        symbols[i] = simplify_impl_name(symbol)
                                    end

                                    -- Remove symbols for lua
                                    if vim.bo[sym_buf].ft == "lua" then
                                        symbols = vim.tbl_filter(function(symbol)
                                            -- Objects and Packages
                                            -- It's statements and tables in reality
                                            return (symbol.icon ~= "󰬐 " and symbol.icon ~= "󰆦 ")
                                        end, symbols)
                                    end

                                    return symbols
                                end,
                            }

                            return {
                                state_source,
                                sources.path,
                                -- sources.lsp,
                                lsp_source,
                            }
                        end,
                    },
                    sources = {
                        path = {
                            max_depth = 1,
                        },
                        lsp = {
                            valid_symbols = {
                                'File',
                                'Module',
                                'Namespace',
                                'Package',
                                'Class',
                                'Method',
                                'Property',
                                'Field',
                                'Constructor',
                                'Enum',
                                'Interface',
                                'Function',
                                'Constant',
                                -- 'String',
                                -- 'Number',
                                -- 'Boolean',
                                -- 'Array',
                                'Object',
                                -- 'Keyword',
                                'Null',
                                -- 'EnumMember',
                                'Struct',
                                'Event',
                                -- 'Operator',
                                'TypeParameter',
                            }
                        },
                    },
                })
            end
        },

        -- Highlight TODO-style comments
        {
            "folke/todo-comments.nvim",
            event = "VeryLazy",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local todos = require("todo-comments")
                todos.setup({
                    keywords = {
                        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                        TODO = { icon = " ", color = "info" },
                        HACK = { icon = "󰈸 ", color = "warning" },
                        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                        PERF = { icon = " ", color = "info", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                        NOTE = { icon = " ", color = "info", alt = { "INFO" } },
                        TEST = { icon = "󰙨 ", color = "warning", alt = { "TESTING", "PASSED", "FAILED" } },
                    },
                    highlight = {
                        multiline = false,
                        pattern = [[.*<(KEYWORDS)\s*]],
                        keyword = "fg",
                        after = "",
                    },
                    colors = {
                        error = { "ErrorMsg" },
                        warning = { "WarningMsg" },
                        info = { "Todo", "Normal" },
                        hint = { "Comment" },
                    },
                })

                vim.keymap.set("n", "]t", todos.jump_next, {})
                vim.keymap.set("n", "[t", todos.jump_prev, {})
            end,
        },

        -- Restore last position in file
        -- NOTE: it's deprecated, but works just fine
        -- NOTE: we need it in addition to session restore
        {
            "ethanholz/nvim-lastplace",
            config = function()
                require("nvim-lastplace").setup({})
            end,
        },

        -- Restore all buffers and their positions
        {
            "rmagatti/auto-session",
            lazy = false, -- We need to restore session ASAP

            opts = {
                suppressed_dirs = { '~/', '/', '~/downloads' },
                session_lens = {
                    theme_conf = {
                        layout_strategy = "horizontal",
                        prompt_title = "",
                        layout_config = {
                            prompt_position = "top",
                            width = 60,
                            height = 30,
                        },
                    },
                },
            },
        },

        -- Wakatime
        {
            "wakatime/vim-wakatime",
            lazy = false, -- In official install
        },
    },
})

--------------
-- Settings --
--------------

-- Do not hide markdown elements in AI chat and documentation
vim.opt.conceallevel = 0

-- Disable swap files
vim.opt.swapfile = false

-- Increase gutter spacing
vim.opt.statuscolumn = "%s%=%l  "

-- Disable mouse
vim.opt.mouse = ""

-- Show line numbers
vim.opt.number = true

-- Disable fill character (in gutter)
vim.opt.fillchars = "eob: ,vert:¦"

-- Enable case-insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable soft wrapping
vim.opt.wrap = false

-- Merge command line and status line
vim.opt.cmdheight = 0

-- Tab as 4 spaces
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Always keep sign column on
vim.opt.signcolumn = "yes"

-- Copy to system's clipboard
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Save undo history
vim.opt.undofile = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time
vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- White space characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '•', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 6

-- Hide status line
vim.opt.laststatus = 0

-- Remove welcome screen
vim.opt.shortmess:append("A")
vim.opt.shortmess:append("I") -- No intro
vim.opt.shortmess:append("s") -- Search wrap without message
vim.opt.shortmess:append("c") -- Unsuccessful search without prompt

-- Diagnostics
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "󰈸", texthl = "Warn" })
vim.fn.sign_define("DiagnosticSignSpell", { text = "X", texthl = "Warn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽", texthl = "Info" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "Hint" })

vim.diagnostic.config({
    underline = {
        min = vim.diagnostic.severity.ERROR,
        max = vim.diagnostic.severity.ERROR,
    },
    severity_sort = true,
})

-- Spelling

-- FIXME:
-- vim.opt.spell = true
-- vim.opt.spelllang = "en"

-----------------
-- Keybindings --
-----------------

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set({ "n", "v" }, "<leader>t", "<cmd> TodoTelescope <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd> Telescope find_files <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>k", "<cmd> Telescope keymaps <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>b", "<cmd> Telescope buffers <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>/", "<cmd> Telescope live_grep <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>j", "<cmd> Telescope jumplist <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>h", "<cmd> Telescope help_tags <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>d", "<cmd> Telescope diagnostics <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>s", "<cmd> Telescope lsp_document_symbols <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>S", "<cmd> Telescope lsp_workspace_symbols <cr>", {})

vim.keymap.set({ "n", "v" }, "<leader>p", "<cmd> SessionSearch <cr>", {})

-- WASD
vim.keymap.set({ "n", "v" }, "w", "k", {})
vim.keymap.set({ "n", "v" }, "s", "j", {})
vim.keymap.set({ "n", "v" }, "a", "h", {})
vim.keymap.set({ "n", "v" }, "d", "l", {})

vim.keymap.set({ "n", "v", "o" }, "q", "^", {})
vim.keymap.set({ "n", "v", "o" }, "e", "$", {})

vim.keymap.set({ "n", "v" }, "W", "5k", {})
vim.keymap.set({ "n", "v" }, "S", "5j", {})
vim.keymap.set({ "n", "v", "o" }, "A", "b", {})
vim.keymap.set({ "n", "v", "o" }, "D", "w", {})

vim.keymap.set({ "n", "v" }, "Q", "I", {})
vim.keymap.set({ "n", "v" }, "E", "A", {})

-- Windows
vim.keymap.set({ "n", "v" }, "<c-left>", "<c-w>h", {})
vim.keymap.set({ "n", "v" }, "<c-right>", "<c-w>l", {})
vim.keymap.set({ "n", "v" }, "<c-down>", "<c-w>j", {})
vim.keymap.set({ "n", "v" }, "<c-up>", "<c-w>k", {})

-- Jumps
vim.keymap.set({ "n", "v" }, "j", "<c-o>", {})
vim.keymap.set({ "n", "v" }, "J", "<c-i>", {})

-- Modifications
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Undo
vim.keymap.set({ "n", "v" }, "U", "<c-r>", {})

-- Git
vim.keymap.set({ "n", "v" }, "gs", "<cmd> Telescope git_status <cr>", {})

-- Save
vim.keymap.set({ "n", "v", "i" }, "<c-s>", "<cmd> w <cr>", {})

-- Selections
vim.keymap.set({ "n", "v" }, "mw", "viw", {})
vim.keymap.set({ "n", "v" }, "mb", "vib", {})
vim.keymap.set({ "n", "v" }, "m(", "vib", {})
vim.keymap.set({ "n", "v" }, "mp", "vip", {})
vim.keymap.set({ "n", "v" }, "mq", "vi\"", {})
vim.keymap.set({ "n", "v" }, "m\"", "vi\"", {})

vim.keymap.set({ "n" }, "(", "vib", {})
vim.keymap.set({ "n" }, "\"", "vi\"", {})

vim.keymap.set({ "v" }, "(", ":s/\\%V\\(.*\\)/\\(\\1\\)/<cr>", { silent = true })
vim.keymap.set({ "v" }, "\"", ":s/\\%V\\(.*\\)/\"\\1\"/<cr>", { silent = true })

-- LSP
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "gr", "<cmd> Telescope lsp_references <cr>", {})
vim.keymap.set({ "n", "v" }, "h", vim.lsp.buf.hover, {})
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {})
vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, {})
vim.keymap.set({ "n", "v" }, "<c-f>", vim.lsp.buf.format, {})

-- AI
function toggle_copilot()
    local chat = require("CopilotChat")
    local select = require("CopilotChat.select")

    local selection = false
    if vim.api.nvim_get_mode().mode ~= "n" then
        selection = select.visual
    end

    chat.toggle({ selection = selection })
end

vim.keymap.set({ "n", "v" }, "<leader>c", toggle_copilot, {})

-- Completion
-- Some advanced but very practical and easy to use logic:
--   Continue nvim-cmp completion, if it's already active
--   Accept copilot suggestion, if any
--   Use nvim-cmp, if any
--   If in insert mode, insert tab
function tab_complete()
    local copilot = require("copilot.suggestion")
    local cmp = require("cmp")

    if cmp.get_selected_index() ~= nil then
        return cmp.select_next_item()
    end

    if copilot.is_visible() then
        return copilot.accept()
    end

    if cmp.visible() then
        return cmp.select_next_item()
    end

    if vim.api.nvim_get_mode().mode == "i" then
        vim.fn.feedkeys("\t")
        return
    end
end

vim.keymap.set({ "i" }, "<tab>", tab_complete, {})

-- Don't modify clipboard
vim.keymap.set({ "n", "v" }, "X", '"_x', {})
vim.keymap.set({ "n", "v" }, "c", '"_c', {})
vim.keymap.set({ "x", "v" }, "p", 'P', {})
vim.keymap.set({ "x", "v" }, "P", 'P', {})
vim.keymap.set({ "n" }, "V", '"_V', {})
