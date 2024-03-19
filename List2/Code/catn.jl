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

#L(end_t) = int(cosh(t), t, 0, end_t);
int(cosh(t), t, 0, :x);
