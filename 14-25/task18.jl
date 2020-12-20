include("../roblib.jl")

function mark_angels(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))
    putmarker!(r)
    through_rectangles_into_angle(r, (Up, Left))
    putmarker!(r)
    through_rectangles_into_angle(r, (Up, Right))
    putmarker!(r)
    through_rectangles_into_angle(r, (Down, Right))
    putmarker!(r)
    through_rectangles_into_angle(r, (Down, Left))
    movements_if_possible!(r, (Up, Right), reverse(num_steps))
end