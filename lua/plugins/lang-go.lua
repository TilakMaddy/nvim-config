return {
    -- Debugging (delve)
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
            { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
            { "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle [B]reakpoint" },
            {
                "<leader>bc",
                function()
                    require("dap").set_breakpoint(vim.fn.input "Condition: ")
                end,
                desc = "Debug: [C]onditional Breakpoint",
            },
            { "<leader>br", function() require("dap").restart() end, desc = "Debug: [R]estart" },
            { "<leader>bq", function() require("dap").terminate() end, desc = "Debug: [Q]uit" },
            { "<leader>bu", function() require("dapui").toggle() end, desc = "Debug: Toggle [U]I" },
            { "<leader>bt", function() require("dap-go").debug_test() end, desc = "Debug: Nearest Go [T]est" },
        },
        config = function()
            local dap, dapui = require "dap", require "dapui"
            dapui.setup()
            require("nvim-dap-virtual-text").setup {}
            require("dap-go").setup()

            dap.listeners.after.event_initialized["dapui"] = dapui.open
            dap.listeners.before.event_terminated["dapui"] = dapui.close
            dap.listeners.before.event_exited["dapui"] = dapui.close
        end,
    },

    -- Test runner
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "fredrikaverpil/neotest-golang",
        },
        keys = {
            { "<leader>Tt", function() require("neotest").run.run() end, desc = "Test: Nearest" },
            { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test: File" },
            { "<leader>Ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: All" },
            { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Test: Last" },
            {
                "<leader>Td",
                function()
                    require("neotest").run.run { strategy = "dap" }
                end,
                desc = "Test: Debug Nearest",
            },
            { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test: Summary" },
            {
                "<leader>To",
                function()
                    require("neotest").output.open { enter = true, auto_close = true }
                end,
                desc = "Test: Output",
            },
            { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Test: Output Panel" },
        },
        config = function()
            require("neotest").setup {
                adapters = { require "neotest-golang" {} },
            }
        end,
    },
}
