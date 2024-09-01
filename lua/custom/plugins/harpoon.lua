return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon'):setup()
    end,
    keys = function()
      local harpoon = require 'harpoon'
  
      local conf = require('telescope.config').values
  
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
  
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end
  
        local make_finder = function()
          local paths = {}
  
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end
  
          return require('telescope.finders').new_table {
            results = paths,
          }
        end
  
        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_buffer_number, map)
              map('i', '<c-d>', function()
                local state = require 'telescope.actions.state'
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_buffer_number)
  
                harpoon:list():remove(selected_entry)
                current_picker:refresh(make_finder())
              end)
              return true
            end,
          })
          :find()
      end
  
      return {
        {
          '<leader>hf',
          function()
            toggle_telescope(harpoon:list())
          end,
          desc = '[H]arpoon [F]ind',
        },
        {
          '<leader>ha',
          function()
            harpoon:list():add()
          end,
          desc = '[H]arpoon: [A]dd',
        },
  
        -- Toggle previous & next buffers stored within Harpoon list
        {
          '<c-p>',
          function()
            harpoon:list():prev()
          end,
          desc = 'Harpoon: Previous',
        },
  
        {
          '<c-n>',
          function()
            harpoon:list():next()
          end,
          desc = 'Harpoon: Next',
        },
      }
    end,
  }
  