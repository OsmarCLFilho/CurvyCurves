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
