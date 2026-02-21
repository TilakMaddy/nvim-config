return {
  "yetone/avante.nvim",
  cmd = { "AvanteToggle", "AvanteAsk", "AvanteEdit", "AvanteNewChat", "AvanteModels", "AvanteSwitchProvider" },
  version = false,
  build = "make",
  config = function(_, opts)
    require("avante").setup(opts)
    local Sidebar = require("avante.sidebar")
    Sidebar.get_todos_container_height = function(self)
      local Path = require("avante.path")
      local history = Path.history.load(self.code.bufnr)
      if #history.todos == 0 then return 0 end
      return 5
    end
  end,
  ---@type table
  opts = {
    provider = "openrouter",
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = [[cmd:sed -n 's/^export OPENROUTER_API_KEY="\(.*\)"/\1/p' ~/.zshrc]],
        model = "anthropic/claude-sonnet-4",
      },
    },
    input = {
      provider = "snacks",
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        local sidebar = require("avante").get()
        if sidebar and sidebar:is_open() then
          require("avante").close_sidebar()
        else
          require("avante.api").zen_mode()
        end
      end,
      desc = "Avante Zen Toggle",
    },
    {
      "<leader>aa",
      function() require("avante.api").zen_mode() end,
      mode = "v",
      desc = "Avante Zen Mode",
    },
    {
      "<leader>an",
      function()
        require("avante.api").ask({
          new_chat = true,
          show_logo = true,
          sidebar_post_render = function(sidebar) sidebar:toggle_code_window() end,
        })
      end,
      desc = "Avante New Chat (Zen)",
    },
    { "<leader>am", "<cmd>AvanteModels<cr>", desc = "Avante Models" },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
