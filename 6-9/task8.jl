include("../roblib.jl")

function find_entrance(r)
    n = 0
    side = Right
    while isborder(r, Up)
        n += 1
        movements!(r, side, n)
        side = inverse(side)
    end
end