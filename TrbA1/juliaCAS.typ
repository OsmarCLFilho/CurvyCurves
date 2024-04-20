#let jlBlack  = rgb("282f2f")
#let jlGreen  = rgb("389826")
#let jlRed    = rgb("cb3c33")
#let jlPurple = rgb("9558b2")

#let title = "Julia como CAS"
#let subtitle = "Usando Reduce e Plots.jl"
#let author = "Osmar Cardoso Lopes Filho"

#let hdcnt = align(
  horizon,

  [
    #set text(size: 14pt)

    #text(fill: jlGreen, sym.circle.filled)
    #text(fill: jlRed, sym.circle.filled)
    #text(fill: jlPurple, sym.circle.filled)
    #smallcaps([*#title*])
    #box(width: 1fr, line(length: 100%, stroke: jlBlack))
  ]
)

#set page(
  paper: "a4",
  numbering: "1",

  header: locate(loc => {
    if loc.page() > 1 {
      hdcnt
    }
  })
)

#set text(
  lang: "pt"
)

#set math.mat(
  delim: "["
)

#set heading(
  numbering: "1.1"
)

#show raw.where(block: true): it => {
  block(
    fill: luma(240),
    width: 100%,
    inset: 10pt,
    radius: 8pt,

    it
  )
}

#show link: underline
#show link: set text(fill: jlPurple)

#let titlecontent = align(
  center + horizon,
  [
    #set text(fill: white, size: 20pt)
    
    #v(20%)

    #text(size: 60pt, weight: 300, title) \ \
    #text(size: 30pt, weight: 100, subtitle) \
    
    #v(5%)

    #author

    #v(20%)

    #line(length: 90%, stroke: white)

    #v(5%)

    #link("https://github.com/OsmarCLFilho/CurvyCurves")[GitHub]\
  ]
)

#let titlepage() = page(
  margin: 0pt,

  background: grid(
    columns: (20%, 1fr),
    rows: (100%),

    [],
    image("cover.png", height: 250%)
  ),

  grid(
    columns: (60%, 1fr, 1fr, 1fr, 30%),
    rows: (100%),
    fill: (
      jlBlack,
      jlGreen,
      jlRed,
      jlPurple,
      none
    ),

    stroke: (
      none,
      jlGreen,
      jlRed,
      jlPurple,
      none
    ),

    titlecontent,
    [],
    [],
    [],
    []
  )
)

#titlepage()

#show outline.entry.where(level: 1): it => {
  box(
    fill: luma(240),
    outset: 4pt,

    strong(it)
  )
}

#outline(
  indent: auto
)

#v(10pt)
#line(length: 100%, stroke: jlBlack)
#v(10pt)

= Introdução
== REDUCE
Como descrito no #link("http://reduce-algebra.sourceforge.io/index.php")[site oficial], REDUCE é um
sistema algébrico computacional (CAS em inglês) portátil e de uso geral. Seu desenvolvimento teve
início na década de 1960, com sua primeira versão sendo lançada ao público em 1968 (10 anos antes da
primeira versão do antigo Macsyma).

Ainda que por grande parte de sua existência tenha sido um programa comercial e pago, em 2008 o
código fonte for aberto e o REDUCE passou a ser grátis e livre.

== Reduce.jl
O pacote #link("https://github.com/chakravala/Reduce.jl")[Reduce.jl] é uma interface entre a
linguagem Julia e o Reduce. Seu funcionamento pode ser dividido em duas partes: Primeiramente,
variáveis do tipo `Symbol`, `Expr` são traduzidas para expressões algébricas e envidas para o
Reduce. Em seguida, o resultado é analizado sintaticamente para reconstruir ASTs (_Abstract Syntax
Trees_) em Julia.

Reduce.jl é capaz de estender localmente as funções nativas de Julia para os tipos `Symbol` e
`Expr`, permitindo escrevermos expressões simbólicas sem nos preocupar com novas sintaxes.

= Instalação
== Julia
Para instalar a linguagem Julia, acesse o #link("https://julialang.org/")[site oficial] e siga as
instruções na aba "Download". A partir disso, você terá em seu sistema dois executaveis em CLI
(_command line interface_): `julia` e `juliaup`. Seus usos são:

 - `julia`: Inicializar o REPL (Read-Eval-Print-Loop) interativo da linguagem ou compilar código em
   Julia caso um arquivo seja passado junto com o comando;

 - `juliaup`: Atualizar e gerenciar versões da linguagem Julia no sistema,

== Kernel IJulia
Para utilizar Julia através do Jupyter Notebook ou Lab, instale primeiro a linguagem e depois siga
as instruções de instalação do pacote #link("https://github.com/JuliaLang/IJulia.jl")[IJulia.jl].
Feito isso, o Jupyter deve ser capaz de identificar o _kernel_ de Julia instalado pelo pacote em seu
sistema.

== Reduce.jl
Para instalar o #link("https://github.com/chakravala/Reduce.jl")[Reduce.jl], siga as instruções na
seção "Setup" da #link("https://reduce.crucialflow.com/stable/#Setup")[documentação]. Esse processo também instalará um executavel do
Reduce para uso com o pacote. Portanto, não precisamos nos preocupar em instalar o Reduce
manualmente.

= Curvas em Duas Dimensões
== Parametrização
Em duas dimensões, curvas são parametrizadas por aplicações da seguinte forma:
$
  alpha: I --> RR^2 \
$

Podendo serem separadas em componentes para cada coordenada:
$
  alpha_i: I --> RR, thick i = 1, 2 \
  alpha(t) = (alpha_1(t), alpha_2(t)), thick t in I
$

Caso $alpha$ seja diferenciável, o seguinte vetor, chamado de vetor tangente, é bem definido:
$
  alpha'(t) = (alpha'_1(t), alpha'_2(t)), thick t in I
$

Para renderizar essas curvas, usaremos o pacote
#link("https://github.com/JuliaPlots/Plots.jl")[Plots.jl]. Contudo, precisamos antes coletar alguns
pontos ao longo de seus traços para então desenhá-las. Fazemos isso através da seguinte função:

```julia
function curvepoints(expressions, exprvar, trange)
    rangelen = length(trange)
    domaindim = length(expressions)
    points = zeros(Float64, (rangelen, domaindim))

    for i in 1:rangelen
        eval(:($exprvar = $(trange[i])))
        points[i, :] = eval.(expressions)
    end

    return points
end
```

Nela, uma array de expressões, `expressions`, a variável parâmetro, `exprvar` e os valores dessa
variável, `trange` são passados. Então, a função avalia o parâmetro em cada valor e depois a
expressão com esse parâmetro. O resultado obtido é guardado na array `points`.

Feito isso, desenharemos a @spiral1 como exemplo:
$
  alpha(t) = (cos(t) log(t+1), sin(t) log(t+1))
$

```julia
  using Plots

  curve = [:(cos(t) * log(t+1)), :(sin(t) * log(t+1))]
  cpnts = curvepoints(curve, :t, range(0, 30*π, length=1500))

  plot(
    (cpnts[:,1], cpnts[:,2]);

    linewidth=2,
    size=(600,600),
    label="",
    aspect_ratio=1
  )
```

#figure(
  image("sprl1.png", width: 60%),
  caption: [Curva espiral.]
) <spiral1>

Criaremos também uma função para calcular os vetores velocidade em certos pontos na curva:

```julia
  df(:x, :x)
  function curvevectors(expressions, exprvar, tvalues)
      valueslen = length(tvalues)
      domaindim = length(expressions)
      vectors = zeros(Float64, (valueslen*3, domaindim))

      derivatives = df.(expressions, exprvar)

      for i in 1:valueslen
          eval(:($exprvar = $(tvalues[i])))

          e_expr = eval.(expressions)
          e_derv = eval.(derivatives)
          
          vectors[(i-1)*3 + 1, :] = e_expr
          vectors[(i-1)*3 + 2, :] = e_expr + e_derv
          vectors[(i-1)*3 + 3, :] = fill(NaN, (1, domaindim))
      end

      return vectors
  end
```

Com isso, desenhamos a @spiral2:

```julia
plot!(
    (cvecs[:,1], cvecs[:,2]);
    
    linewidth=2,
    arrow=true,
    label=""
)
```

#figure(
  image("sprl2.png", width: 60%),
  caption: [Curva espiral com vetores velocidade.]
) <spiral2>

== Regularidade
Define-se como curva regular qualquer curva $alpha: I --> RR^n$ que satifaz o seguinte:

$
  forall t in I, thick alpha'(t) != 0
$

== Reparametrização
Uma reparametrização de uma curva $alpha$ é uma aplicação $beta: I_0 --> RR^2$ tal que $forall t in
I_0, thick beta(t) = alpha(phi(t))$, onde $phi: I_0 --> I$ é um difeomorfismo.

Dado dois conjuntos abertos, $U in RR^n$ e $V in RR^m$, definimos como difeomorfismo qualquer
bijeção $f: U --> V$ tal que ambas $f$ e $f^(-1)$ sejam diferenciáveis.

Definimos uma reparametrização $beta = alpha circle.small phi$ como positiva caso $phi' > 0$. Caso
$phi' < 0$, definimos $beta$ como uma reparametrização negativa.

== Comprimento de Arco
Definimos o comprimento de arco de uma curva regular $alpha$ da seguinte forma:
$
  L(alpha) = integral^b_a ||alpha'(t)|| d t
  = integral^b_a sqrt(angle.l alpha' "," alpha' angle.r) d t
$

Como essa função é um difeomorfismo, podemos usá-la para reparametrizar curvas. Seja $phi(s) =
L^(-1)(t)$ sua invérsa, definimos $beta(s) = alpha circle.small phi (s)$ como a reparametrização por
comprimento de arco, ou unit-speed, de $alpha$.

Para calcular esse comprimento, escrevemos primeiro sua expressão simbolicamente e tentamos
simplificá-la computacionalmente. Caso isso seja possível, Reduce retornará uma expressão fechada.
Caso contrário, o comando inicial ou expressões com outras integrais podem ser retornadas. A seguir,
escrevemos a expressão para o comprimento da curva já apresentada:

```julia
  curved1t = df.(curve, :t)
  curvelen = int(sqrt(curved1t[1]^2 + curved1t[2]^2), :t)
```

O resultado obtido é:

```julia
  :(int((sqrt((t ^ 2 + 2t + 1) * log(t + 1) ^ 2 + 1) * sqrt(cos(t) ^ 2 + sin(t) ^ 2)) / abs(t + 1), t))
```

$
  integral((sqrt((t ^ 2 + 2t + 1) log(t + 1) ^ 2 + 1) thick sqrt(cos(t) ^ 2 + sin(t) ^ 2))
  / abs(t + 1)) d t
$

Ou seja, ainda temos uma integral, mas com uma expressão expandida. Em seguida, utilizamos o pacote
`TRIGSIMP` do Reduce para simplificar expressões trigonométricas:

```julia
  curvelen = :(trigsimp($curvelen)) |> rcall
```

$
  integral(sqrt((t ^ 2 + 2t + 1) thick log(t + 1) ^ 2 + 1) / abs(t + 1))
$

A partir desse ponto, utilizamos ferramentas computacionais para resolver o problema.

== Curvatura
Primeiramente, dado o círculo unitário $S^1$ e a curva diferenciável $gamma: I --> S^1$, definimos a
função ângulo como $theta(s)$ tal que $gamma(s) = (cos(theta(s)), sin(theta(s)))$.

Feito isso, tomamos uma curva $alpha(t)$ com $||alpha'(t)|| = 1 thick forall t in I$ (unit-speed).
Concluímos que $alpha': I --> S^1$ e tomamos sua função ângulo $theta$. Definimos então sua
curvatura $kappa (t)$ da seguinte forma:
$
  kappa(t) = theta'(t) = det(alpha'(t), alpha''(t))
$

Como $alpha'(t)$ é um vetor unitário, concluímos que $|kappa(t)| = ||alpha''(t)||$.

Por exemplo, consideremos o círculo de raio 2, centrado na origem. Calculamos a seguir a primeira
derivada da sua expressão:

```julia
  circexpr = [:(r*cos(t)), :(r*sin(t))]
  r = 2
  circexprd1t = df.(circexpr, :t)
```

Prosseguimos calculando o comprimento de arco:

```julia
  :(trigsimp(sqrt($(circexprd1t[1])^2 + $(circexprd1t[2])^2))) |> rcall
```

Com isso, obtemos $|r| = r$. Concluímos, portanto, que a invérsa comprimento de arco é dada por
$phi(s) = s/r$.

Reparametrizamos, então, o círculo e calculamos suas derivadas:

```julia
  t = :(s/r)
  circexpr = [:(r*cos($t)), :(r*sin($t))]
  circexprd1t = df.(circexpr, :s)
  circexprd2t = df.(circexpr, :s, 2)
```

Verificamos que a primeira derivada é unitária e prosseguimos calculando o absoluto da curvatura a
partir da segunda derivada:

```julia
  :(trigsimp(sqrt($(circexprd2t[1])^2 + $(circexprd2t[2])^2))) |> rcall
```

Concluímos que a curvatura é dada por $1/r$ em todos os pontos.

= Curvas em Três Dimensões
Para desenhar curvas em 3 dimensões, utilizamos as mesmas funções que já escrevemos:

```julia
  curve3d = [:(cos(t) * log(t+1)), :(sin(t) * log(t+1)), :(t)]

  curve3dpnts = curvepoints(curve3d, :t, range(0, 30*π, length=1500))
  curve3dvecs = curvevectors(curve3d, :t, range(0, 30*π, length=1500))

  plot(
    (curve3dpnts[:,1], curve3dpnts[:,2], curve3dpnts[:,3]);
    
    linewidth=2,
    size=(600,600),
    label="",
    aspect_ratio=1,
    seriescolor=:inferno,
    line_z=f(x,y,z) = z,
    colorbar_entry=false
  )
```

#figure(
  image("spiral3d.png", width: 60%),
  caption: [Espiral tridimensional.]
)

== Equações de Frenet
Seja $alpha(t): I --> RR^3$, $alpha(t) = (alpha_1 (t), alpha_2 (t), alpha_3 (t))$, tal que:
 - $||alpha''(t)|| != 0 thick forall t$;
 - $||alpha'(t)|| = 1 thick forall t$

Com isso, definimos a seguinte base ortonormal para o $RR^3$:
$
  T := (d r)/(d s); quad
  N := ((d T)/(d s)) / (||(d T)/(d s)||); quad
  B := T times N
$

Concluimos que:
$
  mat(
    T'; N'; B'
  )
  =
  mat(
    0, kappa, 0;
    -kappa, 0, tau;
    0, -tau, 0
  )
  mat(
    T; N; B
  )
$

Onde $kappa$ é a curvatura e $tau$ a torsão de $alpha$.

