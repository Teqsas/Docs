-- Pandoc Lua filter: turns Divs with class "admonition" into raw Typst calls
-- to the #admonition() helper defined in pdf/preamble.typ.

-- Map signal words (German) to normative hazard levels (ANSI Z535.6 / ISO 3864).
local title_to_level = {
  ["Gefahr"]   = "danger",
  ["GEFAHR"]   = "danger",
  ["Warnung"]  = "warning",
  ["Warnung!"] = "warning",
  ["WARNUNG"]  = "warning",
  ["Vorsicht"] = "caution",
  ["VORSICHT"] = "caution",
  ["Achtung"]  = "notice",
  ["ACHTUNG"]  = "notice",
  ["Hinweis"]  = "notice",
  ["HINWEIS"]  = "notice",
  ["Tipp"]     = "tip",
  ["TIPP"]     = "tip",
}

function Div(el)
  if not el.classes:includes("admonition") then
    return nil
  end

  -- Default kind from the markdown class (info/warning/danger/abstract/...)
  local kind = "info"
  for _, c in ipairs(el.classes) do
    if c ~= "admonition" then
      kind = c
      break
    end
  end

  local title = el.attributes["title"] or ""

  -- Title takes precedence so '!!! warning "Vorsicht"' renders as caution-yellow,
  -- while '!!! warning "Warnung"' renders as warning-orange.
  if title ~= "" and title_to_level[title] then
    kind = title_to_level[title]
  end

  local title_escaped = title:gsub("\\", "\\\\"):gsub('"', '\\"')
  local body_typst = pandoc.write(pandoc.Pandoc(el.content), "typst")

  local raw = string.format(
    '#admonition(kind: "%s", title: "%s")[\n%s\n]\n',
    kind, title_escaped, body_typst
  )
  return pandoc.RawBlock("typst", raw)
end
