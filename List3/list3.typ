#import "../template.typ": makedoc, animlink

#let repolink = "https://github.com/OsmarCLFilho/CurvyCurves/tree/main/List3"

#set math.mat(delim:"[")

#show: doc => makedoc(
  subtitle: "Lista 3",
  repolink: repolink,
  doc
)

= Questão 1
== Item 1
Dada uma reta qualuer $alpha(t) = (a + t c, b + t d), thick t in RR$, verificamos que sua derivada
existe e é dada por $alpha'(t) = (c, b)$. Dado isso, como $alpha' != 0$, concluimos que $alpha$
*é regular*.

Seu comprimento de arco no intervalo $[p, q]$ é:

$
  integral_p^q ||alpha'(t)|| d t = sqrt(c^2 + d^2)(q - p)
$

== Item 2
Dada a curva $alpha(t) = (t, t^4), thick t in RR$, verificamos que sua derivada existe e é dada
por $alpha'(t) = (1, 4t^3)$. Dado isso, como $alpha' != 0$, concluimos que $alpha$ *é regular*.

== Item 3
Dada a curva $alpha(s) = (a + r cos(s/r), b + r sin(s/r)), thick s in RR, thick r > 0$,
verificamos que sua derivada existe e é dada por $alpha(-sin(s), cos(s))$. Dado isso, como
$alpha' != 0$, concluimos que $alpha$ *é regular*.

Seu comprimento de arco no intervalo $[0, 2 pi r]$ é:

$
  integral_p^q ||alpha'(t)|| d t = r;
$

== Item 4
Dada a curva $alpha(t) = (cos(t)(2 cos(t) - 1), sin(t)(2 cos(t) - 1)), thick t in RR$, verificamos
que sua derivada existe e é dada por $alpha'(t) = (sin(t) - 2 sin(2t), 2 cos(2t) - cos(t))$.
Dado isso, como $alpha' != 0$, concluimos que $alpha$ *é regular*.

Para obter sua integral, calculamos seu comprimento de arco em coordenadas polares:

$
  integral_p^q sqrt(r(theta)^2 + r'(theta)^2) d theta
  =
  integral_p^q sqrt(5 - 4 cos(theta)) d theta
$

Onde $r = 2 cos(theta) - 1$.

== Item 5
Dada a curva $alpha(t) = (t, cosh(t)), thick t in RR$, verificamos que sua derivada existe e é
dada por $alpha'(t) = (1, sinh(t))$. Dado isso, como $alpha != 0$, concluimos que $alpha$ *é regular*.

#pagebreak
= Questão 2
Começamos escrevendo:

$
   & arg_t "minmax" k(t) \
  =& arg_t "minmax" (a b)/(sqrt((a sin(t))^2 + (b cos(t))^2))^3
$

Como $f(x) = x^3$ é injetiva e crescente:

$
  =& arg_t "minmax" (a b)^3/(sqrt((a sin(t))^2 + (b cos(t))^2))
$

E dado que constantes não alteram o parâmetro maximizador/minimizador:

$
  =& arg_t "minmax" 1/(sqrt((a sin(t))^2 + (b cos(t))^2))
$

Em seguida, já que nossa expressão é positiva e $f(x) = 1/x$ é injetiva e decrescente
no domínio $RR^+$:

$
  =& arg_t "maxmin" sqrt((a sin(t))^2 + (b cos(t))^2)
$

Finalmente, como $f(x) = sqrt(x)$ é injetiva e crescente:

$
  =& arg_t "maxmin" (a sin(t))^2 + (b cos(t))^2
$

Suponha então, sem perda de generalidade, que $a > b$. Concluimos, portanto, uma vez que
$sin(t)^2 + cos(t)^2 = 1$, que:

$
  {pi 1/2, pi 3/2} &"min" k(t) \
  {0, pi} &"max" k(t)
$

= Questão 3
Primeiramente, verificamos que $beta$ é parametrizada por comprimento de arco:

$
  beta'(t) = (alpha(-t))' = -alpha'(-t) => ||beta'(t)|| = ||alpha'(-t)|| = 1 thick forall t
$

Sabemos também que $beta$ é uma reparametrização de $alpha$ pelo difeomorfismo $phi(t) = -t$.
Isso é, $beta = alpha(phi(t)) = alpha(-t)$.

Então, segue que:

$
  k_beta (t) &= det(beta'(t), beta''(t)) \
  &= det(-alpha'(-t), alpha''(-t)) \
  &= -det(alpha'(-t), alpha''(-t)) \
  &= -k_alpha (-t)
$

= Questão 5
Primeiramente, calculamos:

$
  f'(v) dot h = T h &= lim_(t->0) (f(v + h t) - f(v))/(t) \
  &= lim_(t->0) mat(
    (v_2 + h_2 t)^3 - v_2^3 + (v_1 + h_1 t)^3 - v_1^3;
    -(v_2 + h_2 t)^3 - v_2^3 + (v_1 + h_1 t)^3 - v_1^3;
  )
  1/t \
  &= mat(
    3 h_1 v_1^2 + 3 h_2 v_2^2;
    3 h_1 v_1^2 - 3 h_2 v_2^2
  ) \
  &= mat(
    3 v_1^2, 3 v_2^2;
    3 v_1^2, -3 v_2^2
  ) mat(h_1; h_2)
$

Em seguida, remapeando $f': RR^2 -> L(RR^2, RR^2)$ para $f': RR^2 -> RR^4$:

$
  f''(v) dot h = S h &= lim_(t->0) (f'(v + h t) - f(v))/(t) \
  &= lim_(t->0) mat(
    3 (v_1 + h_1 t)^2 - 3 v_1^2;
    3 (v_1 + h_1 t)^2 - 3 v_1^2;
    3 (v_2 + h_1 2)^2 - 3 v_2^2;
    - 3 (v_2 + h_2 t)^2 - 3 v_2^2
  )
  1/t \
  &= mat(
    6 h_1 v_1;
    6 h_1 v_1;
    6 h_2 v_2;
    - 6 h_2 v_2
  )
$

Retomando, então, $f': RR^2 -> L(RR^2, RR^2)$, obtemos:

$
  f''(v) dot h = S h &= mat(
    6 h_1 v_1, 6 h_2 v_2;
    6 h_1 v_1, - 6 h_2 v_2
  ) \
  &= mat(
    mat(
      6 h_1 v_1, 0;
      6 h_1 v_1, 0
    ),
    mat(
      0, 6 h_2 v_2;
      0, - 6 h_2 v_2
    )
  ) mat(h_1; h_2)
$
