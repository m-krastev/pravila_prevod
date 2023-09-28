// This function gets your whole document as its `body` and formats
// it as a simple fiction book.
#let book(
  // The book's title.
  title: "Book title",

  subtitle: "Subtitle",

  // The book's author.
  author: "Author",


  // The paper size to use.
  paper: "iso-b5",

  // A dedication to display on the third page.
  dedication: none,

  // Details about the book's publisher that are
  // display on the second page.
  publishing-info: none,

  // The book's content.
  body,
) = {

  set text(lang:"ru")
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font. TeX Gyre Pagella is a free alternative
  // to Palatino.
  set text(font: "Times New Roman")

  // Configure the page properties.
  set page(
    paper: paper,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )

  // The first page.
  page(align(center + horizon)[
    #text(2em)[*#title*]
    #v(1em, weak: true)
    #text(1.2em)[   #emph[#subtitle]]
    #v(2em, weak:true)
    #text(1.6em, author)
  ])

  // Display publisher info at the bottom of the second page.
  if publishing-info != none {
    align(center + bottom, text(0.8em, publishing-info))
  }

//   TODO: add for publishing
//   pagebreak()

  // Display the dedication at the top of the third page.
  if dedication != none {
    v(15%)
    align(center, strong(dedication))
  }

  // Books like their empty pages.
//   TODO: Add for publishing
//   pagebreak(to: "odd")

  // Configure paragraph properties.
  set par(leading: 0.78em, first-line-indent: 12pt, justify: true)
  show par: set block(spacing: 0.78em)

  // Start with a chapter outline.
  outline(title: [Съдържание],depth:2, indent: true)

  show outline.entry : it => {
    strong[it.entry]
  }

  // Configure page properties.
  set page(
    numbering: "1",

    // The header always contains the book title on odd pages and
    // the chapter title on even pages, unless the page is one
    // the starts a chapter (the chapter title is obvious then).
    header: locate(loc => {
      // Are we on an odd page?
      let i = counter(page).at(loc).first()
      if calc.odd(i) {
        return text(0.95em, smallcaps(title))
      }

      // Are we on a page that starts a chapter? (We also check
      // the previous page because some headings contain pagebreaks.)
      let all = query(heading, loc)
      if all.any(it => it.location().page() in (i - 1, i)) {
        return
      }

      // Find the heading of the section we are currently in.
      let before = query(selector(heading).before(loc), loc)
      if before != () {
        align(right, text(0.95em, smallcaps(before.last().body)))
      }
    }),
  )

  // Configure chapter headings.
  show heading.where(level: 1): it => {
    // Always start on odd pages.
    // pagebreak(to: "odd")

    // TODO: Fix for publishing
    pagebreak()

    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(1.25em)
    text(1.5em, weight: 700, block([#it.body]))
    v(1.25em)
  }
  show heading: set text(14pt, weight: 800)

  show heading: set block(spacing: 1.2em)

  body
}
