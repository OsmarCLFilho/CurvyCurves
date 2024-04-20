#import "../template.typ": makedoc, animlink

#let repolink = "https://github.com/OsmarCLFilho/CurvyCurves/tree/main/List4"

#set math.mat(delim:"[")

#show: doc => makedoc(
  subtitle: "Lista 4",
  repolink: repolink,
  doc
)

= Questão 1
== Item a
Tome a curva $alpha (t) = (t, t^2, t^3), med t in RR$. Calculamos suas derivadas:

$
  alpha' (t) = (1, 2t, 3t^2) \
  alpha'' (t) = (0, 2, 6t)
$

Concluimos que $alpha (t)$ é 2-regular, dado que $forall t thick alpha'' (t) != 0$.

== Item b
Tome a curva $alpha (t) = (t, t^2 + 2, t^3 + t), med t in RR$. Calculamos suas derivadas:

$
  alpha' (t) = (1, 2t, 3t^2 + 1) \
  alpha'' (t) = (0, 2, 6t)
$

Concluimos que $alpha (t)$ é 2-regular, dado que $forall t thick alpha'' (t) != 0$.

= Questão 2
Começamos mostrando que a curva é regular. Considere sua derivada:

$
  alpha' (t) = (-sin(t), cos(t), cos(t/2))
$

Dado que $forall t thick "t.q." sin(t) = 0, thick cos(t) != 0$, concluimos que
$forall t, thick alpha' (t) != 0$.

Feito isso, mostramos que todos os pontos da curva estão contidos no cilindro:

$
  (1 + cos(t) - 1)^2 + sin(t)^2 &<= 1 \
  <=> 1 &<= 1
$

Em seguida, mostramos que todos os pontos estão contidos na esfera:

$
  (1 + cos(t))^2 + sin(t)^2 + (2 sin(t/2))^2 &<= 4 \
  <=> 2 cos(t) + 2 - 2 cos(t) + 2 &<= 4 \
  <=> 0 &<= 0
$

= Questão 3
Primeiramente, calculamos a função comprimento de arco da curva a partir de um ponto $t_0$:

$
  alpha(t) = (e^t cos(t), e^t sin(t), e^t) \
  L = integral _(t_0) ^t ||alpha'(t)|| d t &= integral _(t_0) ^t ||(e^t (cos(t) - sin(t)), e^t (sin(t) + cos(t)), e^t)|| d t\
  &= integral _(t_0) ^ t sqrt(e^(2t)(2 cos(t)^2 + 2 sin(t)^2 + 1)) d t\
  &= sqrt(3)(e^(t) - e^(t_0))
$

Então, deduzimos sua função inversa $phi (s)$:

$
  phi (s) = log(s/sqrt(3) + e^(t_0))
$

Feito isso, obtemos a reparametrização por comprimento de arco $beta (t)$:

$
  beta (t) &= alpha circle.stroked.small phi (t) \
$

= Questão 4
Provamos que $||alpha' (t)|| "const." <=> angle.l alpha' (t), alpha'' (t) angle.r$ a seguir:

$
  &||alpha'(t)|| "const." &&<==> ||alpha'(t)||^2 "const." \
  <==> &angle.l alpha'(t), alpha'(t) angle.r "const." &&<==> d/(d t) angle.l alpha'(t), alpha'(t) angle.r = 0 \
  <==> &2 angle.l alpha'' (t), alpha' (t) angle.r = 0 &&<==> angle.l alpha'' (t), alpha' (t) angle.r = 0
$

Em seguida, considere a curva $alpha (t) = (a cos(t), a sin(t), b t)$. Sua derivada e
seu absoluto são:

$
  alpha' (t) = (-a sin(t), a cos(t), b) \
  ||alpha' (t)|| = sqrt(a^2 (sin(t)^2 + cos(t)^2) + b^2) = sqrt(a^2 + b^2)
$

Concluimos que $||alpha'(t)||$ é constante.
