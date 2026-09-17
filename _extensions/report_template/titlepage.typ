// ===== TITLE PAGE: `titlepage` ====================

#let titlepage(
  doc-category,
  doc-title,
  doc-subtitle,             // subtitle added
  author,
  affiliation,
  logo,
  heading-font,             // the heading-font is also used for all text on the titlepage
  heading-color,            // heading-color applies as well for the title
  info-size,                // used throughout the document for "info text"
  datetime-fmt,
) = {

  // ----- Page-Setup ------------------------
  set page(
    paper: "a4",
    margin: (top: 3cm, left: 4.5cm, right: 3cm, bottom: 4.5cm),
  )

  // Some basic rules for the title page layout:
  // - logo is right-justified
  // - all other elements are left-justified
  // - the page uses a grid of 1.5 cm units

  // ----- Logo ------------------------
  place(
    top + right,
    logo,
  )

  v(6cm)

  // ----- Title Category ------------------------
  align(
    left,
    text(
      font: heading-font,
      weight: "regular",
      size: 14pt,
      doc-category,
    ),
  )

  // ----- Title ------------------------
  text(
    font: heading-font,
    weight: "light",
    size: 36pt,
    fill: heading-color,
    doc-title,
  )

  // ----- Subtitle ------------------------
  if doc-subtitle != none and doc-subtitle != "" {
    v(0.4cm)

    text(
      font: heading-font,
      weight: "regular",
      size: 18pt,
      fill: luma(40%).mix(heading-color),
      doc-subtitle,
    )
  }

  // ----- Info Block ------------------------
  set par(leading: 1em)

  place(
    bottom + left,
    text(
      font: heading-font,
      weight: "regular",
      size: info-size,
      fill: black,

      datetime.today().display(datetime-fmt)
      + str("\n")
      + author
      + str("\n")
      + affiliation
    ),
  )
}
