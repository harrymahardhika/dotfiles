local use = require("plugin-util").use

return use("text-case.nvim", "johmsalas/text-case.nvim", {
  pack = "opt",
  keys = {
    { lhs = "ga.", mode = "n", desc = "Text case picker" },
    { lhs = "ga.", mode = "x", desc = "Text case picker" },
  },
  config = function()
    require("textcase").setup({})

    local actions = {
      { "Title Case", "to_title_case" },
      { "UPPER CASE", "to_upper_case" },
      { "lower case", "to_lower_case" },
      { "snake_case", "to_snake_case" },
      { "dash-case", "to_dash_case" },
      { "Title-Dash-Case", "to_title_dash_case" },
      { "CONSTANT_CASE", "to_constant_case" },
      { "dot.case", "to_dot_case" },
      { "camelCase", "to_camel_case" },
      { "PascalCase", "to_pascal_case" },
      { "path/case", "to_path_case" },
      { "Phrase case", "to_phrase_case" },
      { "UPPER PHRASE CASE", "to_upper_phrase_case" },
      { "lower phrase case", "to_lower_phrase_case" },
      { "comma,case", "to_comma_case" },
    }

    local items = {}
    local by_name = {}
    for _, a in ipairs(actions) do
      items[#items + 1] = a[1]
      by_name[a[1]] = a[2]
    end

    local function picker()
      local textcase = require("textcase")
      require("fzf-lua").fzf_exec(items, {
        prompt = "Cases> ",
        winopts = { height = 0.4, width = 0.5 },
        actions = {
          ["default"] = function(selected)
            local fn = by_name[selected[1]]
            if fn then
              textcase.current_word(fn)
            end
          end,
        },
      })
    end

    vim.keymap.set("n", "ga.", picker, { desc = "Text case picker" })

    vim.keymap.set("x", "ga.", function()
      local utils = require("textcase.shared.utils")
      local region = utils.get_visual_region(0, true)

      require("fzf-lua").fzf_exec(items, {
        prompt = "Cases> ",
        winopts = { height = 0.4, width = 0.5 },
        actions = {
          ["default"] = function(selected)
            local fn = by_name[selected[1]]
            if fn then
              local conversion = require("utils")
              conversion.do_substitution(
                region.start_row,
                region.start_col,
                region.end_row,
                region.end_col,
                require("textcase").api[fn].apply
              )
            end
          end,
        },
      })
    end, { desc = "Text case picker (visual)" })
  end,
})
