local M = {}

local prettier = {
  [".prettierrc"] = true,
  [".prettierrc.json"] = true,
  [".prettierrc.json5"] = true,
  [".prettierrc.yaml"] = true,
  [".prettierrc.yml"] = true,
  [".prettierrc.toml"] = true,
  [".prettierrc.js"] = true,
  [".prettierrc.cjs"] = true,
  [".prettierrc.mjs"] = true,
  [".prettierrc.ts"] = true,
  [".prettierrc.cts"] = true,
  [".prettierrc.mts"] = true,
  ["prettier.config.js"] = true,
  ["prettier.config.cjs"] = true,
  ["prettier.config.mjs"] = true,
  ["prettier.config.ts"] = true,
  ["prettier.config.cts"] = true,
  ["prettier.config.mts"] = true,
}

local eslint = {
  [".eslintrc"] = true,
  [".eslintrc.js"] = true,
  [".eslintrc.cjs"] = true,
  [".eslintrc.json"] = true,
  [".eslintrc.yaml"] = true,
  [".eslintrc.yml"] = true,
  ["eslint.config.js"] = true,
  ["eslint.config.cjs"] = true,
  ["eslint.config.mjs"] = true,
  ["eslint.config.ts"] = true,
  ["eslint.config.cts"] = true,
  ["eslint.config.mts"] = true,
}

local biome = { ["biome.json"] = true, ["biome.jsonc"] = true, [".biome.json"] = true, [".biome.jsonc"] = true }
local oxfmt = { [".oxfmtrc.json"] = true, [".oxfmtrc.jsonc"] = true, ["oxfmt.config.ts"] = true }
local oxlint = { [".oxlintrc.json"] = true, [".oxlintrc.jsonc"] = true, ["oxlint.config.ts"] = true }

local function package_config(path)
  local file = io.open(path, "r")
  if not file then
    return {}
  end
  local contents = file:read("*a")
  file:close()
  local ok, config = pcall(vim.json.decode, contents)
  return ok and type(config) == "table" and config or {}
end

-- Walk from the edited file upwards so a package's config wins over a monorepo's.
local function find_config(filename, names, package_key)
  if filename == "" then
    return nil
  end
  local dir = vim.fs.dirname(vim.fs.normalize(filename))
  while dir do
    for name in pairs(names) do
      if vim.uv.fs_stat(vim.fs.joinpath(dir, name)) then
        return dir
      end
    end
    if package_key and package_config(vim.fs.joinpath(dir, "package.json"))[package_key] then
      return dir
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
end

local function nearest(filename, choices)
  local selected, selected_dir
  for _, choice in ipairs(choices) do
    local dir = find_config(filename, choice.files, choice.package_key)
    if dir and (not selected_dir or #dir > #selected_dir) then
      selected, selected_dir = choice.name, dir
    end
  end
  return selected
end

function M.formatter(filename)
  return nearest(filename, {
    { name = "biome", files = biome },
    { name = "prettier", files = prettier, package_key = "prettier" },
    { name = "oxfmt", files = oxfmt },
  }) or "oxfmt"
end

function M.has_oxfmt_config(filename)
  return find_config(filename, oxfmt) ~= nil
end

function M.linter(filename)
  return nearest(filename, {
    { name = "biome", files = biome },
    { name = "eslint", files = eslint, package_key = "eslintConfig" },
    { name = "oxlint", files = oxlint },
  }) or "oxlint"
end

return M
