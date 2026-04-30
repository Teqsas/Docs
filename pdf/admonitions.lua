-- Pandoc Lua filter: turns Divs with class "admonition" into raw Typst calls
-- to the #admonition() helper defined in pdf/preamble.typ.

function Div(el)
  if not el.classes:includes("admonition") then
    return nil
  end

  local kind = "info"
  for _, c in ipairs(el.classes) do
    if c ~= "admonition" then
      kind = c
      break
    end
  end

  local title = el.attributes["title"] or ""
  local title_escaped = title:gsub("\\", "\\\\"):gsub('"', '\\"')

  local body_typst = pandoc.write(pandoc.Pandoc(el.content), "typst")

  local raw = string.format(
    '#admonition(kind: "%s", title: "%s")[\n%s\n]\n',
    kind, title_escaped, body_typst
  )
  return pandoc.RawBlock("typst", raw)
end
