// Show-Rules und Helper-Funktionen, via --include-in-header eingespeist.

// ---------- Admonitions ----------

#let admonition_palette = (
  danger:   (border: rgb("#cc0000"), fill: rgb("#fdecec"), label: "Gefahr"),
  warning:  (border: rgb("#cc7700"), fill: rgb("#fff6e8"), label: "Warnung"),
  info:     (border: rgb("#005599"), fill: rgb("#eef4fa"), label: "Hinweis"),
  abstract: (border: rgb("#555555"), fill: rgb("#f1f1f1"), label: "Achtung"),
  note:     (border: rgb("#005599"), fill: rgb("#eef4fa"), label: "Hinweis"),
  tip:      (border: rgb("#0a8754"), fill: rgb("#eaf6ee"), label: "Tipp"),
)

#let admonition(kind: "info", title: none, body) = {
  let p = admonition_palette.at(kind, default: admonition_palette.info)
  let header_text = if title != none and title != "" { title } else { p.label }
  block(
    width: 100%,
    inset: 10pt,
    radius: 3pt,
    fill: p.fill,
    stroke: (left: 3pt + p.border),
    breakable: false,
    [
      #text(weight: "bold", fill: p.border)[#header_text]
      #v(0.3em)
      #body
    ],
  )
  v(0.4em)
}

// ---------- Cover ----------

#let cover(
  title: "",
  vendor: "TEQSAS PRODUCTS",
  subtitle: "Bedienungsanleitung",
  logo: none,
) = {
  set page(header: none, footer: none, numbering: none)
  v(1.5fr)
  if logo != none {
    align(center)[#image(logo, width: 55mm)]
    v(1.2em)
  }
  align(center)[
    #text(size: 11pt, weight: "bold", tracking: 2pt, fill: rgb("#222"))[#vendor]
  ]
  v(2.5fr)
  align(center)[
    #text(size: 30pt, weight: "bold")[#title]
  ]
  v(0.8em)
  align(center)[
    #text(size: 13pt, fill: rgb("#555"))[#subtitle]
  ]
  v(3fr)
  pagebreak()
}

// ---------- Show-Rules ----------

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  set text(size: 22pt, weight: "bold")
  block(it.body, above: 0pt, below: 0.8em)
  v(0.4em)
}

#show heading.where(level: 2): it => {
  set text(size: 14pt, weight: "bold", fill: rgb("#1a1a1a"))
  block(it.body, above: 1.3em, below: 0.5em)
}

#show heading.where(level: 3): it => {
  set text(size: 11.5pt, weight: "bold")
  block(it.body, above: 0.9em, below: 0.3em)
}

#show heading.where(level: 4): it => {
  set text(size: 10.5pt, weight: "bold", style: "italic")
  block(it.body, above: 0.7em, below: 0.2em)
}

#show link: it => text(fill: rgb("#0055aa"), it)

#show raw.where(block: true): it => block(
  fill: rgb("#f5f5f5"),
  inset: 9pt,
  radius: 3pt,
  width: 100%,
  text(size: 9pt, it),
)

#show raw.where(block: false): it => box(
  fill: rgb("#f5f5f5"),
  inset: (x: 3pt, y: 0pt),
  radius: 2pt,
  text(size: 0.95em, it),
)

#set par(justify: true, leading: 0.62em)

#set list(indent: 0.6em, body-indent: 0.5em, marker: ([•], [◦], [‣]))

#set table(stroke: 0.5pt + rgb("#bbb"), inset: 6pt)
#show table.cell.where(y: 0): set text(weight: "bold")
