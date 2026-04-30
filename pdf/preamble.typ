// Show-Rules werden vor #show: doc => conf(...) eingefuegt und ueberschreiben
// das Default-Styling von Pandocs Typst-Template fuer ueberschriften, Tabellen,
// Code, Links und Listen.

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
