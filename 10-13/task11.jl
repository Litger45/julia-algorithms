include("../roblib.jl")

function mark_centers(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    num_steps_to_right = sum(num_steps[1:2:end])
    num_steps_to_up = sum(num_steps[2:2:end])

    movements!(r, Up, num_steps_to_up)
    putmarker!(r)
    num_steps_to_down = get_num_movements!(r, Up)

    movements!(r, Right, num_steps_to_right)
    putmarker!(r)
    num_steps_to_left = get_num_movements!(r, Right)

    movements!(r, Down, num_steps_to_down)
    putmarker!(r)
    movements!(r, Down)

    movements!(r, Left, num_steps_to_left)
    putmarker!(r)
    movements!(r, Left)

    movements!(r, (Up, Right), reverse(num_steps))
end