-- Image-Anpassungen fuer den PDF-Build.
-- 1) MkDocs-Material liefert "_dark" Asset-Varianten fuer das dunkle Theme.
--    Im PDF auf weissem Papier brauchen wir die hellen Originale.
-- 2) Pandoc reicht numerische width/height aus '{ width="480" }' als Zahl
--    durch. Typst image() erwartet aber eine Length oder 'auto'. Typst
--    kennt keine 'px'-Einheit, daher haengen wir 'pt' an. Bei den
--    typischen MkDocs-Bildbreiten (240..480) ergibt das eine Anzeigegroesse
--    knapp unter A4-Druckbreite (~480pt = 169mm).

local function strip_dark(src)
  return (src:gsub("(_dark)(%.[A-Za-z0-9]+)$", "%2"))
end

local function ensure_length(value)
  if value == nil or value == "" then return value end
  if value:match("[%a%%]$") then return value end -- already has a unit
  if tonumber(value) then return value .. "pt" end
  return value
end

function Image(el)
  el.src = strip_dark(el.src)
  el.attributes.width  = ensure_length(el.attributes.width)
  el.attributes.height = ensure_length(el.attributes.height)
  return el
end
