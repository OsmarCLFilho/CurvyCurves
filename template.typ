#let animlink(repolink, animation, content) = [
  #link(repolink + "/Animations/" + animation)[#content]
]

#let makedoc(
  title: "Curvas e Superfícies",
  subtitle: "N-ésima Lista",
  author: "Osmar Cardoso Lopes Filho",
  email: "osmarclopesfilho@gmail.com",
  repolink: "https://github.com/OsmarCLFilho/CurvyCurves/tree/main",
  doc
) = {
  set par(
    justify: true
  )

  let headercont = align(horizon)[
    #smallcaps[#title #h(1fr) #subtitle]
  ]

  set page(
    header: locate(
      loc => {
        if loc.page() > 1 {headercont}
      }
    ),

    numbering: "1"
  )

  show link: set text(fill: rgb(20%, 20%, 100%))

  show raw.where(block: true): it => {
    block(
      width: 100%,
      fill: rgb(90%, 95%, 95%),
      inset: 10pt,
      radius: 5pt,
      breakable: true,
      it
    )
  }

  align(
    center,
    table(
      columns: (1fr, 1fr),
      align: (left + horizon, right + horizon),
      stroke: none,

      [
        #text(20pt)[* #smallcaps(title) *] \
        #text(18pt)[#sym.triangle.filled.r #smallcaps(subtitle)] \
        #datetime.today().display("[day]/[month]/[year]")
      ],
      [
        #text(12pt)[#author \ #email] \
      ]
    )
  )

  box(width: 100%, height: 0.5pt, fill: black)

  box(
    width: 100%,
    radius: 5pt,
    fill: rgb(90%, 90%, 90%),
    inset: 5pt,

    align(center)[ 
      Esse documento possui códigos que geram animações no formato `gif` e que podem ser acessadas
      separadamente no #link(repolink)[repositório].
    ]
  )

  doc
}
