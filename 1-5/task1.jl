include("../roblib.jl")

function mark_kross(r)
    side = Up
    for i in 0:1:3
        steps = 0
        while isborder(r,side)==false
            move!(r,side)
            putmarker!(r)
            steps += 1
        end
        movements!(r, inverse(side), steps)
        side = left(side)
    end
    putmarker!(r)
end
