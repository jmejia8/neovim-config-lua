-- Follow the system light/dark preference (freedesktop portal) with gruvbox
local M = {}

local light_bg = "#f6f2e7"

local portal = {
  "--session",
  "--dest", "org.freedesktop.portal.Desktop",
  "--object-path", "/org/freedesktop/portal/desktop",
}

-- color-scheme: 0 = no preference, 1 = prefer dark, 2 = prefer light
local function to_background(value)
  return value == "2" and "light" or "dark"
end

local function system_background()
  if vim.fn.executable("gdbus") == 0 then
    return "dark"
  end
  local cmd = { "gdbus", "call", "--timeout", "1" }
  vim.list_extend(cmd, portal)
  vim.list_extend(cmd, {
    "--method", "org.freedesktop.portal.Settings.Read",
    "org.freedesktop.appearance", "color-scheme",
  })
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return "dark"
  end
  return to_background(out:match("uint32 (%d)"))
end

function M.apply(background)
  -- Light mode uses the "hard" contrast slot with a custom background,
  -- so the dark palette stays untouched
  require("gruvbox").setup({
    contrast = background == "light" and "hard" or "",
    palette_overrides = { light0_hard = light_bg },
  })
  vim.o.background = background
  vim.cmd.colorscheme("gruvbox")
end

-- Re-apply the theme when the system preference changes
local function watch()
  if vim.fn.executable("gdbus") == 0 then
    return
  end
  local cmd = { "gdbus", "monitor" }
  vim.list_extend(cmd, portal)
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, lines)
      for _, line in ipairs(lines) do
        if line:find("'color%-scheme'") then
          local background = to_background(line:match("uint32 (%d)"))
          if background ~= vim.o.background then
            vim.schedule(function()
              M.apply(background)
            end)
          end
        end
      end
    end,
  })
end

function M.setup()
  M.apply(system_background())
  watch()
end

return M
