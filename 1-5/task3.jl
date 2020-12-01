include("../roblib.jl")

function mark_all_cells(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    side = Right
    while (isborder(r, Up) == false) || (isborder(r, Right) == false)
        putmarkers!(r, side)
        if (isborder(r, Up) == false) || (isborder(r, Right) == false)
            move!(r, Up)
        end
        side = inverse(side)
    end

    through_rectangles_into_angle(r, (Down, Left))
    movements!(r, (Up, Right), reverse(num_steps))
end