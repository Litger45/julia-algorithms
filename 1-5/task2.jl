include("../roblib.jl")

function mark_perimeter(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    side = Up
    for i in 0:1:3
        putmarkers!(r, side)
        side = right(side)
    end

    movements!(r, (Up, Right), reverse(num_steps))
end