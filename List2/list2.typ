#import "../template.typ": makedoc, animlink

#let repolink = "https://github.com/OsmarCLFilho/CurvyCurves/tree/main/List2"

#show: doc => makedoc(
  subtitle: "Lista 2",
  repolink: repolink,
  doc
)

= Questão 1
== Item 1
Seja $alpha: I in RR -> RR^2$ uma curva regular e $phi: I_0 -> I$ um difeormofismo. Vamos mostrar
que a reparametrização $beta = alpha thin circle.stroked.small thin phi$ possui o mesmo
comprimento de arco. Suponha que $I = [a, b]$, $I_0 = [c, d]$ e $phi' > 0$, logo, obtemos
o seguinte:

$
  integral_c^d ||beta'(t)|| med d t 
  &= integral_c^d ||alpha'(phi(t))||phi'(t) med d t \
  &= integral_phi(c)^phi(d) ||alpha'(s)|| med d s \
  &= integral_a^b ||alpha'(s)|| med d s
$

Caso $phi' < 0$ (uma reparametrização invertida), simplesmente invertemos o sinal a partir
da primeira igualdade.

== Item 2
Começamos esse item alterando nosso pacote CAS: ao invés do `Symbolics.jl` usaremos o `Reduce.jl`.
Esse pacote utiliza o sistema CAS Reduce como _backend_, fornecendo ferramentas CAS para nosso
código em Julia.

Seja $r > 0$ e $alpha(t) = r(cos t, sin t), t in R$, vamos calcular o comprimento de arco de
$alpha$ entre $0$ e $pi$:

```julia
using Reduce
@force using Reduce.Algebra

r = :r;
t = :t;

x = r*cos(t);
y = r*sin(t);

x1d = df(x, t);
y1d = df(y, t);

l = sqrt(x1d^2 + y1d^2);

L = int(l, t, 0, π)
```

O resultado obtido para `L` é $pi r$.

Em seguida, seja $alpha(t) = (t, t^2/2), med t in RR$, calculamos o comprimento de arco entre $alpha(0)$ e
$alpha(1)$ da seguinte forma:

```julia
t = :t;

x = t;
y = (t^2)/2;

x1d = df(x, t);
y1d = df(y, t);

l = sqrt(x1d^2 + y1d^2);

L = int(l, t, 0, 1)
```

O resultado obtida para `L` é $(sqrt(2) + log(sqrt(2) + 1)) / 2$

== Item 3
Construiremos uma animação onde os vetores tangentes e normais de cada curva a percorrerão
simultaneamente um cículo de raio 2:

```julia
using Plots

r = :r;
t = :t;
s = :s;

αfunc(targ, rarg) = (rarg*cos(targ), rarg*sin(targ));
ϕ = s/r;

α = αfunc(t, r);
β = αfunc(ϕ, r);

α1t = df.(α, t);
β1s = df.(β, s);

α2t = df.(α1t, t);
β2s = df.(β1s, s);

trange = range(0, 4π, length=100);
srange = range(0, 4π, length=100);

xvalues = zeros(Float64, 100);
yvalues = zeros(Float64, 100);

for i=1:100
    (xvalues[i], yvalues[i]) = eval.(sub.(
        (Dict(
            t => trange[i],
            r => 2
        ),), α
    ));
end

base_plt = plot((xvalues, yvalues);
    linewidth=2,
    label="",
    size=(600,600),
    lim=(-3,3)
);

vecα = [
    α[1]            α[2]
    (α[1] + α1t[1]) (α[2] + α1t[2])
    NaN             NaN
    α[1]            α[2]
    (α[1] + α2t[1]) (α[2] + α2t[2])
];

vecβ = [
    β[1]            β[2]
    (β[1] + β1s[1]) (β[2] + β1s[2])
    NaN             NaN
    β[1]            β[2]
    (β[1] + β2s[1]) (β[2] + β2s[2])
];

anim = @animate for i=1:100
    plt = plot(base_plt);

    numvecα = eval.(sub.(
        (Dict(
            t => trange[i],
            r => 2
        ),), (vecα[:,1], vecα[:,2])
    ))

    numvecβ = eval.(sub.(
        (Dict(
            s => srange[i],
            r => 2
        ),), (vecβ[:,1], vecβ[:,2])
    ))

    plot!(plt, [numvecα, numvecβ];
        arrow=true,
        linewdith=2,
        label=""
    );
end

gif(anim, "circpara.gif");
```

#figure(
  image("circpara.png", width:50%),
  caption:[
    Vetores da parametrização original (vermelhos) e vetores da reparametrização com
    velocidade unitária (verdes). #animlink(repolink, "circpara.gif")[Vetores animados]
]
)

= Questão 2
Uma reparametrização de uma curva possui o mesmo traço que ela. Portanto, mostraremos que
$beta$ é simplesmente uma reparametrização de $alpha$.

Primeiramente, construiremos um difeormofismo $phi.alt$ entre $RR$ e $(0, infinity)$. Seja
$phi.alt(t) = log(t)$ e, portanto, $phi.alt^(-1)(t) = e^t$. Sabemos que $phi.alt$ é uma bijeção,
já que sua inversa existe. Sabemos também que tanto $phi.alt$ quanto $phi.alt^(-1)$ são
diferenciáveis. Portanto, concluimos que $phi.alt$ é um difeormofismo e, dado que
$beta(s) = alpha thin circle.stroked.small thin phi.alt (s)$, que $beta$ é uma reparametrização
de $alpha$.

Concluimos, então, que seus traços são iguais, já que, para todo ponto na imagem da curva, existem
valores únicos em ambas as contra imagens.

= Questão 3
== Item a
Calculamos o comprimento da seguinte forma:

```julia
using Reduce
@force using Reduce.Algebra

load_package(:trigsimp)

t = :t;

x = 3*cosh(2t);
y = 3*sinh(2t);
z = 6t;

x1t = df(x, t);
y1t = df(y, t);
z1t = df(z, t);

l = (sqrt(x1t^2 + y1t^2 + z1t^2));
l = :(trigsimp($l)) |> rcall;

L = int(l, t, 0, π)
```

O resultado para `L` é
$
  (3 sqrt(2) (ℯ^(4π) - 1)) / (2  ℯ^(2π))
$

== Item b
Calculamos o comprimento da seguinte forma:

```julia
using Reduce
@force using Reduce.Algebra

load_package(:trigsimp);

t = :t;

x = t;
y = cosh(t);

x1t = df(x, t);
y1t = df(y, t);

l = sqrt(x1t^2 + y1t^2);
l = :(trigsimp($l, cosh)) |> rcall;
# julia> :(abs(cosh(t)))
```

Nesse ponto, como a catenária é simétrica ao redor de $x$, podemos trocar o valor obtido,
`abs(cosh(t))` por `cosh(t)`:

```julia
int(cosh(t), t, 0, :x)
```

O resultado é:
$
  (e^(2x)-1) / (2e^x)
$

= Questão 4
== Item a
Primeiramente, precisamos mostrar que $s(theta)$ é uma bijeção entre os intervalos
$A = (0, infinity)$ e $B = (0, 1)$.

Seja $b in B$ um valor qualquer, queremos mostrar que existe
$a in A$ tal que $s(a) = b$. Verificamos que $s(0) = 0$ e também que $lim_(x->infinity) s(x) = 1$.
Portanto, dado que $s$ é contínua, concluimos pelo teorema do valor intermediário que $a$ existe.

Agora, vamos mostrar que esse $a$ é único. Fazemos isso mostrando que $s$ é estritamente crescente.
Seja $x > y in A$, logo:

$
      &x^2/(x^2 + 1) > y^2/(y^2 + 1) \
  <=> &x^2/y^2 > (x^2 + 1)/(y^2 + 1) \
  <=> &x^2/y^2 - (x^2 + 1)/(y^2 + 1) > 0 \
  <=> &(x^2(y^2 + 1) - (x^2 + 1)y^2)/(y^2 (y^2+1)) > 0 \
  <=> &(x^2 - y^2)/(y^2(y^2 + 1)) > 0 \
  <=> &x^2 > y^2 <=> |x| > |y| arrow.l.double x > y
$

Concluimos, então, que $s$ é uma bijeção.

Encontraremos agora a inversa $s^(-1)$ para mostrar que tanto ela quanto $s$ são diferenciáveis.
Seja $Phi = s^(-1)(phi)$, sabemos que $s(s^(-1)(phi)) = s(Phi) = phi$. Logo:

$
  s(s^(-1)(phi)) &= (Phi^2)/(Phi^2 + 1) = phi \
  => &1/(1 + 1/Phi^2) = phi \
  => &1/phi = 1 + 1/Phi^2 \
  => &1/phi - 1 = 1/Phi^2 \
  => &(1-phi)/phi = 1/Phi^2 \
  => &Phi = sqrt(phi/(1 - phi))
$

Verificamos que tanto $s$ quanto $s^(-1)$ são diferenciáveis, possuindo as seguintes derivadas:

$
  s'(theta) = (2θ) / (θ ^ 2 + 1) ^ 2 \
  s^(-1) '(phi) = 1 / (2 sqrt(ϕ / (ϕ + 1)) (ϕ + 1) ^ 2)
$

== Item b
A função $tan$ possui inversa $arctan$, i.e., é uma bijeção. Além disso, ambas possuem derivadas:

$
  tan'(x) = tan(x) ^ 2 + 1 \
  arctan'(x) = 1 / (x ^ 2 + 1)
$

== Item c
Seja $alpha: I -> RR^n$ uma curva qualquer. Queremos mostrar que existe um difeormofismo
$phi: [0, 1] -> I$. Seja $I = [a, b]$, considere a função
$phi(t) = a + t(b - a) = a(1-t) + b t$. Sabemos que ela é contínua e que $phi(0) = a$ e
$phi(1) = b$. Portanto, pelo teorema do valor intermediário, sabemos que ela é sobrejetiva.
Além disso sabemos que ela é estritamente crescente:

$
  &x > y in [0, 1] \
  => &a + x(b-a) > a + y(b-a) \
  => &phi(x) > phi(y)
$

Portanto, sabemos que ela é injetiva e, logo, uma bijeção.

Finalmente, tanto ela quanto sua inversa $phi^(-1)(s) = (s-a)/(b-a)$ possuem derivadas:

$
  phi'(t) = b - a \
  phi^(-1) '(t) = 1/(b - a)
$

= Questão 5
Começamos mostrando que a derivada de $gamma(t) = (2t, 2/(1 + t^2))$ nunca se anula quando $t > 0$:

$
  gamma'(t) = (2, (-4t) / (t ^ 2 + 1) ^ 2)
$

Como $-4t != 0 quad forall t > 0$, concluimos que a curva $gamma$ é regular.

Em seguida, para mostrar que $gamma$ é uma reparametrização da curva
$alpha(s) = ((2 cos(s))/(1 + sin(s)), 1 + sin(s))$, precisamos encontrar um difeormofismo $phi$
tal que $gamma(t) = alpha(phi(t))$.

Seja, então, $phi(t) = cos^(-1)(2t/(1+t^2))$.

= Questão 6
Para realizar a reparametrização, primeiro calculamos o comprimento de arco:

```julia
using Reduce
@force using Reduce.Algebra

isr2 = :(1/sqrt(2));
isr3 = :(1/sqrt(3));

α = (cos(t)*isr3 + sin(t)*isr2, cos(t)*isr3, cos(t)*isr3 - sin(t)*isr2);

α1t = df.(α, t);

l = sqrt(α1t[1]^2 + α1t[2]^2 + α1t[3]^2);
L = int(l, t);
L = :(trigsimp($L)) |> rcall
```

O resultado final para $L$ é $t$. Ou seja, o difeormofismo inverso $phi(s) = s$
é igual a $L(t) = t$. Concluimos então que essa curva já está parametrizada por comprimento
de arco.
